local open_floating_window = require("lazydocker.window").open_floating_window
local project_root_dir = require("lazydocker.utils").project_root_dir
local get_root = require("lazydocker.utils").get_root
local is_lazydocker_available = require("lazydocker.utils").is_lazydocker_available
local is_symlink = require("lazydocker.utils").is_symlink

local fn = vim.fn

LAZYGIT_BUFFER = nil
LAZYGIT_LOADED = false
vim.g.lazydocker_opened = 0
local prev_win = -1
local win = -1
local buffer = -1

--- on_exit callback function to delete the open buffer when lazydocker exits in a neovim terminal
local function on_exit(job_id, code, event)
  if code ~= 0 then
    return
  end

  LAZYGIT_BUFFER = nil
  LAZYGIT_LOADED = false
  vim.g.lazydocker_opened = 0
  vim.cmd("silent! :checktime")

  if vim.api.nvim_win_is_valid(prev_win) then
    vim.api.nvim_win_close(win, true)
    vim.api.nvim_set_current_win(prev_win)
    prev_win = -1
    if vim.api.nvim_buf_is_valid(buffer) and vim.api.nvim_buf_is_loaded(buffer) then
      vim.api.nvim_buf_delete(buffer, { force = true })
    end
    buffer = -1
    win = -1
  end
end

--- Call lazydocker
local function exec_lazydocker_command(cmd)
  if LAZYGIT_LOADED == false then
    -- ensure that the buffer is closed on exit
    vim.g.lazydocker_opened = 1
    vim.fn.termopen(cmd, { on_exit = on_exit })
  end
  vim.cmd("startinsert")
end

local function lazydockerdefaultconfigpath()
  return fn.substitute(fn.system("lazydocker -cd"), "\n", "", "")
end

local function lazydockergetconfigpath()
  if vim.g.lazydocker_config_file_path then
    -- if file exists
    if fn.empty(fn.glob(vim.g.lazydocker_config_file_path)) == 0 then
      return vim.g.lazydocker_config_file_path
    end

    print("lazydocker: custom config file path: '" .. vim.g.lazydocker_config_file_path .. "' could not be found")
  else
    print("lazydocker: custom config file path is not set, option: 'lazydocker_config_file_path' is missing")
  end

  -- any issue with the config file we fallback to the default config file path
  return lazydockerdefaultconfigpath()
end

--- :LazyDocker entry point
local function lazydocker(path)
  if is_lazydocker_available() ~= true then
    print("Please install lazydocker. Check documentation for more information")
    return
  end

  prev_win = vim.api.nvim_get_current_win()

  win, buffer = open_floating_window()

  local cmd = "lazydocker"

  -- set path to the root path
  _ = project_root_dir()

  if vim.g.lazydocker_use_custom_config_file_path == 1 then
    cmd = cmd .. " -ucf " .. lazydockergetconfigpath()
  end

  if path == nil then
    if is_symlink() then
      path = project_root_dir()
    end
  else
    if fn.isdirectory(path) then
      cmd = cmd .. " -p " .. path
    end
  end

  exec_lazydocker_command(cmd)
end

--- :LazyDockerCurrentFile entry point
local function lazydockercurrentfile()
  local current_dir = vim.fn.expand("%:p:h")
  local git_root = get_root(current_dir)
  lazydocker(git_root)
end

--- :LazyDockerFilter entry point
local function lazydockerfilter(path)
  if is_lazydocker_available() ~= true then
    print("Please install lazydocker. Check documentation for more information")
    return
  end
  if path == nil then
    path = project_root_dir()
  end
  prev_win = vim.api.nvim_get_current_win()
  win, buffer = open_floating_window()
  local cmd = "lazydocker " .. "-f " .. path
  exec_lazydocker_command(cmd)
end

--- :LazyDockerFilterCurrentFile entry point
local function lazydockerfiltercurrentfile()
  local current_file = vim.fn.expand("%")
  lazydockerfilter(current_file)
end

--- :LazyDockerConfig entry point
local function lazydockerconfig()
  local config_file = lazydockergetconfigpath()

  if fn.empty(fn.glob(config_file)) == 1 then
    -- file does not exist
    -- check if user wants to create it
    local answer = fn.confirm(
      "File "
        .. config_file
        .. " does not exist.\nDo you want to create the file and populate it with the default configuration?",
      "&Yes\n&No"
    )
    if answer == 2 then
      return nil
    end
    if fn.isdirectory(fn.fnamemodify(config_file, ":h")) == false then
      -- directory does not exist
      fn.mkdir(fn.fnamemodify(config_file, ":h"), "p")
    end
    vim.cmd("edit " .. config_file)
    vim.cmd([[execute "silent! 0read !lazydocker -c"]])
    vim.cmd([[execute "normal 1G"]])
  else
    vim.cmd("edit " .. config_file)
  end
end

return {
  lazydocker = lazydocker,
  lazydockercurrentfile = lazydockercurrentfile,
  lazydockerfilter = lazydockerfilter,
  lazydockerfiltercurrentfile = lazydockerfiltercurrentfile,
  lazydockerconfig = lazydockerconfig,
  project_root_dir = project_root_dir,
}
