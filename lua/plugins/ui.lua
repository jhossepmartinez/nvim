return {
	{
		"nvim-lualine/lualine.nvim",
		lazy = false,
		config = function()
			local transparent_theme = require("lualine.themes.auto")

			-- 2. Strip the background colors from the middle sections for every mode
			for _, mode in pairs(transparent_theme) do
				if mode.a then
					mode.a.fg = "NONE"
					mode.a.bg = "#f2f2f2"
				end
				-- Make the mode section text the color of its original background,
				-- and make the background itself transparent
				if mode.a then
					mode.a.fg = mode.a.bg
					mode.a.bg = "NONE"
				end

				-- Make the middle sections transparent
				if mode.b then
					mode.b.bg = "NONE"
				end
				if mode.c then
					mode.c.bg = "NONE"
				end
			end
			-- Custom component: Python Virtual Env
			local function python_venv()
				local venv = os.getenv("VIRTUAL_ENV")
				if venv then
					local name = string.match(venv, "([^/]+)$")
					return string.format("🐍 %s", name)
				end
				return ""
			end
			local colors = {
				black = "#000000",
				white = "#f8efd8",
				red = "#fb4934",
				green = "#053230",
				greenish = "#008787",
				lightgreen = "#a9c45e",
				blue = "#337591",
				bluish = "#4db2dd",
				darkblue = "#13324d",
				gray = "#697281",
				darkgray = "#3c3836",
				lightgray = "#d3dde2",
				inactivegray = "#d0d0d0",
				lightyellow = "#916700",
				yellow = "#715306",
				lightrose = "#cb7e8c",
				lighterrose = "#ff9eaf",
				rose = "#d7c4ca",
				none = "none",
			}

			require("lualine").setup({
				options = {
					icons_enabled = true,
					disabled_filetypes = { "neo-tree" },
					theme = transparent_theme,
					section_separators = { left = "", right = "" },
					-- Separators:   •
					component_separators = { left = "", right = "" },
				},
				sections = {
					lualine_b = {
						{
							"branch",
							icon = "",
							padding = { left = 0, right = 0 },
						},
						{
							"filetype",
							padding = { right = 0, left = 1 },
							fmt = function(str)
								if str == "" then
									return "%s", str
								end
								return "%s", str
							end,
						},
						{
							"filename",
							path = 1,
							padding = { left = 0, right = 0 },
						},
					},
					lualine_c = {},
					lualine_x = {},
					lualine_z = {},
					lualine_y = {
						{
							color = { bg = colors.none },
						},
					},
				},
			})
			vim.cmd("hi lualine_transitional_lualine_a_normal_to_lualine_c_normal guifg=#ffffff")
		end,
		enabled = true,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<Leader>nm", "<cmd>Neotree toggle<CR>" },
		},
		opts = {
			close_if_last_window = true,
			use_default_mappings = false,
			window = {
				width = 25,
				mappings = {
					["<space>"] = {
						"toggle_node",
						nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use
					},
					["<2-LeftMouse>"] = "open",
					["<cr>"] = "open",
					["<esc>"] = "cancel",
					["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
					["l"] = "focus_preview",
					["S"] = "open_split",
					["s"] = "open_vsplit",
					["w"] = "open_with_window_picker",
					["C"] = "close_node",
					["z"] = "close_all_nodes",
					["a"] = {
						"add",
						config = {
							show_path = "none",
						},
					},
					["A"] = "add_directory",
					["d"] = "delete",
					["r"] = "rename",
					["b"] = "rename_basename",
					["y"] = "copy_to_clipboard",
					["x"] = "cut_to_clipboard",
					["p"] = "paste_from_clipboard",
					["c"] = "copy",
					["m"] = "move",
					["q"] = "close_window",
					["R"] = "refresh",
					["?"] = "show_help",
					["<"] = "prev_source",
					[">"] = "next_source",
					["i"] = "show_file_details",
				},
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_hidden = false,
				},
				window = {
					mappings = {
						["<bs>"] = "navigate_up",
						["."] = "set_root",
					},
				},
			},
			follow_current_file = {
				leave_dirs_open = false,
			},
			default_component_configs = {
				icon = {
					folder_empty = "",
				},
			},
		},
	},
}
