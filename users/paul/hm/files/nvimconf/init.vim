if empty(nixManaged)
    " Expand the home directory to an absolute path.
    let homeDir=expand('~')

    " Find the desired VimPlug install location for different system configurations.
    if(has('win32') || has('win64'))
        let shareDir=homeDir.'\AppData\Local\nvim'
        let plugVim=shareDir.'\autoload\plug.vim'
    else
        let shareDir=homeDir.'/.local/share/nvim/site'
        let plugVim=shareDir.'/autoload/plug.vim'
    endif

    " Url of the VimPlug script.
    let plugUri = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    if empty(glob(expand(plugVim)))
        if has('win32') || has('win64')
        	" Make sure the autoload directory has been created.
            exec '!md '.shareDir.'\autoload'

            " Download VimPlug using PowerSHell.
            exec '!powershell -command Invoke-WebRequest -Uri "'.plugUri.'" -OutFile "'.plugVim.'"'
        else
            " Download VimPlug using curl.
            exec '!curl -fLo '.plugVim.' --create-dirs '.plugUri
        endif

    	" Automatically run PlugInstall command.
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endif

if(has("win32") || has ("win64"))
  let $VIMRUNTIME='C:\tools\neovim\Neovim\share\nvim\runtime'
  let g:loaded_python_provider=0
  let g:python_host_prog=''
  let g:python3_host_prog='C:\msys64\usr\bin\python3.9.exe'
endif

filetype indent plugin on
syntax on
let mapleader=' '
let maplocalleader='\\'
set nocompatible nu rnu laststatus=2 noshowmode splitbelow splitright
set completeopt=menuone,noselect clipboard=unnamedplus autochdir
set encoding=utf-8 lazyredraw scrolloff=7 nohlsearch go=a hidden
set nolist lcs=eol:$,tab:>-\|,space:·,nbsp:°,trail:¤ lbr

if empty(nixManaged)
  call plug#begin(stdpath('config') . '/plugged')
  Plug 'SirVer/ultisnips'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/nvim-compe'
  Plug 'neovim/nvim-lspconfig'
  Plug 'navarasu/onedark.nvim'
    let g:onedark_style = 'darker'
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'sheerun/vim-polyglot'
  Plug 'tomtom/tcomment_vim'
  Plug 'machakann/vim-sandwich'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-abolish'
  Plug 'tpope/vim-repeat'
  Plug 'jiangmiao/auto-pairs'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'machakann/vim-highlightedyank'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'tommcdo/vim-lion'
    let g:lion_squeeze_spaces=0
  Plug 'justinmk/vim-sneak'
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'jvgrootveld/telescope-zoxide'
  Plug 'simrat39/rust-tools.nvim'
  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'
  Plug 'junegunn/goyo.vim'
  Plug 'Teu5us/lens.vim'
  Plug 'glepnir/indent-guides.nvim'
  Plug 'yamatsum/nvim-cursorline'
  Plug 'akinsho/nvim-toggleterm.lua'
  Plug 'lukas-reineke/format.nvim'
  Plug 'direnv/direnv.vim'
  call plug#end()
endif

if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" APPEARANCE
set cursorline
set bg=dark
colo onedark

" LENS.VIM
let g:lens#disabled_filetypes = ['TelescopePrompt', 'NvimTree']
let g:lens#disable_for_diff = 1

" KEYMAP
nnoremap <C-z> /<C-^><C-c>
vnoremap <C-z> /<C-^><C-c>
lnoremap <C-z> <C-^>
inoremap <C-z> <C-^>
cnoremap <C-z> <C-^>
onoremap <C-z> <C-^>
inoremap <C-\> /
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=-1

" Show active keymap
fun! KM()
  if &iminsert
    return b:keymap_name
  else
    return 'us'
  endif
endfu
com! KM call KM()

noremap Q <Nop>
nnoremap Y y$
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <leader>wj <C-W><C-J>
nnoremap <leader>wk <C-W><C-K>
nnoremap <leader>wl <C-W><C-L>
nnoremap <leader>wh <C-W><C-H>

nnoremap <leader>fp :e stdpath('config') . "/init.vim"<cr>
nnoremap <leader>fn :e "~/.config/nixpkgs/home/config/nvim/init.vim"<cr>
nnoremap <leader>rr :so stdpath('config') . "/init.vim"<cr>
nnoremap <leader>fs :w<cr>
nnoremap <leader>qq :q<cr>
nnoremap <leader>qQ :q!<cr>
nnoremap <leader>bd :bd<cr>
nnoremap <leader>bD :bd!<cr>
nnoremap <leader>oE :silent !explorer .

" GOYO
nnoremap <leader>tg :Goyo<cr>

" TELESCOPE
nnoremap <leader>. <cmd>Telescope find_files<cr>
nnoremap <leader>ff <cmd>lua require'telescope.builtin'.find_files({ hidden = true })<cr>
nnoremap <leader>fh <cmd>lua require'telescope.builtin'.find_files({ hidden = true, search_dirs = { nvim = "C:\\Users\\Suess" } })<cr>
nnoremap <leader>pF <cmd>lua require'telescope.builtin'.find_files({ hidden = true, search_dirs = { nvim = "C:\\Users\\Suess\\AppData\\Local\\nvim" } })<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope file_browser<cr>
nnoremap <leader>fr <cmd>Telescope oldfiles<cr>
nnoremap <leader>, <cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>
nnoremap <leader>bb <cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>
nnoremap <leader>hh <cmd>Telescope help_tags<cr>
nnoremap <leader>ho <cmd>Telescope vim_options<cr>
nnoremap <leader>; <cmd>Telescope commands<cr>
nnoremap <leader>: <cmd>Telescope command_history<cr>
nnoremap <leader>/ <cmd>Telescope search_history<cr>
nnoremap <leader>" <cmd>Telescope registers<cr>
nnoremap <leader>ss <cmd>Telescope current_buffer_fuzzy_find<cr>
" nnoremap <leader>zo <cmd>lua require'telescope'.extensions.zoxide.list{}<cr>

" SNEAK
let g:sneak#label=1
function! SetLabels()
  if &iminsert
    let g:sneak#target_labels = "аовлыдфжмьсбчюя."
  else
    let g:sneak#target_labels="fjdksla;vmc,x.z/"
  endif
endfunction
au User SneakEnter call SetLabels()
highlight Sneak guifg=black guibg=yellow ctermfg=black ctermbg=yellow
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" VIM-HIGHLIGHTEDYANK
let g:highlightedyank_highlight_duration=200
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif

" MARKDOWN
let g:vim_markdown_folding_style_pythonic=1
let g:vim_markdown_strikethrough=1
let g:vim_markdown_frontmatter=1
let g:vim_markdown_math=1

" NVIM TREE
let g:nvim_tree_side = 'left' "left by default
let g:nvim_tree_width = 40 "30 by default
let g:nvim_tree_ignore = [ '.git', 'node_modules', '.cache' ] "empty by default
let g:nvim_tree_gitignore = 1 "0 by default
let g:nvim_tree_auto_open = 0 "0 by default, opens the tree when typing `vim $DIR` or `vim`
let g:nvim_tree_auto_close = 1 "0 by default, closes the tree when it's the last window
let g:nvim_tree_auto_ignore_ft = [ 'startify', 'dashboard' ] "empty by default, don't auto open tree on specific filetypes.
let g:nvim_tree_quit_on_open = 1 "0 by default, closes the tree when you open a file
let g:nvim_tree_follow = 1 "0 by default, this option allows the cursor to be updated when entering a buffer
let g:nvim_tree_indent_markers = 1 "0 by default, this option shows indent markers when folders are open
let g:nvim_tree_hide_dotfiles = 1 "0 by default, this option hides files and folders starting with a dot `.`
let g:nvim_tree_git_hl = 1 "0 by default, will enable file highlight for git attributes (can be used without the icons).
let g:nvim_tree_highlight_opened_files = 1 "0 by default, will enable folder and file icon highlight for opened files/directories.
let g:nvim_tree_root_folder_modifier = ':~' "This is the default. See :help filename-modifiers for more options
let g:nvim_tree_tab_open = 1 "0 by default, will open the tree when entering a new tab and the tree was previously open
let g:nvim_tree_width_allow_resize  = 1 "0 by default, will not resize the tree when opening a file
let g:nvim_tree_disable_netrw = 0 "1 by default, disables netrw
let g:nvim_tree_hijack_netrw = 0 "1 by default, prevents netrw from automatically opening when opening directories (but lets you keep its other utilities)
let g:nvim_tree_add_trailing = 1 "0 by default, append a trailing slash to folder names
let g:nvim_tree_group_empty = 1 " 0 by default, compact folders that only contain a single folder into one node in the file tree
let g:nvim_tree_lsp_diagnostics = 1 "0 by default, will show lsp diagnostics in the signcolumn. See :help nvim_tree_lsp_diagnostics
let g:nvim_tree_disable_window_picker = 1 "0 by default, will disable the window picker.
let g:nvim_tree_window_picker_exclude = {
    \   'filetype': [
    \     'packer',
    \     'qf',
    \   ],
    \   'buftype': [
    \     'terminal'
    \   ]
    \ }
" Dictionary of buffer option names mapped to a list of option values that
" indicates to the window picker that the buffer's window should not be
" selectable.
let g:nvim_tree_special_files = [ 'README.md', 'Makefile', 'MAKEFILE' ] " List of filenames that gets highlighted with NvimTreeSpecialFile
let g:nvim_tree_show_icons = {
    \ 'git': 1,
    \ 'folders': 1,
    \ 'files': 1,
    \ }
"If 0, do not show the icons for one of 'git' 'folder' and 'files'
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath

" default will show icon by default if no icon is provided
" default shows no icon by default
let g:nvim_tree_icons = {
    \ 'default': '',
    \ 'symlink': '',
    \ 'git': {
    \   'unstaged': "✗",
    \   'staged': "✓",
    \   'unmerged': "",
    \   'renamed': "➜",
    \   'untracked': "★",
    \   'deleted': "",
    \   'ignored': "◌"
    \   },
    \ 'folder': {
    \   'default': "",
    \   'open': "",
    \   'empty': "",
    \   'empty_open': "",
    \   'symlink': "",
    \   'symlink_open': "",
    \   },
    \   'lsp': {
    \     'hint': "",
    \     'info': "",
    \     'warning': "",
    \     'error': "",
    \   }
    \ }

nnoremap <leader>ot :NvimTreeToggle<CR>
nnoremap <leader>tr :NvimTreeRefresh<CR>
nnoremap <leader>tf :NvimTreeFindFile<CR>
" NvimTreeOpen and NvimTreeClose are also available if you need them

" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blue

" ULTINSIPS
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" COMPE
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" FORMAT
augroup Format
    autocmd!
    autocmd BufWritePost * FormatWrite
augroup END

" LOAD LUA
lua require 'treesitter'
lua require 'completion'
lua require 'lsp'
lua require 'tscope'
lua require 'rust'
" lua require 'indent'
lua require 'term'
lua require 'statusline'
" lua require 'autoformat'
lua require'nvim-tree'.setup{}
lua require'onedarkPro'

" AU SECTION
" restore last cursor position
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
