
all: vimrc zsh tmux modules

vimrc: vim-default

vim-default: $(HOME)/.vimrc vundle

vim-extended: vim-default vimrc-extended
	sed -i "/\"Plugin EXTEND/r vimrc-extended" $(HOME)/.vimrc
	sed -i "s/\"Plugin EXTEND//g" $(HOME)/.vimrc
	vim +PluginInstall +qall

vundle: $(HOME)/.vim/bundle/Vundle.vim
	vim +PluginInstall +qall

$(HOME)/.vim/bundle/Vundle.vim:
	git clone https://github.com/VundleVim/Vundle.vim.git $(HOME)/.vim/bundle/Vundle.vim

$(HOME)/.vimrc: vimrc-default
	cp vimrc-default $(HOME)/.vimrc

$(HOME)/.zshrc.local: zshrc.local
	cp zshrc.local $(HOME)/.zshrc.local

$(HOME)/.zshrc:
	wget -O $(HOME)/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc

zsh: $(HOME)/.zshrc $(HOME)/.zshrc.local

$(HOME)/.tmux.conf: tmux.conf
	cp tmux.conf $(HOME)/.tmux.conf

$(HOME)/.tmuxconkyrc: tmuxconkyrc
	cp tmuxconkyrc $(HOME)/.tmuxconkyrc

tmux: $(HOME)/.tmux.conf $(HOME)/.tmuxconkyrc

nix: $(HOME)/.nix-profile/etc/profile.d/nix.sh
	curl https://nixos.org/nix/install | sh

modules:
	rsync -rupE modules/* $(HOME)/.modules

.PHONY: all vimrc vim-default vim-extended vundle zsh tmux nix modules
