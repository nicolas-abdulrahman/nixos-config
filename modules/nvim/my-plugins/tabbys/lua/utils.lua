local function pretty_print(table, indent, buffer, iter)
	indent = indent or "" -- Default indentation
	buffer = buffer or ""
	iter = iter or 0

	for key, value in pairs(table) do
		if type(value) == "table" then
			print(indent .. tostring(key) .. ":")
			buffer = buffer .. indent .. tostring(key) .. ":"
			pretty_print(value, indent .. "  ", buffer, iter + 1) -- Recursively print nested tables
		else
			-- print(indent .. tostring(key) .. ": " .. tostring(value))
			buffer = buffer .. indent .. tostring(key) .. ":" .. tostring(value) .. "\n"
		end
	end
	if iter == 0 then
		vim.notify(buffer)
	end
end

-- Example usage
local my_table = {
	name = "Alice",
	age = 30,
	hobbies = { "reading", "coding", "gaming" },
	address = {
		city = "Wonderland",
		zip = "12345",
	},
}
-- pretty_print(my_table)

return { pretty_print = pretty_print }
