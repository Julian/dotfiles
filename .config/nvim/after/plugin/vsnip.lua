if vim.g.loaded_vsnip ~= 1 then return end
vim.g.vsnip_snippet_dir = vim.env.XDG_CONFIG_HOME .. '/nvim/vsnip/'
