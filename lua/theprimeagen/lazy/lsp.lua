local root_files = {
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
  '.git',
}

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
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
        "ray-x/lsp_signature.nvim",
        "windwp/nvim-autopairs",
    },

    config = function()
        -- conform setup is handled in conform.lua
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})

        -- Configure nvim-autopairs
        local autopairs = require("nvim-autopairs")
        autopairs.setup({
            check_ts = true, -- enable treesitter
            ts_config = {
                lua = {'string', 'source'}, -- don't add pairs in lua string treesitter nodes
                javascript = {'string', 'template_string'}, -- don't add pairs in javscript template_string treesitter nodes
                java = false, -- don't check treesitter on java
            },
            disable_filetype = { "TelescopePrompt", "spectre_panel" },
            -- Reduce LSP trigger frequency to prevent duplicate diagnostics
            enable_check_bracket_line = false,
            ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
            fast_wrap = {
                map = '<M-e>',
                chars = { '{', '[', '(', '"', "'" },
                pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
                offset = 0, -- Offset from pattern match
                end_key = '$',
                keys = 'qwertyuiopzxcvbnmasdfghjkl',
                check_comma = true,
                highlight = 'PmenuSel',
                highlight_grey = 'LineNr'
            },
        })

        -- Configure lsp_signature for enhanced signature help
        require("lsp_signature").setup({
            bind = true, -- This is mandatory, otherwise border config won't get registered.
            handler_opts = {
                border = "rounded"
            },
            hint_enable = true, -- virtual hint enable
            hint_prefix = "🐼 ",  -- Panda for parameter
            hint_scheme = "String",
            hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
            floating_window = true, -- show hint in a floating window, set to false for virtual text only mode
            floating_window_above_cur_line = true, -- try to place the floating above the current line when possible
            floating_window_off_x = 1, -- adjust float windows x position.
            floating_window_off_y = 0, -- adjust float windows y position.
            close_timeout = 4000, -- close floating window after ms when laster parameter is entered
            fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
            toggle_key = '<M-x>', -- toggle signature on and off in insert mode,  e.g. '<M-x>'
            select_signature_key = '<M-n>', -- cycle to next signature, e.g. '<M-n>'
            move_cursor_key = '<M-c>', -- imap, use nvim_set_current_win to move cursor between current win and floating
        })

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "tailwindcss",
                "ts_ls",
                -- "eslint"
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                zls = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.zls.setup({
                        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                        settings = {
                            zls = {
                                enable_inlay_hints = true,
                                enable_snippets = true,
                                warn_style = true,
                            },
                        },
                    })
                    vim.g.zig_fmt_parse_errors = 0
                    vim.g.zig_fmt_autosave = 0

                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                format = {
                                    enable = true,
                                    -- Put format options here
                                    -- NOTE: the value should be STRING!!
                                    defaultConfig = {
                                        indent_style = "space",
                                        indent_size = "2",
                                    }
                                },
                            }
                        }
                    }
                end,
                ["tailwindcss"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.tailwindcss.setup({
                        capabilities = capabilities,
                        filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "heex" },
                    })
                end,
                ["ts_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ts_ls.setup({
                        capabilities = capabilities,
                        filetypes = { "typescript", "typescriptreact" }, -- Only TypeScript files
                        settings = {
                            typescript = {
                                validate = true,
                            },
                            javascript = {
                                validate = false, -- Disable JavaScript validation
                            },
                        },
                    })
                end,

            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            }),
            -- Enable signature help in completion
            experimental = {
                ghost_text = true,
            },
        })

        -- Enable autopairs integration with cmp
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

        vim.diagnostic.config({
            update_in_insert = false,
            virtual_text = {
                prefix = "●",
                spacing = 4,
            },
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
