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
        "lazydev.nvim",
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
                    default = { "lsp", "path", "snippets", "buffer", "lazydev" },
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

            lspconfig.lua_ls.setup({
                capabilities = capabilities,

                settings = {
                    Lua = {
                        hints = { enabled = true },
                    }
                }
            })

            lspconfig.gopls.setup({
                on_attach = function(_, bufnr)
                    -- add_inlay_hints(bufnr)

                    vim.api.nvim_create_autocmd('BufWritePre', {
                        pattern = "*.go",
                        callback = function()
                            local params = vim.lsp.util.make_range_params()
                            params.context = { only = { "source.organizeImports" } }

                            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                            for cid, res in pairs(result or {}) do
                                for _, r in pairs(res.result or {}) do
                                    if r.edit then
                                        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                                        vim.lsp.util.apply_workspace_edit(r.edit, enc)
                                    end
                                end
                            end
                            vim.lsp.buf.format({ async = false })
                        end
                    })
                end,
                cmd = { "gopls" },
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = {
                            unusedparams = true,
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        }
                    }
                }
            })

            lspconfig.basedpyright.setup({
                settings = {
                    basedpyright = {
                        disableOrganizeImports = false,
                        analysis = {
                            ignore = { "*" },
                        },
                    },
                },
            })

            lspconfig.ruff.setup({
                init_options = {
                    settings = {
                        lint = {
                            enable = true,
                            select = { "ALL" },
                            -- ignore = { "D", "ANN101", "ANN204" },
                        },
                        organizeImports = false,
                    },
                },
            })

            -- lspconfig.pylsp.setup({
            --     settings = {
            --         pylsp = {
            --             plugins = {
            --                 -- formatter
            --                 black = { enabled = true },
            --                 autopep8 = { enabled = false },
            --                 yapf = { enabled = false },
            --                 -- linter
            --                 ruff = {
            --                     enabled = true,
            --                     formatEnabled = true,
            --                     extendSelect = { "ALL" },
            --                     format = { "I" },
            --                     extendIgnore = { "D", "ANN101", "ANN204" },
            --                 },
            --                 pylint = { enabled = false },
            --                 pyflakes = { enabled = false },
            --                 pycodestyle = { enabled = false },
            --                 -- type checker
            --                 pylsp_mypy = { enabled = true },
            --                 -- auto-completion
            --                 jedi_completion = { fuzzy = true },
            --                 -- auto import
            --                 rope_autoimport = { enabled = false },
            --                 -- import sorting
            --                 pyls_isort = { enabled = false }
            --             },
            --         },
            --     },
            -- })

            -- lspconfig.rust_analyzer.setup({
            --     on_attach = function(_, bufnr)
            --         vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
            --     end,
            --     settings = {
            --         ["rust-analyzer"] = {
            --             add_return_type = {
            --                 enable = true,
            --             },
            --             inlayHints = {
            --                 enable = true,
            --                 showParameterName = true,
            --             },
            --         }
            --     }
            -- })


            lspconfig.terraformls.setup({})
            lspconfig.tflint.setup({})

            lspconfig.dockerls.setup({})

            lspconfig.jsonls.setup({})

            -- lspconfig.nil_ls.setup({
            --     settings = {
            --         ["nil"] = {
            --             formatting = {
            --                 command = { "nixfmt" },
            --             }
            --         }
            --     }
            -- })

            lspconfig.nixd.setup({
                settings = {
                    nixd = {
                        formatting = {
                            command = { "nixfmt" },
                        }
                    }
                }
            })

            lspconfig.cue.setup({
                cmd = { "cuelsp" }
            })

            lspconfig.helm_ls.setup({
                settings = {
                    helm_ls = {
                        yamlls = {
                            path = "yaml-language-server"
                        },
                    },
                },
            })

            lspconfig.yamlls.setup {
                schemas = {
                    kubernetes = "*.yaml",
                    ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                    ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                    ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                    ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                    ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                    ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                    ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                    ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                    ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                    ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                    ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                    ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
                },
            }
        end,
    }
}
