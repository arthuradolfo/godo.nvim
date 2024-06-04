local settings	= require( "godo.settings" )
local fshelper = require( "godo.utilities.fshelper" )
local depshelper = require( "godo.utilities.depshelper" )
local parser = require( "godo.utilities.parser" )

if pcall(require, 'notify') then
    vim.notify = require( "notify" )
end

local M = {}

M.has_setup = false

local function buffer_to_string()
    local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    return table.concat(content, "\n")
end

local function setup_autocmds()
	vim.api.nvim_create_autocmd({"BufEnter"}, {
		pattern = "*",
		callback = function()
            if settings.current.parse_todo_file then
		        local buffer_content = buffer_to_string()
                parser.extract_godos( buffer_content )
            end
        end
	})
end

---@param config GodoSettings?
function M.setup(config)
    if config then
        settings.set(config)
    end

    vim.env.GODO = settings.current.install_root_dir

    if not fshelper.isdir(vim.env.GODO) then
        os.execute( "mkdir -p " .. vim.env.GODO )
    end

    if not depshelper.is_dep_installed( "go" ) then
        print( "Go is not installed. Please install." )
        return
    end

    depshelper.set_gopath()

    if not depshelper.is_dep_installed( "godo" )
        or not depshelper.is_godo_version_latest_supported() then
        os.execute( 
            "go install github.com/gabrierlseibel1/godo@" .. settings.godo_version
        )
    end

    require "godo.api.command"
    setup_autocmds()
    M.has_setup = true
end

return M
