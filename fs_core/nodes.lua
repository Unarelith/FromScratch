minetest.register_node("fs_core:dust", {
	description = "Dust",
	tiles = {"fs_core_block_dust.png"},
	groups = {crumbly = 3, falling_node = 1, dust = 1},
	sounds = default.node_sound_sand_defaults()
})

