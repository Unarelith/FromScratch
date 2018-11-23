minetest.register_craft({
	output = "fs_sieve:sieve",
	recipe = {
		{"group:wood", "",                      "group:wood"},
		{"group:wood", "default:steel_ingot",   "group:wood"},
		{"group:wood", "",                      "group:wood"},
	},
})

minetest.register_craft({
	output = "fs_sieve:compressed_gravel",
	recipe = {
		{"default:gravel", "default:gravel", "default:gravel"},
		{"default:gravel", "default:gravel", "default:gravel"},
		{"default:gravel", "default:gravel", "default:gravel"},
	},
})

minetest.register_craft({
	type = "cooking",
	output = "default:cobble",
	recipe = "fs_sieve:compressed_gravel",
	cooktime = 10,
})

