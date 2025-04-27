#
# ~/.bashrc
#
blk='\[\033[01;30m\]'   # Black
red='\[\033[01;31m\]'   # Red
grn='\[\033[01;32m\]'   # Green
ylw='\[\033[01;33m\]'   # Yellow
blu='\[\033[01;34m\]'   # Blue
pur='\[\033[01;35m\]'   # Purple
cyn='\[\033[01;36m\]'   # Cyan
wht='\[\033[01;37m\]'   # White
clr='\[\033[00m\]'	# reset
set -o vi
echo -e "\e[3 q"
HISTTIMEFORMAT="%F %T"
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# xsecurelock
export XSECURELOCK_PASSWORD_PROMPT=time_hex
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll='ls -l'
alias lla='ls -la'
alias cls='clear'
# User defined functions
function bigboi(){
	du -h -x -s -- * | sort -r -h | head -20;
}
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="${wht}[${cyn}\w\[\033[32m\]\[\033[00m\]${wht}] ${grn} ${wht}"
