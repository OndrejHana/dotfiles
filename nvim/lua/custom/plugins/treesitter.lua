return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "lua", "bash", "css", "git_config", "git_rebase", "gitignore", "gitcommit", "go", "html", "http" ,"javascript", "json", "markdown", "java", "python", "rust", "sql", "swift", "tmux", "toml", "tsx", "typescript" },
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
    end
}
