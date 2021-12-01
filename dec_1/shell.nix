{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
	# nativeBuildInputs is usually what you want -- tools you need to run
	nativeBuildInputs = with pkgs; [
		clang-tools
		gcc
		nasm
			
		neovim
		nodejs
		vimPlugins.coc-nvim
	];
	shellHook = ''
		PS1="\e[32;1mnix-shell: \e[34m\w \[\033[00m\]\n↳ "
		alias java_assertions="java -ea"
		alias javac="javac -encoding UTF8"
	'';
}
