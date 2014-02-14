# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias mysql-prod="mysql --defaults-file=/home/web/.my.multiposting.cnf mp_app"
alias cda="cd ~/app"
alias cdg="cd ~/app/symfony/lib/generators"
alias cdi="cd ~/app/symfony/lib/imports"
alias cdj='cd ~/app/symfony/lib/generators/php/jobboards'
alias cdpj='cd ~/app/symfony/lib/generators/python/jobboards'
alias cdb="cd ~/app/bin"
alias cdr="cd ~/reports"
alias cdm="cd ~/app/django/"
alias cdsch='cd ~/app/symfony/lib/generators/php/schools'
alias cdpsch='cd ~/app/symfony/lib/generators/python/schools'
alias cddm='cd ~/app/django/mplib/django/'
alias cdsm='cd ~/app/symfony/lib/model/'
alias cds='cd ~/scripts'
alias cdl='cd /home/mplogs'
alias sel_s='cd ~/app/bin/selenium && java -jar selenium-server-standalone-2.24.1.jar -port 8454 -role hub'

alias django_shell='cd ~/app/django/ && ./manage.py shell'
alias django_shell_error='cd ~/app/django/ && ./manage-errors.py shell'

alias findn='find -name'
alias import_full='cd ~/app/ && ./bin/db/import full'

alias log_django='cd ~/app/log/dev-frontoffice/ && tail -f django.log'
alias rmpyc='find . -name "*.pyc" -exec rm {} \;'

alias feed_server="~/app/django/mpjobs/projects/feeds/runserver"
alias php=$HOME/.bin/sfphp

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/opt/bin:/usr/x86_64-pc-linux-gnu/gcc-bin/4.5.4"
# export MANPATH="/usr/local/man:$MANPATH"

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

function mydump {
    TMPFILE='/home/jandrade/dump.tmp'
    touch $TMPFILE
    echo -e "SET AUTOCOMMIT = 0;\nSET FOREIGN_KEY_CHECKS=0;\n\n" > $TMPFILE
    mysqldump --defaults-file=/home/web/.my.multiposting.cnf --compact -t --replace mp_app $* >> $TMPFILE
    echo -e "\nSET FOREIGN_KEY_CHECKS = 1;\nCOMMIT;\nSET AUTOCOMMIT = 1;\n" >> $TMPFILE
    cat $TMPFILE | mysql
}

function clean-branches
{
    echo -n "deleting merged branches..."
    for b in $(git branch -a --merged)
    do
        git br -d "$b" &>/dev/null
    done
    echo " done"
}

function symfony {
    php ~/app/symfony/symfony $*
}

function import {
    ~/app/bin/db/import-postings $*
}

function generate {
    ~/app/bin/generate $*
}

function generate-python {
    ~/app/symfony/lib/generators/manage.py generate $*
}

function recup_champs {
    mydump field_i18n
    echo "Field_i18n OK"
    mydump field
    echo "Field OK"
    mydump field_item_i18n
    echo "Field_item_i18n OK"
    mydump field_item
    echo "Field_item OK"
    mydump field_mapping
    echo "Field_mapping OK"
    mydump field_mapping_assoc
    echo "Field_mapping_assoc OK"
}

function recup_essential {
    mydump generator
    echo "Generator OK"
    mydump jobboard_generator
    echo "Jobboard Generator OK"
    mydump generator_value
    echo "Generator Value OK"
    mydump jobboard_value
    echo "Jobboard Value OK"
    mydump jobboard_posting_field
    echo "Jobboard Posting Field OK"
    mydump field_data
    echo "Field Data OK"
    mydump jobboard_config_field
    echo "Jobboard Config Field OK"
    mydump jobboard_config
    echo "Jobboard Config OK"
    mydump jobboard_group_config
    echo "Jobboard Group Value OK"
    mydump jobboard_config_value
    echo "Jobboard Config Value OK"
}


function rerr
{
    if [ $# -eq 2 ]
    then
        ST=",state=$2"
    else
        ST=''
    fi
    mysql -e "UPDATE posting_jobboard SET errors=0 $ST WHERE posting_id IN ($1)"
    mysql -e "UPDATE posting_jobboard_error SET is_active=0 WHERE posting_id IN ($1)"
}

if [ -f ~/.agent.env ] ; then
    . ~/.agent.env > /dev/null
if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
    echo "Stale agent file found. Spawning new agent… "
    eval `ssh-agent | tee ~/.agent.env`
    ssh-add
fi
else
    echo "Starting ssh-agent"
    eval `ssh-agent | tee ~/.agent.env`
    ssh-add
fi

setup_mp_virtualenv() {
    mkdir -p ~/.venvs

    [ ! -d ~/.venvs/generators ] && virtualenv ~/.venvs/generators
    [ -d ~/app/symfony/lib/generators ] && [ ! -e ~/app/symfony/lib/generators/.venv ] && ln -s ~/.venvs/generators ~/app/symfony/lib/generators/.venv

    [ ! -d ~/.venvs/mpjobs ] && virtualenv ~/.venvs/mpjobs
    [ -d ~/app ] && [ ! -e ~/app/.venv ] && ln -s ~/.venvs/mpjobs ~/app/.venv

    [ ! -d ~/.venvs/reports ] && virtualenv ~/.venvs/reports
    [ -d ~/reports ] && [ ! -e ~/reports/.venv ] && ln -s ~/.venvs/reports ~/reports/.venv
}

active_mp_virtualenv() {
    current_path=$PWD
    virtualenv_path=""

    if [[ -z $MP_VENV_PATH ]]; then export MP_VENV_PATH; fi

    # Traverse the arborescence to find the closest existing virtualenv
    while [[ $current_path != "" ]]
    do
        if [[ -d ${current_path}/.venv ]]
        then
            virtualenv_path=${current_path}/.venv
            break
        else
            current_path=${current_path%/*}
        fi;
    done

    # Change the current virtualenv if one was detected.
    if [[ -n $virtualenv_path ]]
    then
        if [[ $MP_VENV_PATH != $virtualenv_path ]]
        then
            source ${virtualenv_path}/bin/activate
            MP_VENV_PATH=$virtualenv_path
        fi
    elif [[ -n $MP_VENV_PATH && $MP_VENV_PATH != "" ]]
    then
        MP_VENV_PATH=""
        deactivate
    fi;
}

precmd_functions+='active_mp_virtualenv'
