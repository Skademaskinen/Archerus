vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.g.autoformat = false

vim.g.pyindent_open_paren = 0
vim.g.pyindent_close_paren = 0
vim.o.number = true
-- Integrate autopairs with nvim-cmp
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

local Terminal = require("toggleterm.terminal").Terminal

local chatgpt = Terminal:new({
    cmd = "ollama run codellama",  -- replace with your actual command, e.g., "ollama run llama3"
    hidden = true,
    direction = "float",
    float_opts = {
        border = "curved",
    },
    on_open = function(term)
        vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<A-a>", "<cmd>lua toggle_chatgpt()<CR>", { noremap = true, silent = true })
    end,
})

function _G.toggle_chatgpt()
    chatgpt:toggle()
end

function _G.send_to_chatgpt(selection)
    local text = ""

    if selection then
        local start_pos = vim.fn.getpos("'<")[2]
        local end_pos = vim.fn.getpos("'>")[2]
        local lines = vim.api.nvim_buf_get_lines(0, start_pos - 1, end_pos, false)
        text = table.concat(lines, "\n")
    else
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        text = table.concat(lines, "\n")
    end

    text = text:gsub("\\", "\\\\"):gsub('"', '\\"')

    chatgpt:open()
    vim.defer_fn(function()
        chatgpt:send(text .. "\n", false)
    end, 100)
end

vim.api.nvim_set_keymap("n", "<A-a>", "<cmd>lua toggle_chatgpt()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<A-a>", "<cmd>lua toggle_chatgpt()<CR>", { noremap = true, silent = true })

-- Normal mode: whole buffer with Alt+b
vim.api.nvim_set_keymap("n", "<A-b>", "<cmd>lua send_to_chatgpt(false)<CR>", { noremap = true, silent = true })

-- Visual mode: selection with Alt+b
vim.api.nvim_set_keymap("v", "<A-b>", [[:<C-u>lua send_to_chatgpt(true)<CR>]], { noremap = true, silent = true })
