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

```
:LazyDockerFilter<CR>
```

Open buffer commits with `lazydocker` directly from vim in floating window.

```
:LazyDockerFilterCurrentFile<CR>
```

### Highlighting groups

| Highlight Group      | Default Group | Description                              |
| -------------------- | ------------- | ---------------------------------------- |
| **LazyDockerFloat**  | **_Normal_**  | Float terminal foreground and background |
| **LazyDockerBorder** | **_Normal_**  | Float terminal border                    |
