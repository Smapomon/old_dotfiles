All my configuration files I wish to make portable.

## Current Branches
These will probably change in the future.
Especially main, as it will always be my daily driver OS.
New ones will be added each time I start using a new OS.


### Important Branches
```
main = ubuntu
```


## Installation
Installation processes
### Importing dotfiles to system
```console
git clone --separate-git-dir=~/.myconf git@github.com:Smapomon/dotfiles.git $HOME/myconf-tmp
cp ~/myconf-tmp/.gitmodules ~  # If you use Git submodules
rm -r ~/myconf-tmp/
alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
```

### Making a new dotfiles repo
Use git init to create a new directory with bare repo
.dotconf, .myconf or any other directory can be used
```console
git init --bare $HOME/.dotconf
```

Create an alias to bashr, zshrc or whichever shell system you use.
Alias will make it easier to access the repo since using git without options will not work.
Note that when installing to a new system from the repo, the alias is automatically going to be in the zshrc (in this case).
```
alias dot_git='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
```

Turn off untracked files in status (there will be many)
```console
dot_git config status.showUntrackedFiles no
```

Finally add your new empty repo in github/gitlab to the bare repo remote.
Instructions for this can be seen when creating a new empty repo in github for example.
