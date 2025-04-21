local colorschemeName = nixCats("colorscheme")
vim.cmd.colorscheme(colorschemeName)

-- General
if nixCats("general.always") then
    require("conf.plugins.general.always")
end
if nixCats("general.extra") then
    require("conf.plugins.general.extra")
end
if nixCats("general.treesitter") then
    require("conf.plugins.general.treesitter")
end
if nixCats("general.telescope") then
    require("conf.plugins.general.telescope")
end
if nixCats("general.markdown") then
    require("conf.plugins.general.markdown")
end
if nixCats("general.dap") then
    require("conf.plugins.general.dap")
end

