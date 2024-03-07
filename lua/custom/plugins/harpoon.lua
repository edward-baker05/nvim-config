return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("harpoon"):setup()
    end,
    keys = {
      { "<leader>a", function() require("harpoon"):list():append() end,  desc = "harpoon file", },
      {
        "<leader>A",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "harpoon quick menu",
      },
      { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon to file 1", },
      { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon to file 2", },
      { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon to file 3", },
      { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon to file 4", },
      { "<leader>5", function() require("harpoon"):list():select(5) end, desc = "Harpoon to file 5", },
      { "<leader>r1", function() require("harpoon"):list():removeAt(1) end, desc = "Remove file 1 from harpoon"},
      { "<leader>r2", function() require("harpoon"):list():removeAt(2) end, desc = "Remove file 2 from harpoon"},
      { "<leader>r3", function() require("harpoon"):list():removeAt(3) end, desc = "Remove file 3 from harpoon"},
      { "<leader>r4", function() require("harpoon"):list():removeAt(4) end, desc = "Remove file 4 from harpoon"},
      { "<leader>r5", function() require("harpoon"):list():removeAt(5) end, desc = "Remove file 5 from harpoon"},
    },
}
