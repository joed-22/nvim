-- To keep keymappings the same if i ever change term plugin, export float, horz, vert, terms here
local Terminal = require("toggleterm.terminal").Terminal

local M = {}

M.float_term = Terminal:new({ direction = "float", hidden = true })
M.horiz_term = Terminal:new({ direction = "horizontal", hidden = true, size = 15 })
M.vert_term  = Terminal:new({ direction = "vertical", hidden = true, size = 0.4 })

return M

