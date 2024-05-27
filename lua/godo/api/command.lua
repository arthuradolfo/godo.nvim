local function GodoCreateItem( id, description )
    os.execute( "godo create " .. id .. ' "' .. description .. '"' )
    vim.notify( "Item `" .. id .. "` created." )
end

vim.api.nvim_create_user_command( "GodoCreateItem", function( opts )
    GodoCreateItem( opts.fargs[1], opts.fargs[2] )
end, {
    desc = "Creates an item",
    nargs = "+",
})

local function GodoGetItem( id )
    local command = "godo get " .. id
    local handle = io.popen( command )
    local result = handle:read( "*a" )
    vim.notify( result )
end

vim.api.nvim_create_user_command( "GodoGetItem", function( opts )
    GodoGetItem( opts.fargs[1] )
end, {
    desc = "Displays information about a specific item",
    nargs = 1
})

local function GodoListItems()
    local command = "godo list"
    local handle = io.popen( command )
    local result = handle:read( "*a" )
    vim.notify( result )
end

vim.api.nvim_create_user_command( "GodoListItems", GodoListItems,{
    desc = "Displays information about all items",
    nargs = 0
})

local function GodoDeleteItem( id )
    os.execute( "godo delete " .. id )
    vim.notify( "Item `" .. id .. "` deleted." )
end

vim.api.nvim_create_user_command( "GodoDeleteItem", function( opts )
    GodoDeleteItem( opts.fargs[1] )
end, {
    desc = "Deletes an item by id",
    nargs = 1
})

local function GodoDoItem( id )
    os.execute( "godo do " .. id )
    vim.notify( "Item `" .. id .. "` done." )
end

vim.api.nvim_create_user_command( "GodoDoItem", function( opts )
    GodoDoItem( opts.fargs[1] )
end, {
    desc = "Closes an item by id",
    nargs = 1
})

local function GodoUndoItem( id )
    os.execute( "godo undo " .. id )
    vim.notify( "Item `" .. id .. "` reopened." )
end

vim.api.nvim_create_user_command( "GodoUndoItem", function( opts )
    GodoUndoItem( opts.fargs[1] )
end, {
    desc = "Reopens an item by id",
    nargs = 1
})

local function GodoWorkItem( id, time )
    os.execute( "godo work " .. id .. " " .. time )
    vim.notify( "Added " .. time .. " to item `" .. id .. "` work hours." )
end

vim.api.nvim_create_user_command( "GodoWorkItem", function( opts )
    GodoWorkItem( opts.fargs[1], opts.fargs[2] )
end, {
    desc = "Adds time worked on item by id",
    nargs = "+"
})

local function Godo()
    vim.cmd( "belowright vsplit +term" )
    vim.api.nvim_input('igodo<cr>')
end

vim.api.nvim_create_user_command( "Godo", function()
    Godo()
end, {
    desc = "Opens godo's UI",
    nargs = 0
})
