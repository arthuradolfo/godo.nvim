local parser = require( "godo.utilities.parser" )
local godoapi = require( "godo.api.godoapi" )

local M = {}

local main_id
local main_opened = false
local godo_list = {}

local function display_godos( buf, ns )
	for i, godo in pairs( godo_list ) do
		local first_godo = -1
		local line = {}
		local tags = ""
		if godo.tags then
			tags = ':' .. table.concat( godo.tags, "," )
		end
		line[ 1 ] = '(' .. godo.id .. tags .. ') ' .. godo.description
		local extmark = godo.file_name .. ':' .. godo.line_number

		if i == 1 then
			first_godo = 0
		end
		vim.api.nvim_buf_set_lines( buf, first_godo, -1, true, line )

		vim.api.nvim_buf_set_extmark( buf, ns, i -1, 1, {
			id = i + 1,
			virt_text = {
				{ extmark, { "Conceal" } }
			},
			virt_text_pos = "eol"
		} )
	end
end

local function create_buffer()
	local buf = vim.api.nvim_create_buf( false, true )
	vim.api.nvim_buf_set_name( buf, "items://godo" )
	local ns = vim.api.nvim_create_namespace( "" )

	display_godos( buf, ns )

	vim.api.nvim_buf_set_keymap(
		buf,
		'n',
		'<leader>n',
		'<cmd>s/^\\([^#]\\)/#\\1/e<cr><cmd>nohlsearch<cr>',
		{}
	)

	vim.api.nvim_buf_set_keymap(
		buf,
		'n',
		'<leader>y',
		'<cmd>s/^#//e<cr><cmd>nohlsearch<cr>',
		{}
	)

	return buf
end

local function set_autocmd()
	vim.api.nvim_create_autocmd( "WinClosed", {
		pattern = tostring( main_id ),
		callback = function()
			godo_list = parser.extract_edited_godos()
			godoapi.create_godos( godo_list )
			vim.api.nvim_buf_delete( 0, { force = true } )
			main_opened = false
		end
	} )
end

local function open_main_window()
	local buf = create_buffer()

    local ui = vim.api.nvim_list_uis()[ 1 ]

    local width = 100
    local height = 20

    local opts = {
		relative = 'editor',
		width = width,
		height = height,
		col = ( ui.width / 2 ) - ( width / 2 ),
		row = ( ui.height / 2 ) - ( height / 2 ),
		border = 'rounded',
		style = 'minimal',
		title = 'TODO items',
		footer = 'Press <leader>n to reject and <leader>y to accept an item.'..
				' Close the window to persist in godo.'
    }
    main_id = vim.api.nvim_open_win( buf, 1, opts )
	main_opened = true

	set_autocmd()
end

function M.set_godo_list( list )
	godo_list = list
end

function M.create_floating_window()
	if main_opened then
		vim.notify( "Window already open." )
		return
	end
	open_main_window( godo_list )
end

return M
