return {
    "neovim/nvim-lspconfig",

    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()

        -- LSP server configs (NO KEYS HERE)

        -- clangd
        vim.lsp.config("clangd", {
            cmd = { "clangd" },
            capabilities = capabilities,
        })

        -- gopls
        vim.lsp.config("gopls", {
            capabilities = capabilities,
        })

        -- pyright
        vim.lsp.config("pyright", {
            capabilities = capabilities,
        })

        -- lua ls
        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                },
            },
        })

        -- Enable servers (start them)
        for _, server in ipairs({ "clangd", "gopls", "pyright", "lua_ls" }) do
            vim.lsp.enable(server)
        end
    end,
}
