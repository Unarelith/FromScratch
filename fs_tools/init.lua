--[[

	fs_tools
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local modpath = minetest.get_modpath(minetest.get_current_modname())

fs_tools = rawget(_G, "fs_tools") or {}
fs_tools.modpath = modpath

dofile(modpath .. "/hammer.lua")
dofile(modpath .. "/crook.lua")
dofile(modpath .. "/crafting_tweaks.lua")
dofile(modpath .. "/crafting.lua")

