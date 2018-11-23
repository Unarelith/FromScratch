fs_core.silkworm = {}

fs_core.silkworm.on_place = function(itemstack, player, pointed_thing)
	local node = minetest.get_node(pointed_thing.under)
	if minetest.get_item_group(node.name, "leaves") == 1 then
		node.name = ("fs_core:infested_leaves0")
		minetest.swap_node(pointed_thing.under, node)

		local meta = minetest.get_meta(pointed_thing.under)
		meta:set_int("idx", 0)
		meta:set_string("node_name", "fs_core:infested_leaves")

		minetest.get_node_timer(pointed_thing.under):start(2)

		itemstack:take_item()
		return itemstack
	end
end

