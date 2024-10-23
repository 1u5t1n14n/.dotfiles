return {
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
	},
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        options = {
          "-xelatex",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
        },
      }
      vim.g.maplocalleader = ","
    end,
  },
}
