# LazyDocker.nvim

Work in progress

All credits to the original LazyGit.nvim creator [kdheepak](https://github.com/kdheepak/lazygit.nvim)

Plugin for calling [LazyDocker](https://github.com/jesseduffield/lazydocker) from within neovim.

![](https://github.com/jesseduffield/lazydocker/blob/master/docs/resources/demo3.gif)

### Install

Install using [`lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
{
    "BrunoKrugel/lazydocker.nvim",
    cmd = "LazyDocker",
    -- optional for floating window border decoration
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
},
```

### Usage

The following are configuration options and their defaults.

```vim
let g:lazydocker_floating_window_winblend = 0 " transparency of floating window
let g:lazydocker_floating_window_scaling_factor = 0.9 " scaling factor for floating window
let g:lazydocker_floating_window_border_chars = ['╭','─', '╮', '│', '╯','─', '╰', '│'] " customize lazydocker popup window border characters
let g:lazydocker_floating_window_use_plenary = 0 " use plenary.nvim to manage floating window if available
let g:lazydocker_use_neovim_remote = 1 " fallback to 0 if neovim-remote is not installed

let g:lazydocker_use_custom_config_file_path = 0 " config file path is evaluated if this value is 1
let g:lazydocker_config_file_path = '' " custom config file path
```

```lua
vim.g.lazydocker_floating_window_winblend = 0 -- transparency of floating window
vim.g.lazydocker_floating_window_scaling_factor = 0.9 -- scaling factor for floating window
vim.g.lazydocker_floating_window_border_chars = {'╭','─', '╮', '│', '╯','─', '╰', '│'} -- customize lazydocker popup window border characters
vim.g.lazydocker_floating_window_use_plenary = 0 -- use plenary.nvim to manage floating window if available
vim.g.lazydocker_use_neovim_remote = 1 -- fallback to 0 if neovim-remote is not installed

vim.g.lazydocker_use_custom_config_file_path = 0 -- config file path is evaluated if this value is 1
vim.g.lazydocker_config_file_path = '' -- custom config file path
```

Call `:LazyDocker` to start a floating window with `lazydocker` in the current working directory.

Or set up a mapping to call `:LazyDocker`:

Call `:LazyDockerCurrentFile` to start a floating window with `lazydocker` in the project root of the current file.

Open the configuration file for `lazydocker` directly from vim.

```vim
:LazyDockerConfig<CR>
```

If the file does not exist it'll load the defaults for you.

![](https://user-images.githubusercontent.com/1813121/78830902-46721580-79d8-11ea-8809-291b346b6c42.gif)

Open project commits with `lazydocker` directly from vim in floating window.

```vim
:LazyDockerFilter<CR>
```

Open buffer commits with `lazydocker` directly from vim in floating window.

```vim
:LazyDockerFilterCurrentFile<CR>
```

**Using neovim-remote**

If you have [neovim-remote](https://github.com/mhinz/neovim-remote) and have configured to use it in neovim, it'll launch the commit editor inside your neovim instance when you use `C` inside `lazydocker`.

1. `pip install neovim-remote`

2. Add the following to your `~/.bashrc`:

```bash
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
fi
```

3. Set `EDITOR` environment variable in `~/.bashrc`:

```bash
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export VISUAL="nvim"
    export EDITOR="nvim"
fi
```

4. Add the following to `~/.vimrc`:

```vim
if has('nvim') && executable('nvr')
  let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
endif
```

If you have `neovim-remote` and don't want `lazydocker.nvim` to use it, you can disable it using the following configuration option:

```vim
let g:lazydocker_use_neovim_remote = 0
```

**Using nvim --listen and nvim --server to edit files in same process**

You can use vanilla nvim server to edit files in the same nvim instance when you use `e` inside `lazydocker`.

1. You have to start nvim with the `--listen` parameter. An easy way to ensure this is to use an alias:

```bash
# ~/.bashrc
alias vim='nvim --listen /tmp/nvim-server.pipe'
```

2. You have to modify lazydocker to attempt connecting to existing nvim instance on edit:

```yml
# ~/.config/jesseduffield/lazydocker/config.yml
os:
  editCommand: "nvim"
  editCommandTemplate: '{{editor}} --server /tmp/nvim-server.pipe --remote-tab "$(pwd)/{{filename}}"'
```

### Telescope Plugin

The Telescope plugin is used to track all git repository visited in one nvim session.

![lazydockertelplugin](https://user-images.githubusercontent.com/10464534/156933468-c89abee4-6afb-457c-8b02-55b67913aef2.png)
(background image is not included :smirk:)

**Why a telescope Plugin** ?

Assuming you have one or more submodule(s) in your project and you want to commit changes in both the submodule(s)
and the main repo.
Though switching between submodules and main repo is not straight forward.
A solution at first could be:

1. open a file inside the submodule
2. open lazydocker
3. do commit
4. then open a file in the main repo
5. open lazydocker
6. do commit

That is really annoying.
Instead, you can open it with telescope.

**How to use**

Install using [`packer.nvim`](https://github.com/wbthomason/packer.nvim):

```lua
-- nvim v0.7.2
use({
    "kdheepak/lazydocker.nvim",
    requires = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim",
    },
    config = function()
        require("telescope").load_extension("lazydocker")
    end,
})
```

Install using [`lazy.nvim`](https://github.com/folke/lazy.nvim):

```lua
-- nvim v0.8.0
require("lazy").setup({
    {
        "kdheepak/lazydocker.nvim",
        dependencies =  {
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require("telescope").load_extension("lazydocker")
        end,
    },
})
```

### Highlighting groups

| Highlight Group      | Default Group | Description                              |
| -------------------- | ------------- | ---------------------------------------- |
| **LazyDockerFloat**  | **_Normal_**  | Float terminal foreground and background |
| **LazyDockerBorder** | **_Normal_**  | Float terminal border                    |
