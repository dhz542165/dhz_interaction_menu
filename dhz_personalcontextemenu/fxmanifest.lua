----------------------BY DHZ----------------------
---------------discord.gg/ZKJcrDddYx--------------
----------------------BY DHZ----------------------
fx_version 'adamant'
game 'gta5'

shared_scripts {
  'shared/cfg.lua'
}

client_scripts {
  "src/components/*.lua",
  "src/ContextUI.lua",
  'cl/cl_utils.lua',
  'cl/cl_main.lua'
}

server_scripts {
  '@async/async.lua',
  '@es_extended/locale.lua',
  '@mysql-async/lib/MySQL.lua',
  'sv/sv_main.lua'
}
