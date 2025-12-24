require("lze").load {
    {
        "rustaceanvim",
        for_cat = "lsp.always",
        event = "DeferredUIEnter",
        dep_of = { "neotest" },
        after = function(plugin)
        end
    },
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
        "lazydev",
        for_cat = "general.always",
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
                    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            -- make lazydev completions top priority (see `:h blink.cmp`)
                            score_offset = 100,
                        },
                    },
                },


                snippets = {
                    -- preset = "luasnip"
                },

                signature = {
                    enabled = true,
                    window = { border = 'single' }
                },

                cmdline = {
                    enabled = true,
                    completion = {
                        menu = {
                            auto_show = true,
                        },
                    },
                },

                completion = {
                    menu = {
                        border = 'single',

                        draw = {
                            columns = {
                                { "label",     "label_description", gap = 1 },
                                { "kind_icon", gap = 1,             "kind" }
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
        "nvim-lspconfig",
        for_cat = "lsp.always",
        event = "FileType",
        after = function(plugin)
            local blink = require("blink.cmp")
            local capabilities = blink.get_lsp_capabilities()

            vim.diagnostic.config({ virtual_text = true })

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    local nmap = function(keys, func, desc)
                        if desc then
                            desc = 'LSP: ' .. desc
                        end

                        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
                    end

                    nmap('K', vim.lsp.buf.hover)
                    nmap('gk', vim.lsp.buf.signature_help)

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

                    if client.server_capabilities.inlayHintProvider then
                        nmap('<leader>th', function()
                            local current_setting = vim.lsp.inlay_hint.is_enabled(bufnr)
                            vim.lsp.inlay_hint.enable(not current_setting, { bufnr })
                        end)
                    end

                    if client == nil then
                        return
                    end

                    if client.name == 'ruff' then
                        -- Disable hover in favor of Pyright
                        client.server_capabilities.hoverProvider = false
                    end
                end,
            })

            vim.lsp.enable("lua_ls")
            vim.lsp.enable("gopls")
            vim.lsp.enable("ruff")
            vim.lsp.enable("basedpyright")
            -- vim.lsp.enable("ty")
            vim.lsp.enable("terraformls")
            vim.lsp.enable("tflint")
            vim.lsp.enable("dockerls")
            vim.lsp.enable("jsonls")
            vim.lsp.enable("nixd")
            vim.lsp.enable("cue")
            vim.lsp.enable("helm_ls")
            vim.lsp.enable("yamlls")
        end,
    }
}
