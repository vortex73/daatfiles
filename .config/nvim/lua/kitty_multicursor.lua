-- Kitty Multiple Cursors Integration for Neovim
-- Add this to your init.lua or as a separate plugin file

local M = {}

-- Helper function to send escape sequences to terminal
local function send_escape_sequence(sequence)
    io.write(sequence)
    io.flush()
end

-- Clear all multiple cursors
function M.clear_cursors()
    -- CSI > 0;4 TRAILER - clears all cursors using rectangle coordinate system
    send_escape_sequence("\27[>0;4 q")
end

-- Set cursors at specific positions (1-indexed, like Vim)
function M.set_cursors(positions)
    M.clear_cursors()
    
    if #positions == 0 then
        return
    end
    
    -- Build the escape sequence for multiple positions
    -- CSI > SHAPE;CO-ORD TYPE : CO-ORDINATES TRAILER
    -- Shape 29 = follow main cursor shape
    -- CO-ORD TYPE 2 = pairs of y:x coordinates
    local coords = {}
    for _, pos in ipairs(positions) do
        table.insert(coords, pos.row .. ":" .. pos.col)
    end
    
    local sequence = "\27[>29;2:" .. table.concat(coords, ";2:") .. " q"
    send_escape_sequence(sequence)
end

-- Get visual selection range
local function get_visual_range()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    return {
        start_row = start_pos[2],
        start_col = start_pos[3],
        end_row = end_pos[2],
        end_col = end_pos[3]
    }
end

-- Add cursors to each line in visual selection at the same column
function M.add_cursors_visual_column()
    local range = get_visual_range()
    local positions = {}
    
    -- Get the column position from the start of selection
    local col = range.start_col
    
    for row = range.start_row, range.end_row do
        -- Make sure the line exists and has enough characters
        local line = vim.fn.getline(row)
        if #line >= col then
            table.insert(positions, {row = row, col = col})
        end
    end
    
    M.set_cursors(positions)
end

-- Add cursors to end of each line in visual selection
function M.add_cursors_visual_eol()
    local range = get_visual_range()
    local positions = {}
    
    for row = range.start_row, range.end_row do
        local line = vim.fn.getline(row)
        table.insert(positions, {row = row, col = #line + 1})
    end
    
    M.set_cursors(positions)
end

-- Add cursors at the beginning of each line in visual selection
function M.add_cursors_visual_bol()
    local range = get_visual_range()
    local positions = {}
    
    for row = range.start_row, range.end_row do
        table.insert(positions, {row = row, col = 1})
    end
    
    M.set_cursors(positions)
end

-- Add cursors at current column for a range of lines
function M.add_cursors_column_range(start_line, end_line)
    local current_col = vim.fn.col('.')
    local positions = {}
    
    for row = start_line, end_line do
        local line = vim.fn.getline(row)
        if #line >= current_col then
            table.insert(positions, {row = row, col = current_col})
        end
    end
    
    M.set_cursors(positions)
end

-- Find and add cursors at all occurrences of word under cursor
function M.add_cursors_word_occurrences()
    local word = vim.fn.expand("<cword>")
    if word == "" then
        return
    end
    
    local positions = {}
    local line_count = vim.fn.line('$')
    
    for row = 1, line_count do
        local line = vim.fn.getline(row)
        local col = 1
        while true do
            local start_col = string.find(line, "\\<" .. vim.fn.escape(word, "\\") .. "\\>", col)
            if not start_col then
                break
            end
            table.insert(positions, {row = row, col = start_col})
            col = start_col + 1
        end
    end
    
    M.set_cursors(positions)
end

-- Auto-clear cursors when entering insert mode (to avoid confusion)
local function setup_autocmds()
    vim.api.nvim_create_augroup("KittyMultiCursor", { clear = true })
    
    -- Clear cursors when entering insert mode
    vim.api.nvim_create_autocmd("InsertEnter", {
        group = "KittyMultiCursor",
        callback = function()
            -- Small delay to let the cursors show during the transition
            vim.defer_fn(M.clear_cursors, 50)
        end
    })
    
    -- Clear cursors when leaving vim
    vim.api.nvim_create_autocmd("VimLeave", {
        group = "KittyMultiCursor",
        callback = M.clear_cursors
    })
    
    -- Clear cursors when switching buffers
    vim.api.nvim_create_autocmd("BufLeave", {
        group = "KittyMultiCursor",
        callback = M.clear_cursors
    })
end

-- Setup function to initialize the plugin
function M.setup()
    setup_autocmds()
    
    -- Key mappings
    vim.keymap.set('v', '<leader>mc', M.add_cursors_visual_column, 
        { desc = "Add cursors at same column in visual selection" })
    vim.keymap.set('v', '<leader>me', M.add_cursors_visual_eol, 
        { desc = "Add cursors at end of lines in visual selection" })
    vim.keymap.set('v', '<leader>mb', M.add_cursors_visual_bol, 
        { desc = "Add cursors at beginning of lines in visual selection" })
    vim.keymap.set('n', '<leader>mw', M.add_cursors_word_occurrences, 
        { desc = "Add cursors at all word occurrences" })
    vim.keymap.set('n', '<leader>mx', M.clear_cursors, 
        { desc = "Clear all multiple cursors" })
    
    -- Command to add cursors in a range
    vim.api.nvim_create_user_command('MultiCursorRange', function(opts)
        local args = vim.split(opts.args, ' ')
        local start_line = tonumber(args[1]) or vim.fn.line('.')
        local end_line = tonumber(args[2]) or start_line
        M.add_cursors_column_range(start_line, end_line)
    end, { 
        nargs = '*', 
        desc = "Add cursors at current column for line range" 
    })
end

return M
