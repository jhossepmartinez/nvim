-- Glow-style heading renderer: adds blank line below headings
-- Glow's glamour style has block_suffix: "\n" for headings
local M = {}

function M.patch()
	local Heading = require("render-markdown.render.markdown.heading")
	local original_run = Heading.run

	Heading.run = function(self)
		original_run(self)
		local fg = self.data.fg or "RenderMarkdownH1"
		self.marks:add(self.config, "virtual_lines", self.node.start_row, 0, {
			virt_lines = { { { "", fg } } },
			virt_lines_above = false,
		})
	end
end

return M
