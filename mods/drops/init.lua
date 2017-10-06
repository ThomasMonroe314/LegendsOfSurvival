local age                   = 1 --how old an item has to be before collecting
local radius_magnet         = 2.5 --radius of item magnet
local player_collect_height = 1.3 --added to their pos y value
local adjuster_collect      = 0.01 --Delay before collecting to visualize moveme
	
--Item collection
minetest.register_globalstep(function(dtime)
	--collection
	for _,player in ipairs(minetest.get_connected_players()) do
		--don't magnetize to dead players
		if player:get_hp() > 0 then
			local pos = player:getpos()
			local inv = player:get_inventory()
			--radial detection
			for _,object in ipairs(minetest.env:get_objects_inside_radius({x=pos.x,y=pos.y + player_collect_height,z=pos.z}, radius_magnet)) do
				if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
					if object:get_luaentity().age > age then
						if inv and inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then
							--collect
							if object:get_luaentity().collectioner == true and object:get_luaentity().age > age and object:get_luaentity().age > object:get_luaentity().age_stamp + adjuster_collect  then
								if object:get_luaentity().itemstring ~= "" then
									inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
									minetest.sound_play("item_drop_pickup", {
										pos = pos,
										max_hear_distance = 100,
										gain = 10.0,
									})
									object:get_luaentity().itemstring = ""
									object:remove()
								end
							
							--magnet
							else
								--moveto for extreme speed boost
								local pos1 = pos
								pos1.y = pos1.y + player_collect_height
								object:moveto(pos1)
								object:get_luaentity().collectioner = true
								object:get_luaentity().age_stamp = object:get_luaentity().age
								
							end
						end
					end
				end
			end
		end
	end
end)

--Throw items using player's velocity
function minetest.item_drop(itemstack, dropper, pos)
	
	--if player then do modified item drop
	if dropper and minetest.get_player_information(dropper:get_player_name()) then
		local v = dropper:get_look_dir()
		local vel = dropper:get_player_velocity()
		local p = {x=pos.x, y=pos.y+1.3, z=pos.z}
		local item = itemstack:to_string()
		local obj = core.add_item(p, item)
		if obj then
			v.x = (v.x*5)+vel.x
			v.y = ((v.y*5)+2)+vel.y
			v.z = (v.z*5)+vel.z
			obj:setvelocity(v)
			obj:get_luaentity().dropped_by = dropper:get_player_name()
			itemstack:clear()
			return itemstack
		end
	end
end
if minetest.setting_get("log_mods") then
	minetest.log("action", "Drops loaded")
end
