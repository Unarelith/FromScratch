--[[

	fs_sieve
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local modpath = minetest.get_modpath(minetest.get_current_modname())

fs_sieve = rawget(_G, "fs_sieve") or {}
fs_sieve.modpath = modpath

dofile(modpath .. "/ore_probability.lua")
dofile(modpath .. "/ore_pieces.lua")
dofile(modpath .. "/sieve.lua")
dofile(modpath .. "/crafting.lua")
dofile(modpath .. "/nodes.lua")

