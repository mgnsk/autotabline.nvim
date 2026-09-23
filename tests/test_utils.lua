local M = {}

--- Reset the editor to a single tab with one fresh, unnamed, unmodified buffer.
function M.reset()
	vim.cmd("tabonly!")
	vim.cmd("only!")
	vim.cmd("silent! %bwipeout!")
	vim.cmd("enew")
	vim.go.columns = 80
end

--- Open a new tab, making it the current one, optionally editing a file in it.
--- @param path string?
function M.open_tab(path)
	vim.cmd("tabnew")
	if path then
		vim.cmd("edit " .. vim.fn.fnameescape(path))
	end
end

return M
