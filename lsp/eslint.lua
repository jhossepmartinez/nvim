---@type vim.lsp.Config
return {
	cmd = { "vscode-eslint-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	root_markers = {
		"eslint.config.js",
		"eslint.config.mjs",
		"eslint.config.cjs",
		"eslint.config.ts",
		"eslint.config.mts",
		"eslint.config.cts",
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.json",
		"package.json",
		".git",
	},
	settings = {
		validate = "on",
		nodePath = "",
		experimental = {
			useFlatConfig = true,
		},
		workingDirectory = { mode = "auto" },
	},
	before_init = function(_, config)
		if config.root_dir then
			config.settings = config.settings or {}
			config.settings.workspaceFolder = {
				uri = vim.uri_from_fname(config.root_dir),
				name = vim.fn.fnamemodify(config.root_dir, ":t"),
			}
		end
	end,
	handlers = {
		["eslint/confirmESLintExecution"] = function()
			return 4
		end,
		["eslint/noLibrary"] = function()
			return {}
		end,
	},
}
