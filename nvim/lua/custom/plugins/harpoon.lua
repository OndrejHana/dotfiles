return {
  "ThePrimeagen/harpoon",
  dependencies = { 'nvim-lua/plenary.nvim' },
  branch = "harpoon2",
  config = function()
    local harpoon = require "harpoon"
    harpoon:setup()

    vim.keymap.set("n", "<leader>a", function()
      harpoon:list():add()
    end)
    vim.keymap.set("n", "<leader>h", function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end)

    vim.keymap.set("n", "<C-h>",function() harpoon:list():select(1)end)
    vim.keymap.set("n", "<C-j>",function() harpoon:list():select(2)end)
    vim.keymap.set("n", "<C-k>",function() harpoon:list():select(3)end)
    vim.keymap.set("n", "<C-l>",function() harpoon:list():select(4)end)

    -- Set <space>1..<space>5 be my shortcuts to moving to the files
    -- for _, idx in ipairs { 1, 2, 3, 4, 5 } do
    --   vim.keymap.set("n", string.format("<C-%d>", idx), function()
    --     harpoon:list():select(idx)
    --   end)
    -- end
  end,
}
