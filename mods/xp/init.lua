xp = {}

xp.values = {}

dofile(minetest.get_modpath("xp").."/values.lua")

xp.level = {}
xp.xp = {}
xp.huds = {}
local mod_storage = minetest.get_mod_storage()
local blue = minetest.get_color_escape_sequence("#0000ff")

function xp.levelfunc(level)
	return (math.floor(1.15^level)+100)
end

function xp.add_xp(player,XP)
	local name = player:get_player_name()
	XP = xp.xp[name]+XP
	local level = xp.level[name]
	local temp = level
	if (xp.levelfunc(level)-XP)<1 then
		XP = XP-(xp.levelfunc(level))
		level = level+1
		xp.level[name] = level
		mod_storage:set_int(name.."_level",level)
		player:set_nametag_attributes({text = name.."  "..blue..level})
	end
	if temp~=level and math.mod(level,5)==0 then
		minetest.chat_send_all(name.." reached level " ..level.."!")
	end
	xp.xp[name] = XP
	mod_storage:set_int(name.."_xp",XP)
	xp.update_hud(player,level,XP)
end

function xp.update_hud(player,level,XP)
	local name = player:get_player_name()
	if xp.huds[name] then
		player:hud_change(xp.huds[name],"text","Level: "..level.."\nXP: "..XP.."\nXP needed: "..(xp.levelfunc(level)-XP))
	else
		xp.huds[name] = player:hud_add({
			hud_elem_type = "text",
			position = {x = 0, y = 0.5},
			offset = {x = 10, y = 0},
			scale = {x = 100, y = 100},
			text = "Level: "..level.."\nXP: "..XP.."\nXP needed: "..xp.levelfunc(level),
			number = 0xFFFFFF,
			alignment = {x = 1, y = 0.5},
			direction = 2,
		})
	end
end

minetest.register_on_joinplayer(function(player)
	local name = player:get_player_name()
	local level = mod_storage:get_int(name.."_level")
	local XP = mod_storage:get_int(name.."_xp")
	if level == 0 then
		level = 1
		mod_storage:set_int(name.."_level",level)
	end
	if XP == 0 then
		XP = 0
		mod_storage:set_int(name.."_xp",XP)
	end
	xp.level[name] = level
	xp.xp[name] = XP
	player:set_nametag_attributes({text = name..blue.." "..level})
	xp.update_hud(player,level,XP)
end)

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	xp.huds[name] = nil
	xp.level[name] = nil
	xp.xp[name] = nil
end)


minetest.register_on_dignode(function(pos, oldnode, digger)
	local XP = xp.values[oldnode.name]
	local name = digger:get_player_name()
	if XP then
		XP = XP*(math.ceil(xp.level[name]/30))
		xp.add_xp(digger,XP)
	end
	
end)

minetest.register_chatcommand("getxp",{
	privs = {server = true},
	params = "<name>",
	description = "returns the xp level of a player",
	func = function(name, param)
		local level = mod_storage:get_int(param.."_level")
		local XP = mod_storage:get_int(param.."_xp")
		minetest.chat_send_player(name,"Level: "..level.."\nXP: "..XP.."\nXP needed: "..(math.floor(1.15^level)+100-XP))
	end,
})
