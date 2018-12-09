minetest.register_craft({
	output = "fs_crucible:crucible",
	recipe = {
		{"fs_core:porcelain_clay", "",                       "fs_core:porcelain_clay"},
		{"fs_core:porcelain_clay", "",                       "fs_core:porcelain_clay"},
		{"fs_core:porcelain_clay", "fs_core:porcelain_clay", "fs_core:porcelain_clay"},
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

