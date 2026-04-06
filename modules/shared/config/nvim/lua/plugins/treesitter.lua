return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      ensure_installed = { "lua", "vim", "vimdoc", "python" },
      auto_install = true,
      highlight = true,
      indent = true,
    },
  },
}
