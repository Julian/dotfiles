vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

vim.b.switch_definitions = {
    { 'is_true', 'is_false' },
    { 'is_truthy', 'is_falsy' },
    vim.fn['switch#Words']({ 'pending', 'it' })
}
