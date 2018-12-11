--[[

	fs_tools
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

minetest.override_item("default:cobble", {drop = {
	max_items = 1,
	items = {
		{
			tools = {"~fs_tools:hammer_"},
			items = {"default:gravel"}
		},
		{
			items = {"default:cobble"}
		}
	}
}})

minetest.override_item("default:sand", {drop = {
	max_items = 1,
	items = {
		{
			tools = {"~fs_tools:hammer_"},
			items = {"fs_core:dust"}
		},
		{
			items = {"default:sand"}
		}
	}
}})

local gravel = minetest.registered_nodes["default:gravel"]
table.insert(gravel.drop.items, 1, {
	tools = {"~fs_tools:hammer_"},
	items = {"default:sand"}
})

local leaves_types = {
	-- minetest_game
	"default:leaves",
	"default:jungleleaves",
	"default:pine_needles",
	"default:acacia_leaves",
	"default:aspen_leaves",
	"default:bush_leaves",
	"default:blueberry_bush_leaves",
	"default:acacia_bush_leaves",
	"default:pine_bush_needles",
}

for _, v in ipairs(leaves_types) do
	local leaves = minetest.registered_nodes[v]
	if leaves then
		table.insert(leaves.drop.items, 1, {
			tools = {"~fs_tools:crook_"},
			items = {'fs_core:silkworm'},
			rarity = 10,
		})
	end
end

