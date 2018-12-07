--[[

	fs_barrel
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local N = 9
local entity_name = "fs_barrel:barrel_entity"

local animate_barrel = function(meta, idx)
	idx = (idx + 1) % N
	meta:set_int("idx", idx)
	return idx
end

fs_barrel.update_entity = function(pos, idx, entity)
	entity = entity or fs_core.get_subentity(pos, entity_name)
	if entity then
		pos.y = pos.y - 6 / 16 + 12 / 16 * idx / (N - 1) / 2
		entity:set_pos(pos)

		entity:set_properties({
			textures = {"default:dirt"},

			visual_size = {
				x = 0.666 * 10 / 16,
				y = 0.666 * 12 / 16 * idx / (N - 1)
			},

			is_visible = idx > 0
		})
	end
end

-- TODO: Use a table instead of hardcoded items
fs_barrel.is_compostable = function(itemname)
	local is_sapling = minetest.get_item_group(itemname, "sapling") > 0
	local is_leaves = minetest.get_item_group(itemname, "leaves") > 0
	return is_sapling or is_leaves
end

local on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local idx = meta:get_int("idx")
	local progress = meta:get_int("progress")

	if idx < N - 1 and fs_barrel.is_compostable(itemstack:get_name()) then
		idx = animate_barrel(meta, idx)
		itemstack:take_item()

		if idx == N - 1 then
			minetest.get_node_timer(pos):start(1)
		end
	elseif idx == N - 1 and progress == 100 then
		idx = animate_barrel(meta, idx)

		local dirt = ItemStack("default:dirt")
		if fs_core.give_item_to_player(player, itemstack, dirt) then
			meta:set_int("progress", 0)
		end
	end

	fs_barrel.update_entity(pos, idx)

	return itemstack
end

fs_barrel.register_barrel = function(node_name, description, texture)
	minetest.register_node(node_name, {
		description = description,
		drawtype = "nodebox",

		tiles = {
			-- up, down, right, left, back, front
			texture,
			texture,
			texture,
			texture,
			texture,
			texture,
		},

		node_box = {
			type = "fixed",
			fixed = {
				{-6/16, -8/16, -6/16,  6/16,  6/16, -5/16},
				{-6/16, -8/16,  5/16,  6/16,  6/16,  6/16},
				{-6/16, -8/16, -6/16, -5/16,  6/16,  6/16},
				{ 5/16, -8/16, -6/16,  6/16,  6/16,  6/16},
				{-5/16, -8/16, -5/16,  5/16, -6/16,  5/16},
			}
		},

		selection_box = {
			type = "fixed",
			fixed = {-6/16, -8/16, -6/16,
					  6/16,  6/16,  6/16},
		},

		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_int("idx", 0)
			meta:set_int("progress", 0)

			local entity = minetest.add_entity(pos, entity_name)
			fs_barrel.update_entity(pos, 0, entity)
		end,

		on_destruct = function(pos)
			fs_core.remove_subentity(pos, entity_name)
		end,

		on_timer = function(pos, elapsed)
			local meta = minetest.get_meta(pos)
			local progress = meta:get_int("progress") + 10
			meta:set_int("progress", progress)

			return progress < 100
		end,

		after_place_node = function(pos, placer)
			local meta = minetest.get_meta(pos)
			meta:set_string("infotext", "Wooden Barrel!!!")
		end,

		on_rightclick = on_rightclick,

		paramtype = "light",
		sounds = default.node_sound_wood_defaults(),
		paramtype2 = "facedir",
		sunlight_propagates = true,
		is_ground_content = false,
		groups = {
			choppy = 2,
			cracky = 1
		},
	})
end

fs_core.register_subentity(entity_name, 10/16, 12/16, "default:dirt")

fs_barrel.register_barrel("fs_barrel:barrel_wood", "Wooden Barrel", "default_wood.png")
fs_barrel.register_barrel("fs_barrel:barrel_stone", "Stone Barrel", "default_stone.png")

