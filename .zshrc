HISTSIZE=1000
HISTFILE=~/.histfile
SAVEHIST=1000
bindkey -v
# aliases
alias 'studio'='~/.config/android-studio/bin/studio.sh'
alias 'shitlab'='LIBGL_ALWAYS_SOFTWARE=1 ~/.config/scilab-2023.0.0/bin/scilab-adv-cli'
alias 'lla'='ls -la'
autoload -Uz vcs_info
precmd() { vcs_info }
#autoload -Uz promptinit
#promptinit
#prompt adam2
plugins=(git shh-agent)
unsetopt prompt_cr prompt_sp
zstyle ':vcs_info:git:*' formats 'on %F{82}%b%f'
setopt PROMPT_SUBST
PROMPT='%B%F{130}%n%f %F{82}%~%f (${vcs_info_msg_0_})> '
