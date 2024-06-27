return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "onsails/lspkind.nvim"
    },

    config = function()

        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        local lspconfig = require('lspconfig')

        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        -- local icons = {
        --     Array         = " ",
        --     Boolean       = "󰨙 ",
        --     Class         = " ",
        --     Codeium       = "󰘦 ",
        --     Color         = " ",
        --     Control       = " ",
        --     Collapsed     = " ",
        --     Constant      = "󰏿 ",
        --     Constructor   = " ",
        --     Copilot       = " ",
        --     Enum          = " ",
        --     EnumMember    = " ",
        --     Event         = " ",
        --     Field         = " ",
        --     File          = " ",
        --     Folder        = " ",
        --     Function      = "󰊕 ",
        --     Interface     = " ",
        --     Key           = " ",
        --     Keyword       = " ",
        --     Method        = "󰊕 ",
        --     Module        = " ",
        --     Namespace     = "󰦮 ",
        --     Null          = " ",
        --     Number        = "󰎠 ",
        --     Object        = " ",
        --     Operator      = " ",
        --     Package       = " ",
        --     Property      = " ",
        --     Reference     = " ",
        --     Snippet       = "󰘍 ",
        --     String        = " ",
        --     Struct        = "󰆼 ",
        --     TabNine       = "󰏚 ",
        --     Text          = " ",
        --     TypeParameter = " ",
        --     Unit          = " ",
        --     Value         = " ",
        --     Variable      = "󰀫 ",
        -- }

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls" },
            handlers = {
                function(server_name) -- default handler (optional)

                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.4" },
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
            }
        })

        vim.opt.completeopt = { "menu", "menuone", "popup" }
        vim.opt.shortmess:append "c"

        local lspkind = require("lspkind")
        lspkind.init({})

        local disable_semantic_tokens = {
            lua = true,
        }
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

                vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
                vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
                vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })
                vim.keymap.set("n", "<leader>er", vim.diagnostic.open_float, { buffer = 0 })
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = 0 })
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })

                local filetype = vim.bo[bufnr].filetype
                if disable_semantic_tokens[filetype] then
                    client.server_capabilities.semanticTokensProvider = nil
                end
            end,
        })

        local cmp = require("cmp")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            sources = {
                { name = "nvim_lsp" },
                { name = "path" },
                { name = "buffer" }
            },
            mapping = {
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ["<C-h>"] = cmp.mapping(
                    cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true
                    },
                        {"i", "c"})
                ),
            },
            experimental = {
                ghost_text = true
            }
        })


        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },

            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                    { name = 'buffer' },
                })
        })

        local ls = require("luasnip")
        ls.config.set_config({
            history = false,
            updateevents = "TextChanged,TextChangedI",
        })

        vim.keymap.set({"i", "s"}, "<C-k>", function ()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end)

        vim.keymap.set({"i", "s"}, "<C-j>", function ()
            if ls.expand_or_jumpable(-1) then
                ls.expand_or_jump(-1)
            end
        end)
    end


}
