#!/bin/bash
# Clone your dotfiles repo, then run this:
#   git clone git@github.com:youruser/dotfiles.git ~/dotfiles
#   ~/dotfiles/install.sh

set -e
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p ~/projects/company
mkdir -p ~/projects/personal

for file in gitconfig bashrc; do
    target="$HOME/.${file}"
    if [ -f "$target" ] && [ ! -L "$target" ]; then
        mv "$target" "${target}.backup"
        echo "Backed up .${file}"
    fi
    ln -sf "$DOTFILES_DIR/$file" "$target"
    echo "Linked .${file}"
done

echo ""
echo "Done. Open a new terminal to load config."
