local  any = {
    name = "any",
    pattern = "*.*"
}

local augroup = vim.api.nvim_create_augroup("SimpleFold.any", { clear = true })

function any:fold( current_node) 
  if not vim.fn.match(vim.api.nvim_buf_get_name(0), pattern)then 
        return false
  end
  if (current_node:type() == "function_declaration")then 
      local start_row, start_col, end_row, end_col = current_node:range()
        if(end_row - start_row > simple_fold.fold_at_less+2)then
            vim.api.nvim_command(string.format("%d,%dfold", start_row+2, end_row+1))
            return true
        end
  end
  return false
end

function any:create_preview( current_node)
    local current_buffer = vim.api.nvim_get_current_buf()
  if (current_node:type() == "function_declaration")then 
      local start_row, start_col, end_row, end_col = current_node:range()
      local line = vim.api.nvim_win_get_cursor(0)[1]
      if(line == start_row+1)then 
            local fold_level = vim.fn.foldclosed(line+1)
            if not simple_fold.preview.buf and fold_level>=0   then
                local text = vim.treesitter.get_node_text(current_node, current_buffer)
                local splitted = string.split(text, "\n")
                simple_fold:create_preview(count(splitted))
                  vim.api.nvim_buf_set_lines(simple_fold.preview.buf, 0, -1, false, splitted)
                return true
            end
            return false
        end
  end
    return false
end

function any:check_cursor_pos()
    local current_buffer = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(current_buffer)
    local tree = parser:parse()[1]
    local root = tree:root()
    local current_node = root:child(0) -- Start with the first child of the root
    while current_node do
        if any:create_preview(current_node) then return end
      current_node = current_node:next_sibling()
    end
    if simple_fold.preview.buf then
        vim.api.nvim_buf_delete(simple_fold.preview.buf, { force = true })
        simple_fold.preview.buf = nil
    end
end

local function setup(opts)
    return any

end

return {setup = setup}
