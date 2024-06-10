local fshelper = require( "godo.utilities.fshelper" )

local M = {}

--- Check if command has error
---@param message string
---@return boolean
local function has_error( message )
    if string.find( message, "!BADKEY=\"not found\"" ) then
        return true
    else
        return false
    end
end

local function check_item_exists( id )
    local command = "godo get " .. id

    local result = fshelper.execute(
        command,
        "Error getting item `" .. id .. "`"
    )

    if has_error( result ) then
        return false
    end

    return true
end

function M.create_godos( godo_list )
	for _, godo in pairs( godo_list ) do
		if not check_item_exists( godo.id ) then
			vim.cmd.GodoCreateItem( godo.id, godo.description )
            for _, tag in ipairs( godo.tags ) do
                vim.cmd.GodoTagItems( godo.id, tag )
            end
		end
	end
end

return M
