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
    identity = {
        color = {a = 255, r = 255, g = 255, b = 255},
        bgcolor = false,
    },

    combine = function(nametag_attributes1, nametag_attributes2)
        if nametag_attributes1.hide_all or nametag_attributes2.hide_all then
            return {
                text = "",
                color = {a = 0, r = 255, g = 255, b = 255},
                bgcolor = {a = 0, r = 255, g = 255, b = 255},
                hide_all = true,
            }
        else
            local bgcolor
            if nametag_attributes2.bgcolor == nil then
                bgcolor = nametag_attributes1.bgcolor
            else
                bgcolor = nametag_attributes2.bgcolor
            end

            return {
                text = table.concat(
                    remove_empty({nametag_attributes1.text, nametag_attributes2.text}),
                    nametag_attributes2.text_separator or name_monoid.settings.text_separator
                ),
                color = nametag_attributes1.color or nametag_attributes2.color,
                bgcolor = bgcolor,
            }
        end
    end,

    fold = function(values)
        local nametag_attributes1 = table.copy(name_monoid.monoid_def.identity)
        for _, nametag_attributes2 in pairs(values) do
            nametag_attributes1 = name_monoid.monoid_def.combine(nametag_attributes1, nametag_attributes2)
        end
        return nametag_attributes1
    end,

    apply = function(nametag_attributes, player)
        player:set_nametag_attributes({
            text = nametag_attributes.text,
            color = nametag_attributes.color,
            bgcolor = nametag_attributes.bgcolor or false,
        })
    end,
}

name_monoid.monoid = player_monoids.make_monoid(name_monoid.monoid_def)
