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

# ------------ NVM SETUP ------------ #
source /usr/share/nvm/init-nvm.sh

# ------------ SSH SETUP ------------ #
SSH_ENV="$HOME/.ssh/agent-environment"

function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}

function add_ssh_keys {
	echo "Adding keys..."
	for possiblekey in ${HOME}/.ssh/id_*; do
		if grep -q PRIVATE "$possiblekey"; then
			ssh-add "$possiblekey"
		fi
	done

}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    #ps ${SSH_AGENT_PID} doesn't work under cywgin
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

# ------------ ALIASES ------------ #

# BASIC SHELL STUFF
alias ls="exa --long --header --icons --color=always --group-directories-first"
alias files="clear;ls -alh"
alias s="kitty +kitten ssh"
alias icat="kitty +kitten icat"
alias update_kitty="curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin"
alias termconf="cd ~; clear; nvim .zshrc"
alias :q="exit"
alias :qa="exit"

# GIT ALIASES
alias co='checkout'
alias c_branch="git branch --show-current | tr -d '\n' | xclip -selection clipboard"
alias dot_git='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'
alias dgit='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'


# NAVIGATION ALIASES
alias dev='cd ~/dev; clear; ls -alh'
alias omni="cd ~/dev/gitlab/omnitool-be; clear; ls -alh"
alias sptla="cd ~/dev/work/spotilla-be; clear; ls -alh"
alias get_perm="cd ~/dev/work/perms; clear; ls -alh"
alias vimconf="cd ~/.config/nvim; clear; files; nvim init.lua"
alias wmconf="cd ~/.config/awesome; clear; files; nvim rc.lua"
alias kittyconf="cd ~/.config/kitty; clear; files; nvim kitty.conf"
alias start_vpn="cd /usr/local/bin; clear; sudo sh goodaccess.sh -r smapo-linukka"
alias mallu="cd ~/dev/gitlab/mallu-frontend/; clear; files"

# NAVIGATE WINDOW CLIENTS
alias fuzzy_win='wmctrl -i -a $(wmctrl -l | fzf | cut -d\  -f1); exit'

# SPTLA FUNCTIONS
alias specmigrate="docker compose run be rake db:migrate RAILS_ENV=test"
alias dspec="docker compose run be rspec ./spec/$1"
alias dspec_all="docker compose run be rspec ./spec"
alias jarru="clear; docker compose run be brakeman -A -z -I"

# DOCKER FUNCTIONS
alias dcup="clear; rm tmp/pids/server.pid; docker compose up"
alias dbld="docker compose build"
alias docker_start="sudo systemctl start docker.service"

# RAILS FUNCTIONS
alias rcon="open_console"
alias genmodel_no_migrate="genmodel_without_migration_function $1"
alias genmodel="genmodel_with_migration_function $1"
alias genmigration="genmigrationonly_function $1"
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
	ex_command="clear; docker compose run $docker_instance_name rails c"
	eval $ex_command;
}

function genmodel_without_migration_function() {
	modelname=$1
	docker_instance_name=$(rails_dir_map)
	ex_command="docker compose run $docker_instance_name rails g model $modelname --skip-migration --no-test-framework"
	eval $ex_command;
}

function genmodel_with_migration_function() {
	modelname=$1
	docker_instance_name=$(rails_dir_map)
	ex_command="docker compose run $docker_instance_name rails g model $modelname --no-test-framework"
	eval $ex_command;
}

function genmigrationonly_function() {
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

export PATH="$HOME/.local/kitty.app/bin:$PATH"

export PATH="$HOME/dev/android_studio/android-studio-2021.3.1.16-linux/android-studio/bin:$PATH"
export PATH="/usr/java/jre1.8.0_341/bin:$PATH"
alias luamake=/luamake
export PATH="${HOME}/lsp_servers/lua-language-server/bin:${PATH}"

neofetch
