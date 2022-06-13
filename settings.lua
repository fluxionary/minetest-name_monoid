local s = minetest.settings

name_monoid.settings = {
    tag_separator = s:get("name_monoid.tag_separator") or " ",
    show_name = s:get_bool("name_monoid.show_name", true),
    invert_composition = s:get_bool("name_monoid.invert_composition", false),
}
