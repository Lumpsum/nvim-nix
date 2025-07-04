local cat = "general.always"

require("lze").load {
    {
        "comment.nvim",
        for_cat = cat,
        event = "DeferredUIEnter",
        after = function(plugin)
            require("Comment").setup()
        end,
    },
    {
        "grapple.nvim",
        for_cat = cat,
        event = "DeferredUIEnter",
        after = function (plugin)
            local opts = {
                scope = "git"
            }
            require("grapple").setup(opts)
        end
    },
    {
        "lazygit.nvim",
        for_cat = cat,
        event = "DeferredUIEnter",
        after = function (plugin)
        end
    },
    {
        "gitsigns.nvim",
        for_cat = cat,
        event = "DeferredUIEnter",
        after = function (plugin)
            require("gitsigns").setup()
        end
    },
    {
        "todo-comments.nvim",
        for_cat = cat,
        event = "DeferredUIEnter",
        after = function (plugin)
            require("todo-comments").setup()
        end
    },
    {
        "vim-tmux-navigator",
        for_cat = cat,
        event = "DeferredUIEnter",
        after = function (plugin)
        end
    },
}
