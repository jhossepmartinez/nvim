local formatters = {
	"stylua",
	-- "black",
	"prettier",
	"prettierd",
	-- "eslint_d", -- Remember to install eslint_d globally
	"php-cs-fixer",
	"buf",
}

local lsp_servers = {
	"lua-language-server",
	"vim-language-server",

	"pyright",
	-- "clangd",
	-- "rust-analyzer",

	-- "eslint",
	"typescript-language-server",
	"html-lsp",
	"css-lsp",
	"tailwindcss-language-server",
	"emmet-language-server",
	-- "angularls",
	-- "gopls", -- Only install when go is installed
	"graphql-language-service-cli",
	"prisma-language-server",

	"jdtls",
	"phpactor",
	-- "protols",

	"terraform-ls",
}

return {
	{
		"stevearc/conform.nvim",

		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					-- markdown = { "prettier" },
					-- javascript = { "prettier" },
					-- typescript = { "prettier" },
					-- javascriptreact = { "prettier" },
					-- typescriptreact = { "prettier" },
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					scss = { "prettier" },
					json = { "prettier" },
					jsonc = { "prettier" },
					html = { "prettier" },
					python = { "black" },
					php = { "php_cs_fixer" },
					proto = { "buf" },
					terraform = { "terraform_fmt" },
					-- ckl = { "prettier" },
				},
				format_after_save = function(bufnr)
					local ignore_filetypes = { "gitcommit", "gitrebase" }
					local filetype = vim.bo[bufnr].filetype

					if vim.tbl_contains(ignore_filetypes, filetype) then
						return
					end

					return { lsp_format = "fallback" }
				end,
				-- format_after_save = {
				-- 	lsp_format = "fallback",
				-- },
				formatters = {
					php_cs_fixer = {
						command = "php-cs-fixer",
						args = {
							"fix",
							"$FILENAME",
							"--config=.php-cs-fixer.php",
						},
					},
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			local ensure_installed = {}
			table.move(formatters, 1, #formatters, 1, ensure_installed)
			table.move(lsp_servers, 1, #lsp_servers, #formatters + 1, ensure_installed)

			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})
		end,
	},
}
