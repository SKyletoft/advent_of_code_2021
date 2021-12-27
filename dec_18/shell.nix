{ pkgs ? import <nixpkgs> {} }:
let
	old_pkgs = import (builtins.fetchGit {
		# Whatever old version was in the example.
		# Used because the current swift package fails to build
		name = "my-old-revision";                                                 
		url = "https://github.com/nixos/nixpkgs-channels/"; 
		ref = "refs/heads/nixpkgs-unstable";                     
		rev = "67912138ea79c9690418e3c6fc524c4b06a396ad";
	}) {};
in
	pkgs.mkShell {
		# nativeBuildInputs is usually what you want -- tools you need to run
		nativeBuildInputs = with pkgs; [
			old_pkgs.julia

			neovim
			nodejs
			vimPlugins.coc-nvim
		];
		shellHook = ''
			PS1="\e[32;1mnix-shell: \e[34m\w \[\033[00m\]\n↳ "
		'';
	}
