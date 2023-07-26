scriptencoding utf-8

if exists('g:loaded_lazydocker_vim') | finish | endif

let s:save_cpo = &cpoptions
set cpoptions&vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists('g:lazydocker_floating_window_winblend')
    let g:lazydocker_floating_window_winblend = 0
endif

if !exists('g:lazydocker_floating_window_scaling_factor')
  let g:lazydocker_floating_window_scaling_factor = 0.9
endif

if !exists('g:lazydocker_use_neovim_remote')
  let g:lazydocker_use_neovim_remote = executable('nvr') ? 1 : 0
endif

if exists('g:lazydocker_floating_window_corner_chars')
  echohl WarningMsg
  echomsg "`g:lazydocker_floating_window_corner_chars` is deprecated. Please use `g:lazydocker_floating_window_border_chars` instead."
  echohl None
  if !exists('g:lazydocker_floating_window_border_chars')
    let g:lazydocker_floating_window_border_chars = g:lazydocker_floating_window_corner_chars
  endif
endif

if !exists('g:lazydocker_floating_window_border_chars')
  let g:lazydocker_floating_window_border_chars = ['╭','─', '╮', '│', '╯','─', '╰', '│']
endif

" if lazydocker_use_custom_config_file_path is set to 1 the
" lazydocker_config_file_path option will be evaluated
let g:lazydocker_use_custom_config_file_path = 0
" path to custom config file
let g:lazydocker_config_file_path = ''

command! LazyDocker lua require'lazydocker'.lazydocker()

command! LazyDockerCurrentFile lua require'lazydocker'.lazydockercurrentfile()

command! LazyDockerFilter lua require'lazydocker'.lazydockerfilter()

command! LazyDockerFilterCurrentFile lua require'lazydocker'.lazydockerfiltercurrentfile()

command! LazyDockerConfig lua require'lazydocker'.lazydockerconfig()

""""""""""""""""""""""""""""""""""""""""""""""""""""""

let &cpoptions = s:save_cpo
unlet s:save_cpo

let g:loaded_lazydocker_vim = 1
