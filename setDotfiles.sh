if [  "$(uname)" == 'Darwin' ]; then
    if type git > /dev/null 2>&1; then
	# is brew installed as default?
	sudo brew install git
	sudo brew install tig
    fi
    OS='Mac'
elif [  "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    if   [  -e /etc/debian_version ] ||
         [  -e /etc/debian_release ]; then
        # Check Ubuntu or Debian
	# for golang
	sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
	sudo apt-get update
	sudo apt-get upgrade -y
	sudo apt-get install -y cmake
	sudo apt-get install -y golang
	sudo apt-get install -y zsh
    fi
    if type git > /dev/null 2>&1; then
	sudo apt-get install -y git
	sudo apt-get install -y tig
    fi
    OS='Linux'
elif [  "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
    OS='Cygwin'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

# google test settings
git clone https://github.com/google/googletest $HOME/googletest
makedir googletest/googletest/build
cd googletest/googletest/build
cmake ..
make ..
cd $HOME/dotfiles

cp .tmux.conf $HOME/
cp .emacs $HOME/
cp -r .emacs.d $HOME/
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
sudo chsh -s /usr/bin/zsh
cp .zshrc $HOME/
