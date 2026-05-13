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
		".eslintrc.js",
		".eslintrc.cjs",
		".eslintrc.json",
		"package.json",
		".git",
	},
	settings = {
		validate = "on",
		-- THIS is the missing string that caused the crash!
		nodePath = "",
		experimental = {
			useFlatConfig = true,
		},
		workingDirectory = { mode = "auto" },
	},
	handlers = {
		["eslint/confirmESLintExecution"] = function()
			return 4
		end,
		["eslint/noLibrary"] = function()
			return {}
		end,
	},
}
