if status is-interactive
# Commands to run in interactive sessions can go here
end
export PATH="$HOME/.local/bin:$PATH"

fish_add_path "/Users/johndoe/go/bin"
fish_add_path "/Users/johndoe/.cargo/bin"

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/johndoe/.lmstudio/bin
# End of LM Studio CLI section

set EDITOR nvim

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# pnpm
set -gx PNPM_HOME "/Users/johndoe/Library/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
