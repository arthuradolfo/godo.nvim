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

function M.check_item_exists( id )
    local command = "godo get " .. id
    local result = fshelper.execute( command, "Error getting item `" .. id .. "`" )

    if has_error( result ) then
        return false
    end

    return true
end

return M
