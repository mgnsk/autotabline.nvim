local utils = require("tests.test_utils")

-- Loading the module defines the global _G.autotabline() function under test.
require("autotabline")

describe("autotabline", function()
	before_each(function()
		utils.reset()
	end)

	after_each(function()
		utils.reset()
	end)

	describe("single tab", function()
		it("shows [New] for a blank unnamed buffer", function()
			assert.are.same("%#TabLineSel#%1T 1 [New]%#TabLineFill#%T", _G.autotabline())
		end)

		it("shows the shortened path for a named buffer", function()
			vim.cmd("edit /a/b/c.lua")
			assert.are.same("%#TabLineSel#%1T 1 /a/b/c.lua %#TabLineFill#%T", _G.autotabline())
		end)

		it("shows a [N+] badge for a modified buffer", function()
			vim.bo.modified = true
			assert.are.same("%#TabLineSel#%1T 1 [1+][New]%#TabLineFill#%T", _G.autotabline())
		end)

		it("sums the modified badge and lists every window's buffer in the tab", function()
			vim.cmd("edit /a/one.lua")
			vim.bo.modified = true
			vim.cmd("vsplit")
			vim.cmd("edit /a/two.lua")
			vim.bo.modified = true
			assert.are.same("%#TabLineSel#%1T 1 [2+]/a/two.lua /a/one.lua %#TabLineFill#%T", _G.autotabline())
		end)

		it("shows [H]<name> for a help buffer, stripping the .txt extension", function()
			vim.bo.buftype = "help"
			vim.api.nvim_buf_set_name(0, "/doc/mytag.txt")
			assert.are.same("%#TabLineSel#%1T 1 [H]mytag %#TabLineFill#%T", _G.autotabline())
		end)

		it("shows [Q] for a quickfix buffer", function()
			vim.bo.buftype = "quickfix"
			assert.are.same("%#TabLineSel#%1T 1 [Q] %#TabLineFill#%T", _G.autotabline())
		end)

		it("shows [T]<shortened path> for a terminal buffer", function()
			vim.fn.jobstart({ "true" }, { term = true })
			local bufname = vim.fn.bufname(vim.api.nvim_get_current_buf())
			local expected_label = "[T]" .. vim.fn.pathshorten(vim.split(bufname, "//")[2])
			assert.are.same("%#TabLineSel#%1T 1 " .. expected_label .. " %#TabLineFill#%T", _G.autotabline())
		end)
	end)

	describe("multiple tabs", function()
		it("highlights only the current tab and appends the close button", function()
			vim.cmd("edit /a/one.lua")
			utils.open_tab("/a/two.lua")
			assert.are.same(
				"%#TabLineFill#%1T 1 /a/one.lua %#TabLineSel#%2T 2 /a/two.lua %#TabLineFill#%T%=%#TabLineFill#%999XX",
				_G.autotabline()
			)
		end)
	end)

	describe("truncation", function()
		before_each(function()
			for i = 1, 5 do
				utils.open_tab(string.format("/aaaaaaaaaa/bbbbbbbbbb/file%d.lua", i))
			end
			vim.go.columns = 40
		end)

		it("drops tabs from the right and prefixes nothing when current tab is near the left edge", function()
			vim.cmd("tabfirst")
			local result = _G.autotabline()
			assert.truthy(result:find("···", 1, true))
			assert.falsy(result:find("file5", 1, true))
			assert.truthy(result:find("[New]", 1, true))
		end)

		it("drops tabs from the left when current tab is near the right edge", function()
			-- tablast is implicit: the loop above already leaves tab 6 current.
			local result = _G.autotabline()
			assert.truthy(result:find("···", 1, true))
			assert.falsy(result:find("file1.lua", 1, true))
			assert.truthy(result:find("file5.lua", 1, true))
		end)
	end)

	describe("setup", function()
		it("sets the tabline option", function()
			require("autotabline").setup()
			assert.are.same("%!v:lua.autotabline()", vim.o.tabline)
		end)
	end)
end)
