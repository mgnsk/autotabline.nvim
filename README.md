# autotabline.nvim

Minimal automatic tabline for neovim.

## Features
* Shows opened windows and their types in tab title
* Shows number of modifications on each tab
* When tabs don't fit to screen, removes tabs from left or right and shows `...`
* Mouse support for selecting and closing tabs

## Setup

lazy.nvim:
```lua
{
	"mgnsk/autotabline.nvim",
	config = function()
		require("autotabline").setup()
	end,
},
```

## Colors
* `TabLineSel` - current tab
* `TabLineFill` - inactive tabs and tab row

### Inspired by

https://stackoverflow.com/questions/33710069/how-to-write-tabline-function-in-vim/33765365#33765365

https://github.com/lukelbd/vim-tabline

https://gist.github.com/neilmarion/6432019
