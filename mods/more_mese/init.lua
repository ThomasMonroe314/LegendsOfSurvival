-- mese
-- hard mese
-- hot mese
-- super mese
-- extreme mese
-- legendary mese

minetest.register_node("more_mese:hard_mese",{
	description = "Hard Mese",
	tiles = {"hard_mese_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
	stack_max = 999,
})
minetest.register_node("more_mese:hot_mese",{
	description = "Hot Mese",
	tiles = {"hot_mese_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
	stack_max = 500,
})
minetest.register_node("more_mese:super_mese",{
	description = "Super Mese",
	tiles = {"super_mese_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
	stack_max = 250,
})
minetest.register_node("more_mese:extreme_mese",{
	description = "Extreme Mese",
	tiles = {"extreme_mese_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
	stack_max = 125,
})
minetest.register_node("more_mese:legendary_mese",{
	description = "Legendary Mese",
	tiles = {"legendary_mese_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
})
--   crafting   --

minetest.register_craft({
	output = 'more_mese:hard_mese',
	recipe = {
		{'default:mese', 'default:mese', 'default:mese'},
		{'default:mese', 'default:mese', 'default:mese'},
		{'default:mese', 'default:mese', 'default:mese'},
	}
})

minetest.register_craft({
	output = 'more_mese:hot_mese',
	recipe = {
		{'more_mese:hard_mese', 'more_mese:hard_mese', 'more_mese:hard_mese'},
		{'more_mese:hard_mese', 'more_mese:hard_mese', 'more_mese:hard_mese'},
		{'more_mese:hard_mese', 'more_mese:hard_mese', 'more_mese:hard_mese'},
	}
})

minetest.register_craft({
	output = 'more_mese:super_mese',
	recipe = {
		{'more_mese:hot_mese', 'more_mese:hot_mese', 'more_mese:hot_mese'},
		{'more_mese:hot_mese', 'more_mese:hot_mese', 'more_mese:hot_mese'},
		{'more_mese:hot_mese', 'more_mese:hot_mese', 'more_mese:hot_mese'},
	}
})

minetest.register_craft({
	output = 'more_mese:extreme_mese',
	recipe = {
		{'more_mese:super_mese', 'more_mese:super_mese', 'more_mese:super_mese'},
		{'more_mese:super_mese', 'more_mese:super_mese', 'more_mese:super_mese'},
		{'more_mese:super_mese', 'more_mese:super_mese', 'more_mese:super_mese'},
	}
})

minetest.register_craft({
	output = 'more_mese:legendary_mese',
	recipe = {
		{'more_mese:extreme_mese', 'more_mese:extreme_mese', 'more_mese:extreme_mese'},
		{'more_mese:extreme_mese', 'more_mese:extreme_mese', 'more_mese:extreme_mese'},
		{'more_mese:extreme_mese', 'more_mese:extreme_mese', 'more_mese:extreme_mese'},
	}
})
-- reverse crafting recipes --
minetest.register_craft({
	output = "default:mese 9",
	recipe = {{'more_mese:hard_mese'}},
})
minetest.register_craft({
	output = 'more_mese:hard_mese 9',
	recipe = {{'more_mese:hot_mese'}},
})
minetest.register_craft({
	output = 'more_mese:hot_mese 9',
	recipe = {{'more_mese:super_mese'}},
})
minetest.register_craft({
	output = 'more_mese:super_mese 9',
	recipe = {{'more_mese:extreme_mese'}},
})
minetest.register_craft({
	output = 'more_mese:extreme_mese 9',
	recipe = {{'more_mese:legendary_mese'}},
})
