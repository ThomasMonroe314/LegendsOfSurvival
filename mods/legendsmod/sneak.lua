minetest.register_on_joinplayer(function(player)
    minetest.after(1, function(player)
        player:set_physics_override({
            sneak = true,
            sneak_glitch = true,
        })
    end, player)
end)
