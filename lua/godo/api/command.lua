local function GodoCreateItem(id, description)
    vim.fn.jobstart( "godo create " .. id .. ' "' .. description .. '"' )
end

vim.api.nvim_create_user_command("GodoCreateItem", function(opts)
    GodoCreateItem(opts.fargs[1], opts.fargs[2])
end, {
    desc = "Create an item on godo",
    nargs = "+",
})
