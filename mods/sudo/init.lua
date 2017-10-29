minetest.register_privilege("sudo", {description = "Allows you to run a command in another players name", give_to_singleplayer = false})



minetest.register_chatcommand("sudo", {
	privs = {sudo = true},
	description = "Run a command in another players name",
	params = "<name> <command> <command's params>",
	func = function(name,param)
		local targetname, command_full = param:match("^(%S+)%s(.+)$")
		local command, params = command_full:match("^(%S+)%s*(.*)$")
		local commands = minetest.registered_chatcommands
		local comm = commands[command]
		if comm then
			local bool, reply = comm.func(targetname, params)
			if reply then
				minetest.chat_send_player(name, reply)
				minetest.chat_send_player(targetname, reply)
			end
		else
			minetest.chat_send_player(name, command.." is not a command")
		end
	end
})
