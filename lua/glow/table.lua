-- Glow-style table renderer: width-constrained wrapping + truncation
-- Replaces render-markdown's built-in table.run with glow's behavior:
--   - No │ at left/right edges (concealed with spaces)
--   - ─ for alignment indicator (not ━)
--   - Header cells truncated with "..." when too wide
--   - Data cells word-wrapped when too wide, extra lines as virt_lines
--   - Column widths calculated from window width, not content width
local M = {}

function M.patch()
	local Table = require("render-markdown.render.markdown.table")
	local str = require("render-markdown.lib.str")

	Table.run = function(self)
		local num_cols = #self.data.cols
		if num_cols == 0 then
			return
		end

		local win_width = vim.api.nvim_win_get_width(0)
		if vim.wo.number or vim.wo.relativenumber then
			win_width = win_width - vim.wo.numberwidth - 1
		end
		if vim.wo.signcolumn ~= "no" then
			win_width = win_width - vim.wo.signcolumn:len()
		end
		if vim.wo.foldcolumn ~= "0" then
			win_width = win_width - vim.wo.foldcolumn:len()
		end
		win_width = win_width - 1
		local col_offset = self.data.layout.col
		local margin = 2
		local padding = 1
		local num_seps = num_cols - 1
		local overhead = col_offset + margin + num_seps + (num_cols * 2 * padding)
		local available = win_width - overhead

		local natural = {}
		local total = 0
		for i, col in ipairs(self.data.cols) do
			natural[i] = math.max(col.width, 3)
			total = total + natural[i]
		end

		local col_widths
		if total <= available then
			col_widths = natural
		else
			col_widths = {}
			if available < num_cols * 3 then
				for i = 1, num_cols do
					col_widths[i] = 3
				end
			else
				local ratio = available / total
				local used = 0
				for i = 1, num_cols - 1 do
					col_widths[i] = math.max(3, math.floor(natural[i] * ratio))
					used = used + col_widths[i]
				end
				col_widths[num_cols] = math.max(3, available - used)
			end
		end

		local head_hl = self.config.head
		local row_hl = self.config.row

		local function sw(s)
			return str.width(s)
		end

		local function truncate(text, width)
			if sw(text) <= width then
				return text
			end
			if width <= 3 then
				return string.rep(".", width)
			end
			local result = ""
			local w = 0
			for char in text:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
				local cw = sw(char)
				if w + cw > width - 3 then
					break
				end
				result = result .. char
				w = w + cw
			end
			return result .. "..."
		end

		local function wrap(text, width)
			if sw(text) <= width then
				return { text }
			end
			local lines = {}
			local current = ""
			local cur_w = 0
			for word in text:gmatch("%S+") do
				local ww = sw(word)
				if cur_w == 0 then
					current = word
					cur_w = ww
				elseif cur_w + 1 + ww <= width then
					current = current .. " " .. word
					cur_w = cur_w + 1 + ww
				else
					lines[#lines + 1] = current
					current = word
					cur_w = ww
				end
			end
			if current ~= "" then
				lines[#lines + 1] = current
			end
			local result = {}
			for _, line in ipairs(lines) do
				while sw(line) > width do
					local cut = ""
					local w = 0
					for char in line:gmatch("[%z\1-\127\194-\244][\128-\191]*") do
						local cw = sw(char)
						if w + cw > width then
							break
						end
						cut = cut .. char
						w = w + cw
					end
					result[#result + 1] = cut
					line = line:sub(#cut + 1)
				end
				result[#result + 1] = line
			end
			return result
		end

		local function pad(text, width, align)
			local tw = sw(text)
			if tw >= width then
				return text
			end
			local rem = width - tw
			if align == "center" then
				local l = math.floor(rem / 2)
				return string.rep(" ", l) .. text .. string.rep(" ", rem - l)
			elseif align == "right" then
				return string.rep(" ", rem) .. text
			else
				return text .. string.rep(" ", rem)
			end
		end

		local function build_row(cells)
			local parts = { string.rep(" ", margin) }
			for i, text in ipairs(cells) do
				parts[#parts + 1] = " "
				parts[#parts + 1] = text
				parts[#parts + 1] = " "
				if i < num_cols then
					parts[#parts + 1] = "│"
				end
			end
			return table.concat(parts)
		end

		local function build_delim()
			local parts = { string.rep(" ", margin) }
			for i = 1, num_cols do
				parts[#parts + 1] = " "
				parts[#parts + 1] = string.rep("─", col_widths[i])
				parts[#parts + 1] = " "
				if i < num_cols then
					parts[#parts + 1] = "┼"
				end
			end
			return table.concat(parts)
		end

		local function render_row(node, lines, hl)
			local prefix = string.rep(" ", col_offset)

			self.marks:add(self.config, false, node.start_row, node.start_col, {
				end_row = node.end_row,
				end_col = node.end_col,
				conceal = "",
			})

			local vlines = {}
			for _, text in ipairs(lines) do
				vlines[#vlines + 1] = { { prefix .. text, hl } }
			end
			self.marks:add(self.config, false, node.start_row, 0, {
				virt_lines = vlines,
				virt_lines_above = false,
			})
		end

		local alignments = {}
		for i, col in ipairs(self.data.cols) do
			alignments[i] = col.alignment
		end

		-- header (truncated with "...")
		local header = self.data.rows[1]
		local header_cells = {}
		for i, cell in ipairs(header.cells) do
			local text = vim.trim(cell.node.text or "")
			text = truncate(text, col_widths[i])
			header_cells[i] = pad(text, col_widths[i], alignments[i])
		end
		render_row(header.node, { build_row(header_cells) }, head_hl)

		-- delimiter
		render_row(self.data.delim, { build_delim() }, head_hl)

		-- data rows (wrapped, extra lines as virt_lines)
		for i = 2, #self.data.rows do
			local row = self.data.rows[i]
			local wrapped = {}
			local max_lines = 1
			for j, cell in ipairs(row.cells) do
				local text = vim.trim(cell.node.text or "")
				wrapped[j] = wrap(text, col_widths[j])
				if #wrapped[j] > max_lines then
					max_lines = #wrapped[j]
				end
			end

			local all_lines = {}
			for line_idx = 1, max_lines do
				local cells = {}
				for j = 1, num_cols do
					cells[j] = pad(wrapped[j][line_idx] or "", col_widths[j], alignments[j])
				end
				all_lines[#all_lines + 1] = build_row(cells)
			end

			render_row(row.node, all_lines, row_hl)
		end
	end
end

return M
