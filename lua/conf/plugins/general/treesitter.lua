require("lze").load {
    {
        "nvim-treesitter",
        for_cat = "general.treesitter",
        event = "DeferredUIEnter",
        dep_of = { "neotest" },
        lazy = false,
        load = function(name)
            vim.cmd.packadd(name)
            vim.cmd.packadd("nvim-treesitter-textobjects")
        end,
        after = function(plugin)
            local ts = require("nvim-treesitter")
            -- ts.install({
            --     'bash',
            --     'comment',
            --     'css',
            --     'diff',
            --     'fish',
            --     'git_config',
            --     'git_rebase',
            --     'gitcommit',
            --     'gitignore',
            --     'html',
            --     'javascript',
            --     'json',
            --     'latex',
            --     'lua',
            --     'luadoc',
            --     'make',
            --     'markdown',
            --     'markdown_inline',
            --     'python',
            --     'query',
            --     'regex',
            --     'scss',
            --     'svelte',
            --     'toml',
            --     'tsx',
            --     'go',
            --     'rust',
            --     'typescript',
            --     'typst',
            --     'vim',
            --     'vimdoc',
            --     'vue',
            --     'xml', }):wait(300000)

            -- vim.api.nvim_create_autocmd("FileType", {
            --     pattern = "*",
            --     callback = function()
            --         pcall(vim.treesitter.start)
            --     end,
            -- })

            -- vim.api.nvim_create_autocmd("FileType", {
            --     callback = function(details)
            --         vim.bo[details.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            --     end,
            -- })

            local parsers_loaded = {}
            local parsers_pending = {}
            local parsers_failed = {}
            local ns = vim.api.nvim_create_namespace('treesitter.async')

            local function start(buf, lang)
                local ok = pcall(vim.treesitter.start, buf, lang)
                if ok then
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
                return ok
            end

            vim.api.nvim_set_decoration_provider(ns, {
                on_start = vim.schedule_wrap(function()
                    if #parsers_pending == 0 then
                        return false
                    end
                    for _, data in ipairs(parsers_pending) do
                        if vim.api.nvim_buf_is_valid(data.buf) then
                            if start(data.buf, data.lang) then
                                parsers_loaded[data.lang] = true
                            else
                                parsers_failed[data.lang] = true
                            end
                        end
                    end
                    parsers_pending = {}
                end),
            })

            local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })

            local ignore_filetypes = {
                'checkhealth',
                'lazy',
                'mason',
                'snacks_dashboard',
                'snacks_notif',
                'snacks_win',
            }


            vim.api.nvim_create_autocmd('FileType', {
                group = group,
                desc = 'Enable treesitter highlighting and indentation (non-blocking)',
                callback = function(event)
                    if vim.tbl_contains(ignore_filetypes, event.match) then
                        return
                    end

                    local lang = vim.treesitter.language.get_lang(event.match) or event.match
                    local buf = event.buf

                    if parsers_failed[lang] then
                        return
                    end

                    if parsers_loaded[lang] then
                        -- Parser already loaded, start immediately (fast path)
                        start(buf, lang)
                    else
                        -- Queue for async loading
                        table.insert(parsers_pending, { buf = buf, lang = lang })
                    end

                    -- Auto-install missing parsers (async, no-op if already installed)
                    ts.install({ lang })
                end,
            })
        end

        -- require('nvim-treesitter.configs').setup {
        --     ensure_installed = {},
        --
        --     -- Install parsers synchronously (only applied to `ensure_installed`)
        --     sync_install = false,
        --
        --     -- Automatically install missing parsers when entering buffer
        --     -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        --     auto_install = false,
        --
        --     highlight = {
        --         enable = true,
        --
        --         -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        --         -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        --         -- Using this option may slow down your editor, and you may see some duplicate highlights.
        --         -- Instead of true it can also be a list of languages
        --         -- additional_vim_regex_highlighting = false,
        --     },
        --
        --     indent = {
        --         enable = true,
        --         disable = {"yaml"},
        --     },
        --
        --     ignore_install = {},
        --
        --     modules = {},
        -- }
    },
}
