--[[
timed server shutdown mod for minetest
by shivajiva101@hotmail.com

Useage: you can set a value in minetest.conf, the default length is ~24 hours
        minus 30 seconds.
  e.g. ts.duration = 86360
  should be used in conjunction with a shell script that restarts the server

]]

local duration = minetest.setting_get("ts.duration") or 86370 -- 23h 59m 30s

local function chatsend(txt)
  minetest.chat_send_all(txt)
end

local function notify()
  minetest.after(0, chatsend, "Daily restart in 30 seconds\nThe server will take ~30s to reload")
  minetest.after(10, chatsend, "restarting in 20 seconds")
  minetest.after(20, chatsend, "restarting in 10 seconds")
  minetest.after(25, chatsend, "restarting in 5 seconds")
  -- kick all player with a message
  minetest.after(29, function()
    chatsend("kicking players...")
    for _,player in ipairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		-- player potentially attached to an entity
		player:set_detach()
		minetest.kick_player(name, name.." please rejoin in 30 seconds")
    end
	minetest.request_shutdown()
  end)
end

minetest.after(duration, notify)
