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
if [ ! -e $HOME/dotfiles/git-prompt.sh ]; then
    echo "Please Download git-prompt.sh "
else
    source $HOME/dotfiles/git-prompt.sh
fi

PROMPT_OPT=""
if [ "$INDOCKER" = y ]; then
    PROMPT_OPT="%F{5}docker%f"
fi
GIT_PS1_SHOWDIRTYSTATE=true
PS1=$PROMPT_OPT'%F{6}$(__git_ps1) %f%F{3}>> %f'
PROMPT=$PS1
RPROMPT='%F{white}%35<..<%~/%f'

#color
export LS_COLOR='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export CLICOLOR=tru
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

alias ls='ls -G'
#conduct 'ls' after 'cd'
function cd(){
    builtin cd $@ && ls;
}
export LSCOLORS=gxfxcxdxbxegedabagacad # ls color for black background

#macports
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=/opt/local/share/man:/opt/local/man:$MANPATH

#from bash path
export PATH=/sw/bin:/sw/sbin:./:/usr/local/sbin/:$PATH
export MANPATH=/sw/share/man/ja:/sw/share/man:/usr/share/man:/usr/local/share/man:/opt/X11/share/man:/usr/textbin/man:/Library/Developer/CommandLineTools/usr/share/man:/sw/lib/perl15/5.16.2/man:$MANPATH

#git
export EDITOR='emacs -nw'

#lang
export locale=en_US.UTF-8

#Go
export PATH=$PATH:/usr/local/go/bin
if [ ! -e $HOME/Go ]; then
    mkdir $HOME/Go
export GOPATH=$HOME/Go
export PATH=$PATH:$GOPATH/bin

# for gtags use, not only default langages.
export GTAGSCONF=/usr/local/share/gtags/gtags.conf
export GTAGSLABEL=pygments

#alias
alias emacs="emacs -nw"
alias python="python2.7" #"python" has rich package but "python2.7" is version 2.7.10
alias active2="source /Users/daiki/pyENV2/bin/activate"
alias active3="source /Users/daiki/pyENV3/bin/activate"
#C++ test
alias cpptest="c++ -I $HOME/googletest/googletest/include $HOME/googletest/googletest/build/libgtest.a $HOME/googletest/googletest/build/libgtest_main.a"
alias ls='ls --color=auto'

#SNAP
export SNAP_PATH=$HOME/Go/src/github.com/intelsdi-x/snap/build

bindkey '^]' peco-src
function peco-src() {
    local src=$(ghq list --full-path | peco --query "$LBUFFER")
    if [ -n "$src" ]; then
	BUFFER="cd $src"
	zle accept-line
    fi
    zle -R -c
}
zle -N peco-src

case `uname` in
  Darwin)
      export DYLD_LIBRARY_PATH=$HOME/llvm/build/lib:$DYLD_LIBRARY_PATH
      alias clang-omp='/usr/local/opt/llvm/bin/clang -fopenmp -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib'
      alias clang-omp++='/usr/local/opt/llvm/bin/clang++ -fopenmp -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib'
      HOMEBREW_GITHUB_API_TOKEN=""
  ;;
  Linux)
    # commands for Linux
  ;;
esac
