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
			obj:setvelocity({x = math.random(-3, 3),
			                 y = math.random(2, 5),
			                 z = math.random(-3, 3)})
		end
	end
end

