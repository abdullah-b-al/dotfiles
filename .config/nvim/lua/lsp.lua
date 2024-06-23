local found_lspconfig = pcall(require, 'lspconfig')
local found_signature = pcall(require, 'lsp_signature')
local found_cmp       = pcall(require, 'cmp_nvim_lsp')

if not found_lspconfig then
    print("Couldn't find lspconfig in lsps/init.lua")
    return
end
if not found_signature then
    print("Couldn't find lsp-signature in lsps/init.lua")
    return
end
if not found_cmp then
    print("Couldn't find cmp in lsps/init.lua")
    return
end

local on_attach = function(client, bufnr)
    -- vim.lsp.inlay_hint.enable()
    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#5b606c", bold = true })

    -- client.server_capabilities.semanticTokensProvider = nil

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    Unique_map('n', 'gD', vim.lsp.buf.declaration,         { remap = false, silent=true , buffer = 0 , desc = 'LSP: Go to declaration'})
    Unique_map('n', 'gd', vim.lsp.buf.definition,          { remap = false, silent=true , buffer = 0 , desc = 'LSP: Go to definition'})
    Unique_map('n', '<C-s>', vim.lsp.buf.signature_help,   { remap = false, silent=true , buffer = 0 , desc = 'LSP: Show function signature'})
    Unique_map('n', '<space>rn', vim.lsp.buf.rename,       { remap = false, silent=true , buffer = 0 , desc = 'LSP: Rename symbol'})
    Unique_map('n', 'gr', vim.lsp.buf.references,          { remap = false, silent=true , buffer = 0 , desc = 'LSP: Put references in quickfix list'})
    Unique_map('n', '<space>e', vim.diagnostic.open_float, { remap = false, silent=true , buffer = 0 , desc = 'LSP: Show diagnostics'})
    Unique_map('n', '<space>q', vim.diagnostic.setloclist, { remap = false, silent=true , buffer = 0 , desc = 'LSP: Place diagnostics in local quickfix list'})
    Unique_map('n', '<space>lc', vim.lsp.buf.code_action,  { remap = false, silent=true , buffer = 0 , desc = 'LSP: Code action'})
    Unique_map('n', '<space>hi', function ()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end,  { remap = false, silent=true , buffer = 0 , desc = 'LSP: toggle inlay hint'})
end

local signature_cfg = {
    debug = false, -- set to true to enable debug logging
    log_path = "debug_log_file_path", -- debug log path
    verbose = false, -- show debug line number

    bind = true, -- This is mandatory, otherwise border config won't get registered.
    -- If you want to hook lspsaga or other signature handler, pls set to false
    doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
    -- set to 0 if you DO NOT want any API comments be shown
    -- This setting only take effect in insert mode, it does not affect signature help in normal
    -- mode, 10 by default

    floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

    floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
    -- will set to true when fully tested, set to false will use whichever side has more space
    -- this setting will be helpful if you do not want the PUM and floating win overlap
    fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
    hint_enable = true, -- virtual hint enable
    hint_prefix = "",
    hint_scheme = "String",
    use_lspsaga = false,  -- set to true if you want to use lspsaga popup
    hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
    max_height = 12, -- max height of signature floating_window, if content is more than max_height, you can scroll down
    -- to view the hiding contents
    max_width = 120, -- max_width of signature floating_window, line will be wrapped if exceed max_width
    transpancy = 10, -- set this value if you want the floating windows to be transpant (100 fully transpant), nil to disable(default)
    handler_opts = {
        border = "single"   -- double, single, shadow, none
    },

    always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

    auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
    extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
    zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

    padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

    shadow_blend = 36, -- if you using shadow as border use this set the opacity
    shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
    timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
    toggle_key = nil -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
}

local lspconfig = require 'lspconfig'
local signature = require 'lsp_signature'
local cmp       = require('cmp_nvim_lsp')

local servers = {
    {name = 'texlab'},
    {name = 'zls'},
    {name = 'gopls'},
    {name = 'clangd'},
    {name = 'pylsp'},
    {name = 'ansiblels', cmd = {'ansible-language-server', '--stdio'}, filetypes = {'yaml.ansible', "yaml", "yml"},},
    {name = 'lua_ls', cmd = {'lua-language-server'} },
}

require("mason-lspconfig").setup({
    automatic_installation = false,
    ensure_installed = {
        'gopls',
        'lua_ls',
        'pylsp',
        'clangd',
        'ansiblels',
    },
})

for _, server in ipairs(servers) do
    local cmd = server.cmd or {server.name}
    local filetypes = server.filetypes or lspconfig[server.name].filetypes
    lspconfig[server.name].setup{
        on_attach = on_attach,
        cmd = cmd,
        -- nvim-cmp setting
        capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities ()),
        filetypes = filetypes,
        -- LSP signature
        signature.setup(signature_cfg),
    }
end
