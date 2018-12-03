--[[

	fs_core
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

fs_core.silkworm = {}

fs_core.silkworm.on_place = function(itemstack, player, pointed_thing)
	local node = minetest.get_node(pointed_thing.under)
	if minetest.get_item_group(node.name, "leaves") == 1 then
		local node_name = fs_core.leaves[node.name]
		node.name = node_name .. "0"
		minetest.swap_node(pointed_thing.under, node)

		local meta = minetest.get_meta(pointed_thing.under)
		meta:set_int("idx", 0)
		meta:set_string("node_name", node_name)

		minetest.get_node_timer(pointed_thing.under):start(2)

		itemstack:take_item()
		return itemstack
	end
end

