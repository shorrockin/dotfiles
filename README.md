# Dotfiles
This contains all the dotfiles used across various environments. 
A lot of the instructions and scripts assume it is git cloned in your home directory.

## Stow
This uses [gnu stow](https://www.gnu.org/software/stow/) to symlink all dotfiles to the home directory. 
You can install things (on osx) with:
```
> brew install stow
> ./stow_setup.sh
```
The setup script is only needed for environments where you may have a separate overlay collection of 
scripts (work env) that may be needed. Then you can use it to symlink the dotfiles.
```
> stow .
```
And finally, clean them up with:
```
> stow -D .
```

## NixOS
Once you get this on nix you can rebuild the normal way or through the nix_rebuild script in .config/scripts

## Quirks
A few other things to note:
- `bat` requires a `bat cache --build`
- `tmux` needs it's plugins installed with `I
- when running `git stow` you can ignore files with `--ignore=.gitconfig`
