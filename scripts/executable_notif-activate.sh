#!/usr/bin/env bash
# "Click" the newest notification: invoke its default action, dismiss it,
# then focus the sending app's window via niri. The explicit focus step is
# needed because apps invoked over D-Bus get no xdg-activation token, so
# niri's focus-stealing prevention keeps them from raising themselves.

list=$(makoctl list)
id=$(printf '%s\n' "$list" | sed -n 's/^Notification \([0-9]*\):.*/\1/p' | head -1)
[ -z "$id" ] && exit 0
summary=$(printf '%s\n' "$list" | sed -n "s/^Notification $id: //p" | head -1)

# Fields of this notification only (up to the next "Notification" header).
block=$(printf '%s\n' "$list" | awk -v id="$id" '
  $0 ~ "^Notification " id ":" {p=1; next}
  /^Notification /{p=0}
  p')
app=$(printf '%s\n' "$block" | awk -F': ' '/^  Desktop entry:/{print $2; exit}')
[ -z "$app" ] && app=$(printf '%s\n' "$block" | awk -F': ' '/^  App name:/{print $2; exit}')

focused_before=$(niri msg focused-window | sed -n 's/^Window ID \([0-9]*\).*/\1/p')

makoctl invoke -n "$id" || exit 1
makoctl dismiss -n "$id"
[ -z "$app" ] && exit 0

# Some apps (e.g. kitty) route the action to the right window and try to
# activate it themselves; give that a moment and don't fight it if it worked.
sleep 0.4
focused_after=$(niri msg focused-window | sed -n 's/^Window ID \([0-9]*\).*/\1/p')
[ "$focused_after" != "$focused_before" ] && exit 0

app_lc=$(printf '%s' "$app" | tr '[:upper:]' '[:lower:]')
sum_lc=$(printf '%s' "$summary" | tr '[:upper:]' '[:lower:]')
curws=$(niri msg focused-window | awk '/^  Workspace ID:/{print $3; exit}')

# Among windows of the sending app, prefer the one whose title shares words
# with the notification summary (picks the right kitty/browser window), then
# the one on the current workspace, then the first listed.
win=$(niri msg windows | awk -v app="$app_lc" -v summary="$sum_lc" -v curws="$curws" '
  function flush(   score, n, words, i, lt) {
    if (wid == "" || tolower(appid) != app) return
    score = 0
    lt = tolower(title)
    if (summary != "" && index(lt, summary)) score += 100
    n = split(summary, words, /[^a-z0-9]+/)
    for (i = 1; i <= n; i++)
      if (length(words[i]) >= 3 && index(lt, words[i])) score += 10
    if (ws == curws) score += 1
    if (score > best) { best = score; bestid = wid }
  }
  BEGIN { best = -1 }
  /^Window ID/        { flush(); wid = $3; sub(/:/, "", wid); appid = ""; title = ""; ws = "" }
  /^  Title:/         { title = $0; sub(/^  Title: "/, "", title); sub(/"$/, "", title) }
  /^  App ID:/        { appid = $0; sub(/^  App ID: "/, "", appid); sub(/"$/, "", appid) }
  /^  Workspace ID:/  { ws = $3 }
  END { flush(); if (bestid != "") print bestid }')
[ -n "$win" ] && niri msg action focus-window --id "$win"
