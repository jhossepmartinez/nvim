return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			heading = {
				enabled = false,
				sign = false,
				position = "inline",
				icons = {
					"",
					"",
				},
				backgrounds = { "", "", "", "", "", "" },
			},
			code = {
				enabled = false,
				language_icon = false,
				highlight_language = nil,
				highlight = nil,
				highlight_info = nil,
				highlight_border = nil,
				highlight_inline_right = nil,
				highlight_inline = nil,
				highlight_inline_left = nil,
				highlight_fallback = nil,
				disable_background = true,
				sign = false,
			},
		},
		-- config = function ()
		--     require("render-markdown").setup({
		--         heading = { position=inline}
		--     })
		-- end
	},
}
