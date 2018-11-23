minetest.register_craft({
	output = "fs_tools:crook_wood",
	recipe = {
		{"group:stick", "group:stick", ""},
		{"",            "group:stick", ""},
		{"",            "group:stick", ""},
	}
})

minetest.register_craft({
	output = "fs_tools:hammer_wood",
	recipe = {
		{"",            "group:wood",  ""},
		{"",            "group:stick", "group:wood"},
		{"group:stick", "",            ""},
	}
})

minetest.register_craft({
	output = "fs_tools:hammer_stone",
	recipe = {
		{"",            "group:stone",  ""},
		{"",            "group:stick", "group:stone"},
		{"group:stick", "",            ""},
	}
})

minetest.register_craft({
	output = "fs_tools:hammer_iron",
	recipe = {
		{"",            "default:steel_ingot",  ""},
		{"",            "group:stick",          "default:steel_ingot"},
		{"group:stick", "",                     ""},
	}
})

minetest.register_craft({
	output = "fs_tools:hammer_diamond",
	recipe = {
		{"",            "default:diamond",  ""},
		{"",            "group:stick",      "default:diamond"},
		{"group:stick", "",                 ""},
	}
})

