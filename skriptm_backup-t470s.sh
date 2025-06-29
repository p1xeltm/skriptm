#!/bin/bash

#=======================================================================================================
CONFIG=(
    "$HOME/.bash_aliases"
    "$HOME/.bash_profile"
    "$HOME/.bashrc"
    "$HOME/.xinitrc"
    "$HOME/.config/Thunar"
    "$HOME/.config/lxterminal"
    "$HOME/.config/Mousepad"
    "$HOME/.config/ristretto"
    "$HOME/.config/rofi"
    "$HOME/.config/wallpaper"
    "$HOME/.config/xfce4"
)

DIR_DOTFILES="$HOME/git_t470s-dotfiles"
DIR_SKRIPTM="$HOME/git_t470s-skriptm"
REPO_URL_DOT="git@github.com:p1xeltm/t470s-dotfiles.git"
REPO_URL_SH="git@github.com:p1xeltm/t470s-skriptm.git"
#=======================================================================================================



#--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->
# (1) backup dotfiles
#--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->

mkdir -p "$DIR_DOTFILES"
find "$DIR_DOTFILES" -mindepth 1 -path "$DIR_DOTFILES/.git" -prune -o -exec rm -rf {} +

cd "$HOME"
for EINTRAG in "${CONFIG[@]}"; do
    REL_PATH="${EINTRAG#$HOME/}"
    if [ -e "$EINTRAG" ]; then
        mkdir -p "$DIR_DOTFILES/$(dirname "$REL_PATH")"
        cp -a "$EINTRAG" "$DIR_DOTFILES/$REL_PATH"
    fi
done

cd "$DIR_DOTFILES" || exit
if [ ! -d .git ]; then
    git init
    git remote add origin "$REPO_URL_DOT"
    git config --global user.name "$USER"
    git config --global user.email "${USER}@$(hostname)"
    git config --global init.defaultBranch main
    git config --global advice.defaultBranchName false
    git symbolic-ref HEAD "refs/heads/main"
fi

git add .
git commit -m "backup $(date '+%F %T')"
git branch -M main
git push --force -u origin main


#--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->
# (2) backup skriptm
#--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->--->

mkdir -p "$DIR_SKRIPTM"
find "$DIR_SKRIPTM" -mindepth 1 -path "$DIR_SKRIPTM/.git" -prune -o -exec rm -rf {} +

cp --preserve=all "$0" "$DIR_SKRIPTM/"

cd "$DIR_SKRIPTM" || exit
if [ ! -d .git ]; then
    git init
    git remote add origin "$REPO_URL_SH"
    git config --global user.name "$USER"
    git config --global user.email "${USER}@$(hostname)"
    git config --global init.defaultBranch main
    git config --global advice.defaultBranchName false
    git symbolic-ref HEAD "refs/heads/main"
fi

git add "$(basename "$0")"
git commit -m "backup $(date '+%F %T')"
git branch -M main
git push --force -u origin main

