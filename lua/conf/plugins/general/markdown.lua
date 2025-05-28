local cat = "general.markdown"

require("lze").load {
    {
        "markdown-preview.nvim",
        for_cat = cat,
        ft = "markdown",
        after = function(plugin)
        end
    },
    {
        "markview.nvim",
        for_cat = cat,
        ft = "markdown",
        after = function(plugin)
            vim.keymap.set("n", "<leader>mt", function()
                require("markview").commands.toggle()
            end)
        end
    },
}
