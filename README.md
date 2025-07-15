# Niri Dotfiles

My personal niri (Arch Linux) + MacOS (lix, nix-darwin, yabai) setup.

# Loading Dotfiles

I use chezmoi to track and load dotfiles. You learn more here: https://www.chezmoi.io/

After that, use the command `chezmoi init https://github.com/x4132/dotfiles.git` to initialize.
Then use `chezmoi apply` to apply the dots.
If you would like to view the changes before you apply them, use `chezmoi diff`.
