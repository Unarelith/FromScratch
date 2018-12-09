--[[

	fs_sieve
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

fs_sieve.ore_pieces = {}

fs_sieve.register_ore_piece = function(name, description, color, lump)
	local itemname = "fs_sieve:"..name.."_piece"
	minetest.register_craftitem(itemname, {
		description = description,

		inventory_image = "fs_sieve_orepieceoverlay.png^[colorize:"..color..":120",
		inventory_overlay = "fs_sieve_orepiece.png^[colorize:"..color..":40",
	})

	minetest.register_craft({
		type = "shapeless",
		output = lump,
		recipe = {itemname, itemname, itemname, itemname},
	})

	fs_sieve.ore_pieces[lump] = itemname
end

-- default ores
fs_sieve.register_ore_piece("iron_ore",       "Iron Ore Piece",       "#bf8040", "default:iron_lump")
fs_sieve.register_ore_piece("gold_ore",       "Gold Ore Piece",       "#ffff00", "default:gold_lump")
fs_sieve.register_ore_piece("copper_ore",     "Copper Ore Piece",     "#ff9933", "default:copper_lump")
fs_sieve.register_ore_piece("tin_ore",        "Tin Ore Piece",        "#336699", "default:tin_lump")

-- elepower ores
fs_sieve.register_ore_piece("lead_ore",       "Lead Ore Piece",       "#330066", "elepower_dynamics:lead_lump")
fs_sieve.register_ore_piece("nickel_ore",     "Nickel Ore Piece",     "#ffffcc", "elepower_dynamics:nickel_lump")
fs_sieve.register_ore_piece("zinc_ore",       "Zinc Ore Piece",       "#000022", "elepower_dynamics:zinc_lump")
fs_sieve.register_ore_piece("viridisium_ore", "Viridisium Ore Piece", "#006611", "elepower_dynamics:viridisium_lump")
fs_sieve.register_ore_piece("uranium_ore",    "Uranium Ore Piece",    "#339933", "elepower_nuclear:uranium_lump")

