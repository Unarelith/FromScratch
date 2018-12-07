minetest.register_tool("fs_tools:crook_wood", {
	description = "Wooden Crook\n"
	           .. minetest.get_color_escape_sequence("#aaaaaa")
	           .. "Use on leaves to get Silk Worms"
	           .. minetest.get_color_escape_sequence("#ffffff"),
	inventory_image = "fs_tools_crook_wood.png",
	tool_capabilities = {
		full_punch_interval = 1.2,
		max_drop_level=1,
		groupcaps={
			leaves          = {times={[1]=0.25}, uses=30, maxlevel=1},
			infested_leaves = {times={[1]=0.25}, uses=30, maxlevel=1},
		},
		damage_groups = {fleshy=2},
	},
	groups = {flammable = 2},
	sound = {breaks = "default_tool_breaks"},
})

