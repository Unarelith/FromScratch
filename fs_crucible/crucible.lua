--[[

	fs_crucible
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

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

