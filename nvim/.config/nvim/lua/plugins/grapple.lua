return {
  "cbochs/grapple.nvim",
  event = { "BufReadPost", "BufNewFile" },
  cmd = "Grapple",
  opts = {
    scope = "git",
  },
  keys = {
    {
      "<leader>ma",
      function()
        vim.ui.input({ prompt = "Bookmark name: " }, function(name)
          if name and name ~= "" then
            require("grapple").tag({ name = name })
          end
        end)
      end,
      desc = "Add named bookmark",
    },
    { "<leader>mm", "<cmd>Grapple open_tags<cr>", desc = "Open bookmarks" },
    { "<leader>md", "<cmd>Grapple untag<cr>",     desc = "Delete bookmark" },
    { "<leader>mn", "<cmd>Grapple cycle_tags next<cr>", desc = "Next bookmark" },
    { "<leader>mp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Prev bookmark" },
  },
}
