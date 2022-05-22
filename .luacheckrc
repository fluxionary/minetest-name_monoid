
unused_args = false

globals = {
	"name_monoid",
}

read_globals = {
	-- Stdlib
	string = {fields = {"split"}},
	table = {fields = {"copy", "getn"}},

	-- Minetest
	"vector", "ItemStack",
	"dump", "VoxelArea",
	"DIR_DELIM",

	-- deps
	"minetest",
	"player_monoids",
}
