echo "yarn https://yarnpkg.com/pt-BR/docs/install"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

echo "install"
sudo apt update
sudo apt install git bison gcc make zsh silversearcher-ag autojump yarn python-dev python-pip python3-dev python3-pip aria2

echo "max watches"
sudo sysctl -w fs.inotify.max_user_watches=1048576 && sysctl -p

echo "oh-my-zsh, https://github.com/robbyrussell/oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "zsh autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions


echo "plug - https://github.com/junegunn/vim-plug"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "yarn basics"
yarn global add parcel eslint prettier-eslint eslint-plugin-react

echo "neovim+"
echo "download appimage from https://github.com/neovim/neovim/releases"
echo "mkdir -p ~/appimage && chmod +x ~/appimage"
yarn global add neovim
pip install neovim
pip3 install neovim
