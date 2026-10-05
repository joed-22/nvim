return {
    "e-q/okcolors.nvim",
    priority = 1000,
    init = function()
        vim.api.nvim_create_autocmd("ColorScheme", {
            pattern = "okcolors*",
            callback = function()
                -- okcolors italicizes functions and macros; keep their colors, drop the italic
                for _, group in ipairs({ "Function", "@function.macro" }) do
                    local hl = vim.api.nvim_get_hl(0, { name = group })
                    hl.italic = false
                    vim.api.nvim_set_hl(0, group, hl)
                end
            end,
        })
    end,
}
