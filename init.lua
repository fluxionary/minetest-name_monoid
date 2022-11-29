name_monoid = fmod.create()

name_monoid.dofile("monoid")

minetest.register_on_joinplayer(function(player)
	if name_monoid.settings.show_name then
		name_monoid.monoid:add_change(player, { order = 0, text = player:get_player_name() }, "name_monoid")
	else
		name_monoid.monoid:add_change(player, { text = "", text_separator = "" }, "name_monoid")
	end
end)
