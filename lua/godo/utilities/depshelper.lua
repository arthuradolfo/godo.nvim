local M = {}

--- Check if dependency is installed on system
---@param dependency string
---@return boolean
function M.is_dep_installed(dependency)
	local command = "command -v " .. dependency .. " >/dev/null 2>&1 || echo 'Not found'"
	local handle = io.popen( command )

	if handle == nil then
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
		return false
	end

	local result = handle:read( "*a" )
	handle:close()
	vim.env.PATH = vim.env.PATH .. ':' .. result:gsub( '[\n\r]', '' ) .. '/bin'
end

return M
