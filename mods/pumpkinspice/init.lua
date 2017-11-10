-- PUMPKIN SPICE!!!

-- Spice
minetest.register_craftitem("pumpkinspice:pumpkinspice", {
	description = "Pumpkin Spice",
	inventory_image = "pumpkinspice.png"
})

minetest.register_craft({
	type = "shapeless",
	output = "pumpkinspice:pumpkinspice 2",
	recipe = {"farming:pumpkin_slice"},
})

-- Latte
minetest.register_craftitem("pumpkinspice:pumpkinspice_latte", {
	description = "Pumpkin Spice Latte",
	inventory_image = "pumpkinspice_latte.png",
	stack_max = 1,
	on_use = minetest.item_eat(15, "farming:drinking_cup"),
})

minetest.register_craft({
	type = "shapeless",
	output = "pumpkinspice:pumpkinspice_latte",
	recipe = {"farming:coffee_cup_hot", "pumpkinspice:pumpkinspice"}
})

-- Donut
minetest.register_craftitem("pumpkinspice:donut_pumpkinspice", {
	description = "Pumpkin Spice Donut",
	inventory_image = "donut_pumpkinspice.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craft({
	output = "pumpkinspice:donut_pumpkinspice",
	recipe = {
		{'pumpkinspice:pumpkinspice'},
		{'farming:donut'},
	}
})

-- Cookie
minetest.register_craftitem("pumpkinspice:pumpkinspice_cookie", {
	description = "Pumpkin Spice Cookie",
	inventory_image = "pumpkinspice_cookie.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	type = "shapeless",
	output = "pumpkinspice:pumpkinspice_cookie",
	recipe = {"farming:cookie", "pumpkinspice:pumpkinspice"}
})

-- Bread
minetest.register_craftitem("pumpkinspice:pumpkinspice_bread", {
	description = "Pumpkin Spice Bread",
	inventory_image = "pumpkinspice_bread.png",
	on_use = minetest.item_eat(6),
})

minetest.register_craft({
	type = "shapeless",
	output = "pumpkinspice:pumpkinspice_bread",
	recipe = {"farming:bread", "pumpkinspice:pumpkinspice"}
})

-- Muffins

-- base
minetest.register_craftitem("pumpkinspice:muffin", {
	description = "Muffin",
	inventory_image = "muffin_base.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	output = "pumpkinspice:muffin 2",
	recipe = {
		{"default:paper", "farming:bread", "default:paper"},
		{"default:paper", "farming:bread", "default:paper"},
	},
})

-- re-register blueberry
minetest.register_craftitem(":farming:muffin_blueberry", {
	description = "Blueberry Muffin",
	inventory_image = "farming_blueberry_muffin.png",
	on_use = minetest.item_eat(3),
})

minetest.register_craft({
	type = "shapeless",
	output = "farming:muffin_blueberry 2",
	recipe = {"farming:blueberries", "pumpkinspice:muffin"},
})

-- pumpkinspice muffin
minetest.register_craftitem("pumpkinspice:muffin_pumpkinspice", {
	description = "Pumpkin Spice Muffin",
	inventory_image = "muffin_pumpkinspice.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craft({
	type = "shapeless",
	output = "pumpkinspice:muffin_pumpkinspice 2",
	recipe = {"pumpkinspice:pumpkinspice", "pumpkinspice:muffin"},
})

-- Bagels

-- base
minetest.register_craftitem("pumpkinspice:bagel", {
	description = "Bagel",
	inventory_image = "bagel.png",
	on_use = minetest.item_eat(2),
})

minetest.register_craft({
	output = "pumpkinspice:bagel 5",
	recipe = {
		{"farming:bread", "farming:bread", "farming:bread"},
		{"farming:bread", "", "farming:bread"},
		{"farming:bread", "farming:bread", "farming:bread"},
	},
})

-- pumpkinspice bagel
minetest.register_craftitem("pumpkinspice:bagel_pumpkinspice", {
	description = "Pumpkin Spice Bagel",
	inventory_image = "pumpkinspice_bagel.png",
	on_use = minetest.item_eat(4),
})

minetest.register_craft({
	type = "shapeless",
	output = "pumpkinspice:bagel_pumpkinspice 2",
	recipe = {"pumpkinspice:pumpkinspice", "pumpkinspice:bagel"},
})

-- Cake

minetest.register_craftitem("pumpkinspice:pumpkinspice_cakebatter", {
	description = "Pumpkin Spice Cake Batter",
	inventory_image = "pumpkinspice_cakebatter.png",
})

minetest.register_craft({
	output = "pumpkinspice:pumpkinspice_cakebatter",
	recipe = {
		{"pumpkinspice:pumpkinspice", "pumpkinspice:pumpkinspice", "pumpkinspice:pumpkinspice"},
		{"farming:flour", "farming:sugar", "farming:flour"},
	},
})

pie.register_pie("pumpkinspicecake","Pumpkin Spice Cake","pumpkinspice")
minetest.register_craft({
    type = "cooking",
    output = "pumpkinspice:pumpkinspicecake_0",
    recipe = "pumpkinspice:pumpkinspice_cakebatter",
    cooktime = 25,
})
