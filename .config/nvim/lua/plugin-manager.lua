local err, job = pcall(require, 'plenary.job')

local plugin_manager = {}
plugin_manager.plugins = {}

function plugin_manager.plugins_install()
  for _, plugin in ipairs(plugin_manager.plugins) do
    local plugin_name = vim.split(plugin, "/")[2]
    local install_path = vim.fn.stdpath('data') .. '/site/pack/plugins/start/' .. plugin_name

    local git_clone = 'git clone --depth=1 https://github.com/' .. plugin .. ' ' .. install_path .. ' 2>/dev/null &'
    os.execute(git_clone)
  end
end

function plugin_manager.plugins_update()
  for _, plugin in ipairs(plugin_manager.plugins) do
    local plugin_name = vim.split(plugin, "/")[2]
    local plugin_path = vim.fn.stdpath('data') .. '/site/pack/plugins/start/' .. plugin_name

    if not err then
      job:new({
        command = 'git',
        args = { 'pull' },
        cwd = plugin_path,
        on_exit = function(j, return_val)
          if j:result()[1] then
            if string.match(j:result()[1], "Already up to date.") then
              print("Couldn't update " .. plugin_name)
            else
              print('Updated ' .. plugin_name)
            end
          end
        end,
      }):start()
    end
  end
end

return plugin_manager
