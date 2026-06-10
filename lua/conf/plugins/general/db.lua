local cat = "general.db"

require("lze").load {
    {
        "vim-dadbod",
        for_cat = cat,
        event = "DeferredUIEnter",
        dep_of = {
            "vim-dadbod-ui"
        },
    },
    {
        "vim-dadbod-completion",
        for_cat = cat,
        event = "DeferredUIEnter",
        dep_of = {
            "vim-dadbod-ui"
        },
    },
    {
        "vim-dadbod-ui",
        for_cat = cat,
        event = "DeferredUIEnter",
        dep_of = {},
        before = function()
            vim.g.db_ui_use_nerd_fonts = 1
        end,
        after = function() 
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "sql", "mysql", "plsql" },
                callback = function()
                    require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
                end,
            })
        end
    }
}

