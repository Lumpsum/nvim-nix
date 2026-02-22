local cat = "general.ai"
local adapter = nixCats("adapter")

require("lze").load {
    {
        "vimplugin-codecompanion-spinner.nvim",
        for_cat = cat,
        event = "DeferredUIEnter",
        dep_of = {
            "codecompanion.nvim"
        },
    },
    {
        "codecompanion.nvim",
        for_cat = cat,
        event = "DeferredUIEnter",
        after = function()
            require("codecompanion").setup({
                strategies = {
                    chat = {
                        adapter = adapter,
                    },
                    inline = { adapter = adapter, },
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
                                auth_method = "gemini-api-key",
                                model = "gemini-2.5-flash",
                            },
                        })
                    end,

                    http = {
                        openai = function()
                            return require("codecompanion.adapters").extend("openai", {
                                url =
                                "https://genai-api.eon.com/llmgw/central/openai/deployments/gpt-4.1/chat/completions?api-version=2024-03-01-preview"
                            })
                        end,
                    }
                },

                extensions = {
                    spinner = {},
                },

                vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat" }),
                vim.keymap.set({ "n", "v" }, "<leader>ai", "<cmd>CodeCompanion<cr>", { desc = "AI Inline" }),
            })
        end
    },
    {
        "claudecode.nvim",
        for_cat = cat,
        event = "DeferredUIEnter",
        after = function()
            local cc = require("claudecode")
            cc.setup({})
        end,
    }
}
