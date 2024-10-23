return {
  "eandrju/cellular-automaton.nvim",
  config = function()
    vim.keymap.set("n", "<leader>fu", "<cmd>:CellularAutomaton make_it_rain<CR>")
    vim.keymap.set('n', "<C-p>", "<cmd>:CellularAutomaton game_of_life<CR>")
  end
}
