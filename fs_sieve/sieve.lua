--[[

	fs_sieve
	================

	Derived from gravelsieve v1.08 by JoSt

	Copyright (C) 2018-2019 Quentin Bazin
	Copyright (C) 2017-2018 Joachim Stolberg
	Copyright (C) 2011-2016 celeron55, Perttu Ahola <celeron55@gmail.com>
	Copyright (C) 2011-2016 Various Minetest developers and contributors

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local animate_sieve = function(pos, meta, start)
	local node = minetest.get_node(pos)
	local idx = meta:get_int("idx")
	if start then
		if idx == 3 then
			idx = 0
		end
	else
		idx = (idx + 1) % 4
	end
	meta:set_int("idx", idx)
	node.name = meta:get_string("node_name")..idx
	minetest.swap_node(pos, node)
	return idx == 3
end

local add_random_ores = function(inv)
	local num
	for ore, probability in pairs(fs_sieve.ore_probability) do
		if math.random(probability) == 1 then
			local item = ItemStack(ore)
			if inv:room_for_item("dst", item) then
				inv:add_item("dst", item)
			end
		end
	end
end

local update_sieve = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local gravel = ItemStack("default:gravel")

	if inv:contains_item("src", gravel) then
		local is_done = animate_sieve(pos, meta, false)
		if is_done then
			add_random_ores(inv)
			inv:remove_item("src", gravel)
		end
	end
end

for idx = 0, 4 do
	-- FIXME: Use nodebox to draw sieve mesh
	local nodebox_data = {
		{-8/16, -8/16, -8/16,  8/16, 4/16, -6/16},
		{-8/16, -8/16,  6/16,  8/16, 4/16,  8/16},
		{-8/16, -8/16, -8/16, -6/16, 4/16,  8/16},
		{ 6/16, -8/16, -8/16,  8/16, 4/16,  8/16},
		{-6/16, -2/16, -6/16,  6/16, 8/16,  6/16},
	}
	nodebox_data[5][5] = (8 - 2 * idx) / 16

	local node_name = "fs_sieve:sieve"
	local description = "Gravel Sieve"
	local tiles_data = {
		-- up, down, right, left, back, front
		"fs_sieve_gravel.png",
		"fs_sieve_gravel.png",
		"fs_sieve_sieve.png",
		"fs_sieve_sieve.png",
		"fs_sieve_sieve.png",
		"fs_sieve_sieve.png",
	}

	if idx == 3 then
		tiles_data[1] = "fs_sieve_top.png"
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
			fixed = { -8/16, -8/16, -8/16,   8/16, 4/16, 8/16 },
		},

		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_int("idx", idx)        -- for the 4 sieve phases
			meta:set_string("node_name", node_name)

			local inv = meta:get_inventory()
			inv:set_size('src', 1)
			inv:set_size('dst', 16)
		end,

		after_place_node = function(pos, placer)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", "Gravel Sieve")
		end,

		on_punch = function(pos, node, puncher, pointed_thing)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			if inv:is_empty("dst") and inv:is_empty("src") then
				minetest.node_punch(pos, node, puncher, pointed_thing)
			end
		end,

		on_dig = function(pos, node, puncher, pointed_thing)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			if inv:is_empty("dst") and inv:is_empty("src") then
				minetest.node_dig(pos, node, puncher, pointed_thing)
			end
		end,

		on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local idx = meta:get_int("idx")
			if inv:is_empty("src") and itemstack:get_name() == "default:gravel" then
				inv:set_stack("src", 1, itemstack:take_item())
			end

			if not inv:is_empty("src") then
				update_sieve(pos)
			end

			if idx == 2 and not inv:is_empty("dst") then
				local list = inv:get_list("dst")
				for _, stack in ipairs(list) do
					fs_core.drop_item_stack(pos, stack)
				end
				inv:set_list("dst", {})
			end
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
		drop = node_name.."3",
	})
end

minetest.register_alias("fs_sieve:sieve", "fs_sieve:sieve3")

