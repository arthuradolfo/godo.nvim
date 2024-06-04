local M = {}

---@class GodoSettings
local DEFAULT_SETTINGS = {
	---@since 1.0.0
	-- Directory to install dependencies (divoom api clients)
	install_root_dir = table.concat(
		{ vim.fn.stdpath "data", "/godo.nvim" }
	),

	---@since 1.0.0
	-- Log file
	log_file = table.concat(
		{ vim.fn.stdpath "data", "/godo.nvim", "/log", "/log.txt" }
	),

	---@since 1.0.0
	--- Boolean to enable/disable parsing of TODO comments
	parse_todo_file = false
}

M.DEFAULT_SETTINGS = DEFAULT_SETTINGS
M.current = DEFAULT_SETTINGS
M.godo_version = "v0.2.0"

---@param opts GodoSettings
function M.set(opts)
    M.current = vim.tbl_deep_extend("force", vim.deepcopy(M.current), opts)
end

return M
