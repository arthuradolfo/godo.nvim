local M = {}

--- Copied from https://stackoverflow.com/questions/1340230/check-if-directory-exists-in-lua
--- Check if a file or directory exists in this path
function M.exists(file)
   local ok, err, code = os.rename(file, file)
   if not ok then
      if code == 13 then
         -- Permission denied, but it exists
         return true
      end
   end
   return ok, err
end

--- Copied from https://stackoverflow.com/questions/1340230/check-if-directory-exists-in-lua
--- Check if a directory exists in this path
function M.isdir(path)
   -- "/" works on both Unix and Windows
   return M.exists(path.."/")
end

--- Execute command and print error message if error occurs
---@param command string
---@param message string
---@return string
function M.execute( command, message )
    local handle = io.popen( command .. " 2>&1" )

    if handle == nil then
		vim.notify( message, "error" )
		return false
	end

    local result = handle:read( "*a" )
    return result
end

return M
