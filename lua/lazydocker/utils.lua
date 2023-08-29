local fn = vim.fn

-- store all git repositories visited in this session
local lazydocker_visited_git_repos = {}

-- TODO:check if the repo isa git repo
local function append_git_repo_path(repo_path)
  if repo_path == nil or not fn.isdirectory(repo_path) then
    return
  end

  for _, path in ipairs(lazydocker_visited_git_repos) do
    if path == repo_path then
      return
    end
  end

  table.insert(lazydocker_visited_git_repos, tostring(repo_path))
end


--- Strip leading and lagging whitespace
local function trim(str)
  return str:gsub('^%s+', ''):gsub('%s+$', '')
end


local function get_root(cwd)
  local status, job = pcall(require, 'plenary.job')
  if not status then
    return fn.system('git rev-parse --show-toplevel')
  end

  local gitroot_job = job:new({
    'git',
    'rev-parse',
    '--show-toplevel',
    cwd=cwd
  })

  local path, code = gitroot_job:sync()
  if (code ~= 0) then
    return nil
  end

  return table.concat(path, "")
end

--- Get project_root_dir for git repository
local function project_root_dir()
  -- always use bash on Unix based systems.
  local oldshell = vim.o.shell
  if vim.fn.has('win32') == 0 then
    vim.o.shell = 'zsh'
  end

  local cwd = vim.loop.cwd()
  local root = get_root(cwd)
  if root == nil then
    return nil
  end

  local cmd = string.format('cd "%s" && git rev-parse --show-toplevel', fn.fnamemodify(fn.resolve(fn.expand('%:p')), ':h'), root)
  -- try symlinked file location instead
  local gitdir = fn.system(cmd)
  local isgitdir = fn.matchstr(gitdir, '^fatal:.*') == ''

  if isgitdir then
    vim.o.shell = oldshell
    append_git_repo_path(gitdir)
    return trim(gitdir)
  end

  -- revert to old shell
  vim.o.shell = oldshell

  local repo_path = fn.getcwd(0, 0)
  append_git_repo_path(repo_path)

  -- just return current working directory
  return repo_path
end

--- Check if lazydocker is available
local function is_lazydocker_available()
  return fn.executable('lazydocker') == 1
end

local function is_symlink()
  local resolved = fn.resolve(fn.expand('%:p'))
  return resolved ~= fn.expand('%:p')
end


return {
  get_root = get_root,
  project_root_dir = project_root_dir,
  lazydocker_visited_git_repos = lazydocker_visited_git_repos,
  is_lazydocker_available = is_lazydocker_available,
  is_symlink = is_symlink,
}
