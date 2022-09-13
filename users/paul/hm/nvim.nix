{ stdenv, neovim, vimPlugins, tree-sitter }:

let
  neovim-with-config = { rc, plugins }: neovim.override {
    configure = {
      customRC = rc;
      plug.plugins = plugins;
    };
  };
  neovim-config = stdenv.mkDerivation rec {
    name = "nvimconf";
    src = ./files/nvimconf;
    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
    '';
  };
in
neovim-with-config {
  rc = (''
          let nixManaged=1
          set runtimepath+=${neovim-config}
        '' + builtins.readFile "${neovim-config}/init.vim");
  plugins = with vimPlugins; [
    # editing
    tcomment_vim vim-sandwich vim-unimpaired vim-abolish vim-repeat
    auto-pairs vim-lion vim-sneak tabular vim-markdown rust-tools-nvim
    # snippets
    ultisnips friendly-snippets vim-vsnip
    # completion
    nvim-compe nvim-lspconfig
    # appearance
    (nvim-treesitter.withPlugins (plugins: tree-sitter.allGrammars))
    onedark-nvim onedarkpro-nvim vim-polyglot lualine-nvim
    vim-highlightedyank nvim-web-devicons
    plenary-nvim popup-nvim goyo-vim lens-vim nvim-cursorline
    # tools
    toggleterm-nvim direnv-vim formatter-nvim
    telescope-nvim
    nvim-tree-lua vim-fugitive
  ];
}
