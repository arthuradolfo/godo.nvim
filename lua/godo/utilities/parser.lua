local M = {}

local leading_chars = "/?[/#';%%]"
local trailing_chars = "\r?\n"
local godo_keyword = "GODO%(%s*(.-)%s*%)%s*"
local todo_keyword = "TODO%s*"

local godo_pattern = leading_chars .. godo_keyword .. "(.-)" .. trailing_chars
local todo_pattern = leading_chars .. todo_keyword .. "(.-)" .. trailing_chars
local edited_todo_pattern = "^[^#](.-)%)%s*(.-)$"

local function get_file_name()
	return vim.fn.expand( "%:t" ):gsub( "%.", "" )
end

local function buffer_to_string()
    local content = vim.api.nvim_buf_get_lines(
		0,
		0,
		vim.api.nvim_buf_line_count(0),
		false
	)
    return table.concat( content, "\n" ) .. "\n"
end

local function buffer_to_table()
	return vim.api.nvim_buf_get_lines(
		0,
		0,
		vim.api.nvim_buf_line_count(0),
		false
	)
end

local function get_line( todo, buffer, last_index, last_line )
	local todo_index = buffer:find( todo )
	local line_number = last_line
	for _ in buffer:sub( last_index, todo_index ):gmatch( "\n" ) do
		line_number = line_number + 1
	end
	return todo_index, line_number
end

function M.extract_godos()
	local buffer = buffer_to_string()
	local godos = {}
	local i = 1
	local last_index = 1
	local last_line = 1

	for todo in buffer:gmatch( todo_pattern ) do
		last_index, last_line = get_line( todo, buffer, last_index, last_line )
		godos[ i ] = {
			id = get_file_name() .. tostring( i - 1 ),
			description = todo,
			file_name = vim.fn.expand( "%:t" ),
			line_number = last_line
		}
		i = i + 1
	end

	last_index = 1
	last_line = 1
	for id_with_tags, description in buffer:gmatch( godo_pattern ) do
		local tag_list = {}
		local id, tags = id_with_tags:match( "(.-):(.*)" )

		if tags then
			for tag in tags:gmatch( "[^,]+" ) do
				table.insert( tag_list, tag )
			end
		else
			id = id_with_tags
		end

		last_index, last_line = get_line(
			description,
			buffer,
			last_index,
			last_line
		)

		godos[ i ] = {
			id = id,
			description = description,
			file_name = vim.fn.expand( "%:t" ),
			line_number = last_line,
			tags = tag_list
		}

		i = i + 1
	end

	table.sort(godos, function (a, b)
		return a.line_number < b.line_number
	end)

	return godos
end

function M.extract_edited_godos()
	local buffer = buffer_to_table()
	local godos = {}
	local i = 1

	for _, line in ipairs( buffer ) do
		local id_with_tags, description = line:match( edited_todo_pattern )
		if id_with_tags then
			local tag_list = {}
			local id, tags = id_with_tags:match( "(.-):(.*)" )
			if tags then
				for tag in tags:gmatch( "[^,]+" ) do
					table.insert( tag_list, tag )
				end
			else
				id = id_with_tags
			end
			godos[ i ] = {
				id = id,
				description = description,
				tags = tag_list
			}
			i = i + 1
		end
	end

	return godos
end

return M
