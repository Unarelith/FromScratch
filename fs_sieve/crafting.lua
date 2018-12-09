minetest.register_craft({
	output = "fs_sieve:sieve",
	recipe = {
		{"group:wood",  "fs_core:silkmesh", "group:wood"},
		{"group:wood",  "fs_core:silkmesh", "group:wood"},
		{"group:stick", "",                 "group:stick"},
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

