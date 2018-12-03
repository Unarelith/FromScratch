local N = 13

local animate_barrel = function(meta, idx)
	idx = (idx + 1) % N
	meta:set_int("idx", idx)
	return idx
end

fs_barrel.get_entity = function(pos)
	local objects = minetest.get_objects_inside_radius(pos, 0.5)
	for _, obj in ipairs(objects) do
		local e = obj:get_luaentity()
		if e and e.name == "fs_barrel:barrel_entity" then
			return obj
		end
	end
end

fs_barrel.update_entity = function(pos, idx, entity)
	entity = entity or fs_barrel.get_entity(pos)
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

fs_barrel.update = function(pos, player, itemstack)
	local meta = minetest.get_meta(pos)
	local idx = meta:get_int("idx")
	local progress = meta:get_int("progress")

	if idx < N - 1 and minetest.get_item_group(itemstack:get_name(), "sapling") > 0 then
		idx = animate_barrel(meta, idx)
		itemstack:take_item()

		if idx == N - 1 then
			minetest.get_node_timer(pos):start(1)
		end
	elseif idx == N - 1 and progress == 100 then
		idx = animate_barrel(meta, idx)

		local handstack = not itemstack:is_empty() and itemstack:add_item("default:dirt")
		if not handstack:is_empty() and player:get_inventory():room_for_item("main", "default:dirt") then
			player:get_inventory():add_item("main", handstack)
		end

		meta:set_int("progress", 0)
	end

	fs_barrel.update_entity(pos, idx)

	return itemstack
end

minetest.register_entity("fs_barrel:barrel_entity", {
	initial_properties = {
		visual = "wielditem",
		visual_size = {
			x = 0.666 * 10/16,
			y = 0.666 * 12/16
		},

		textures = {"default:dirt"},

		collide_with_objects = false,

		pointable = false,
	}
})

minetest.register_node("fs_barrel:barrel_wood", {
	description = "Wooden Barrel",
	drawtype = "nodebox",

	tiles = {
		-- up, down, right, left, back, front
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
		"default_wood.png",
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
		meta:set_string("node_name", node_name)

		minetest.add_entity(pos, "fs_barrel:barrel_entity")
		fs_barrel.update_entity(pos, 0, entity)
	end,

	on_destruct = function(pos)
		local e = fs_barrel.get_entity(pos)
		if e then
			e:remove()
		end
	end,

	on_timer = function(pos, elapsed)
		local meta = minetest.get_meta(pos)
		local progress = meta:get_int("progress") + 10
		meta:set_int("progress", progress)

		-- FIXME: Show a small tooltip instead
		-- if progress < 100 then
		-- 	minetest.override_item(node_name, {
		-- 		description = description .. " (" .. progress .. "%)"
		-- 	})
		-- else
		-- 	minetest.override_item(node_name, {
		-- 		description = description
		-- 	})
		-- end

		return progress < 100
	end,

	-- after_place_node = function(pos, placer)
	-- 	local meta = minetest.get_meta(pos)
	-- 	meta:set_string("infotext", "Wooden Barrel")
	-- end,

	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		return fs_barrel.update(pos, player, itemstack)
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

