--[[

	fs_sieve
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local N = 5
local entity_name = "fs_sieve:sieve_entity"

local animate_sieve = function(pos, meta, idx)
	idx = (idx + 1) % N
	meta:set_int("idx", idx)
	return idx
end

local add_random_ore_pieces = function(inv)
	local num
	for ore, probability in pairs(fs_sieve.ore_probability) do
		probability = probability / 4.0

		local ore_piece = fs_sieve.ore_pieces[ore]
		if ore_piece then
			probability = probability / 4.0
			ore = ore_piece
		end

		if math.random(probability) == 1 then
			local item = ItemStack(ore)
			if inv:room_for_item("dst", item) then
				inv:add_item("dst", item)
			end
		end
	end
end

local add_random_dirt_drops = function(inv)
	local item = ItemStack("fs_core:stone_pebble "..math.random(3, 5))
	if inv:room_for_item("dst", item) then
		inv:add_item("dst", item)
	end
end

local update_sieve = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local idx = meta:get_int("idx")
	local content = meta:get_string("content")
	local item = ItemStack(content)

	if inv:contains_item("src", item) then
		if idx == 0 then
			if content ~= "default:dirt" then
				add_random_ore_pieces(inv)
			else
				add_random_dirt_drops(inv)
			end

			inv:remove_item("src", item)
		end

		idx = animate_sieve(pos, meta, idx)
	end
end

local update_entity = function(pos, idx, item, entity)
	entity = entity or fs_core.get_subentity(pos, entity_name)
	if entity then
		local texture, height
		texture = item
		height = 8 / 16 - 7 / 16 * idx / (N - 1)

		pos.y = pos.y + 3 / 16 + height / 2
		entity:set_pos(pos)

		entity:set_properties({
			textures = {texture},

			visual_size = {
				x = 0.666 * 14 / 16,
				y = 0.666 * height
			},

			is_visible = idx > 0,
		})
	end
end

local is_valid_input = function(itemstack)
	return itemstack:get_name() == "default:gravel"
	    or itemstack:get_name() == "default:sand"
	    or itemstack:get_name() == "fs_core:dust"
	    or itemstack:get_name() == "default:dirt"
end

local on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local idx = meta:get_int("idx")
	if inv:is_empty("src") and is_valid_input(itemstack) then
		meta:set_string("content", itemstack:get_name())
		inv:set_stack("src", 1, itemstack:take_item())
	end

	if not inv:is_empty("src") then
		update_sieve(pos)
		update_entity(pos, idx, meta:get_string("content"))
	end

	if idx == 0 and not inv:is_empty("dst") then
		local list = inv:get_list("dst")
		for _, stack in ipairs(list) do
			fs_core.drop_item_stack(pos, stack)
		end
		inv:set_list("dst", {})
	end
end

fs_core.register_subentity(entity_name, 14/16, 7/16, "default:gravel")

minetest.register_node("fs_sieve:sieve", {
	description = "Wooden Sieve",
	drawtype = "nodebox",

	tiles = {
		-- up, down, right, left, back, front
		"fs_sieve_top.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
	},

	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, 0.1, -0.5, -0.4375, 0.5, 0.5},
			{0.4375, 0.1, -0.5, 0.5, 0.5, 0.5},
			{-0.5, 0.1, -0.5, 0.5, 0.5, -0.4375},
			{-0.5, 0.1, 0.4375, 0.5, 0.5, 0.5},
			{-0.4375, -0.5, 0.375, -0.375, 0.1, 0.4375},
			{0.375, -0.5, 0.375, 0.4375, 0.1, 0.4375},
			{-0.4375, -0.5, -0.4375, -0.375, 0.1, -0.375},
			{0.375, -0.5, -0.4375, 0.4375, 0.1, -0.375},
			{-0.4375, 0.2, -0.4375, 0.4375, 0.1, 0.4375},
		}
	},

	collision_box = {
		type = "fixed",
		fixed = {-8/16, -8/16, -8/16,   8/16, 8/16, 8/16},
	},

	selection_box = {
		type = "fixed",
		fixed = {-8/16, -8/16, -8/16,   8/16, 8/16, 8/16},
	},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("idx", 0)
		meta:set_string("content", "")

		local inv = meta:get_inventory()
		inv:set_size('src', 1)
		inv:set_size('dst', 16)

		local entity = minetest.add_entity(pos, entity_name)
		update_entity(pos, 0, "", entity)
	end,

	on_destruct = function(pos)
		fs_core.remove_subentity(pos, entity_name)
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Wooden Sieve")
	end,

	on_rightclick = on_rightclick,

	paramtype = "light",
	sounds = default.node_sound_wood_defaults(),
	paramtype2 = "facedir",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {
		choppy = 2,
		cracky = 1,
	},
})

