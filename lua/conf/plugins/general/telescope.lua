require("lze").load {
    {
        "telescope.nvim",
        for_cat = "general.telescope",
        cmd = { "Telescope", "LiveGrepGitRoot" },
        on_require = { "telescope", },
        keys = {
            { "<leader>pf", mode = {"n"}, },
            { "<leader>ps", mode = {"n"}, },
            { "<leader>pg", mode = {"n"}, },
            { "<leader>pd", mode = {"n"}, },
        },
        load = function(name)
            vim.cmd.packadd(name)
            vim.cmd.packadd("telescope-fzf-native.nvim")
            vim.cmd.packadd("telescope-ui-select.nvim")
        end,
        after = function(plugin)
            require("telescope").setup({
                -- pickers = {
                --     find_files = {
                --         find_files = {
                --             theme = "dropdown"
                --         }
                --     }
                -- }
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown()
                    }
                }
            })

            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
            vim.keymap.set('n', '<leader>ps', builtin.grep_string, {})
            vim.keymap.set('n', '<leader>pg', builtin.live_grep, {})
            vim.keymap.set('n', '<leader>pd', builtin.diagnostics, {})
            vim.keymap.set('n', '<leader>pb', builtin.buffers, {})
        end
    }
}
