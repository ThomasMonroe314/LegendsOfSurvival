minetest.log("Loading trashmouth")
-- Minetest 0.4.10+ mod: trashmouth
-- punish player for cursing by disconnecting them
--
--  Created in 2015 by Andrey. 
--  This mod is Free and Open Source Software, released under the LGPL 2.1 or later.
-- 
-- See README.txt for more information.
-- Horribly hacked by ExeterDad to work as pretty much a different mod.

trashmouth = {}

-- text file trashmouth.simplemask. Table bad words
dofile(minetest.get_modpath("trashmouth").."/curse_words.lua")

--[[
	Take all brunt of checking for bad words.
	Returns true if bad words found, kicks if kick_on_trashtalk enabled.
--]]

trashmouth.check_message = function(name, message)
    local checkingmessage=string.lower( message .." " )
    for i=1, #trashmouth.simplemask do
        if string.find(checkingmessage, trashmouth.simplemask[i], 1, true) ~=nil then
			return true -- bad words found
        end
    end
    return false
end


minetest.register_on_chat_message(function(name, message)
    if trashmouth.check_message(name, message) then
        minetest.kick_player(name, "[MOD TRASHMOUTH] You said a bad word in chat! Let's keep it clean!")
        minetest.chat_send_all("[MOD TRASHMOUTH] Player "..name.." got kicked for foul language in open chat." )
        minetest.log("action", "[MOD TRASHMOUTH] Player "..name.." got kicked for foul language in open chat: "..message)
        return true
    end
    --[[
    -- Disallow ALL CAPS in chat.
    -- fails with russian
    if string.upper( message ) == message and string.len (message) >= 6 then
    	minetest.chat_send_player(name, "[MOD TRASHMOUTH] Chatting in ALL CAPS isn't allowed in HOMETOWN, please try again.")
    	minetest.log("action", "[MOD TRASHMOUTH] Player "..name.." warned for ALL CAPS: "..message)
    	return true
    end
    --]]
end)

if minetest.chatcommands["me"] then
    local old_command = minetest.chatcommands["me"].func
    minetest.chatcommands["me"].func = function(name, param)
        if trashmouth.check_message(name, param) then
            minetest.kick_player(name, "[MOD TRASHMOUTH] You said a bad word with the /me command. Let's keep it clean!")
            minetest.chat_send_all("[MOD TRASHMOUTH] Player "..name.." got kicked for foul language using /me command." )
            minetest.log("action", "[MOD TRASHMOUTH] Player <"..name.."> got kicked for foul language. (/me) Msg:"..param)
            return
        end       
        return old_command(name, param)
    end
end

if minetest.chatcommands["msg"] then
    local old_command = minetest.chatcommands["msg"].func
    minetest.chatcommands["msg"].func = function(name, param)
        if trashmouth.check_message(name, param) then
            minetest.kick_player(name, "[MOD TRASHMOUTH] You said a bad word in a PM! Let's keep it clean!")
            minetest.chat_send_all("[MOD TRASHMOUTH] Player "..name.." got kicked for foul language in a PM." )
            minetest.log("action", "[MOD TRASHMOUTH] Player "..name.." got kicked for foul language in a PM. Msg :"..param)
            return
        end        
        return old_command(name, param)
    end
end
