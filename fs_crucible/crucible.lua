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

local update_entity = function(pos, input_amount, fluid_amount, input, fluid, entity)
	entity = entity or get_entity(pos)
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
	},

	-- TODO: Move these functions to fs_core
	on_activate = function(self, staticdata, dtime_s)
		local data = minetest.deserialize(staticdata)
		if not data or type(data) ~= "table" then
			return
		end

		self.object:set_properties({
			visual_size = data.visual_size,
			textures = data.textures,
			is_visible = data.is_visible,
		})
	end,

	get_staticdata = function(self)
		local prop = self.object:get_properties()
		return minetest.serialize({
			visual_size = prop.visual_size,
			textures = prop.textures,
			is_visible = prop.is_visible,
		})
	end,
})

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

			local entity = minetest.add_entity(pos, "fs_crucible:crucible_entity")
			update_entity(pos, 0, 0, info.input, info.fluid, entity)
		end,

		on_destruct = function(pos)
			local e = get_entity(pos)
			if e then
				e:remove()
			end
		end,

		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			local meta = minetest.get_meta(pos)
			local input_amount = meta:get_int("input")
			local fluid_amount = meta:get_int("fluid")
			local input = meta:get_string("input_name")
			local fluid = meta:get_string("fluid_name")

			if fluid_amount > 1000 and itemstack:get_name() == "bucket:bucket_empty" then
				itemstack:take_item()

				local handstack = ItemStack("bucket:bucket_"..fluid)
				if itemstack:is_empty() then
					handstack = itemstack:add_item(handstack)
				end

				if not handstack:is_empty() and player:get_inventory():room_for_item("main", handstack) then
					clicker:get_inventory():add_item("main", handstack)

					meta:set_int("fluid", fluid_amount - 1000)
					update_entity(pos, input_amount, fluid_amount - 1000, input, fluid)
				end

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
end

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

