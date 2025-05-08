# Dotfiles
This contains all the dotfiles used across various environments. 
A lot of the instructions and scripts assume it is git cloned in your home directory.

## NixOS
This contains nix config for various hosts, use the rebuild script to target the 
correct one.

## MacOS, etc
This uses [gnu stow](https://www.gnu.org/software/stow/) to symlink all dotfiles to the home directory. 
You can install things with:
```
> brew install stow
> ./setup.sh
> stow .
```

And clean them up with:
```
> stow -D .
```
