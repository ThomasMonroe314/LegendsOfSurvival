
-- Simple Skins mod for minetest (29th September 2017)
-- Adds a simple skin selector to the inventory by using
-- the default sfinv or inventory_plus when running.
-- Released by TenPlus1 and based on Zeg9's code under MIT license

skins = {}
skins.skins = {}
skins.modpath = minetest.get_modpath("simple_skins")
skins.invplus = minetest.get_modpath("inventory_plus")
skins.sfinv = minetest.get_modpath("sfinv")
skins.ui = minetest.get_modpath("unified_inventory")
skins.playerlist = {}

-- Load support for intllib.
local MP = minetest.get_modpath(minetest.get_current_modname())
local S, NS = dofile(MP.."/intllib.lua")


-- load skin list
skins.list = {}
skins.add = function(skin)
	table.insert(skins.list, skin)
end

local id = 1
local f
while true do
	f = io.open(skins.modpath .. "/textures/character_" .. id .. ".png")
	if not f then break end
--	if id>31 then break end
	f:close()
	skins.add("character_" .. id)
	id = id + 1
end
id = id - 1


-- load Metadata
skins.meta = {}
local f, data
for _, i in pairs(skins.list) do
	skins.meta[i] = {}
	f = io.open(skins.modpath .. "/meta/" .. i .. ".txt")
	data = nil
	if f then
		data = minetest.deserialize("return {" .. f:read('*all') .. "}")
		f:close()
	end
	data = data or {}
	skins.meta[i].name = data.name or ""
	skins.meta[i].author = data.author or ""
	skins.meta[i].owner = data.owner or ""
end


-- player load/save routines
skins.file = minetest.get_worldpath() .. "/simple_skins.mt"

skins.load = function()
	local input = io.open(skins.file, "r")
	local data = nil
	if input then
		data = input:read('*all')
	end
	if data and data ~= "" then
		local lines = string.split(data, "\n")
		for _, line in pairs(lines) do
			data = string.split(line, ' ', 2)
			skins.skins[data[1]] = data[2]
		end
		io.close(input)
	end
end


-- load player skins now for backwards compatibility
skins.load()


--get player skinlist
skins.get_playerlist = function(name)
	local list = {}
	for i = 1, #skins.list do
		if skins.meta[ skins.list[i] ].owner == "" or skins.meta[ skins.list[i] ].owner == name then
			list[#list+1] = skins.list[i]
		end
	end
	skins.playerlist[name] = list
end


-- skin selection page
skins.formspec = {}
skins.formspec.main = function(name)

	local formspec = ""

	if skins.invplus or skins.ui then
		formspec = "size[4,8.6]"
			.. "bgcolor[#08080822;true]"
	end

	formspec = formspec .. "label[.5,2;" .. S("Select Player Skin:") .. "]"
		.. "textlist[.5,2.5;6.8,6;skins_set;"

	local meta
	local selected = 1

	for i = 1, #skins.playerlist[name] do

		formspec = formspec .. skins.meta[ skins.playerlist[name][i] ].name .. ","

		if skins.skins[name] == skins.playerlist[name][i] then
			selected = i
			meta = skins.meta[ skins.skins[name] ]
		end
	end

	if skins.invplus then
		formspec = formspec .. ";" .. selected .. ";true]"
	else
		formspec = formspec .. ";" .. selected .. ";false]"
	end

	if meta then
		if meta.name then
			formspec = formspec .. "label[2,.5;" .. S("Name: ") .. meta.name .. "]"
		end
		if meta.author then
			formspec = formspec .. "label[2,1;" .. S("Author: ") .. meta.author .. "]"
		end
	end

	return formspec
end


-- update player skin
skins.update_player_skin = function(player)

	if not player then
		return
	end

	local name = player:get_player_name()

	player:set_properties({
		textures = {skins.skins[name] .. ".png"},
	})

	if skins.skins[name] ~= "character_1" then
		player:set_attribute("simple_skins:skin", skins.skins[name])
	end
end

unified_inventory.register_page("skins:skins", {
	title = "Skins",
	get_formspec = function(player, context)
		local name = player:get_player_name()
		return {formspec=skins.formspec.main(name),draw_inventory = false,draw_item_list = false}
	end,

})
minetest.register_on_player_receive_fields(function(player, context, fields)

	local name = player:get_player_name()

	local event = minetest.explode_textlist_event(fields["skins_set"])

	if event.type == "CHG" then

		local index = event.index

		if index > #skins.playerlist[name] then index = #skins.playerlist[name] end

		skins.skins[name] = skins.playerlist[name][index]
		skins.update_player_skin(player)

		unified_inventory.set_inventory_formspec(player,"skins:skins")
	end
end)
unified_inventory.register_button("skins:skins",{
	type = "image",
	image = "inventory_plus_skins.png",
})

-- register sfinv tab when inv+ not active
if skins.sfinv and not skins.invplus then

sfinv.register_page("skins:skins", {
	title = "Skins",
	get = function(self, player, context)
		local name = player:get_player_name()
		return sfinv.make_formspec(player, context,skins.formspec.main(name))
	end,
	on_player_receive_fields = function(self, player, context, fields)

		local name = player:get_player_name()

		local event = minetest.explode_textlist_event(fields["skins_set"])

		if event.type == "CHG" then

			local index = event.index

			if index > #skins.playerlist[name] then index = #skins.playerlist[name] end

			skins.skins[name] = skins.playerlist[name][index]

			skins.update_player_skin(player)

			sfinv.override_page("skins:skins", {
				get = function(self, player, context)
					local name = player:get_player_name()
					return sfinv.make_formspec(player, context,
							skins.formspec.main(name))
				end,
			})

			sfinv.set_player_inventory_formspec(player)
		end
	end,
})

end


-- load player skin on join
minetest.register_on_joinplayer(function(player)

	local name = player:get_player_name()
	
	-- Get the custom skinlist for this player
	skins.get_playerlist(name)

	-- do we already have a skin in player attributes?
	local skin = player:get_attribute("simple_skins:skin")
	if skin then
		skins.skins[name] = skin
	end

	-- no skin found? ok we use default
	if not skins.skins[name] then
		skins.skins[name] = "character_1"
	end

	skins.update_player_skin(player)

	if skins.invplus then
		inventory_plus.register_button(player,"skins", "Skin")
	end
end)

-- formspec control for inventory_plus
minetest.register_on_player_receive_fields(function(player, formname, fields)

	if skins.sfinv and not skins.invplus then
		return
	end

	local name = player:get_player_name()

	if fields.skins then
		inventory_plus.set_inventory_formspec(player,
			skins.formspec.main(name) .. "button[0,.75;2,.5;main;Back]")
	end

	local event = minetest.explode_textlist_event(fields["skins_set"])

	if event.type == "CHG" then

		local index = event.index

		if index > #skins.playerlist[name] then index = #skins.playerlist[name] end

		skins.skins[name] = skins.playerlist[name][index]

		if skins.invplus then
			inventory_plus.set_inventory_formspec(player,
				skins.formspec.main(name) .. "button[0,.75;2,.5;main;Back]")
		end

		skins.update_player_skin(player)
	end
end)


-- admin command to set player skin (usually for custom skins)
minetest.register_chatcommand("setskin", {
	params = "<player> <skin number>",
	description = S("Admin command to set player skin"),
	privs = {server = true},
	func = function(name, param)

		if not param or param == "" then return end

		local user, skin = string.match(param, "([^ ]+) (-?%d+)")

		if not user or not skin then return end

		skins.skins[user] = "character_"..tonumber(skin)

		skins.update_player_skin(minetest.get_player_by_name(user))

		minetest.chat_send_player(name,
			 "** " .. user .. S("'s skin set to") .. " character_" .. skin .. ".png")
	end,
})


print (S("[MOD] Simple Skins loaded"))
