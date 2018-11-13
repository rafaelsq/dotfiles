echo "neovim"
sudo apt-add-repository ppa:neovim-ppa/stable

echo "yarn https://yarnpkg.com/pt-BR/docs/install"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

echo "install"
sudo apt update
sudo apt install git bison gcc make zsh silversearcher-ag autojump yarn neovim python-dev python-pip python3-dev python3-pip

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
pip install neovim
pip3 install neovim
