local colorschemeName = nixCats("colorscheme")

vim.g.loaded_netrwPlugin = 1
require("oil").setup({
    default_file_explorer = true,
    columns = {
        "icon",
        "permissions",
        "size",
    },
})

require("lze").load {
    {
        "lualine.nvim",
        for_cat = "general.always",
        event = "DeferredUIEnter",
        after = function(plugin)
            require("lualine").setup({
                options = {
                    theme = colorschemeName
                },
                sections = {
                    lualine_x = {
                        function()
                            if vim.fn.reg_recording() ~= '' then
                                return 'Recording @' .. vim.fn.reg_recording()
                            else
                                return ''
                            end
                        end,
                    }
                }
            })
        end,
    },

    -- mini
    { "mini.nvim" },
    {
        "mini.ai",
        for_cat = "general.mini",
        event = "DeferredUIEnter",
        after = function(plugin)
            require("mini.ai").setup({})
        end
    },
    {
        "mini.surround",
        for_cat = "general.mini",
        event = "DeferredUIEnter",
        after = function(plugin)
            require("mini.surround").setup({})
        end
    }
}
