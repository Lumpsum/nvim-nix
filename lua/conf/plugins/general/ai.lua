local cat = "general.ai"

require("lze").load {
    {
        "codecompanion.nvim",
        for_cat = cat,
        event = "DeferredUIEnter",
        after = function(plugin)
            require("codecompanion").setup({
                strategies = {
                    chat = {
                        adapter = {
                            name = "gemini",
                            model = "gemini-2.5-flash"
                        },
                    },
                    inline = { adapter = "gemini", },
                    -- cmd = {},
                    -- background = {},
                },
                display = {
                    chat = {
                        window = {
                            layout = "vertical", --float
                            width = 0.3,
                        },
                    },
                },
                adapters = {
                    gemini = function()
                        return require("codecompanion.adapters").extend("gemini", {
                            defaults = {
                                auth_method = "gemini-api-key"
                            },
                        })
                    end,
                },
                vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat" }),
                vim.keymap.set({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI Inline" }),
            })
        end
    }
}
