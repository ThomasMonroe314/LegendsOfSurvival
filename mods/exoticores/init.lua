-- Load ore files--
dofile(minetest.get_modpath("exoticores").."/nevadaite.lua")
dofile(minetest.get_modpath("exoticores").."/cobaltominite.lua")
dofile(minetest.get_modpath("exoticores").."/sideronatrite.lua")
dofile(minetest.get_modpath("exoticores").."/edoylerite.lua")
dofile(minetest.get_modpath("exoticores").."/lonsdaleite.lua")
if minetest.get_modpath("3d_armor") then
	dofile(minetest.get_modpath("exoticores").."/armor.lua")
end
