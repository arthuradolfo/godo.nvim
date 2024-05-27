local function GodoCreateItem( id, description )
    vim.fn.jobstart( "godo create " .. id .. ' "' .. description .. '"' )
end

vim.api.nvim_create_user_command( "GodoCreateItem", function(opts)
    GodoCreateItem( opts.fargs[1], opts.fargs[2] )
end, {
    desc = "Creates an item on godo",
    nargs = "+",
})

local function GodoGetItem( id )
    local command = "godo get " .. id
    local handle = io.popen( command )
    local result = handle:read( "*a" )
    vim.notify( result )
end

vim.api.nvim_create_user_command( "GodoGetItem", function(opts)
    GodoGetItem( opts.fargs[1] )
end, {
    desc = "Displays information about a specific item",
    nargs = 1
})
