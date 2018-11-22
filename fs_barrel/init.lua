--[[

	fs_barrel
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local modpath = minetest.get_modpath(minetest.get_current_modname())

fs_barrel = rawget(_G, "fs_barrel") or {}
fs_barrel.modpath = modpath

dofile(modpath .. "/barrel.lua")
dofile(modpath .. "/crafting.lua")

