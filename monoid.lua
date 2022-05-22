local function remove_empty(t)
    local t2 = {}
    for _, v in pairs(t) do
        if v then
            table.insert(t2, v)
        end
    end
    return t2
end

name_monoid.monoid_def = {
    identity = {},
    combine = function(tag_desc1, tag_desc2)
        if tag_desc1.hide_all or tag_desc2.hide_all then
            return {
                tag = "",
                hide_all = true
            }
        end

        return {
            tag = table.concat(
                remove_empty({tag_desc1.tag, tag_desc2.tag}),
                tag_desc2.separator or name_monoid.settings.separator
            )
        }
    end,
    fold = function(values)
        local tag_desc1 = table.copy(name_monoid.monoid_def.identity)
        for _, tag_desc2 in ipairs(values) do
            tag_desc1 = name_monoid.monoid_def.combine(tag_desc1, tag_desc2)
        end
        return tag_desc1
    end,
    apply = function(tag_desc, player)
        player:set_nametag_attributes({text=tag_desc.tag})
    end,
}

name_monoid.monoid = player_monoids.make_monoid(name_monoid.monoid_def)
