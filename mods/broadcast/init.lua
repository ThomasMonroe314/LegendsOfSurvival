minetest.register_chatcommand("broadcast", {
	params = "<msg>",
	description = "Broadcast a message serverwide",
	privs = {kick = true},

	func = function(name, param)

		minetest.chat_send_all(minetest.get_color_escape_sequence("#00ff00").."[Broadcast] "..param)

	end
})

minetest.register_chatcommand("warn", {
	params = "<msg>",
	description = "Send a warning serverwide",
	privs = {kick = true},

	func = function(name, param)

		minetest.chat_send_all(minetest.get_color_escape_sequence("#ff0000").."[Warning] "..param)

	end
})
