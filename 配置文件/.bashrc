# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

##2015.1.7
PYTHONPATH=~/SoftWare/Python/Tool/jieba-0.35
export  PYTHONPATH

##2015.1.8
#export http_proxy="http://localhost:8087"
#export https_proxy="http://localhost:8087"

##2015.1.8.2
# Gnome terminal 下需要强制 tmux 采用 256 色
if [ $COLORTERM == "gnome-terminal" ]; then
    TMUX_ZJS_COMMAND='tmux -2'
else
    TMUX_ZJS_COMMAND='tmux'
fi

# 初始化 tmux 会话
tmux_init()
{
    if which tmux >/dev/null 2>&1; then
        if [ -z $1 ]; then
            SESSION_NAME=$USER
        else
            SESSION_NAME=$1
        fi
        $TMUX_ZJS_COMMAND new-session -s "$SESSION_NAME" -d
        $TMUX_ZJS_COMMAND new-window -d
        $TMUX_ZJS_COMMAND new-window -d
        $TMUX_ZJS_COMMAND new-window -d
        $TMUX_ZJS_COMMAND new-window -d
        $TMUX_ZJS_COMMAND new-window -d
    else
        echo "No command tmux found! Please install tmux first!"
    fi
}

# 判断是否已有开启的tmux会话，没有则开启
if which tmux >/dev/null 2>&1; then
    if [ $(cat /proc/$PPID/status | head -1 | cut -f2) != "sshd" ]; then
        SESSION_NAME="$USER"
    else
        SESSION_NAME="$USER-SSH"
    fi
    if ! tmux has-session -t "$SESSION_NAME"  >/dev/null 2>&1; then
        tmux_init $SESSION_NAME >/dev/null 2>&1;
    fi
    if [ -z $TMUX ]; then
        $TMUX_ZJS_COMMAND attach-session -d -t "$SESSION_NAME"
    fi
fi

#2015.1.8
if [ -f ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then
    source ~/.local/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi
export TERM=xterm-256color

#2015.1.16
ANT_OPTS="-Divy.cache.ttl.default=eternal"
export ANT_OPTS

#2015.1.16
# bash completion for maven
MAVEN_BASH_COMPLETION_FILE="$HOME/.m2/bash_completion.bash"
if [ -f $MAVEN_BASH_COMPLETION_FILE ]; then
    . $MAVEN_BASH_COMPLETION_FILE
fi

#050204
#这样执行product，stage就能分别切换到相应的虚拟工作环境，同时进入工作目录
alias product='source ~/.bashrc; workon product; cd ~/envs/product/src'
alias stage='source ~/.bashrc; workon stage; cd ~/envs/stage/src'

# #zookeeper
# export ZOOKEEPER_HOME=/home/hanwei/SoftWare/Java/MyProject/Support/zookeeper/zookeeper-3.3.6
# export PATH=$PATH:$ZOOKEEPER_HOME/bin:$ZOOKEEPER_HOME/conf

# #tomcat
# export CATALINA_HOME=/var/lib/tomcat7
# export PATH=~/bin:~/local/bin:$CATALINA_HOME/bin:$PATH
# export CATALINA_OPTS="-server -Xmx2048m -Xms2048m"
# export JAVA_OPTS="-Dsolr.data.dir=/home/hanwei/SoftWare/Java/MyProject/Support/solr-tomcat7/example/solr"
# export JAVA_OPTS="$JAVA_OPTS -Dsolr.solr.home=/home/hanwei/SoftWare/Java/MyProject/Support/solr-tomcat7/example/solr"
# export SOLR_HOME=/home/hanwei/SoftWare/Java/MyProject/Support/solr-tomcat7/example/solr

source /usr/local/bin/virtualenvwrapper.sh
export WORKON_HOME=$HOME/.virtualenvs
export PIP_REQUIRE_VIRTUALENV=true
#虚拟机开启别名
alias ve_scrapy='source /home/hanwei/SoftWare/Python/ENV/VEScrapy/bin/activate'

#服务器别名
export s51=lanjing@192.168.1.51
export s52=lanjing@192.168.1.52
export s53=lanjing@192.168.1.53
export s54=lanjing@192.168.1.54
export m55=lanjing@192.168.1.55
export s56=lanjing@192.168.1.56
export s57=lanjing@192.168.1.57
export n58=lanjing@192.168.1.58
export n59=lanjing@192.168.1.59
export n50=lanjing@192.168.1.60

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
