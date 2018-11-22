local animate_barrel = function(pos, meta, idx)
	idx = (idx + 1) % 13
	meta:set_int("idx", idx)

	local node = minetest.get_node(pos)
	node.name = meta:get_string("node_name")..idx

	minetest.swap_node(pos, node)

	return idx
end

local update_barrel = function(pos, player, itemstack)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local idx = meta:get_int("idx")

	if idx < 12 and minetest.get_item_group(itemstack:get_name(), "sapling") > 0 then
		idx = animate_barrel(pos, meta, idx)
		itemstack:take_item()
	elseif idx == 12 then
		idx = animate_barrel(pos, meta, idx)
		-- drop_item_stack(pos, "default:dirt")

		if player:get_inventory():room_for_item("main", "default:dirt") then
			player:get_inventory():add_item("main", "default:dirt")
		end
	end

	return itemstack
end

for idx = 0, 13 do
	local nodebox_data = {
		{-6/16, -8/16, -6/16,  6/16,  6/16, -5/16},
		{-6/16, -8/16,  5/16,  6/16,  6/16,  6/16},
		{-6/16, -8/16, -6/16, -5/16,  6/16,  6/16},
		{ 5/16, -8/16, -6/16,  6/16,  6/16,  6/16},
		{-5/16, -8/16, -5/16,  5/16, -6/16,  5/16},
	}
	nodebox_data[5][5] = (-6 + idx) / 16

	local node_name = "fs_barrel:barrel_wood"
	local description = "Wooden Barrel "..idx
	local tiles_data = {
		-- up, down, right, left, back, front
		"fs_barrel_dirt.png",
		"fs_barrel_barrel.png",
		"fs_barrel_barrel.png",
		"fs_barrel_barrel.png",
		"fs_barrel_barrel.png",
		"fs_barrel_barrel.png",
	}

	if idx == 0 then
		tiles_data[1] = "fs_barrel_barrel.png"
		not_in_creative_inventory = 0
	else
		not_in_creative_inventory = 1
	end

	minetest.register_node(node_name..idx, {
		description = description,
		tiles = tiles_data,
		drawtype = "nodebox",
        drop = node_name,

		node_box = {
			type = "fixed",
			fixed = nodebox_data,
		},

		selection_box = {
			type = "fixed",
			fixed = {-6/16, -8/16, -6/16,
			          6/16,  6/16,  6/16},
		},

		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_int("idx", idx)
			meta:set_string("node_name", node_name)

			local inv = meta:get_inventory()
			inv:set_size('dst', 1)
		end,

		after_place_node = function(pos, placer)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", "Wooden Barrel")
		end,

		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			return update_barrel(pos, player, itemstack)
		end,

		paramtype = "light",
		sounds = default.node_sound_wood_defaults(),
		paramtype2 = "facedir",
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {
			choppy = 2,
			cracky = 1,
			not_in_creative_inventory = not_in_creative_inventory
		},
		drop = node_name.."0",
	})
end

minetest.register_alias("fs_barrel:barrel", "fs_barrel:barrel0")

