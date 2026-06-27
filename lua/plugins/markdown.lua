-- glow-style markdown rendering via render-markdown.nvim
-- Colors verified from glow v2.1.2 PTY capture (glamour dark style)
-- Body text: #d0d0d0 (ANSI 252) — all elements use this except headings & inline code
local glow = {
	body = "#d0d0d0", -- ANSI 252 — glow's universal text color
	h1_fg = "#ffff87", -- ANSI 228
	h1_bg = "#5f5fff",
	h_fg = "#00afff", -- ANSI 39 (h2-h5)
	h6_fg = "#00af5f", -- ANSI 35
	hr = "#585858", -- ANSI 240
	code_bg = "#373737",
	code_fg = "#808080", -- ANSI 244 (code block text)
	inline_fg = "#ff5f5f", -- ANSI 203
	inline_bg = "#303030", -- ANSI 236
	link_url = "#00878f", -- ANSI 30
	link_text = "#00af5f", -- ANSI 35
}

-- All render-markdown highlight groups → glow colors
local render_highlights = {
	RenderMarkdownH1 = { fg = glow.h1_fg, bold = true },
	RenderMarkdownH1Bg = { bg = glow.h1_bg },
	RenderMarkdownH2 = { fg = glow.h_fg, bold = true },
	RenderMarkdownH2Bg = {},
	RenderMarkdownH3 = { fg = glow.h_fg, bold = true },
	RenderMarkdownH3Bg = {},
	RenderMarkdownH4 = { fg = glow.h_fg, bold = true },
	RenderMarkdownH4Bg = {},
	RenderMarkdownH5 = { fg = glow.h_fg, bold = true },
	RenderMarkdownH5Bg = {},
	RenderMarkdownH6 = { fg = glow.h6_fg },
	RenderMarkdownH6Bg = {},
	RenderMarkdownCode = { bg = glow.code_bg },
	RenderMarkdownCodeInfo = { fg = glow.code_fg },
	RenderMarkdownCodeBorder = { bg = glow.code_bg },
	RenderMarkdownCodeFallback = { fg = glow.code_fg },
	RenderMarkdownCodeInline = { fg = glow.inline_fg, bg = glow.inline_bg },
	RenderMarkdownBullet = { fg = glow.body },
	RenderMarkdownDash = { fg = glow.hr },
	RenderMarkdownQuote = { fg = glow.body },
	RenderMarkdownQuote1 = { fg = glow.body },
	RenderMarkdownQuote2 = { fg = glow.body },
	RenderMarkdownQuote3 = { fg = glow.body },
	RenderMarkdownQuote4 = { fg = glow.body },
	RenderMarkdownQuote5 = { fg = glow.body },
	RenderMarkdownQuote6 = { fg = glow.body },
	RenderMarkdownInlineHighlight = { fg = glow.body, bg = glow.inline_bg },
	RenderMarkdownSign = {},
	RenderMarkdownMath = { fg = glow.body },
	RenderMarkdownIndent = { fg = glow.hr },
	RenderMarkdownHtmlComment = { fg = glow.hr },
	RenderMarkdownLink = { fg = glow.link_text, bold = true },
	RenderMarkdownLinkTitle = { fg = glow.link_text, bold = true },
	RenderMarkdownWikiLink = { fg = glow.link_text, bold = true },
	RenderMarkdownChecked = { fg = glow.body },
	RenderMarkdownUnchecked = { fg = glow.body },
	RenderMarkdownTodo = { fg = glow.body },
	RenderMarkdownTableHead = { fg = glow.body },
	RenderMarkdownTableRow = { fg = glow.body },
	RenderMarkdownSuccess = { fg = glow.h6_fg },
	RenderMarkdownInfo = { fg = glow.h_fg },
	RenderMarkdownHint = { fg = glow.h_fg },
	RenderMarkdownWarn = { fg = glow.inline_fg },
	RenderMarkdownError = { fg = glow.inline_fg },
}

-- Treesitter captures → glow colors (markdown buffers only)
-- These override solarized's @markup.* / @text.* captures
local ts_overrides = {
	Normal = { fg = glow.body },
	["@markup.heading"] = { fg = glow.h_fg, bold = true },
	["@markup.heading.1"] = { fg = glow.h1_fg, bold = true },
	["@markup.heading.2"] = { fg = glow.h_fg, bold = true },
	["@markup.heading.3"] = { fg = glow.h_fg, bold = true },
	["@markup.heading.4"] = { fg = glow.h_fg, bold = true },
	["@markup.heading.5"] = { fg = glow.h_fg, bold = true },
	["@markup.heading.6"] = { fg = glow.h6_fg },
	["@markup.strong"] = { fg = glow.body, bold = true },
	["@markup.italic"] = { fg = glow.body, italic = true },
	["@markup.strikethrough"] = { fg = glow.body, strikethrough = true },
	["@markup.raw.block"] = { fg = glow.code_fg },
	["@markup.raw.inline"] = { fg = glow.inline_fg, bg = glow.inline_bg },
	["@markup.list"] = { fg = glow.body },
	["@markup.list.checked"] = { fg = glow.body },
	["@markup.list.unchecked"] = { fg = glow.body },
	["@markup.quote"] = { fg = glow.body },
	["@markup.link"] = { fg = glow.link_url, underline = true },
	["@markup.link.label"] = { fg = glow.link_text, bold = true },
	["@markup.link.url"] = { fg = glow.link_url, underline = true },
	["@punctuation.delimiter"] = { fg = glow.body },
	["@punctuation.special"] = { fg = glow.body },
	["@keyword.directive"] = { fg = glow.code_fg },
	["@string.escape"] = { fg = glow.body },
	["@label"] = { fg = glow.link_text, bold = true },
}

local saved = nil

local function apply_glow()
	if not saved then
		saved = {}
		for name, _ in pairs(ts_overrides) do
			local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
			if ok then
				saved[name] = hl
			end
		end
	end
	for name, spec in pairs(ts_overrides) do
		pcall(vim.api.nvim_set_hl, 0, name, spec)
	end
end

local function restore()
	if not saved then
		return
	end
	for name, hl in pairs(saved) do
		pcall(vim.api.nvim_set_hl, 0, name, hl)
	end
end

local function set_render_highlights()
	for name, spec in pairs(render_highlights) do
		pcall(vim.api.nvim_set_hl, 0, name, spec)
	end
end

return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("glow.table").patch()
			require("glow.quote").patch()
			require("glow.heading").patch()
			require("render-markdown").setup({
				render_modes = { "n", "c", "t" },

				anti_conceal = {
					enabled = false,
				},

				heading = {
					sign = false,
					position = "inline",
					icons = { "  ", "## ", "### ", "#### ", "##### ", "###### " },
					width = { "full", "block", "block", "block", "block", "block" },
					left_margin = 0,
					border = false,
					backgrounds = {
						"RenderMarkdownH1Bg",
						"RenderMarkdownH2Bg",
						"RenderMarkdownH3Bg",
						"RenderMarkdownH4Bg",
						"RenderMarkdownH5Bg",
						"RenderMarkdownH6Bg",
					},
					foregrounds = {
						"RenderMarkdownH1",
						"RenderMarkdownH2",
						"RenderMarkdownH3",
						"RenderMarkdownH4",
						"RenderMarkdownH5",
						"RenderMarkdownH6",
					},
				},

				paragraph = {
					left_margin = 2,
				},

				bullet = {
					icons = { "•" },
					left_pad = 0,
					right_pad = 0,
					highlight = "RenderMarkdownBullet",
				},

				checkbox = {
					right_pad = 0,
					unchecked = {
						icon = "[ ] ",
						highlight = "RenderMarkdownUnchecked",
					},
					checked = {
						icon = "[✓] ",
						highlight = "RenderMarkdownChecked",
					},
				},

				quote = {
					icon = "│",
					highlight = "RenderMarkdownQuote1",
				},

				dash = {
					icon = "-",
					width = 8,
					left_margin = 2,
					highlight = "RenderMarkdownDash",
				},

				code = {
					sign = false,
					language = false,
					language_icon = false,
					language_name = false,
					language_info = false,
					border = "none",
					left_margin = 2,
					left_pad = 2,
					width = "full",
					conceal_delimiters = true,
					inline = true,
					inline_left = " ",
					inline_right = " ",
					inline_pad = 0,
					highlight = "RenderMarkdownCode",
					highlight_inline = "RenderMarkdownCodeInline",
					highlight_inline_left = "RenderMarkdownCodeInline",
					highlight_inline_right = "RenderMarkdownCodeInline",
				},

				pipe_table = {
					cell = "padded",
					padding = 1,
					alignment_indicator = "─",
					border = {
						"",
						"",
						"",
						"─",
						"┼",
						"─",
						"",
						"",
						"",
						"│",
						"─",
					},
					border_enabled = false,
					head = "RenderMarkdownTableHead",
					row = "RenderMarkdownTableRow",
				},

				link = {
					enabled = false,
				},

				sign = {
					enabled = false,
				},

				latex = {
					enabled = false,
				},

				completions = {
					lsp = { enabled = false },
				},
			})

			set_render_highlights()

			local group = vim.api.nvim_create_augroup("GlowMarkdown", { clear = true })
			vim.api.nvim_create_autocmd("BufEnter", {
				group = group,
				callback = function()
					if vim.bo.filetype == "markdown" then
						apply_glow()
					else
						restore()
					end
				end,
			})
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = group,
				callback = function()
					saved = nil
					set_render_highlights()
					if vim.bo.filetype == "markdown" then
						apply_glow()
					end
				end,
			})

			if vim.bo.filetype == "markdown" then
				apply_glow()
			end
		end,
		enabled = false,
	},
}
