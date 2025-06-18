local workspace_list = {}

local workspace = {}
local M = {}
-- package.path = package.path .. ";/etc/nixos/users/sunshine/modules/nvim/myplugins/tabbys/lua/utils.lua"

-- local utils = require("utils")
-- local pickers = require("telescope.pickers")
-- local finders = require("telescope.finders")
-- local conf = require("telescope.config").values
-- local actions = require("telescope.actions")
-- local action_state = require("telescope.actions.state")

function workspace.new(opts)
	local opts = opts or {}
	local t = {
		path = opts.path or "yourpath/here",
		buffers = "",
		build = function()
			print("builded")
		end,
	}
	return t
end

function add_workspace(opts)
	local opts = opts or {}
	local new = workspace.new(opts)
	table.insert(workspace_list, new)
end

local function show_workspaces(opts)
	opts = opts or {}
	pickers
		.new({}, {
			prompt_title = "workspaces",
			finder = finders.new_table({
				results = workspace_list,
				entry_maker = function(entry)
					return {
						value = entry,
						display = entry.path,
						ordinal = entry.path,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					-- vim.notify(inspect(selection))
					vim.api.nvim_put({ selection[1] }, "", false, true)
				end)
				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<leader>w", function()
	add_workspace({ path = vim.fn.getcwd() })
end, {})
vim.keymap.set("n", "<leader>we", function()
	show_workspaces(opts)
end, {})

local defaults = {
	enable_feature = false,
	color = "blue",
	keymaps = {
		enable = true,
		leader = "<leader>",
		cmd = "t",
		-- use_leader = true,
		show = "s",
		tabnew = "n",
		tabprev = "h",
		tabnext = "l",
		tabgo = "",
	},
}

function _G.tabbyTabLine()
	local tabs = vim.api.nvim_list_tabpages()
	local current = vim.api.nvim_get_current_tabpage()
	local line = ""
	-- vim.pretty_print(tabs)

	for i, tab in ipairs(tabs) do
		local win = vim.api.nvim_tabpage_get_win(tab)
		local buf = vim.api.nvim_win_get_buf(win)
		local name = vim.api.nvim_buf_get_name(buf)
		local cwd = vim.fn.getcwd()
		local focus = (tab == current)
		name = M.to_display(name, buf, focus)
		if not name then
			goto continue
		end
		line = line .. "%" .. i .. "@v:lua.tabbyTabClick@" .. name .. " %X"
		if i < #tabs then
			line = line .. "%#TabLine#|"
		end
		::continue::
	end

	return line .. "%#TabLineFill#"
end

function _G.tabbyTabClick(n)
	vim.cmd("tabnext " .. n)
end
function M.setup(user_opts)
	local opts = vim.tbl_deep_extend("force", defaults, user_opts or {})
	print("tabbys.lua")
	vim.notify = require("notify")
	M.options = opts
	M.setup_tab()
	if opts.keymaps.enable then
		k = opts.keymaps
		p = k.leader .. k.cmd
		-- vim.keymap.set("n", p .. opts.keymaps.show, _G.show_tab, {
		-- desc = "Tabby: Toggle feature",
		-- })
		vim.keymap.set("n", p .. k.tabnew, M.new_tab, {
			desc = "Tabby: new",
		})
		vim.keymap.set("n", p .. k.tabprev, M.tab_prev, {
			desc = "Tabby: Toggle feature",
		})
		vim.keymap.set("n", p .. k.tabnext, M.tab_next, {
			desc = "Tabby: Toggle feature",
		})
		vim.keymap.set("n", p .. k.tabnext, M.tab_next, {
			desc = "Tabby: Toggle feature",
		})
		vim.keymap.set("n", "ti", ":TabListen<CR>", {
			desc = "Tabby: Toggle feature",
		})
		for i = 0, 9 do
			vim.keymap.set("n", p .. k.tabgo .. i, function()
				print("going to " .. i)
				vim.cmd("tabnext " .. i)
			end, {
				desc = "Tabby: Toggle feature",
			})
		end
	end
end

function M.setup_tab()
	vim.o.showtabline = 2 -- Always show tabline (0=never, 1=only if >1 tab, 2=always)
	vim.o.tabline = "%!v:lua.tabbyTabLine()"
end

function M.new_tab()
	print("new")
	vim.cmd("tabnew")
end
function M.tab_next()
	vim.cmd("tabnext")
	vim.cmd("TabListen")
end

function M.tab_prev()
	vim.cmd("tabprevious")
	vim.cmd("TabListen")
end

function _G.show_tab()
	for i, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local win = vim.api.nvim_tabpage_get_win(tab)
		local buf = vim.api.nvim_win_get_buf(win)
		local name = vim.api.nvim_buf_get_name(buf)
		-- if name ~= "" then
		-- 	vim.notify(win .. name)
		-- end

		if not name then
			return
		end
		vim.notify("oii" .. win .. name)
		name = M.to_display(name)
		-- local bool = (name == "")

		-- vim.notify({ bool })

		local icon, hl_group = devicons.get_icon(name)

		-- vim.notify(string.format("Tab %d: win=%d, buf=%d, name=%s", i, win, buf, name))
	end
end

vim.api.nvim_set_hl(0, "MyTerminalIcon", {
	fg = "#50fa7b", -- example green
	bold = true,
})
function M.to_display(name, buf, focus)
	local devicons = require("nvim-web-devicons")
	local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
	if buftype == "terminal" then
		local hl = focus and "MyTerminalIcon" or "DevIconSh"
		return "%#" .. hl .. "# " .. "%*"
	end
	local uv = vim.loop
	local stat = uv.fs_stat(name)
	if not buftype or not stat then
		return " "
	end

	if string.find(name, "/") and string.find(name, "%.") and name ~= "" then
		local filename = vim.fn.fnamemodify(name, ":t")
		local icon, hl_group = devicons.get_icon(filename)
		local ext = vim.fn.fnamemodify(filepath, ":e")
		local extension = vim.fn.fnamemodify(name, ":e") -- "lua"
		local filename_no_ext = filename:sub(1, #filename - #extension - 1) -- remove dot + ext

		local hl = focus and "%#TabLineSel#" or "%#TabLine#"
		local hl2 = focus and hl_group or "TabLine"

		local start = "%#" .. hl_group .. "#" .. icon .. " " .. hl
		return start .. filename_no_ext .. "%#" .. hl2 .. "#." .. extension .. "%*"

		-- return vim.fs.basename(name)
	end
	return " error"
	-- return nil
end

-- vim.keymap.set("n", "<leader>ts", function()
-- M.show_tab()
-- end, {})

local ns_id = vim.api.nvim_create_namespace("tabby-key-listen")

local extend = false
local time = 1000
function defer()
	if extend then
		vim.defer_fn(defer, time)
		extend = false
		return
	end
	if listener_id then
		vim.on_key(nil, ns_id)
	end
end

-- Define the command to start listening
vim.api.nvim_create_user_command("TabListen", function()
	listener_id = vim.on_key(function(key)
		local key = vim.fn.keytrans(key)
		if key == "l" then
			vim.cmd("tabnext")
			extend = true
		elseif key == "h" then
			vim.cmd("tabprevious")
			extend = true
		else
			vim.on_key(nil, ns_id)
		end
		-- print("You pressed:", vim.fn.keytrans(key))
	end, ns_id)

	-- Stop listening after 1 second (1000 ms)
	vim.defer_fn(defer, 1000)
end, {})
-- M.setup({ keymaps = { leader = "" } })
return M
