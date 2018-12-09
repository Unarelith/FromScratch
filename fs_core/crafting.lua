minetest.register_craft({
	output = "fs_core:silkmesh",
	recipe = {
		{"farming:string", "farming:string", "farming:string"},
		{"farming:string", "farming:string", "farming:string"},
		{"farming:string", "farming:string", "farming:string"},
	},
})

minetest.register_craft({
    type = "cooking",
    recipe = "group:tree",
    output = "default:coal_lump",
    cooktime = 3.5,
})

minetest.register_craft({
    type = "cooking",
    recipe = "default:clay_lump",
    output = "fs_core:porcelain_clay",
    cooktime = 3.5,
})

