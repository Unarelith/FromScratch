--[[

	fs_core
	================

	Copyright (C) 2018-2019 Quentin Bazin

	LGPLv2.1+
	See LICENSE.txt for more information

]]--

fs_core.get_subentity = function(pos, name)
	local objects = minetest.get_objects_inside_radius(pos, 0.5)
	for _, obj in ipairs(objects) do
		local e = obj:get_luaentity()
		if e and e.name == name then
			return obj
		end
	end
end

fs_core.remove_subentity = function(pos, name)
	local objects = minetest.get_objects_inside_radius(pos, 0.5)
	for _, obj in ipairs(objects) do
		local e = obj:get_luaentity()
		if e and e.name == name then
			obj:remove()
		end
	end
end

fs_core.register_subentity = function(name, width, height, default_item)
	return minetest.register_entity(name, {
		initial_properties = {
			visual = "wielditem",
			visual_size = {
				x = 0.666 * width,
				y = 0.666 * height
			},

			textures = {default_item},

			collide_with_objects = false,

			pointable = false,
		},

		on_activate = function(self, staticdata, dtime_s)
			local data = minetest.deserialize(staticdata)
			if not data or type(data) ~= "table" then
				return
			end

			self.object:set_properties({
				visual_size = data.visual_size,
				textures = data.textures,
				is_visible = data.is_visible,
			})
		end,

		get_staticdata = function(self)
			local prop = self.object:get_properties()
			return minetest.serialize({
				visual_size = prop.visual_size,
				textures = prop.textures,
				is_visible = prop.is_visible,
			})
		end,
	})
end

