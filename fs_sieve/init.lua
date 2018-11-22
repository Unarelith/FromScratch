--[[

	fs_sieve
	================

	Derived from gravelsieve v1.08 by JoSt

	Copyright (C) 2018-2019 Quentin Bazin
	Copyright (C) 2017-2018 Joachim Stolberg
	Copyright (C) 2011-2016 celeron55, Perttu Ahola <celeron55@gmail.com>
	Copyright (C) 2011-2016 Various Minetest developers and contributors

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

local modpath = minetest.get_modpath(minetest.get_current_modname())

fs_sieve = rawget(_G, "fs_sieve") or {}
fs_sieve.modpath = modpath

dofile(modpath .. "/hammer.lua")
dofile(modpath .. "/ores.lua")
dofile(modpath .. "/sieve.lua")
dofile(modpath .. "/crafting.lua")
dofile(modpath .. "/nodes.lua")

