fs_core.silkworm = {}

fs_core.silkworm.on_place = function(itemstack, player, pointed_thing)
	local node = minetest.get_node(pointed_thing.under)
	if minetest.get_item_group(node.name, "leaves") > 0 then
		minetest.remove_node(pointed_thing.under)
	end

	itemstack:take_item()
	return itemstack
end

