-- Helper function to pull diff metrics directly from gitsigns
local function gitsigns_diff()
  local gitsigns = vim.b.gitsigns_status_dict
  if gitsigns then
    return {
      added = gitsigns.added,
      modified = gitsigns.changed,
      removed = gitsigns.removed,
    }
  end
end


-- Robust Git tracking check based on active metrics
local function git_track_status()
  -- If we aren't even inside a Git workspace, don't show any circles
  local status_dict = vim.b.gitsigns_status_dict
  if not status_dict or not status_dict.head then
    return ""
  end

  if vim.bo.buftype ~= "" then return "" end

  -- If there are no diff metrics tracking this file yet, it is untracked
  if status_dict.added == nil and status_dict.changed == nil and status_dict.removed == nil then
    return "○ "
  else
    return "● "
  end
end

local function custom_errors()
  local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  if count > 0 then
    return " " .. count
  else
    return ""
  end
end

local function custom_warnings()
  local count = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  if count > 0 then
    return "• " .. count
  else
    return ""
  end
end

require('lualine').setup({
    options = {
        theme = 'auto',
        component_separators = '',
        section_separators = '',
    },
    sections = {
        -- Left side: Single-letter Mode indicators (N, I, V)
        lualine_a = { 
            { 
                'mode', 
                fmt = function(str) return str:sub(1, 1) end 
            } 
        },
        lualine_b = { 'filename' },
        -- Safely styled using our string-formatted hex converter
        lualine_c = {
            { 
                custom_errors, 
                color = function()
                    -- Safely extracts literal "#RRGGBB" format string directly from active theme
                    local hex = vim.fn.synIDattr(vim.fn.hlID('DiagnosticError'), 'fg#')
                    return { fg = (hex and hex ~= "") and hex or '#ff5555' }
                end 
            },
            { 
                custom_warnings, 
                color = function()
                    local hex = vim.fn.synIDattr(vim.fn.hlID('DiagnosticWarn'), 'fg#')
                    return { fg = (hex and hex ~= "") and hex or '#ffb86c' }
                end 
            },
        },
              -- Right side: Git stats, Branch, and Position tracking
        lualine_x = { 
            { 'diff', source = gitsigns_diff }, -- Git diff changes counter
            {
                git_track_status,
                color = function()
                    local status = vim.b.gitsigns_status or ""
                    if string.find(status, "untracked") then
                        -- Uses the universal text editor alert/change color
                        return { fg = vim.api.nvim_get_hl_by_name('DiffChange', true).foreground }
                    else
                        -- Uses the universal text editor green/add color
                        return { fg = vim.api.nvim_get_hl_by_name('DiffAdd', true).foreground }
                    end
                end
            },
        },
        lualine_y = { 'branch' },
        lualine_z = { 'location' } -- Displays line:column string (e.g., 200:10)
    }
})
