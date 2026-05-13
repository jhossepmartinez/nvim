---@brief
--- https://github.com/mdx-js/mdx-analyzer
---
--- `mdx-analyzer`, a language server for MDX

---@type vim.lsp.Config
return {
	cmd = { "mdx-language-server", "--stdio" },
	filetypes = { "mdx" },
	root_markers = { "package.json" },
	settings = {},
	init_options = {
		typescript = {},
	},
	before_init = function(_, config)
		if config.init_options and config.init_options.typescript and not config.init_options.typescript.tsdk then
			local tsdk = vim.fs.joinpath(config.root_dir, "node_modules", "typescript", "lib")
			if vim.uv.fs_stat(tsdk) then
				config.init_options.typescript.tsdk = tsdk
			end
		end
	end,
}
