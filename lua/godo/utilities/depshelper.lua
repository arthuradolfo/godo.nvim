local settings = require( "godo.settings" )

local M = {}

--- Check if dependency is installed on system
---@param dependency string
---@return boolean
function M.is_dep_installed(dependency)
	local command = "command -v " .. dependency .. " >/dev/null 2>&1 || echo 'Not found'"
	local handle = io.popen( command )

	if handle == nil then
		vim.notify( "Error getting information about " .. dependency, "error" )
		return false
	end

	local result = handle:read( "*a" )
	handle:close()
	return not( result == "Not found\n")
end

--- Set gopath and concatenate it on PATH
function M.set_gopath()
	local command = "go env GOPATH"
	local handle = io.popen( command )

	if handle == nil then
		vim.notify( "Error getting GOPATH environment variable.", "error" )
		return false
	end

	local result = handle:read( "*a" )
	handle:close()
	vim.env.PATH = vim.env.PATH .. ':' .. result:gsub( '[\n\r]', '' ) .. '/bin'
end

function M.is_godo_version_latest_supported()
	local command = "godo version"
	local handle = io.popen( command )

	if handle == nil then
		vim.notify( "Error getting godo version", "error" )
		return false
	end

	local result = handle:read( "*a" )
	handle:close()
	return not( result == settings.godo_version .. "\n" )
end

return M
