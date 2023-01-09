require('rose-pine').setup({
    disable_background = true
})

function ColorMyStuff(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    -- Current terminal does not support transparency AFAIK, but worth the effort
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyStuff()
