# Lines configured by zsh-newuser-install
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ -n "$DISPLAY" ]; then
  exec tmux
fi

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
alias neofetch="fastfetch"
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
autoload -Uz vcs_info
export PS1="%F{cyan}%n%f[\w] >>"
autoload -Uz compinit
compinit
export VISUAL=nvim
export EDITOR="$VISUAL"
plugins=(git shh-agent)
unsetopt prompt_cr prompt_sp
zstyle ':vcs_info:git:*' formats 'on %F{82}%b%f'
setopt PROMPT_SUBST
PROMPT='%B%F{130}%n%f [%F{82}%~%f] => '
