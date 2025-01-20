vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local nmap = function(keys, func, desc)
            if desc then
                desc = 'LSP: ' .. desc
            end

            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('K', vim.lsp.buf.hover)
        -- nmap('<C-K>', vim.lsp.buf.signature_help)

        nmap('gd', vim.lsp.buf.definition)
        nmap('gD', vim.lsp.buf.declaration)
        nmap('gi', vim.lsp.buf.implementation)
        nmap('go', vim.lsp.buf.type_definition)
        nmap('gr', require('telescope.builtin').lsp_references)
        nmap('gs', vim.lsp.buf.signature_help)
        nmap('gq', vim.lsp.buf.format)
        nmap('gl', vim.diagnostic.open_float)

        nmap('<leader>rn', vim.lsp.buf.rename)
        nmap('<leader>ca', vim.lsp.buf.code_action)
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols)
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols)


        if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            vim.keymap.set('n', '<leader>th',
                function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
                { buffer = bufnr })
        end

        vim.lsp.inlay_hint.enable(false)
    end
})

require("lze").load {
    {
        "friendly-snippets",
        for_cat = "lsp.always",
        event = "DeferredUIEnter",
        dep_of = { "blink.cmp" },
    },
    {
        "luasnip",
        for_cat = "lsp.always",
        event = "DeferredUIEnter",
        dep_of = { "blink.cmp" },
    },
    {
        "blink.cmp",
        for_cat = "lsp.always",
        event = "DeferredUIEnter",
        dep_of = { "nvim-lspconfig" },
        after = function(plugin)
            require("blink.cmp").setup({
                keymap = {
                    preset = "default",
                    ["<S-k>"] = { "scroll_documentation_up", "fallback" },
                    ["<S-j>"] = { "scroll_documentation_down", "fallback" },
                },
                appearance = {
                    use_nvim_cmp_as_default = true,
                    nerd_font_variant = "mono"
                },

                sources = {
                    default = { "lsp", "path", "snippets", "buffer" }
                },

                snippets = {
                    preset = "luasnip"
                },

                signature = {
                    enabled = true,
                    window = { border = 'single' }
                },

                completion = {
                    menu = {
                        border = 'single',

                        draw = {
                            columns = {
                                { "label", "label_description", gap = 1 },
                                { "kind_icon", gap = 1, "kind" }
                            },
                            treesitter = { "lsp" }
                        }
                    },

                    documentation = {
                        window = { border = 'single' },
                        auto_show = true,
                        auto_show_delay_ms = 300
                    }
                }

            })
        end,
    },
    {
        "lsp-zero.nvim",
        for_cat = "lsp.always",
        event = "DeferredUIEnter",
        dep_of = { "nvim-lspconfig" },
    },
    {
        "nvim-lspconfig",
        for_cat = "lsp.always",
        event = "FileType",
        after = function(plugin)
            local blink = require("blink.cmp")
            local lspconfig = require("lspconfig")
            local capabilities = blink.get_lsp_capabilities()

            lspconfig.lua_ls.setup({
                capabilities = capabilities,

                settings = {
                    Lua = {
                        hints = { enabled = true },
                    }
                }
            })
        end,
    }
}
