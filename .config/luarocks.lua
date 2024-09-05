-- Avoid the usual shebang-with-spaces-makes-not-nice issue.
local data_home = platforms.macos and (home .. '/.local/share') or os_getenv("XDG_DATA_HOME")
rocks_trees = {
  {
    name = 'user',
    root = data_home .. '/luarocks'
  },
}
