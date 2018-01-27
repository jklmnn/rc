
all: vim zsh

vim: $(HOME)/.vimrc vundle

vundle: $(HOME)/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

$(HOME)/.vim/bundle/Vundle.vim:
	git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

$(HOME)/.vimrc: vimrc
	cp vimrc $(HOME)/.vimrc

zsh: zshrc
	cp zshrc $(HOME)/.zshrc
