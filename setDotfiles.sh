while getopts cp: OPT
do
    case $OPT in
	"p" ) PROXY="TRUE" ; PROXY_VALUE="$OPTARG" ;;
    esac
done

if [ "$PROXY" = "TRUE" ]; then
    #this includes git install
    sudo python set_proxy.py PROXY_VALUE
fi

if [  "$(uname)" == 'Darwin' ]; then
    if type git > /dev/null 2>&1; then
	# install brew
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew install git tig go colordiff cmake automake wget libtool pkg-config libevent
	# install pip
	curl https://bootstrap.pypa.io/get-pip.py > get-pip.py
	sudo python get-pip.py
	sudo pip install nose tornado
	rm get-pip.py
    fi
    OS='Mac'
elif [  "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
    if   [  -e /etc/debian_version ] ||
         [  -e /etc/debian_release ] ||
	 [  -e /etc/SuSE-release   ]; then
        # Check Ubuntu, Debian or SuSE
	# for golang
	sudo apt-get update && sudo apt-get install -y apt-file && sudo apt-file update
	sudo apt-get install -y software-properties-common
	sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
	sudo apt-get update -y
	sudo apt-get install -y cmake zsh golang git tig automake libevent-dev \
	     exuberant-ctags python-pygments python3-pygments ncurses-dev \
	     llvm libclang-dev wget cgdb htop python-pip colordiff
	if [  -e /etc/SuSE-release ]; then
	    sudo apt-get install -y go
	else
	    sudo apt-get install -y golang
	fi
    elif [  -e /etc/redhat-release ]; then
	# rhel, centos
	sudo yum install -y centos-release-scl epel-release
	sudo yum-config-manager --enable rhel-server-rhscl-7-rpms -y # for rhel
	sudo yum update -y
	sudo yum install -y zsh cmake git tig ctags-etags libevent gcc gcc-c++ \
	     python-pygments ncurses-devel ncurses wget automake libevent-devel \
	     devtoolset-7 llvm llvm-devel clang clang-devel go python-pip colordiff
    fi
    OS='Linux'
elif [  "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
    OS='Cygwin'
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi
sudo pip install --upgrade pip

git config --global user.name ami-GS
git config --global user.email 1991.daiki@gmail.com

export WORKSPACE=$HOME/workspace
export GOPATH=$WORKSPACE
export PATH=$PATH:$GOPATH/bin
if [ ! -e $WORKSPACE ]; then
    mkdir $WORKSPACE
    go get github.com/motemen/ghq
    git config --global ghq.root $GOPATH/src
fi

if [ ! -e $GOPATH/src/github.com/Andersbakken/rtags ];then
    ghq get https://github.com/Andersbakken/rtags.git
    cd $GOPATH/src/github.com/Andersbakken/rtags
    git submodule init
    git submodule update
    mkdir build && cd build
    cmake ../ -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && make -j4
    ./bin/rdm --daemon
    cd $HOME
fi

if [ ! -e $GOPATH/src/github.com/rizsotto/Bear ]; then
    ghq get https://github.com/rizsotto/Bear
    cd $GOPATH/src/github.com/rizsotto/Bear
    mkdir build && cd build
    cmake .. && make -j 4 && sudo make install -j4
fi

go get github.com/rogpeppe/godef
go get -u github.com/nsf/gocode
go get github.com/golang/lint/golint
go get github.com/kisielk/errcheck
go get github.com/peco/peco/cmd/peco

# [WIP] rust setting
curl -sf -L https://static.rust-lang.org/rustup.sh | sh


# google test settings
if [ ! -e $HOME/googletest ]; then
   git clone https://github.com/google/googletest $HOME/googletest
   mkdir googletest/googletest/build
   cd googletest/googletest/build
   cmake .. && make ..
   cd $HOME/dotfiles
fi


if [ ! -e $GOPATH/src/github.com/tmux/tmux ];then
    ghq get https://github.com/tmux/tmux
    cd $GOPATH/src/github.com/tmux/tmux
    sh autogen.sh && ./configure && make
    cd $HOME/dotfiles
    sudo ln -s $GOPATH/src/github.com/tmux/tmux/tmux /usr/local/bin/tmux
    cp .tmux.conf $HOME/
fi

# need to be separated (observed error only in docker environment)
sudo pip install setuptools Pygments
sudo pip install -U jedi epc pyflakes

if [ ! -e $HOME/.myconfig ]; then
    mkdir $HOME/.myconfig
fi

GLOBAL_VER="global-6.5.6"
if [[ ! -e global* ]]; then
   wget http://tamacom.com/global/$GLOBAL_VER.tar.gz -P $HOME/.myconfig/ #need to be latest
   cd $HOME/.myconfig
   tar -zxvf $GLOBAL_VER.tar.gz && cd $GLOBAL_VER
   sudo ./configure && sudo make && sudo make install
   rm $HOME/.myconfig/$GLOBAL_VER.tar.gz
   cd $HOME/dotfiles
fi


if [ ! -e $HOME/.myconfig/git-prompt.sh ]; then
    wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -P $HOME/.myconfig/
fi
sudo chsh -s /bin/zsh $USER
cp .zshrc $HOME/
cp .emacs $HOME/
cp -r .emacs.d $HOME/
cp -r .docker $HOME/

if [ "$*" == "--xwindow" ]; then
    OUT=$(grep X11Forwarding /etc/ssh/sshd_config | grep -o yes)
    if [ "$OUT" != "yes" ]; then
	sudo sed -i -e 's/X11Forwarding no/X11Forwarding yes/g' /etc/ssh/sshd_config
    fi
fi
