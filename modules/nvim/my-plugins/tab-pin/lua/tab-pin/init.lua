local M = {}


-- Configure cool, high-quality symbols for your gutter diagnostics
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ", -- Heavy solid alert cross
            [vim.diagnostic.severity.WARN]  = "•", -- Clear warning triangle
            [vim.diagnostic.severity.HINT]  = "󰌵 ", -- Sleek glowing lightbulb
            [vim.diagnostic.severity.INFO]  = " ", -- Clean info circle
        },
    },
})
-- State: Maps tabpage IDs to the specific Buffer IDs they are locked to
local pinned_tabs = {}
local allowing_new_tab = false
local is_processing = false
local last_active_tab = nil
local last_active_was_pinned = false

local data_path = vim.fn.stdpath("data") .. "/tabpins_history.json"
-- Internal helper to get the clean filename of a buffer
local function get_buffer_name(bufnr)
	local path = vim.api.nvim_buf_get_name(bufnr)
	if path == "" then
		return "[No Name]"
	end
	return vim.fs.basename(path)
end

local function update_tab_title(tabpage, bufnr)
	if pinned_tabs[tabpage] then
		local name = get_buffer_name(bufnr)
		vim.api.nvim_tabpage_set_var(tabpage, "tab_title", name)
	else
		pcall(vim.api.nvim_tabpage_del_var, tabpage, "tab_title")
	end
end

-- Persistence Engine: Save active pins grouped by CWD
function M.save_pins()
	local cwd = vim.fn.getcwd()
	local data = {}

	-- Read existing file to preserve histories of your other projects
	local r_file = io.open(data_path, "r")
	if r_file then
		local content = r_file:read("*a")
		r_file:close()
		pcall(function()
			data = vim.json.decode(content) or {}
		end)
	end

	-- Extract the file paths of all currently pinned buffers
	local current_pinned_files = {}
	local tabs = vim.api.nvim_list_tabpages()
	for _, tab in ipairs(tabs) do
		local bufnr = pinned_tabs[tab]
		if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
			local path = vim.api.nvim_buf_get_name(bufnr)
			if path ~= "" then
				table.insert(current_pinned_files, path)
			end
		end
	end

	-- Update history map
	if #current_pinned_files > 0 then
		data[cwd] = current_pinned_files
	else
		data[cwd] = nil -- Clear entry if no pins remain
	end

	-- Write database back to disk cleanly
	local w_file = io.open(data_path, "w")
	if w_file then
		w_file:write(vim.json.encode(data))
		w_file:close()
		vim.notify("Saved at:\n" .. data_path, vim.log.levels.INFO, { title = "TabPins" })
	end
end

local function clear_tabs()
    local initial_tab = vim.api.nvim_get_current_tabpage()
    local all_tabs = vim.api.nvim_list_tabpages()
    for _, tab in ipairs(all_tabs) do
        if tab ~= initial_tab and vim.api.nvim_tabpage_is_valid(tab) then
            -- Force close windows within the tab to prevent hang-ups
            pcall(function()
                vim.cmd(vim.api.nvim_tabpage_get_number(tab) .. "tabclose!")
            end)
        end
    end
    -- Clear out any dead tab tracking history references 
end

-- Persistence Engine: Restore pins safely for the current CWD
function M.load_pins()
	local cwd = vim.fn.getcwd()
	local r_file = io.open(data_path, "r")
	if not r_file then
		return
	end

	local content = r_file:read("*a")
	r_file:close()

	local data = {}
	local success = pcall(function()
		data = vim.json.decode(content) or {}
	end)
	if not success or not data[cwd] then
		return
	end

	local files_to_load = data[cwd]
	if #files_to_load == 0 then
		return
	end

	is_processing = true
	allowing_new_tab = true
    clear_tabs()
    pinned_tabs = {}

	-- Analyze the starting tab to see if it's empty or holding a file passed via CLI
	local first_tab = vim.api.nvim_get_current_tabpage()
	local first_buf = vim.api.nvim_get_current_buf()
	local first_is_empty = (vim.api.nvim_buf_get_name(first_buf) == "" and vim.bo[first_buf].buftype == "")

	for i, file_path in ipairs(files_to_load) do
		if vim.fn.filereadable(file_path) == 1 then
			if i == 1 and first_is_empty then
				-- Reuse the initial empty tab layout
				vim.cmd("edit " .. vim.fn.fnameescape(file_path))
				local buf = vim.api.nvim_get_current_buf()
				pinned_tabs[first_tab] = buf
				update_tab_title(first_tab, buf)
			else
				-- Open a brand new isolated tab slot
				vim.cmd("tabedit " .. vim.fn.fnameescape(file_path))
				local new_tab = vim.api.nvim_get_current_tabpage()
				local buf = vim.api.nvim_get_current_buf()
				pinned_tabs[new_tab] = buf
				update_tab_title(new_tab, buf)
			end
		end
	end

	allowing_new_tab = false
	is_processing = false
	vim.cmd("redrawtabline")
end
-- Function 1: Toggle the Pin status of the current tab
function M.toggle_pin()
	local current_tab = vim.api.nvim_get_current_tabpage()
	local current_buf = vim.api.nvim_get_current_buf()
	local current_name = get_buffer_name(current_buf)

	if pinned_tabs[current_tab] then
		-- Unpin it completely
		pinned_tabs[current_tab] = nil
		update_tab_title(current_tab, current_buf)
		vim.notify("Tab unpinned: " .. current_name, vim.log.levels.INFO)
	else
		-- FIX: Pin it and lock it strictly to this specific buffer ID number
		pinned_tabs[current_tab] = current_buf
		vim.api.nvim_tabpage_set_var(current_tab, "tab_title", current_name)
		vim.notify("Tab pinned: " .. current_name, vim.log.levels.INFO)
	end
	vim.cmd("redrawtabline")
    M.save_pins()
end

-- Function 2: Custom Rename Tab Engine
function M.rename_tab(opts)
	local current_tab = vim.api.nvim_get_current_tabpage()
	local current_buf = vim.api.nvim_get_current_buf()
	local new_name = opts.args

	if new_name == "" then
		vim.notify("Custom name cannot be empty", vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_tabpage_set_var(current_tab, "tab_title", new_name)
	-- FIX: Store the active buffer ID number instead of boolean true
	pinned_tabs[current_tab] = current_buf

	vim.cmd("redrawtabline")
	vim.notify("Tab renamed & pinned to: " .. new_name, vim.log.levels.INFO)
end

-- Function 3: Core orchestrator called whenever a file buffer is loaded
local function handle_file_open()
	if is_processing then
		return
	end

	local current_tab = vim.api.nvim_get_current_tabpage()
	local current_buf = vim.api.nvim_get_current_buf()

	-- Ignore special non-file windows (like Neo-tree, Telescope, toggleterm, etc.)
	local buftype = vim.bo[current_buf].buftype
if buftype ~= "" then
		return
	end

	local pinned_buf = pinned_tabs[current_tab]

	-- GUARDRAIL fallback: If old state has a boolean 'true', convert it to current buffer safely
	if pinned_buf == true then
		pinned_tabs[current_tab] = current_buf
		pinned_buf = current_buf
	end

	-- RULE ENFORCEMENT: If the active tab container IS pinned, process redirection
	if pinned_buf then
		if current_buf ~= pinned_buf then
			is_processing = true

			-- Look backwards through open tabs to find an existing unpinned workspace
			local unpinned_tab = nil
			local tabs = vim.api.nvim_list_tabpages()
			for i = #tabs, 1, -1 do
				if not pinned_tabs[tabs[i]] then
					unpinned_tab = tabs[i]
					break
				end
			end

			-- 1. Evict the new file from the pinned window slot immediately
			vim.api.nvim_win_set_buf(0, pinned_buf)

			if unpinned_tab then
				-- 2. REUSE OPTION: Swap the file inside the existing unpinned tab layout
				vim.api.nvim_set_current_tabpage(unpinned_tab)
				local win = vim.api.nvim_tabpage_get_win(unpinned_tab)
				vim.api.nvim_win_set_buf(win, current_buf)
				update_tab_title(unpinned_tab, current_buf)
			else
				-- 3. FALLBACK OPTION: No unpinned tab exists anywhere, create one
				allowing_new_tab = true
				vim.cmd("tabedit")
				allowing_new_tab = false

				local new_tab = vim.api.nvim_get_current_tabpage()
				vim.api.nvim_win_set_buf(0, current_buf)
				update_tab_title(new_tab, current_buf)
			end

			is_processing = false
		end
	else
		-- RULE ENFORCEMENT: If NOT pinned, clear static title to ensure dynamic updates
		update_tab_title(current_tab, current_buf)
	end

	vim.cmd("redrawtabline")
end

-- Tab Navigation Functions
function M.next_tab()
	vim.cmd("tabnext")
end
function M.prev_tab()
	vim.cmd("tabprevious")
end

-- Function 4: Custom Render Engine with devicons and 45-degree pin
function M.render_tabline()
	local s = ""
	local tabs = vim.api.nvim_list_tabpages()
	local current_tab = vim.api.nvim_get_current_tabpage()

	local has_devicons, devicons = pcall(require, "nvim-web-devicons")

	for i, tab in ipairs(tabs) do
		local is_active = (tab == current_tab)

		if is_active then
			s = s .. "%#TabLineSel#"
		else
			s = s .. "%#TabLine#"
		end

		s = s .. "%" .. i .. "T"

		local success, filename = pcall(vim.api.nvim_tabpage_get_var, tab, "tab_title")
		if not success or filename == "" then
			local win = vim.api.nvim_tabpage_get_win(tab)
			local buf = vim.api.nvim_win_get_buf(win)
			filename = get_buffer_name(buf)
		end

		local icon = ""
		local icon_hl = is_active and "TabLineSel" or "TabLine"

		if has_devicons and filename ~= "[No Name]" then
			local ext = vim.fn.fnamemodify(filename, ":e")
			local d_icon, d_hl = devicons.get_icon(filename, ext, { default = true })
			if d_icon then
				icon = d_icon
				icon_hl = is_active and d_hl or "TabLine"
			end
		end

		local pin_prefix = ""
		if pinned_tabs[tab] then
			pin_prefix = "󰐃 "
		end

		s = s .. " " .. pin_prefix .. "%#" .. icon_hl .. "#" .. icon .. "%*"
		s = s .. (is_active and "%#TabLineSel#" or "%#TabLine#") .. " " .. filename .. " "
	end

	s = s .. "%#TabLineFill#%T"
	return s
end

-- Function 5: Plugin Initialization Setup and Guardrail Enforcement
function M.setup(opts)
	opts = opts or {}

	vim.opt.showtabline = 2

	local group = vim.api.nvim_create_augroup("TabPinGroup", { clear = true })

	-- Autocommand A: Dynamic File Redirection Manager
	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		group = group,
		callback = function()
			vim.schedule(handle_file_open)
		end,
	})

	-- Autocommand B: Watcher to log context states right before switching tabs
	vim.api.nvim_create_autocmd({ "TabLeave" }, {
		group = group,
		callback = function()
			last_active_tab = vim.api.nvim_get_current_tabpage()
			last_active_was_pinned = not not pinned_tabs[last_active_tab]
		end,
	})

	-- Autocommand C: THE GUARDRAIL. Intercepts and blocks unauthorized manual tab expansion


    vim.api.nvim_create_autocmd({ "VimEnter" }, {
        group = group,
        callback = function()
            local buf = vim.api.nvim_get_current_buf()
            local buf_name = vim.api.nvim_buf_get_name(buf)
            local buf_type = vim.api.nvim_get_option_value("buftype", { buf = buf })

            -- Only run if the buffer has no name, isn't a special buffer (like a terminal/pipe), 
            -- and no file arguments were passed.
            if buf_name == "" and buf_type == "" and vim.fn.argc() == 0 then
                vim.schedule(M.load_pins)
            end
        end,
    })

	_G.TabPinsRender = M.render_tabline
	vim.opt.tabline = "%!v:lua.TabPinsRender()"
	vim.api.nvim_create_user_command("TabPinToggle", M.toggle_pin, {})
	vim.api.nvim_create_user_command("TabPinNext", M.next_tab, {})
	vim.api.nvim_create_user_command("TabPinPrev", M.prev_tab, {})
	vim.api.nvim_create_user_command("TabPinRename", M.rename_tab, { nargs = 1 })
	vim.api.nvim_create_user_command("TabPinSave", M.save_pins, {})
	vim.api.nvim_create_user_command("TabPinLoad", M.load_pins, {})

	local prefix =  opts.prefix or "t"

    local remap = opts.remap or true 
	if remap then
		vim.keymap.set("n", prefix .. "p", "<cmd>TabPinToggle<CR>", { desc = "TabPin: Toggle Pin" })
		vim.keymap.set("n", prefix .. "l", "<cmd>TabPinNext<CR>", { desc = "TabPin: Next Tab" })
		vim.keymap.set("n", prefix .. "h", "<cmd>TabPinPrev<CR>", { desc = "TabPin: Prev Tab" })
		vim.keymap.set("n", prefix .. "r", "<cmd>TabPinRename ", { desc = "TabPin: Rename Tab" }) -- Left open for typing
		vim.keymap.set("n", prefix .. "s", "<cmd>TabPinSave<CR>", { desc = "TabPin: Save Pins" })
		vim.keymap.set("n", prefix .. "o", "<cmd>TabPinLoad<CR>", { desc = "TabPin: Load Pins" })
	end
end

	-- Concatenating the prefix dynamically to your keys

return M
