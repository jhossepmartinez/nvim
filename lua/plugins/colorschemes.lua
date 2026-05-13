return {
	{
		"maxmx03/solarized.nvim",
		config = function()
			vim.o.background = "dark"
			require("solarized").setup({
				variant = "winter", -- "spring" | "summer" | "autumn" | "winter" (default)
				transparent = { enabled = true, pmenu = false },
				styles = {
					comments = { italic = true },
				},
				on_highlights = function(colors, color)
					return {
						StatusLine = { bg = "NONE" },
						StatusLineNC = { bg = "NONE" },
					}
				end,
			})
		end,
	},
	{ "0xleodevv/oc-2.nvim" },
	{
		"fraeso/xcodedark.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("xcodedark").setup({
				transparent = true, -- or false if you prefer solid background

				integrations = {
					telescope = true,
					nvim_tree = true,
					gitsigns = true,
					bufferline = true,
					incline = true,
					lazygit = true,
					which_key = true,
					notify = true,
					snacks = true,
					blink = true,
				},

				terminal_colors = true,
			})
		end,
	},
}
