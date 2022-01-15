{ pkgs ? import <nixpkgs> {} }:
let
	custom-haskell = pkgs.ghc.withPackages(pkgs: with pkgs; [
		QuickCheck
		hindent
		stylish-haskell
		haskell-language-server
		futhark
	]);
in pkgs.mkShell {
	# nativeBuildInputs is usually what you want -- tools you need to run
	nativeBuildInputs = with pkgs; [
		gnumake
		python3

		custom-haskell

		neovim
		nodejs
		vimPlugins.coc-nvim
	];
	shellHook = ''
		PS1="\e[32;1mnix-shell: \e[34m\w \[\033[00m\]\n↳ "
	'';
}
