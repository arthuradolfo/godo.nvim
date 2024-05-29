local fshelper = require( "godo.utilities.fshelper" )

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

--- Parses description from fargs
---@param args table
local function parse_description( args )
    local constructed_arg = ''
    for i = 2,#args do
        constructed_arg = constructed_arg .. args[i] .. ' '
    end
    return constructed_arg
end

local function GodoCreateItem( id, description )
    local command = "godo create " .. id .. ' "' .. description .. '"'
    local result = fshelper.execute( command, "Error creating item `" .. id .. "`." )

    if has_error( result ) then
        vim.notify( result, "error" )
        return
    end

    vim.notify( "Item `" .. id .. "` created." )
end

vim.api.nvim_create_user_command( "GodoCreateItem", function( opts )
    GodoCreateItem( opts.fargs[1], parse_description( opts.fargs ) )
end, {
    desc = "Creates an item",
    nargs = "+",
})

local function GodoGetItem( id )
    local command = "godo get " .. id
    local result = fshelper.execute( command, "Error getting item `" .. id .. "`" )

    if has_error( result ) then
        vim.notify( "Item `" .. id .. "` not found.", "error" )
        return
    end

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
    local result = fshelper.execute( command, "Error listing all items." )

    if has_error( result ) then
        vim.notify( result )
        return
    end

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
    local command = "godo do " .. id
    local result = fshelper.execute( command, "Error doing item `" .. id .. "`." )

    if has_error( result ) then
        vim.notify( "Item `" .. id .. "` not found.", "error" )
        return
    end

    vim.notify( "Item `" .. id .. "` done." )
end

vim.api.nvim_create_user_command( "GodoDoItem", function( opts )
    GodoDoItem( opts.fargs[1] )
end, {
    desc = "Closes an item by id",
    nargs = 1
})

local function GodoUndoItem( id )
    local command = "godo undo " .. id
    local result = fshelper.execute( command, "Error undoing item `" .. id .. "`." )

    if has_error( result ) then
        vim.notify( "Item `" .. id .. "` not found.", "error" )
        return
    end

    vim.notify( "Item `" .. id .. "` reopened." )
end

vim.api.nvim_create_user_command( "GodoUndoItem", function( opts )
    GodoUndoItem( opts.fargs[1] )
end, {
    desc = "Reopens an item by id",
    nargs = 1
})

local function GodoWorkItem( id, time )
    local command = "godo work " .. id .. " " .. time
    local result = fshelper.execute( command, "Error working on item `" .. id .. "`" )

    if has_error( result ) then
        vim.notify( "Item `" .. id .. "` not found.", "error" )
        return
    end

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
