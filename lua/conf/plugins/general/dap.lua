require("lze").load {
    {
        "nvim-dap-ui",
        for_cat = "lsp.always",
        event = "DeferredUIEnter",
        dep_of = { "nvim-dap" },
    },
    {
        "nvim-dap-go",
        for_cat = "lsp.always",
        event = "DeferredUIEnter",
        after = function(plugin)
            require("dap-go").setup({})
        end
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
        dep_of = { "nvim-dap-go" },
        after = function(plugin)
            local dap, ui = require("dap"), require("dapui")

            ui.setup()
            require("nvim-dap-virtual-text").setup()

            vim.keymap.set("n", "<space>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

            vim.keymap.set("n", "<space>dc", dap.continue)
            vim.keymap.set("n", "<space>ds", dap.step_over)
            vim.keymap.set("n", "<space>di", dap.step_into)
            vim.keymap.set("n", "<space>do", dap.step_out)
            vim.keymap.set("n", "<space>db", dap.step_back)
            vim.keymap.set("n", "<space>dr", dap.restart)


            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end
        end,
    }
}
