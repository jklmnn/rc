
all: neovim zsh tmux modules

vimrc: $(HOME)/.vim/autoload/plug.vim
	cp init.vim $(HOME)/.vimrc

vim: vimrc
	vim +PlugUpdate +qall

vim-extended: vim
	sed -i "/\"Plug extend/r init.extend" $(HOME)/.vimrc
	sed -i "s/\"Plug extend//g" $(HOME)/.vimrc
	vim +PlugUpdate +UpdateRemotePlugins +qall

nvim: $(HOME)/.local/share/nvim/site/autoload/plug.vim
	mkdir -p $(HOME)/.config/nvim
	cp init.vim $(HOME)/.config/nvim/init.vim

neovim: nvim
	nvim +PlugUpdate +qall

neovim-extended: nvim
	sed -i "/\"Plug extend/r init.extend" $(HOME)/.config/nvim/init.vim
	sed -i "s/\"Plug extend//g" $(HOME)/.config/nvim/init.vim
	nvim +PlugUpdate +UpdateRemotePlugins +qall

$(HOME)/%/plug.vim:
	curl -fLo $@ --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

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

.PHONY: all vim vim-extended neovim neovim-extended zsh tmux nix modules
