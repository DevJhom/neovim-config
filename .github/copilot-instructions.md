# Copilot Instructions for Neovim Configuration

This is a **LazyVim starter template** with a modular, plugin-first architecture. Below are conventions, patterns, and critical context for AI-assisted development.

## Architecture Overview

- **Framework**: LazyVim (lazy.nvim-based plugin manager)
- **Language**: Lua (100% Lua configuration, no Vimscript)
- **Code Style**: StyLua (2-space indentation, 120-column width)
- **Entry Point**: `init.lua` → `lua/config/lazy.lua`

## Directory Structure

```
lua/
├── config/          # Core configuration (extends LazyVim defaults)
│   ├── lazy.lua     # Plugin manager bootstrap & global defaults
│   ├── options.lua  # Editor settings
│   ├── keymaps.lua  # Keybindings
│   └── autocmds.lua # Event handlers
└── plugins/         # Individual plugin specifications (one file per plugin/feature)
    ├── lsp-config.lua      # LSP setup (mason → mason-lspconfig → nvim-lspconfig)
    ├── telescope.lua       # Fuzzy finder
    ├── neotree.lua         # File browser
    ├── theme.lua           # Theme (vscode.nvim)
    ├── treesitter.lua      # Syntax highlighting
    └── example.lua         # Template for new plugins
```

## Key Conventions

### 1. **Plugin Specification Pattern**

All plugins follow this explicit pattern:

```lua
return {
  "plugin-author/plugin-name",
  event = "VeryLazy",              -- or: cmd, keys, ft for lazy-loading
  dependencies = { "dep/name" },
  opts = {
    -- Plugin-specific options (passed to setup)
    option_key = value,
  },
  config = function(plugin, opts)
    -- Setup logic (e.g., vim.keymap.set, custom initialization)
    require("plugin-name").setup(opts)
    -- Create keymaps, autocommands, etc. here
  end,
}
```

**Key points**:
- Use `opts` for configuration data; use `config` for setup logic
- Dependencies are explicit; avoid relying on LazyVim auto-setup
- Lazy-loading is enabled per-plugin via `event`, `cmd`, `keys`, or `ft`
- Never use global `setup()` — always use the `config` function

### 2. **Configuration Extension Strategy**

When extending core configs:
- **`lua/config/options.lua`**: Add editor-level settings (e.g., `vim.opt.colorcolumn = "120"`)
- **`lua/config/keymaps.lua`**: Add global keybindings using `vim.keymap.set()`
- **`lua/config/autocmds.lua`**: Add event handlers using `vim.api.nvim_create_autocmd()`
- Plugin-specific keymaps/autocmds go in the plugin's `config` function

### 3. **LSP Stack** (Explicit Order)

The LSP setup follows this explicit chain:
1. **mason.nvim** — Package manager for LSP servers
2. **mason-lspconfig.nvim** — Bridge for auto-install & registration
3. **nvim-lspconfig** — Actual LSP client setup

Server list in `lua/plugins/lsp-config.lua` under `ensure_installed`:
- `lua_ls` — Lua language server
- `ts_ls` — TypeScript/JavaScript language server

To add a new server:
1. Add to `ensure_installed` array
2. Ensure nvim-lspconfig supports it (check `:h lspconfig.server_configurations`)

### 4. **Adding New Plugins**

1. Create a new file in `lua/plugins/` (e.g., `my-plugin.lua`)
2. Follow the plugin specification pattern above
3. Return either a single table or an array of tables
4. Run `:Lazy sync` to install and validate
5. Test in isolated config: `nvim -u /path/to/init.lua`

### 5. **Code Quality & Validation**

- **Formatter**: StyLua (configured in `stylua.toml`)
  - Run: `stylua lua/` to format all Lua files
  - Indentation: 2 spaces; column width: 120
- **No linting CI** — Manual validation only
- Always validate Lua syntax before committing

## Common Tasks

| Task | Location | Pattern |
|------|----------|---------|
| Add a global keybinding | `lua/config/keymaps.lua` | `vim.keymap.set("n", "<leader>x", ...)` |
| Set editor options | `lua/config/options.lua` | `vim.opt.colorcolumn = "120"` |
| Add an autocmd | `lua/config/autocmds.lua` | `vim.api.nvim_create_autocmd("BufWritePre", ...)` |
| Configure LSP | `lua/plugins/lsp-config.lua` | Add to `ensure_installed` or edit config function |
| Add a new plugin | `lua/plugins/new-plugin.lua` | Copy `example.lua` template & follow spec pattern |
| Extend theme | `lua/plugins/theme.lua` | Update `opts` in config function |

## Anti-Patterns (Avoid)

- ❌ Using `require()` in `opts` — keep it simple data
- ❌ Implicit LazyVim auto-setup — always be explicit
- ❌ Putting plugin setup in `config/options.lua` — one concern per file
- ❌ Missing `dependencies` declarations — be explicit about plugin relationships
- ❌ Global `vim.keymap.set()` in plugin files — put global keymaps in `config/keymaps.lua`
- ❌ Ignoring lazy-loading — use `event`, `cmd`, or `keys` appropriately

## Special Files

- **`init.lua`**: Minimal entry point (do not edit unless necessary)
- **`lazy-lock.json`**: Lock file for reproducible plugin versions (auto-generated)
- **`lazyvim.json`**: LazyVim metadata (auto-generated)

## Testing & Validation

Since there's no CI system:
1. Test new plugins in isolation: `nvim -u init.lua`
2. Run `:Lazy sync` after changes
3. Check for errors: `:Lazy log` (if issues occur)
4. Validate Lua: `stylua --check lua/`

## Integration Notes

- **VS Code Vim**: Config sources `_vsvimrc` for VS Code + Vim integration
- This setup bridges local Neovim and VS Code Vim experiences
