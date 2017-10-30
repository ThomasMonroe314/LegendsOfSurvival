minetest.register_privilege("lava", {description = "Can use lava buckets.",give_to_singleplayer = false})

local old_lava_bucket_place = minetest.registered_items["bucket:bucket_lava"].on_place

minetest.override_item("bucket:bucket_lava", {
	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type == "object" then
			pointed_thing.ref:punch(user, 1.0, { full_punch_interval=1.0 }, nil)
			return user:get_wielded_item()
		elseif pointed_thing.type ~= "node" then
			-- do nothing if it's neither object nor node
			return
		end
		--node = minetest.get_node(pointed_thing.under)
		if not minetest.check_player_privs(placer:get_player_name(),
				{lava = true}) and pointed_thing.above.y > 0 then
			minetest.chat_send_player(placer:get_player_name(),"You dont have permission to place lava above sea level (missing privledges: lava)")
			return itemstack
		else
			return old_lava_bucket_place(itemstack, placer, pointed_thing)
		end
	end,
})
