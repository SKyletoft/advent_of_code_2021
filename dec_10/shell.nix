{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
	# nativeBuildInputs is usually what you want -- tools you need to run
	nativeBuildInputs = with pkgs; [
		zig

		neovim
		nodejs
		vimPlugins.coc-nvim
	];
	shellHook = ''
		PS1="\e[32;1mnix-shell: \e[34m\w \[\033[00m\]\n↳ "
	'';
}
