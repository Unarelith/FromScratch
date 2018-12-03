minetest.register_craft({
	output = "fs_barrel:barrel_wood",
	recipe = {
		{"group:wood", "",           "group:wood"},
		{"group:wood", "",           "group:wood"},
		{"group:wood", "group:wood", "group:wood"},
	},
})

minetest.register_craft({
	output = "fs_barrel:barrel_stone",
	recipe = {
		{"default:stone", "",              "default:stone"},
		{"default:stone", "",              "default:stone"},
		{"default:stone", "default:stone", "default:stone"},
	},
})

