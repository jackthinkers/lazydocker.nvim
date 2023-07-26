if exists("g:lazydocker_opened") && g:lazydocker_opened && g:lazydocker_use_neovim_remote && executable("nvr")
    augroup lazydocker_neovim_remote
      autocmd!
      autocmd BufUnload <buffer> :lua local root = require('lazydocker').project_root_dir(); vim.schedule(function() require('lazydocker').lazydocker(root) end)
      autocmd BufUnload <buffer> :let g:lazydocker_opened=0
    augroup END
end
