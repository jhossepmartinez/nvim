-- Glow-style quote renderer: 2-space margin + │ bar (no spillover)
-- Built-in overlay icon "  │" (3 chars) covers first letter of content.
-- This patch: inline "  " margin + overlay "│" (1 char = same as >)
local M = {}

function M.patch()
	local Quote = require("render-markdown.render.markdown.quote")

	Quote.marker = function(self, node, index)
		local range = node:find(">")[index]
		if not range then
			return
		end
		local row = range[1]
		local col = range[2]
		local hl = self.data.highlight

		self.marks:add(self.config, "quote", row, 0, {
			virt_text = { { "  ", hl } },
			virt_text_pos = "inline",
		})

		self.marks:add(self.config, "quote", row, col, {
			end_row = range[3],
			end_col = range[4],
			virt_text = { { "│", hl } },
			virt_text_pos = "overlay",
		})
	end
end

return M
