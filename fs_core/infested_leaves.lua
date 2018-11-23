local N = 10
for idx = 0, N do
	local not_in_creative_inventory
	if idx == 0 then
		not_in_creative_inventory = 0
	else
		not_in_creative_inventory = 1
	end

	local drop
	if idx == N - 1 then
		drop = {
			max_items = 1,
			items = {
				{
					items = {'farming:string'},
				},
			}
		}
	end

	local node_name = "fs_core:infested_leaves"

	minetest.register_node(node_name..idx, {
		description = "Infested Tree Leaves ("..tostring((idx + 1) / N * 100).."%)",
		drawtype = "allfaces_optional",
		waving = 1,
		tiles = {"default_leaves.png^[colorize:#ffffff"..string.format("%02x", (idx + 1) / N * 150)},
		special_tiles = {"default_leaves_simple.png"},
		paramtype = "light",
		is_ground_content = false,

		groups = {
			snappy = 3,
			leafdecay = 3,
			flammable = 2,
			infested_leaves = 1,
			not_in_creative_inventory = not_in_creative_inventory
		},

		drop = drop,

		sounds = default.node_sound_leaves_defaults(),

		after_place_node = default.after_place_leaves,

		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_int("idx", idx)
			meta:set_string("node_name", node_name)

			minetest.get_node_timer(pos):start(2)
		end,

		on_timer = function(pos, elapsed)
			local meta = minetest.get_meta(pos)
			local idx = meta:get_int("idx") + 1
			meta:set_int("idx", idx)

			local node = minetest.get_node(pos)
			node.name = meta:get_string("node_name")..idx
			minetest.swap_node(pos, node)

			-- Infestation propagation
			local leaves_pos = minetest.find_node_near(pos, 1, {"group:leaves"})
			if leaves_pos then
				local neighbour = minetest.get_node(leaves_pos)
				if minetest.get_item_group(neighbour.name, "leaves") == 1 then
					neighbour.name = node_name.."0"
					minetest.swap_node(leaves_pos, neighbour)

					local neighbour_meta = minetest.get_meta(leaves_pos)
					neighbour_meta:set_int("idx", 0)
					neighbour_meta:set_string("node_name", node_name)

					minetest.get_node_timer(leaves_pos):start(2)
				end
			end

			return idx < N - 1
		end
	})
end

minetest.register_alias("fs_core:infested_leaves", "fs_core:infested_leaves"..(N - 1))

