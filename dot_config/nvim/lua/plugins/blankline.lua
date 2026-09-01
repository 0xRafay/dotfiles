return {
  'lukas-reineke/indent-blankline.nvim',
  event = 'BufReadPost',
  main = 'ibl',
  ---@module "ibl"
  ---@type ibl.config
  opts = {
    indent = {
      smart_indent_cap = true,
      char = '┊',
    },
    scope = {
      enabled = true,
      show_exact_scope = true,
    },
  },
}
