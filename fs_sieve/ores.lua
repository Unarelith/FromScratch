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

fs_sieve.ore_rarity = tonumber(minetest.setting_get("fs_sieve_ore_rarity")) or 1

-- Increase the probability over the natural occurrence
local PROBABILITY_FACTOR = 3

-- Ore probability table (1/n)
fs_sieve.ore_probability = {
}

-- Collect all registered ores and calculate the probability
local function add_ores()
	for _,item in  pairs(minetest.registered_ores) do
		if minetest.registered_nodes[item.ore] then
			local drop = minetest.registered_nodes[item.ore].drop
			if type(drop) == "string"
			and drop ~= item.ore
			and drop ~= ""
			and item.ore_type == "scatter"
			and item.clust_scarcity ~= nil and item.clust_scarcity > 0
			and item.clust_size ~= nil and item.clust_size > 0 then
				local probability = item.clust_scarcity / item.clust_size /
								PROBABILITY_FACTOR * fs_sieve.ore_rarity
				probability = math.floor(probability)
				if probability > 20 then
					if fs_sieve.ore_probability[drop] == nil then
						fs_sieve.ore_probability[drop] = probability
					else
						fs_sieve.ore_probability[drop] =
										math.min(fs_sieve.ore_probability[drop], probability)
					end
				end
			end
		end
	end

	local overall_probability = 0.0
	for name,probability in pairs(fs_sieve.ore_probability) do
		print(string.format("[fs_sieve] %-32s %u", name, probability))
		overall_probability = overall_probability + 1.0/probability
	end

	print(string.format("[fs_sieve] Overall probability %g", overall_probability))
end

minetest.after(1, add_ores)

