--[[

Infinite Chest for Minetest

Copyright (c) 2012 cornernote, Brett O'Donnell <cornernote@gmail.com>
Source Code: https://github.com/cornernote/minetest-infinite_chest
License: GPLv3
tweaked by me CalebDavis to fit my mod
API

]]--


sia_chest = {}

sia_chest.log = function(message)
	minetest.log("action", message)
end

sia_chest.formspec = function(pos,page)
	local formspec = "size[15,11]"
		.."button[12,10;1,0.5;go;Go]"
	if page=="main" then
		local meta = minetest.env:get_meta(pos)
		local pages = sia_chest.get_pages(meta)
		local x,y = 0,0
		local p
		for i = #pages,1,-1 do
			p = pages[i]
			x = x+2
			if x == 16 then
				y = y+1
				x = 2
			end
			formspec = formspec .."button["..(x-1.5)..","..(y+1)..";1.5,0.5;jump;"..p.."]"
		end
		if #pages == 0 then
			formspec = formspec
				.."label[4,3.5; --== SIA Chest ==--]"
				.."label[4,4.5; Create one page per player reported in this catagory!]"
				.."label[4,5.0; Simply enter the players name in the field]"
				.."label[4,5.5; then click Go.]"
		end
		return formspec
			.."field[10.5,10.1;2,1;page;;]"
			.."label[0,0;SIA Chest]"
	end
	return formspec
		.."field[10.5,10.1;2,1;page;;"..page.."]"
		.."label[0,0;SIA Chest - page: " .. page .. "]"
		.."button[13,10;2,0.5;back;Back]"
		.."button[13,6.5;2,0.5;delete;Delete]"
		.."list[current_name;"..page..";0,1;15,5;]"
		.."list[current_player;main;0,7;8,4;]"
		.."listring[]"
end

sia_chest.get_pages = function(meta)
	local invs = meta:get_string("sia_chest_list")
	local pages = {}
	for p in string.gmatch(invs, "[^%s]+") do
		table.insert(pages,p)
	end
	return pages
end

sia_chest.add_page = function(pos,page)
	local meta = minetest.env:get_meta(pos)
	local invs = meta:get_string("sia_chest_list")
	local pages = {}
	for p in string.gmatch(invs, "[^%s]+") do
		if page ~= p then
			table.insert(pages,p)
		end
	end
	table.insert(pages,page)
	invs = ""
	for i,p in pairs(pages) do
		invs = invs .." ".. p
	end
	meta:set_string("sia_chest_list",invs)
	meta:get_inventory():set_size(page, 15*5)
end

sia_chest.remove_page = function(pos,page)
	local meta = minetest.env:get_meta(pos)
	local invs = meta:get_string("sia_chest_list")
	local inv = meta:get_inventory()
	if not inv:is_empty(page) then
		return
	end
	local pages = {}
	for p in string.gmatch(invs, "[^%s]+") do
		if page ~= p then
			table.insert(pages,p)
		end
	end
	invs = ""
	for i,p in pairs(pages) do
		invs = invs .." ".. p
	end
	meta:set_string("sia_chest_list",invs)
	return true
end

sia_chest.on_receive_fields = function(pos, formname, fields, sender)
	local meta = minetest.env:get_meta(pos)
	local page
	if fields.go ~= nil and fields.page ~= "" then
		page = string.lower(string.gsub(fields.page, "%W", "_"))
	end
	if fields.jump ~= nil then
		page = fields.jump
	end
	if page ~= nil then
		sia_chest.add_page(pos,page)
		meta:set_string("formspec", sia_chest.formspec(pos,page))
		return
	end
	if fields.delete ~= nil then
		if not sia_chest.remove_page(pos,fields.page) then
			minetest.chat_send_player(sender:get_player_name(), "cannot delete \""..fields.page.."\" - page is not empty")
			return
		end
	end
	meta:set_string("formspec", sia_chest.formspec(pos,"main"))
end

sia_chest.on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("formspec", sia_chest.formspec(pos,"main"))
	meta:set_string("infotext", "sia Chest")
end

sia_chest.can_dig = function(pos,player)
	local meta = minetest.env:get_meta(pos);
	local pages = sia_chest.get_pages(meta)
	local inv = meta:get_inventory()
	for i,page in pairs(pages) do
		if not inv:is_empty(page) then
			minetest.chat_send_player(player:get_player_name(), "cannot dig - page \""..page.."\" is not empty")
			return false
		end
	end
	if sia.is_member(player:get_player_name())==false then 
		return false
	end
	return true
end

sia_chest.after_place_node = function(pos, placer)
	local meta = minetest.env:get_meta(pos)
	meta:set_string("infotext", "SIA Chest Top Secret")
end

sia_chest.allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.env:get_meta(pos)
	if not sia_chest.has_locked_chest_privilege(meta, player) then
		sia_chest.log(player:get_player_name().." tried to access an sia chest at "..minetest.pos_to_string(pos))
		return 0
	end
	return count
end

sia_chest.allow_metadata_inventory_put = function(pos, listname, index, stack, player)
	local meta = minetest.env:get_meta(pos)
	if not sia_chest.has_locked_chest_privilege(meta, player) then
		sia_chest.log(player:get_player_name().." tried to access an sia chest belonging to at "..minetest.pos_to_string(pos))
		return 0
	end
	return stack:get_count()
end

sia_chest.allow_metadata_inventory_take = function(pos, listname, index, stack, player)
	local meta = minetest.env:get_meta(pos)
	if not sia_chest.has_locked_chest_privilege(meta, player) then
		sia_chest.log(player:get_player_name()..
				" tried to access an sia chest at "..minetest.pos_to_string(pos))
		return 0
	end
	return stack:get_count()
end

sia_chest.has_locked_chest_privilege = function(meta, player)
	local name = player:get_player_name()
	if sia.is_member(player:get_player_name()) then
		return true
	end
	return false
end

sia_chest.on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
	sia_chest.log(player:get_player_name().." moves stuff in sia chest at "..minetest.pos_to_string(pos))
end

sia_chest.on_metadata_inventory_put = function(pos, listname, index, stack, player)
	sia_chest.log(player:get_player_name().." moves stuff to sia chest at "..minetest.pos_to_string(pos))
end

sia_chest.on_metadata_inventory_take = function(pos, listname, index, stack, player)
	sia_chest.log(player:get_player_name().." takes stuff from sia chest at "..minetest.pos_to_string(pos))
end
