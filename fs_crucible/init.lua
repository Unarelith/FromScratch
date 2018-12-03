--[[

	fs_crucible
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local modpath = minetest.get_modpath(minetest.get_current_modname())

fs_crucible = rawget(_G, "fs_crucible") or {}
fs_crucible.modpath = modpath

dofile(modpath .. "/crucible.lua")
dofile(modpath .. "/crafting.lua")

