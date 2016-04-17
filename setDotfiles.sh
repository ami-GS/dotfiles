cp .tmux.conf $HOME/
cp .emacs $HOME/
cp -r .emacs.d $HOME/
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > git_prompt.sh
mv git_prompt.sh.1 git_prompt.sh
sudo apt-get install zsh
chsh -s /usr/bin/zsh
cp .zshrc $HOME/
