# dotfiles

#### Usage
``` shell
git clone https://github.com/ami-GS/dotfiles
cd dotfiles
su -mp #if this is needed
echo "$USER ALL=(ALL) ALL" >> /etc/sudoers
exit
bash ./setDotfiles.sh
# if you need proxy in your environment
bash ./setDotfiles.sh -p 'address:port'
```
