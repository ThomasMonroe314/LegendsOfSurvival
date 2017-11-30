
minetest.register_tool("octutool:pick", {
	description = "Octu Pickaxe",
	inventory_image = "octu_pick_pick.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=3,
		groupcaps={
			cracky={times={[1]=2.0, [2]=1.0, [3]=0.5}, uses=60, maxlevel=3},
			crumbly={times={[1]=2.0, [2]=1.0, [3]=0.5}, uses=60, maxlevel=3},
			snappy={times={[1]=2.0, [2]=1.0, [3]=0.5}, uses=60, maxlevel=3}
		}
	},
})
minetest.register_tool("octutool:shovel", {
	description = "Octu Shovel",
	inventory_image = "octu_shovel_shovel.png",
	tool_capabilities = {
		max_drop_level=1,
		groupcaps={
			crumbly={times={[1]=1.0, [2]=1.0, [3]=1.0}, uses=60, maxlevel=2}
		}
	},
})
minetest.register_tool("octutool:axe", {
	description = "Octu Axe",
	inventory_image = "octu_axe_axe.png",
	tool_capabilities = {
		max_drop_level=1,
		groupcaps={
			choppy={times={[1]=3.00, [2]=1.60, [3]=1.00}, uses=60, maxlevel=2},
			fleshy={times={[2]=1.0, [3]=1.0}, uses=60, maxlevel=1}
		}
	},
})
minetest.register_tool("octutool:sword", {
	description = "Octu Sword",
	inventory_image = "octu_sword_sword.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=1,
		groupcaps={
			fleshy={times={[1]=2.00, [2]=0.80, [3]=0.40}, uses=10, maxlevel=2},
			snappy={times={[2]=0.70, [3]=0.30}, uses=40, maxlevel=1},
			choppy={times={[3]=0.70}, uses=40, maxlevel=0}
		}
	}
})
minetest.register_node("octutool:mese", {
	description = "Octu Super Mese",
	tiles = {"octu_mese.png"},
	is_ground_content = true,
	groups = {cracky=1},
	sounds = default.node_sound_defaults(),
})

minetest.register_node("octutool:string", {
	description = "String",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"octu_string.png"},
	inventory_image = "octu_string.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3,flammable=2},
	sounds = default.node_sound_defaults(),
})
minetest.register_node("octutool:string_shards", {
	description = "String Shards",
	drawtype = "plantlike",
	visual_scale = 1.0,
	tiles = {"octu_stringshards.png"},
	inventory_image = "octu_stringshards.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	groups = {fleshy=3,dig_immediate=3,flammable=2},
	sounds = default.node_sound_defaults(),

})
minetest.register_node("octutool:ladder", {
	description = "Octu Ladder",
	drawtype = "signlike",
	tiles = {"octu_ladder.png"},
	inventory_image = "octu_ladder.png",
	wield_image = "octu_ladder.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	is_ground_content = true,
	walkable = false,
	climbable = true,
	selection_box = {
		type = "wallmounted",
		--wall_top = = <default>
		--wall_bottom = = <default>
		--wall_side = = <default>
	},
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=3,flammable=2},
	legacy_wallmounted = true,
	sounds = default.node_sound_wood_defaults(),
})
minetest.register_node("octutool:box", {
	tiles = {"octu_cart_bottom.png", "octu_cart_side.png", "octu_cart_side.png", "octu_cart_side.png", "octu_cart_side.png"},
        paramtype = "light",
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.45, -0.5, 0.5, 0.5, -0.5+1/16},
			{-0.5, -0.45, -0.5, -0.5+1/16, 0.5, 0.5},
			{0.5, -0.5, 0.5, -0.5, 0.5, 0.5-1/16},
			{0.5, -0.5, 0.5, 0.5-1/16, 0.5, -0.5},

			{-0.5, -0.5, -0.5, 0.5, -0.3, 0.5},
		},
	},
	groups = {oddly_breakable_by_hand=3, not_in_creative_inventory=1},
})
minetest.register_craft({
	output = 'octutool:pick',
	recipe = {
		{'wool:blue', 'octutool:mese', 'octutool:mese'},
		{'', 'default:stick', ''},
		{'', 'default:stick', ''},
	}
})
minetest.register_craft({
	output = 'octutool:mese',
	recipe = {
		{'', '', ''},
		{'default:mese', 'default:mese', ''},
		{'default:mese', 'default:mese', ''},
	}
})
minetest.register_craft({
	output = 'octutool:shovel',
	recipe = {
		{'', 'octutool:mese', ''},
		{'', 'default:stick', ''},
		{'', 'default:stick', ''},
	}
})
minetest.register_craft({
	output = 'octutool:axe',
	recipe = {
		{'octutool:mese', 'octutool:mese', ''},
		{'wool:blue', 'default:stick', ''},
		{'', 'default:stick', ''},
	}
})
minetest.register_craft({
	output = 'octutool:axe',
	recipe = {
		{'octutool:mese', 'octutool:mese', ''},
		{'wool:blue', 'default:stick', ''},
		{'', 'default:stick', ''},
	}
})
minetest.register_craft({
	output = 'octutool:string_shards',
	recipe = {
		{'', 'default:leaves', ''},
		{'default:leaves', '', ''},
		{'', 'default:leaves', ''},
	}
})
minetest.register_craft({
	type = "cooking",
	output = "octutool:string 9",
	recipe = "octutool:string_shards",
})
minetest.register_craft({
	output = 'octutool:ladder',
	recipe = {
		{'octutool:string', '', 'octutool:string'},
		{'octutool:string', 'octutool:string', 'octutool:string'},
		{'octutool:string', '', 'octutool:string'},
	}
})
minetest.register_craft({
	output = 'octutool:box',
	recipe = {
		{'default:wood', '', 'default:wood'},
		{'default:wood', 'default:wood', 'default:wood'},
		{'default:wood', 'default:wood', 'default:wood'},
	}
})


