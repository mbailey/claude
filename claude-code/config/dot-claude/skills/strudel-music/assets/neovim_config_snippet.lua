-- Strudel.nvim configuration snippet for lazy.nvim
-- Add this to your Neovim plugins configuration

return {
  "gruvw/strudel.nvim",
  build = "npm install",
  config = function()
    require("strudel").setup({
      -- Optional configuration
      ui = {
        hidden_elements = {
          "header",
          "footer",
          "code",
        },
      },
      sync = {
        two_way = true,  -- Enable two-way sync between Neovim and browser
      },
    })

    -- Keybindings
    local opts = { noremap = true, silent = true }

    -- Launch Strudel
    vim.keymap.set("n", "<leader>sl", ":StrudelLaunch<CR>", opts)

    -- Toggle Strudel playback
    vim.keymap.set("n", "<leader>st", ":StrudelToggle<CR>", opts)

    -- Update Strudel (send buffer content to browser)
    vim.keymap.set("n", "<leader>su", ":StrudelUpdate<CR>", opts)

    -- Stop Strudel
    vim.keymap.set("n", "<leader>ss", ":StrudelStop<CR>", opts)
  end,
}
