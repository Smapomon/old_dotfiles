# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ------------ ALIASES ------------ #

# BASIC SHELL STUFF
alias ls="exa --long --header --icons --color=always --group-directories-first"
alias files="clear;ls -alh"
alias s="kitty +kitten ssh"

# GIT ALIASES
alias co='checkout'
alias c_branch="git branch --show-current | xclip -selection clipboard"
alias dot_git='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'


# NAVIGATION ALIASES
alias dev='cd ~/dev; clear; ls -alh'
alias omni="cd ~/dev/gitlab/omnitool-be; clear; ls -alh"
alias sptla="cd ~/dev/work/spotilla-be; clear; ls -alh"
alias get_perm="cd ~/dev/work/perms; clear; ls -alh"
alias vimconf="cd ~/.config/nvim; clear; files; nvim init.lua"
alias wmconf="cd ~/.config/awesome; clear; files"
alias kittyconf="cd ~/.config/kitty; clear; files; nvim kitty.conf"

# SPTLA FUNCTIONS
alias specmigrate="docker compose run be rake db:migrate RAILS_ENV=test"
alias dspec="docker compose run be rspec ./spec/$1"
alias dspec_all="docker compose run be rspec ./spec"
alias jarru="clear; docker compose run be brakeman -A -z -I"

# RAILS FUNCTIONS
alias dcup="clear; sudo rm tmp/pids/server.pid; docker compose up"
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



# ------------ ALIAS FUNCTIONS ------------ #

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

# Custom appends through shell
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
