# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# ALIASES
alias ls="exa --long --header --icons --color=always --group-directories-first"
alias files="clear;ls -alh"

# GIT ALIASES
alias co='checkout'
alias c_branch="git branch --show-current | xclip -selection clipboard"
alias dot_git='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'


# NAVIGATION ALIASES
alias dev='cd ~/dev; clear; ls -alh'
alias omni="cd ~/dev/gitlab/omnitool-be; clear; ls -alh"
alias sptla="cd ~/dev/work/spotilla-be; clear; ls -alh"
alias get_perm="cd ~/dev/work/perms; clear; ls -alh"
alias vimconf="cd ~/.config/nvim; clear; files"

# SPTLA FUNCTIONS
alias specmigrate="docker compose run be rake db:migrate RAILS_ENV=test"
alias dspec="docker compose run be rspec ./spec/$1"
alias dspec_all="docker compose run be rspec ./spec"
alias jarru="clear; docker compose run be brakeman -A -z -I"

# RAILS FUNCTIONS
alias dcup="clear; rm tmp/pids/server.pid; docker compose up"
alias dbld="docker compose build"

alias rcon="open_console"
alias genmodel_no_migrate="genmodel_without_migration $1"
alias genmodel="genmodel_with_migration $1"
alias genmigration="genmigrationonly $1"
alias droutes="rails_routes"
alias dcmigraationes="run_migrations"
alias dcmigrationstatus="run_migration_status"
alias dcrollback="rollback_migration"
alias dbundle="run_bundle"
alias dbundle_install="install_with_bundle"

function rails_dir_map {
	CDIR=${PWD##*/}
	APPNAME=''
	case $CDIR in
		spotilla-be)
			APPNAME="be"
			;;
		*)
			APPNAME="omnitool"
			;;
	esac

	echo $APPNAME;
}

function rails_env_append() {
	env_append=""

	if [[$1 == 'be']]; then
		env_append=" RAILS_ENV=development"
	fi

	return $env_append;
}

function open_console() {
	docker_instance_name=$(rails_dir_map)
	ex_command="docker compose run $docker_instance_name rails c"
	eval $ex_command;
}

function genmodel_without_migration() {
	modelname=$1
	docker_instance_name=$(rails_dir_map)
	ex_command="docker compose run $docker_instance_name rails g model $modelname --skip-migration --no-test-framework"
	eval $ex_command;
}

function genmodle_with_migration() {
	modelname=$1
	docker_instance_name=$(rails_dir_map)
	ex_command="docker compose run $docker_instance_name rails g model $modelname --no-test-framework"
	eval $ex_command;
}

function genmigrationonly() {
	migrationname=$1
	docker_instance_name=$(rails_dir_map)
	ex_command="docker compose run $docker_instance_name rails g migration $migrationname"
	eval $ex_command;
}

function rails_routes() {
	docker_instance_name=$(rails_dir_map)
	ex_command="docker compose run $docker_instance_name rake routes"
	eval $ex_command;
}

function run_migrations() {
	docker_instance_name=$(rails_dir_map)
	echo "docker name: $docker_instance_name"
	env_append_str=rails_env_append $docker_instance_name
	ex_command="docker compose run $docker_instance_name rake db:migrate$env_append_str"
	echo $ex_command
	eval $ex_command;
}

function run_migration_status() {
	docker_instance_name=$(rails_dir_map)
	env_append_str=rails_env_append $docker_instance_name
	ex_command="docker compose run $docker_instance_name rake db:migrate:status$env_append_str"
	eval $ex_command;
}

function rollback_migration() {
	docker_instance_name=$(rails_dir_map)
	env_append_str=rails_env_append $docker_instance_name
	ex_command="docker compose run $docker_instance_name rake db:rollback$env_append_str"
	eval $ex_command;
}

function run_bundle() {
	docker_instance_name=$(rails_dir_map)
	ex_command="clear;docker compose run $docker_instance_name bundle"
	eval $ex_command;
}

function install_with_bundle() {
	docker_instance_name=$(rails_dir_map)
	ex_command="clear;docker compose run $docker_instance_name bundle install"
	eval $ex_command;
}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
