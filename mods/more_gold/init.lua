-- 9 gold ingots -> gold block
-- 9 gold blocks -> refined gold
-- 9 refined gold -> purified gold
-- 9 purified gold -> radiant gold
-- 9 radiant gold -> true gold
-- 9 true gold -> Legendary gold
-- 9^6 gold ingots() = 1 Legendary gold

minetest.register_node("more_gold:refined_gold",{
	description = "Refined Gold",
	tiles = {"refined_gold_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
	stack_max = 999,
})
minetest.register_node("more_gold:purified_gold",{
	description = "Purified Gold",
	tiles = {"purified_gold_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
	stack_max = 500,
})
minetest.register_node("more_gold:radiant_gold",{
	description = "Radiant Gold",
	tiles = {"radiant_gold_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
	stack_max = 250,
})
minetest.register_node("more_gold:true_gold",{
	description = "True Gold",
	tiles = {"true_gold_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
	stack_max = 125,
})
minetest.register_node("more_gold:legendary_gold",{
	description = "Legendary Gold",
	tiles = {"legendary_gold_block.png"},
	is_ground_content = false,
	groups = {cracky = 1},
	sounds = default.node_sound_metal_defaults(),
})
--   crafting   --

minetest.register_craft({
	output = 'more_gold:refined_gold',
	recipe = {
		{'default:goldblock', 'default:goldblock', 'default:goldblock'},
		{'default:goldblock', 'default:goldblock', 'default:goldblock'},
		{'default:goldblock', 'default:goldblock', 'default:goldblock'},
	}
})

minetest.register_craft({
	output = 'more_gold:purified_gold',
	recipe = {
		{'more_gold:refined_gold', 'more_gold:refined_gold', 'more_gold:refined_gold'},
		{'more_gold:refined_gold', 'more_gold:refined_gold', 'more_gold:refined_gold'},
		{'more_gold:refined_gold', 'more_gold:refined_gold', 'more_gold:refined_gold'},
	}
})

minetest.register_craft({
	output = 'more_gold:radiant_gold',
	recipe = {
		{'more_gold:purified_gold', 'more_gold:purified_gold', 'more_gold:purified_gold'},
		{'more_gold:purified_gold', 'more_gold:purified_gold', 'more_gold:purified_gold'},
		{'more_gold:purified_gold', 'more_gold:purified_gold', 'more_gold:purified_gold'},
	}
})

minetest.register_craft({
	output = 'more_gold:true_gold',
	recipe = {
		{'more_gold:radiant_gold', 'more_gold:radiant_gold', 'more_gold:radiant_gold'},
		{'more_gold:radiant_gold', 'more_gold:radiant_gold', 'more_gold:radiant_gold'},
		{'more_gold:radiant_gold', 'more_gold:radiant_gold', 'more_gold:radiant_gold'},
	}
})

minetest.register_craft({
	output = 'more_gold:legendary_gold',
	recipe = {
		{'more_gold:true_gold', 'more_gold:true_gold', 'more_gold:true_gold'},
		{'more_gold:true_gold', 'more_gold:true_gold', 'more_gold:true_gold'},
		{'more_gold:true_gold', 'more_gold:true_gold', 'more_gold:true_gold'},
	}
})
