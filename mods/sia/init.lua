sia = {}
screwdriver = screwdriver or {}

minetest.register_privilege("SIA_admin", {
	description = "Is a member of the Server Intelegence Agency",
	give_to_singleplayer = false
})

local mod_storage = minetest.get_mod_storage()

function sia.is_member(name)
	local str = mod_storage:get_string("SIA_members")
	for x in string.gmatch(str, '([^,]+)') do
		if x==name then
			return true
		end
	end
	return false
end

minetest.register_chatcommand("listmembers", {
	description = "Lists the Sia members",
	privs = {SIA_admin = true},
	func = function(name, param)
		local str = mod_storage:get_string("SIA_members")
		for x in string.gmatch(str, '([^,]+)') do
		    minetest.chat_send_player(name,x)
		end
	end
})
minetest.register_chatcommand("addmember", {
	description = "Adds player to the SIA member list",
	params = "<player>",
	privs = {SIA_admin = true},
	func = function(name, param)
		if mod_storage:get_string("SIA_members")=="" then
			mod_storage:set_string("SIA_members",param)
		else
			if not sia.is_member(param) then
				mod_storage:set_string("SIA_members",mod_storage:get_string("SIA_members")..","..param)
				minetest.chat_send_player(name,param.." was added succesefully")
			else
				minetest.chat_send_player(name,param.." is already a member")
			end
		end
	end
})

minetest.register_chatcommand("removemember", {
	description = "Removes player from the SIA member list",
	params = "<player>",
	privs = {SIA_admin = true},
	func = function(name, param)
		local str = mod_storage:get_string("SIA_members")
		local nstr = ""
		for x in string.gmatch(str, '([^,]+)') do
			if x==param then
			else
				if nstr == "" then
					nstr = nstr..x
				else
					nstr = nstr..","..x
				end
			end
		end
		mod_storage:set_string("SIA_members",nstr)
		minetest.chat_send_player(name,param.." was removed succesefully")
	end
})

local cbox = {
	type = "fixed",
	fixed = { -6/16, -8/16, -8/16, 6/16, 3/16, 8/16 }
}

dofile(minetest.get_modpath("sia").."/api.lua")


minetest.register_alias("SIA_Mailbox","sia:mailbox")

minetest.register_node("sia:mailbox", {
	paramtype = "light",
	drawtype = "mesh",
	mesh = "sia_mailbox.obj",
	description = "SIA mailbox",
	tiles = {
		"sia_mailbox.png",
	},
	inventory_image = "sia_mailbox_inv.png",
	selection_box = cbox,
	collision_box = cbox,
	paramtype2 = "facedir",
	groups = {choppy=2,oddly_breakable_by_hand=2,not_in_creative_inventory=1},
	sounds = default.node_sound_wood_defaults(),
	on_rotate = screwdriver.rotate_simple,
	after_place_node = function(pos, placer, itemstack)
		local meta = minetest.get_meta(pos)
		local owner = placer:get_player_name()
		meta:set_string("infotext","SIA Mailbox place books inside to let the server admins know something about another player")
		local inv = meta:get_inventory()
		inv:set_size("main", 16*5)
		inv:set_size("drop", 1)
	end,
	on_rightclick = function(pos, node, clicker, itemstack)
		local meta = minetest.get_meta(pos)
		local player = clicker:get_player_name()
		if sia.is_member(player) then
			minetest.show_formspec(
				clicker:get_player_name(),
				"default:chest_locked",
				sia.get_formspec(pos))
		else
			minetest.show_formspec(
				clicker:get_player_name(),
				"default:chest_locked",
				sia.get_insert_formspec(pos))
		end
		return itemstack
	end,
	can_dig = function(pos,player)
		local meta = minetest.get_meta(pos);
		local name = player and player:get_player_name()
		local inv = meta:get_inventory()
		return sia.is_member(player:get_player_name()) and inv:is_empty("main")
	end,
	on_metadata_inventory_put = function(pos, listname, index, stack, player)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local playerinv = player:get_inventory()
		if listname == "drop" and inv:room_for_item("main", stack) then
			inv:remove_item("drop", stack)
			inv:add_item("main", stack)
		end
	end,
	allow_metadata_inventory_put = function(pos, listname, index, stack, player)
		if listname == "main" then
			return 0
		end
		if listname == "drop" then
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			if inv:room_for_item("main", stack) and stack:get_name() == "default:book_written" then
				return -1
			else
				return 0
			end
		end
	end,
})

minetest.register_node("sia:chest", {
	description = "SIA Chest",
	tiles = {"sia_chest_top.png", "sia_chest_top.png", "sia_chest_side.png", "sia_chest_side.png", "sia_chest_side.png", "sia_chest_lock.png"},
	paramtype2 = "facedir",
	groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
	legacy_facedir_simple = true,
	sounds = default.node_sound_wood_defaults(),
	on_rotate = screwdriver.rotate_simple,
	on_construct = sia_chest.on_construct,
	on_receive_fields = sia_chest.on_receive_fields,
	can_dig = sia_chest.can_dig,
	after_place_node = sia_chest.after_place_node,
	allow_metadata_inventory_move = sia_chest.allow_metadata_inventory_move,
	allow_metadata_inventory_put = sia_chest.allow_metadata_inventory_put,
	allow_metadata_inventory_take = sia_chest.allow_metadata_inventory_take,
	on_metadata_inventory_move = sia_chest.on_metadata_inventory_move,
	on_metadata_inventory_put = sia_chest.on_metadata_inventory_put,
	on_metadata_inventory_take = sia_chest.on_metadata_inventory_take,
})

function sia.get_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"size[16,10]"..
		"list[nodemeta:".. spos .. ";main;0,0;16,5;]"..
		"list[current_player;main;4,6;8,4;]" ..
		"listring[]"
	return formspec
end

function sia.get_insert_formspec(pos)
	local spos = pos.x .. "," .. pos.y .. "," ..pos.z
	local formspec =
		"size[8,9]"..
		"label[0,0; Set the topic of the book to the players name]"..
		"label[1,0.5; that you are reporting and the date that you]".. 
		"label[1,1; are reporting it on.]"..
		"label[0,2; Set the body of the book to the reason that you]"..
		"label[1,2.5; are reporting him/her be it good or bad]"..
		"list[nodemeta:".. spos .. ";drop;5,3;1,1;]"..
		"label[0,3.25; Then put the book here]"..
		"image[4,3;1,1;sia_arrow.png]"..
		"list[current_player;main;0,5;8,4;]"..
		"listring[]"
	return formspec
end
