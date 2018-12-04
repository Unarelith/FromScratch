--[[

	fs_crucible
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

-- FIXME: Move this to core
local get_entity = function(pos)
	local objects = minetest.get_objects_inside_radius(pos, 0.5)
	for _, obj in ipairs(objects) do
		local e = obj:get_luaentity()
		if e and e.name == "fs_crucible:crucible_entity" then
			return obj
		end
	end
end

local update_entity = function(pos, stone_amount, lava_amount, entity)
	entity = entity or get_entity(pos)
	if entity then
		local texture, height
		if stone_amount > 0 then
			texture = "default:cobble"
			height = 14 / 16
		else
			texture = "default:lava_source"
			height = 14 / 16 * lava_amount / 2000
		end

		pos.y = pos.y - 6 / 16 + height / 2
		entity:set_pos(pos)

		entity:set_properties({
			textures = {texture},

			visual_size = {
				x = 0.666 * 14 / 16,
				y = 0.666 * height
			},

			is_visible = stone_amount > 0 or lava_amount > 0
		})
	end
end

local on_timer = function(pos, elapsed)
	local heat_source = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
	if heat_source.name ~= "default:torch" then
		return true
	end

	local meta = minetest.get_meta(pos)
	local stone_amount = meta:get_int("stone")
	local lava_amount = meta:get_int("lava")
	if stone_amount == 0 or lava_amount >= 2000 then
		return false
	end

	meta:set_int("stone", stone_amount - 1)
	meta:set_int("lava", lava_amount + 100)
	update_entity(pos, stone_amount - 1, lava_amount + 100)

	return lava_amount < 2000 and stone_amount > 0
end

minetest.register_entity("fs_crucible:crucible_entity", {
	initial_properties = {
		visual = "wielditem",
		visual_size = {
			x = 0.666 * 14/16,
			y = 0.666 * 14/16
		},

		textures = {"default:cobble"},

		collide_with_objects = false,

		pointable = false,
	}
})

minetest.register_node("fs_crucible:crucible", {
	description = "Crucible",
	drawtype = "nodebox",

	tiles = {
		-- up, down, right, left, back, front
		"fs_crucible_top.png",
		"fs_crucible_top.png",
		"fs_crucible_side.png",
		"fs_crucible_side.png",
		"fs_crucible_side.png",
		"fs_crucible_side.png"
	},

	node_box = {
		type = "fixed",
		fixed = {
			{-8/16, -8/16, -8/16,  8/16,  8/16, -7/16},
			{-8/16, -8/16,  7/16,  8/16,  8/16,  8/16},
			{-8/16, -8/16, -8/16, -7/16,  8/16,  8/16},
			{ 7/16, -8/16, -8/16,  8/16,  8/16,  8/16},
			{-7/16, -7/16, -7/16,  7/16, -6/16,  7/16},
		}
	},

	selection_box = {
		type = "fixed",
		fixed = {-8/16, -8/16, -8/16, 8/16, 8/16, 8/16},
	},

	on_timer = on_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("stone", 0)
		meta:set_int("lava", 0)

		local entity = minetest.add_entity(pos, "fs_crucible:crucible_entity")
		update_entity(pos, 0, 0, entity)
	end,

	on_destruct = function(pos)
		local e = get_entity(pos)
		if e then
			e:remove()
		end
	end,

	on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local meta = minetest.get_meta(pos)
		local stone_amount = meta:get_int("stone")
		local lava_amount = meta:get_int("lava")

		if lava_amount > 1000 and itemstack:get_name() == "bucket:bucket_empty" then
			itemstack:take_item()
			clicker:get_inventory():add_item("main", "bucket:bucket_lava")
			meta:set_int("lava", lava_amount - 1000)
			update_entity(pos, stone_amount, lava_amount - 1000)

			if lava_amount >= 2000 and stone_amount > 1 then
				local timer = minetest.get_node_timer(pos)
				if not timer:is_started() then
					timer:start(4)
				end
			end
		elseif stone_amount < 8 and itemstack:get_name() == "default:cobble" then
			itemstack:take_item()
			meta:set_int("stone", stone_amount + 1)
			update_entity(pos, stone_amount + 1, lava_amount)

			local timer = minetest.get_node_timer(pos)
			if not timer:is_started() then
				timer:start(4)
			end
		end

		return itemstack
	end,

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

