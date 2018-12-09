fs_core.drop_item_stack = function(pos, stack)
	local count, name
	if type(stack) == "string" then
		count = 1
		name = stack
	else
		count = stack:get_count()
		name = stack:get_name()
	end
	for i = 1, count do
		local obj = minetest.add_item(pos, name)
		if obj ~= nil then
			obj:get_luaentity().collect = true
			obj:get_luaentity().age = age
			obj:setvelocity({x = math.random(-2, 2),
			                 y = math.random(2, 5),
			                 z = math.random(-2, 2)})
		end
	end
end

fs_core.give_item_to_player = function(player, handstack, itemstack)
	itemstack = handstack:add_item(itemstack)

	if not itemstack:is_empty() and player:get_inventory():room_for_item("main", itemstack) then
		local remainder = player:get_inventory():add_item("main", itemstack)
		if not remainder:is_empty() then
			fs_core.drop_item(remainder)
		end
	end

	return handstack
end

