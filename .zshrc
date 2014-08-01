#auto complete
autoload -Uz compinit
compinit

#spell check
setopt correct
setopt auto_menu
setopt list_packed
setopt list_types
setopt magic_equal_subst
setopt nolistbeep

#history
setopt hist_ignore_space
setopt hist_no_store
setopt hist_ignore_dups

#prompt
setopt prompt_subst
autoload colors
colors

#Emacs like key bind
bindkey -e

#history
HISTFILE=~/.zsh_history
HISTSIZE=1000
SACEHIST=1000

#prompt
PROMPT='%F{green}>> %f'
RPROMPT='%F{white}%35<..<%~/%f'

#color
export LS_COLOR='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export CLICOLOR=tru
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

#conduct 'ls' after 'cd' 
function cd(){
    builtin cd $@ && ls;
}


#macports
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:/opt/local/man:$MANPATH

#from bash path
export PATH=/sw/bin:/sw/sbin:./:/usr/local/sbin/:$PATH
export MANPATH=/sw/share/man/ja:/sw/share/man:/usr/share/man:/usr/local/share/man:/opt/X11/share/man:/usr/textbin/man:/Library/Developer/CommandLineTools/usr/share/man:/sw/lib/perl15/5.16.2/man:$MANPATH

#git
export EDITOR=emacs

#lang
export LANG=ja_JP.UTF-8

#google_appengine
export PATH=/usr/local/google_appengine/:$PATH
export PYTHONPATH=/usr/local/google_appengine/:$PYTHONPATH

#Go
export GOPATH=$HOME/workspace/Go
export PATH=$PATH:$GOPATH/bin

#node
[[ -s /Users/daiki/.nvm/nvm.sh ]] && . /Users/daiki/.nvm/nvm.sh
nvm use v0.10.26
npm_dir=${NVM_PATH}_modules
export NODE_PATH=$npm_dir

#alias
alias emacs="emacs-24.3 -nw"
alias active2="source /Users/daiki/pyENV2/bin/activate"
alias active3="source /Users/daiki/pyENV3/bin/activate"
alias actpypy="source /Users/daiki/pyEnvpy/bin/activate"
alias actbrain="source /Users/daiki/brainENV/bin/activate"
alias py2env="source /Users/daiki/pyENV2/bin/activate && python"
alias py3env="source /Users/daiki/pyENV3/bin/activate && python"
alias lsusb="system_profiler SPUSBDataType"
alias pycat="pygmentize"

# The next line updates PATH for the Google Cloud SDK.
source '/Users/daiki/google-cloud-sdk/path.zsh.inc'

# The next line enables bash completion for gcloud.
source '/Users/daiki/google-cloud-sdk/completion.zsh.inc'
