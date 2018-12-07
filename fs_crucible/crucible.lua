--[[

	fs_crucible
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local entity_name = "fs_crucible:crucible_entity"

local update_entity = function(pos, input_amount, fluid_amount, input, fluid, entity)
	entity = entity or fs_core.get_subentity(pos, entity_name)
	if entity then
		local texture, height
		if input_amount > 0 then
			if fluid == "water" then
				texture = input
			else
				texture = input
			end
			height = 14 / 16
		else
			texture = "default:"..fluid.."_source"
			height = 14 / 16 * fluid_amount / 2000
		end

		pos.y = pos.y - 6 / 16 + height / 2
		entity:set_pos(pos)

		entity:set_properties({
			textures = {texture},

			visual_size = {
				x = 0.666 * 14 / 16,
				y = 0.666 * height
			},

			is_visible = input_amount > 0 or fluid_amount > 0
		})
	end
end

local on_timer = function(pos, elapsed)
	local meta = minetest.get_meta(pos)
	local input = meta:get_string("input_name")
	local fluid = meta:get_string("fluid_name")

	local heat_source = minetest.get_node({x = pos.x, y = pos.y - 1, z = pos.z})
	if fluid == "lava" and heat_source.name ~= "default:torch" then
		return true
	end

	local input_amount = meta:get_int("input")
	local fluid_amount = meta:get_int("fluid")
	if input_amount == 0 or fluid_amount >= 2000 then
		return false
	end

	meta:set_int("input", input_amount - 1)
	meta:set_int("fluid", fluid_amount + 100)
	update_entity(pos, input_amount - 1, fluid_amount + 100, input, fluid)

	return fluid_amount < 2000 and input_amount > 0
end

local on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
	local meta = minetest.get_meta(pos)
	local input_amount = meta:get_int("input")
	local fluid_amount = meta:get_int("fluid")
	local input = meta:get_string("input_name")
	local fluid = meta:get_string("fluid_name")

	if fluid_amount > 1000 and itemstack:get_name() == "bucket:bucket_empty" then
		itemstack:take_item()
		itemstack = fs_core.give_item_to_player(player, ItemStack("bucket:bucket_"..fluid))

		meta:set_int("fluid", fluid_amount - 1000)
		update_entity(pos, input_amount, fluid_amount - 1000, input, fluid)

		if fluid_amount >= 2000 and input_amount > 1 then
			local timer = minetest.get_node_timer(pos)
			if not timer:is_started() then
				timer:start(4)
			end
		end
	elseif input_amount < 8 and itemstack:get_name() == input then
		itemstack:take_item()
		meta:set_int("input", input_amount + 1)
		update_entity(pos, input_amount + 1, fluid_amount, input, fluid)

		local timer = minetest.get_node_timer(pos)
		if not timer:is_started() then
			timer:start(4)
		end
	end

	return itemstack
end

fs_crucible.register_crucible = function(name, info)
	minetest.register_node(name, {
		description = info.name,
		drawtype = "nodebox",

		tiles = info.tiles,

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

		collision_box = {
			type = "fixed",
			fixed = {-8/16, -8/16, -8/16, 8/16, 8/16, 8/16},
		},

		selection_box = {
			type = "fixed",
			fixed = {-8/16, -8/16, -8/16, 8/16, 8/16, 8/16},
		},

		on_timer = on_timer,

		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_int("input", 0)
			meta:set_int("fluid", 0)
			meta:set_string("input_name", info.input)
			meta:set_string("fluid_name", info.fluid)

			local entity = minetest.add_entity(pos, entity_name)
			update_entity(pos, 0, 0, info.input, info.fluid, entity)
		end,

		on_destruct = function(pos)
			fs_core.remove_subentity(pos, entity_name)
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

fs_core.register_subentity(entity_name, 14/16, 14/16, "default:cobble")

fs_crucible.register_crucible("fs_crucible:crucible", {
	name = "Crucible",
	input = "default:cobble",
	fluid = "lava",

	tiles = {
		-- up, down, right, left, back, front
		"fs_crucible_top.png",
		"fs_crucible_top.png",
		"fs_crucible_side.png",
		"fs_crucible_side.png",
		"fs_crucible_side.png",
		"fs_crucible_side.png"
	},
})

fs_crucible.register_crucible("fs_crucible:crucible_wood", {
	name = "Wooden Crucible",
	input = "default:leaves",
	fluid = "water",

	tiles = {
		"default_tree_top.png",
		"default_tree_top.png",
		"fs_crucible_wood_side.png",
		"fs_crucible_wood_side.png",
		"fs_crucible_wood_side.png",
		"fs_crucible_wood_side.png",
	},
})

