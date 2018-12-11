minetest.register_craft({
	output = "fs_core:silkmesh",
	recipe = {
		{"farming:string", "farming:string", "farming:string"},
		{"farming:string", "farming:string", "farming:string"},
		{"farming:string", "farming:string", "farming:string"},
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "fs_core:porcelain_clay",
	recipe = {
		"default:clay_lump",
		"bonemeal:bonemeal",
	},
})

minetest.register_craft({
	type = "shapeless",
	output = "default:cobble",
	recipe = {
		"fs_core:stone_pebble",
		"fs_core:stone_pebble",
		"fs_core:stone_pebble",
		"fs_core:stone_pebble",
	},
})

minetest.register_craft({
    type = "cooking",
    recipe = "group:tree",
    output = "default:coal_lump",
    cooktime = 3.5,
})

