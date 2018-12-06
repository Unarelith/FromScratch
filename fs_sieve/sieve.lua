--[[

	fs_sieve
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local N = 5

local animate_sieve = function(pos, meta, idx)
	idx = (idx + 1) % N
	meta:set_int("idx", idx)
	return idx
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
	local idx = meta:get_int("idx", idx)

	if inv:contains_item("src", gravel) then
		idx = animate_sieve(pos, meta, idx)
		if idx == 0 then
			add_random_ores(inv)
			inv:remove_item("src", gravel)
		end
	end
end

-- FIXME: Move this to core
local get_entity = function(pos)
	local objects = minetest.get_objects_inside_radius(pos, 0.5)
	for _, obj in ipairs(objects) do
		local e = obj:get_luaentity()
		if e and e.name == "fs_sieve:sieve_entity" then
			return obj
		end
	end
end

local update_entity = function(pos, idx, item, entity)
	item = item or "default:gravel"
	entity = entity or get_entity(pos)
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

minetest.register_entity("fs_sieve:sieve_entity", {
	initial_properties = {
		visual = "wielditem",
		visual_size = {
			x = 0.666 * 14/16,
			y = 0.666 * 7/16
		},

		textures = {"default:gravel"},

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

local nodebox_data = {
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

local node_name = "fs_sieve:sieve"
local description = "Gravel Sieve"
local tiles_data = {
	-- up, down, right, left, back, front
	"fs_sieve_top.png",
	"default_wood.png",
	"default_wood.png",
	"default_wood.png",
	"default_wood.png",
	"default_wood.png",
}

minetest.register_node(node_name, {
	description = description,
	tiles = tiles_data,
	drawtype = "nodebox",
	drop = node_name,

	node_box = {
		type = "fixed",
		fixed = nodebox_data,
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

		local inv = meta:get_inventory()
		inv:set_size('src', 1)
		inv:set_size('dst', 16)

		local entity = minetest.add_entity(pos, "fs_sieve:sieve_entity")
		update_entity(pos, 0, entity)
	end,

	on_destruct = function(pos)
		local e = get_entity(pos)
		if e then
			e:remove()
		end
	end,

	after_place_node = function(pos, placer)
		local meta = minetest.get_meta(pos)
		meta:set_string("infotext", "Gravel Sieve")
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
			update_entity(pos, idx)
		end

		if idx == 0 and not inv:is_empty("dst") then
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
	drop = node_name,
})

