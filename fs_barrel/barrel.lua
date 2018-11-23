local N = 13

local animate_barrel = function(pos, meta, idx)
	idx = (idx + 1) % N
	meta:set_int("idx", idx)

	local node = minetest.get_node(pos)
	node.name = meta:get_string("node_name")..idx

	minetest.swap_node(pos, node)

	return idx
end

local update_barrel = function(pos, player, itemstack)
	local meta = minetest.get_meta(pos)
	local idx = meta:get_int("idx")
	local progress = meta:get_int("progress")

	if idx < N - 1 and minetest.get_item_group(itemstack:get_name(), "sapling") > 0 then
		idx = animate_barrel(pos, meta, idx)
		itemstack:take_item()

		if idx == N - 1 then
			minetest.get_node_timer(pos):start(1)
		end
	elseif idx == N - 1 and progress == 100 then
		idx = animate_barrel(pos, meta, idx)

		local handstack = not itemstack:is_empty() and itemstack:add_item("default:dirt")
		if not handstack:is_empty() and player:get_inventory():room_for_item("main", "default:dirt") then
			player:get_inventory():add_item("main", handstack)
		end

		meta:set_int("progress", 0)
	end

	return itemstack
end

for idx = 0, N do
	local nodebox_data = {
		{-6/16, -8/16, -6/16,  6/16,  6/16, -5/16},
		{-6/16, -8/16,  5/16,  6/16,  6/16,  6/16},
		{-6/16, -8/16, -6/16, -5/16,  6/16,  6/16},
		{ 5/16, -8/16, -6/16,  6/16,  6/16,  6/16},
		{-5/16, -8/16, -5/16,  5/16, -6/16,  5/16},
	}
	nodebox_data[5][5] = (-6 + idx) / 16

	local node_name = "fs_barrel:barrel_wood"
	local description = "Wooden Barrel"
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
			meta:set_int("progress", 0)
			meta:set_string("node_name", node_name)
		end,

		on_timer = function(pos, elapsed)
			local meta = minetest.get_meta(pos)
			local progress = meta:get_int("progress") + 10
			meta:set_int("progress", progress)

			if progress < 100 then
				minetest.override_item(node_name..idx, {
					description = description .. " (" .. progress .. "%)"
				})
			else
				minetest.override_item(node_name..idx, {
					description = description
				})
			end

			return progress < 100
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

minetest.register_alias("fs_barrel:barrel_wood", "fs_barrel:barrel_wood0")

