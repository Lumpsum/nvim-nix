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
        ft = { "markdown", "codecompanion" },
        after = function(plugin)
            require("markview").setup({
                preview = {
                    filetypes = {
                        "markdown",
                        "md",
                        "codecompanion"
                    },

                    ignore_buftypes = {},

                    condition = function(buffer)
                        local ft, bt = vim.bo[buffer].ft, vim.bo[buffer].bt;

                        if bt == "nofile" and ft == "codecompanion" then
                            return true;
                        elseif bt == "nofile" then
                            return false;
                        else
                            return true;
                        end
                    end
                }
            })

            vim.keymap.set("n", "<leader>mt", function()
                require("markview").commands.toggle()
            end)
        end
    },
}
