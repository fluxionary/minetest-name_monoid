local modname = minetest.get_current_modname()
local modpath = minetest.get_modpath(modname)
local S = minetest.get_translator(modname)

name_monoid = {
	version = os.time({year = 2022, month = 5, day = 22}),
	fork = "fluxionary",

	modname = modname,
	modpath = modpath,

	S = S,

	log = function(level, message_fmt, ...)
		local message = message_fmt:format(...)
		minetest.log(level, ("[%s] %s"):format(modname, message))
	end,

	dofile = function(...)
		dofile(table.concat({modpath, ...}, DIR_DELIM) .. ".lua")
	end,
}

name_monoid.dofile("settings")
name_monoid.dofile("monoid")

minetest.register_on_joinplayer(function(player)
	if name_monoid.settings.show_name then
		name_monoid.monoid:add_change(player, {text = player:get_player_name()}, "name_monoid")
	else
		name_monoid.monoid:add_change(player, {text = "", text_separator = ""}, "name_monoid")
	end
end)
