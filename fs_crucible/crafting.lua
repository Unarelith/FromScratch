minetest.register_craft({
	output = "fs_crucible:crucible",
	recipe = {
		{"default:clay", "",             "default:clay"},
		{"default:clay", "",             "default:clay"},
		{"default:clay", "default:clay", "default:clay"},
	},
})

minetest.register_craft({
	output = "fs_crucible:crucible_wood",
	recipe = {
		{"default:tree", "",             "default:tree"},
		{"default:tree", "",             "default:tree"},
		{"default:tree", "default:tree", "default:tree"},
	},
})

