require("lze").load {
    {
        "nvim-treesitter",
        for_cat = "general.treesitter",
        event = "DeferredUIEnter",
        load = function (name)
            vim.cmd.packadd(name)
            vim.cmd.packadd("nvim-treesitter-textobjects")
        end,
        after = function(plugin)
            require('nvim-treesitter.configs').setup {
                ensure_installed = {},

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = false,

                -- Automatically install missing parsers when entering buffer
                -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                auto_install = false,

                highlight = {
                    enable = true,

                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    -- additional_vim_regex_highlighting = false,
                },

                indent = {
                    enable = false,
                },

                ignore_install = {},

                modules = {},
            }
        end
    },
}
