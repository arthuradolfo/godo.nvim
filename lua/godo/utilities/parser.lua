local godoapi = require( "godo.api.godoapi" )

local M = {}

local leading_chars = "/?[/#';%%]"
local trailing_chars = "\r?\n"
local godo_keyword = "GODO%(%s*(.-)%s*%)%s*"
local todo_keyword = "TODO%s*"

local godo_pattern = leading_chars .. godo_keyword .. "(.-)" .. trailing_chars
local todo_pattern = leading_chars .. todo_keyword .. "(.-)" .. trailing_chars

local function get_file_name()
	return string.gsub( vim.fn.expand( "%:t" ), "(.-)%..*", "%1" )
end

local function parse_buffer( buffer )
	local todos = {}
	local i = 0

	for todo in string.gmatch( buffer, todo_pattern ) do
		todos[ i ] = {
			id = get_file_name() .. tostring( i ),
			description = todo
		}
		i = i + 1
	end

	for id, description in string.gmatch( buffer, godo_pattern ) do
		todos[ i ] = { id = id, description = description }
	end

	return todos
end

function M.extract_godos( buffer )
	godos = parse_buffer( buffer )

	for _, godo in pairs( godos ) do
		if not godoapi.check_item_exists( godo.id ) then
			vim.cmd.GodoCreateItem( godo.id, godo.description )
		end
	end
end

return M
