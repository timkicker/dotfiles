-- Minimal Neovim configuration: completion, autopairs, statusline, and custom theme.
-- All comments written in English for publication.

-- ---------- Color Palette ----------
-- Base UI + derived syntax colors aligned to a calm, dark aesthetic.
local C = {
  red    = "#a14040",
  green  = "#6aaa64",
  orange = "#df970d",      -- Insert mode / syntax accent
  pink   = "#b16286",
  fg     = "#bec1bf",
  bg     = "#2a2a2a",      -- Dark background (not absolute black)
  bg2    = "#333333",      -- CursorLine / floating windows
  dim    = "#222222",      -- Borders / darker areas
  cyan   = "#64aaaa",
  purple = "#9762b1",
  blue   = "#6289b1",
  yellow = "#d5a442",
  comment= "#8a8a8a",
}

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true

-- ---------- Minimal Inline Colorscheme (with Treesitter links) ----------
local function apply_colors()
  local hl = vim.api.nvim_set_hl

  -- Core UI groups
  hl(0, "Normal",         { fg=C.fg, bg=C.bg })
  hl(0, "NormalFloat",    { fg=C.fg, bg=C.bg2 })
  hl(0, "FloatBorder",    { fg=C.dim, bg=C.bg2 })
  hl(0, "SignColumn",     { bg=C.bg })
  hl(0, "LineNr",         { fg=C.comment, bg=C.bg })
  hl(0, "CursorLine",     { bg=C.bg2 })
  hl(0, "CursorLineNr",   { fg=C.fg, bg=C.bg2, bold=true })
  hl(0, "Visual",         { bg=C.pink, fg="#000000" })
  hl(0, "Search",         { bg=C.green, fg="#000000" })
  hl(0, "IncSearch",      { bg=C.red,   fg="#000000" })
  hl(0, "Pmenu",          { fg=C.fg, bg=C.bg2 })
  hl(0, "PmenuSel",       { fg="#000000", bg=C.green })
  hl(0, "StatusLine",     { fg=C.fg, bg=C.bg2 })
  hl(0, "StatusLineNC",   { fg="#9e9e9e", bg=C.dim })
  hl(0, "WinSeparator",   { fg=C.dim, bg=C.bg })

  -- Basic syntax groups inspired by a balanced "bat" style
  hl(0, "Comment",        { fg=C.comment, italic=true })
  hl(0, "SpecialComment", { fg=C.comment, italic=true })
  hl(0, "Todo",           { fg="#000000", bg=C.yellow, bold=true })

  hl(0, "String",         { fg=C.green })
  hl(0, "Character",      { fg=C.green })
  hl(0, "Number",         { fg=C.orange })
  hl(0, "Float",          { fg=C.orange })
  hl(0, "Boolean",        { fg=C.orange, bold=true })
  hl(0, "Constant",       { fg=C.orange })

  hl(0, "Keyword",        { fg=C.purple, bold=true })
  hl(0, "Conditional",    { fg=C.purple, bold=true })
  hl(0, "Repeat",         { fg=C.purple })
  hl(0, "Exception",      { fg=C.red, bold=true })
  hl(0, "Operator",       { fg=C.fg })
  hl(0, "Statement",      { fg=C.purple })

  hl(0, "Identifier",     { fg=C.fg })
  hl(0, "Function",       { fg=C.orange, bold=true })
  hl(0, "Type",           { fg=C.cyan, bold=true })
  hl(0, "StorageClass",   { fg=C.cyan })
  hl(0, "Structure",      { fg=C.cyan })
  hl(0, "Typedef",        { fg=C.cyan })

  hl(0, "PreProc",        { fg=C.blue })
  hl(0, "Include",        { fg=C.blue })
  hl(0, "Define",         { fg=C.blue })
  hl(0, "Macro",          { fg=C.blue })
  hl(0, "PreCondit",      { fg=C.blue })

  hl(0, "Special",        { fg=C.pink })
  hl(0, "SpecialChar",    { fg=C.pink })
  hl(0, "Delimiter",      { fg=C.fg })
  hl(0, "MatchParen",     { fg=C.yellow, bold=true, underline=true })

  -- LSP / diagnostics (in case an LSP attaches)
  hl(0, "DiagnosticError",{ fg=C.red })
  hl(0, "DiagnosticWarn", { fg=C.orange })
  hl(0, "DiagnosticInfo", { fg=C.blue })
  hl(0, "DiagnosticHint", { fg=C.cyan })
  hl(0, "DiagnosticUnderlineError", { sp=C.red, undercurl=true })
  hl(0, "DiagnosticUnderlineWarn",  { sp=C.orange, undercurl=true })
  hl(0, "DiagnosticUnderlineInfo",  { sp=C.blue, undercurl=true })
  hl(0, "DiagnosticUnderlineHint",  { sp=C.cyan, undercurl=true })

  -- Treesitter links so highlighting is consistent without an external colorscheme
  local ts_links = {
    ["@comment"]           = "Comment",
    ["@string"]            = "String",
    ["@character"]         = "Character",
    ["@number"]            = "Number",
    ["@float"]             = "Float",
    ["@boolean"]           = "Boolean",
    ["@constant"]          = "Constant",
    ["@constant.builtin"]  = "Constant",
    ["@keyword"]           = "Keyword",
    ["@keyword.function"]  = "Keyword",
    ["@conditional"]       = "Conditional",
    ["@repeat"]            = "Repeat",
    ["@exception"]         = "Exception",
    ["@operator"]          = "Operator",
    ["@variable"]          = "Identifier",
    ["@field"]             = "Identifier",
    ["@property"]          = "Identifier",
    ["@type"]              = "Type",
    ["@type.builtin"]      = "Type",
    ["@function"]          = "Function",
    ["@function.call"]     = "Function",
    ["@constructor"]       = "Function",
    ["@include"]           = "Include",
    ["@define"]            = "Define",
    ["@macro"]             = "Macro",
    ["@preproc"]           = "PreProc",
    ["@punctuation"]       = "Delimiter",
  }
  for from, to in pairs(ts_links) do
    hl(0, from, { link = to, default = false })
  end
end
apply_colors()

-- ---------- lazy.nvim Bootstrap ----------
local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ---------- Plugin Setup ----------
require("lazy").setup({
  -- Completion
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<CR>"]    = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"]= cmp.mapping.complete(),
          ["<Tab>"]   = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = {
          { name = "path" },
          { name = "buffer" },
          { name = "luasnip" },
        },
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })
    end
  },

  -- Autopairs
  { "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end
  },

  -- Statusline with mode-dependent colors
  { "nvim-lualine/lualine.nvim",
    config = function()
      local theme = {
        normal   = { a = { fg="#000000", bg=C.orange, gui="bold" }, c = { fg=C.fg, bg=C.bg2 } },
        insert   = { a = { fg="#000000", bg=C.green , gui="bold" } },
        visual   = { a = { fg="#000000", bg=C.pink  , gui="bold" } },
        replace  = { a = { fg="#000000", bg=C.red   , gui="bold" } },
        command  = { a = { fg="#000000", bg=C.red   , gui="bold" } },
        inactive = { a = { fg=C.fg, bg=C.dim }, c = { fg="#9e9e9e", bg=C.dim } },
      }
      require("lualine").setup({
        options = {
          theme = theme,
          globalstatus = true,
          section_separators = "",
          component_separators = "",
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end
  },
}, {
  ui = { border = "rounded" }
})

-- Reapply our colors if another colorscheme loads later.
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_colors })

-- Write current file with sudo by using :SudoWrite or w!!
vim.api.nvim_create_user_command('SudoWrite', function()
  vim.cmd('write !sudo tee % > /dev/null')
  vim.cmd('edit!')
end, { desc = 'Write using sudo' })
vim.keymap.set('n', '<leader>W', ':SudoWrite<CR>', { silent = true, desc = 'sudo write' })
vim.cmd([[cnoreabbrev w!! SudoWrite]])

