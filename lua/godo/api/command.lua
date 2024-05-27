local function GodoCreateItem(id, description)
    vim.fn.jobstart( "godo " .. id .. '"' .. description .. '"' )
end

vim.api.nvim_create_user_command("GodoCreateItem", function(opts)
    GodoCreateItem(opts.fargs)
end, {
    desc = "Create an item on godo",
    nargs = 2,
})
