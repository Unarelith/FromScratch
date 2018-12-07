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

local update_entity = function(pos, idx, entity, texture)
	entity = entity or fs_core.get_subentity(pos, entity_name, texture)
	if entity then
		pos.y = pos.y - 6 / 16 + 12 / 16 * idx / (N - 1) / 2
		entity:set_pos(pos)

		entity:set_properties({
			textures = {texture or "default:dirt"},

			visual_size = {
				x = 0.666 * 10 / 16,
				y = 0.666 * 12 / 16 * idx / (N - 1)
			},

			is_visible = idx > 0
		})
	end

	return entity
end

-- FIXME: Use a table instead of hardcoded items
fs_barrel.is_compostable = function(itemname)
	local is_sapling = minetest.get_item_group(itemname, "sapling") > 0
	local is_leaves = minetest.get_item_group(itemname, "leaves") > 0
	return is_sapling or is_leaves
end

local handle_bucket = function(pos, buffer, itemstack)
	local itemname = itemstack:get_name()

	if itemname == "bucket:bucket_empty" and buffer.amount >= 1000 then
		local bucket = bucket.liquids[buffer.fluid]
		if bucket and fluid_lib.can_take_from_buffer(pos, "buffer", 1000) == 1000 then
			fluid_lib.take_from_buffer(pos, "buffer", 1000)
			itemstack = ItemStack(bucket.itemname)
			update_entity(pos, (buffer.amount - 1000) / buffer.capacity * (N - 2), nil, fluid)
		end
	elseif itemname:find("bucket:bucket_.+") then
		local fluid = bucket.get_liquid_for_bucket(itemname)
		if fluid and fluid_lib.can_insert_into_buffer(pos, "buffer", fluid, 1000) == 1000 then
			fluid_lib.insert_into_buffer(pos, "buffer", fluid, 1000)
			itemstack = ItemStack("bucket:bucket_empty")
			update_entity(pos, (buffer.amount + 1000) / buffer.capacity * (N - 2), nil, fluid)
			:set_pos({x=pos.x, y=pos.y + 6/16, z=pos.z}) -- FIXME: Why is this necessary?
		end
	end

	return itemstack
end

local on_rightclick = function(pos, node, player, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local idx = meta:get_int("idx")
	local progress = meta:get_int("progress")
	local buffer = fluid_lib.get_buffer_data(pos, "buffer")

	if buffer.amount == 0 then
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

		update_entity(pos, idx)
	end

	if idx == 0 then
		itemstack = handle_bucket(pos, buffer, itemstack)
	end

	return itemstack
end

fs_barrel.register_barrel = function(name, info)
	minetest.register_node(name, {
		description = info.name,
		drawtype = "nodebox",

		tiles = {
			-- up, down, right, left, back, front
			info.texture,
			info.texture,
			info.texture,
			info.texture,
			info.texture,
			info.texture,
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

			meta:set_string("infotext", info.name)

			meta:set_string("buffer_fluid", "")
			meta:set_int("buffer_fluid_storage", 0)

			local entity = minetest.add_entity(pos, entity_name)
			update_entity(pos, 0, entity)
		end,

		on_destruct = function(pos)
			fs_core.remove_subentity(pos, entity_name)
		end,

		on_timer = function(pos, elapsed)
			local meta = minetest.get_meta(pos)
			local progress = meta:get_int("progress") + 10
			meta:set_int("progress", progress)

			if progress < 100 then
				meta:set_string("infotext", info.name.." (Composting... "..progress.."%)")
			else
				meta:set_string("infotext", info.name)
			end

			return progress < 100
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

		fluid_buffers = {
			buffer = {
				capacity = 1000,
				accepts = info.accepted_fluids,
				drainable = true,
			},
		}
	})
end

fs_core.register_subentity(entity_name, 10/16, 12/16, "default:dirt")

-- TODO: Update API documentation
fs_barrel.register_barrel("fs_barrel:barrel_wood", {
	name = "Wooden Barrel",
	texture = "default_wood.png",
	accepted_fluids = {"default:water_source"},
})

fs_barrel.register_barrel("fs_barrel:barrel_stone", {
	name = "Stone Barrel",
	texture = "default_stone.png",
	accepted_fluids = {"default:water_source", "default:lava_source"},
})

