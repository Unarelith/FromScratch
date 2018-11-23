minetest.register_craftitem("fs_core:silkworm", {
	description = "Silk Worm",
	inventory_image = "fs_core_silkworm.png",
	on_place = fs_core.silkworm.on_place,
})

minetest.register_craftitem("fs_core:silkmesh", {
	description = "Silk Mesh",
	inventory_image = "fs_core_silkmesh.png"
})

