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

minetest.register_craft({
	output = "fs_sieve:hammer_wood",
	recipe = {
		{"",            "group:wood",  ""},
		{"",            "group:stick", "group:wood"},
		{"group:stick", "",            ""},
	}
})

minetest.register_craft({
	output = "fs_sieve:hammer_stone",
	recipe = {
		{"",            "group:stone",  ""},
		{"",            "group:stick", "group:stone"},
		{"group:stick", "",            ""},
	}
})

minetest.register_craft({
	output = "fs_sieve:hammer_iron",
	recipe = {
		{"",            "default:steel_ingot",  ""},
		{"",            "group:stick",          "default:steel_ingot"},
		{"group:stick", "",                     ""},
	}
})

minetest.register_craft({
	output = "fs_sieve:hammer_diamond",
	recipe = {
		{"",            "default:diamond",  ""},
		{"",            "group:stick",      "default:diamond"},
		{"group:stick", "",                 ""},
	}
})

