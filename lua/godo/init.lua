local settings	= require( "godo.settings" )
local fshelper = require( "godo.utilities.fshelper" )
local depshelper = require( "godo.utilities.depshelper" )

local M = {}

M.has_setup = false

local function setup_autocmds()
end

---@param config GodoSettings?
function M.setup(config)
    if config then
        settings.set(config)
    end

    vim.env.GODO = settings.current.install_root_dir

    if not fshelper.isdir(vim.env.GODO) then
        os.execute( "mkdir " .. vim.env.GODO )
    end

    if not depshelper.is_dep_installed( "go" ) then
        print( "Go is not installed. Please install." )
        return
    end

    if not depshelper.is_dep_installed( "godo" ) then
        os.execute( "go install github.com/gabrierlseibel1/godo@latest" )
    end

    depshelper.set_gopath()

    require "godo.api.command"
    setup_autocmds()
    M.has_setup = true
end

return M
