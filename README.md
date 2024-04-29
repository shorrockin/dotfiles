This uses [gnu stow](https://www.gnu.org/software/stow/) to symlink all dotfiles to the home directory. You can install things with:
```
> brew install stow
> ./setup.sh
> stow .
```

And clean them up with:
```
> stow -D .
```
