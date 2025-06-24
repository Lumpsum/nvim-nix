local colorschemeName = nixCats("colorscheme")

vim.g.loaded_netrwPlugin = 1
vim.g.bigfile_size = 1024 * 1024 * 0.2

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.filetype.add({
    pattern = {
        [".*"] = {
            function(path, buf)
                return vim.bo[buf].filetype ~= "bigfile" and path and vim.fn.getfsize(path) > vim.g.bigfile_size and
                    "bigfile"
                    or nil
            end,
        },
    },
})
vim.api.nvim_create_autocmd({ "FileType" }, {
    group = augroup("bigfile"),
    pattern = "bigfile",
    callback = function(ev)
        vim.b.minianimate_disable = true
        vim.schedule(function()
            vim.bo[ev.buf].syntax = vim.filetype.match({ buf = ev.buf }) or ""
        end)
    end,
})

require("oil").setup({
    default_file_explorer = true,
    columns = {
        "icon",
        "permissions",
        "size",
    },
    keymaps = {
        ["<C-l>"] = false,
        ["<C-h>"] = false,
        ["<C-r>"] = "actions.refresh",
    }
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

-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.wo.foldtext = ""

-- vim.o.foldlevel = 99
-- vim.o.foldlevelstart = 1
-- vim.o.foldnestmax = 4
-- vim.o.foldcolumn = "0"
