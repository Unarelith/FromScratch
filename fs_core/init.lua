--[[

	fs_core
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local modpath = minetest.get_modpath(minetest.get_current_modname())

fs_core = rawget(_G, "fs_core") or {}
fs_core.modpath = modpath

dofile(modpath .. "/utils.lua")
dofile(modpath .. "/subentity.lua")
dofile(modpath .. "/nodes.lua")
dofile(modpath .. "/infested_leaves.lua")
dofile(modpath .. "/silkworm.lua")
dofile(modpath .. "/craftitems.lua")
dofile(modpath .. "/crafting.lua")

