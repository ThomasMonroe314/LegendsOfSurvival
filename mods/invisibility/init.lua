
invisibility = {}

minetest.register_privledge("invis","lets yo go invisible")

-- reset player invisibility if they go offline
minetest.register_on_leaveplayer(function(player)

	local name = player:get_player_name()

	if invisibility[name] then
		invisibility[name] = nil
	end
end)


-- creative check
local creative_mode_cache = minetest.settings:get_bool("creative_mode")
function is_creative(name)
	return creative_mode_cache or minetest.check_player_privs(name, {creative = true})
end


-- invisibility function
invisible = function(player, toggle)

	if not player then return false end

	local name = player:get_player_name()

	invisibility[name] = toggle

	local prop

	if toggle == true then

		-- hide player and name tag
		prop = {
			visual_size = {x = 0, y = 0},
--			collisionbox = {0, 0, 0, 0, 0, 0}
		}

		player:set_nametag_attributes({
			color = {a = 0, r = 255, g = 255, b = 255}
		})
	else
		-- show player and tag
		prop = {
			visual_size = {x = 1, y = 1},
--			collisionbox = {-0.35, -1, -0.35, 0.35, 1, 0.35}
		}

		player:set_nametag_attributes({
			color = {a = 255, r = 255, g = 255, b = 255}
		})
	end

	player:set_properties(prop)

end


-- vanish command (admin only)
minetest.register_chatcommand("vanish", {
	params = "<name>",
	description = "Make player invisible",
	privs = {invis = true},

	func = function(name, param)

		-- player online
		if param ~= ""
		and minetest.get_player_by_name(param) then

			name = param

		-- player not online
		elseif param ~= "" then

			return false, "Player " .. param .. " is not online!"
		end

		local player = minetest.get_player_by_name(name)

		-- hide / show player
		if invisibility[name] then

			invisible(player, nil)
		else
			invisible(player, true)
		end

	end
})