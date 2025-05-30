require("lze").load {
    {
        "nvim-dap-ui",
        for_cat = "lsp.always",
        event = "DeferredUIEnter",
        dep_of = { "nvim-dap" },
    },
    {
        "nvim-dap-virtual-text",
        for_cat = "lsp.always",
        event = "DeferredUIEnter",
        dep_of = { "nvim-dap" },
        after = function(plugin)
        end
    },
    {
        "nvim-nio",
        for_cat = "lsp.always",
        event = "DeferredUIEnter",
        dep_of = { "nvim-dap" },
        after = function(plugin)
        end
    },
    {
        "nvim-dap",
        for_cat = "general.dap",
        event = "DeferredUIEnter",
        dep_of = { "nvim-dap-go", "nvim-dap-python" },
        after = function(plugin)
            local dap, ui, text = require("dap"), require("dapui"), require("nvim-dap-virtual-text")

            ui.setup()
            text.setup()

            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)

            vim.keymap.set("n", "<leader>dc", dap.continue)
            vim.keymap.set("n", "<leader>df", dap.step_over)
            vim.keymap.set("n", "<leader>di", dap.step_into)
            vim.keymap.set("n", "<leader>do", dap.step_out)
            vim.keymap.set("n", "<leader>db", dap.step_back)
            vim.keymap.set("n", "<leader>dr", dap.restart)


            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
                text.refresh()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
                text.refresh()
            end
        end,
    },
    {
        "nvim-dap-go",
        for_cat = "lsp.always",
        ft = "go",
        after = function(plugin)
            require("dap-go").setup({})
        end
    },
    {
        "nvim-dap-python",
        for_cat = "lsp.always",
        ft = "python",
        after = function(plugin)
            require("dap-python").setup("uv")
        end
    }
}
