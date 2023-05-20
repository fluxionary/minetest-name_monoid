local component_separator = name_monoid.settings.component_separator
local invert_composition = name_monoid.settings.invert_composition

name_monoid.monoid_def = {
	identity = {
		color = { a = 255, r = 255, g = 255, b = 255 },
		bgcolor = false,
	},

	combine = function(nametag_attributes1, nametag_attributes2)
		if nametag_attributes1.hide_all or nametag_attributes2.hide_all then
			return {
				hide_all = true,
			}
		end

		local bgcolor, color, texts

		if invert_composition then
			if nametag_attributes1.bgcolor == nil then
				bgcolor = nametag_attributes2.bgcolor
			else
				bgcolor = nametag_attributes1.bgcolor
			end

			color = nametag_attributes1.color or nametag_attributes2.color
		else
			if nametag_attributes2.bgcolor == nil then
				bgcolor = nametag_attributes1.bgcolor
			else
				bgcolor = nametag_attributes2.bgcolor
			end

			color = nametag_attributes2.color or nametag_attributes1.color
		end

		if nametag_attributes2._texts then
			texts = nametag_attributes2._texts

			if nametag_attributes1._texts then
				table.insert_all(texts, nametag_attributes1._texts)
			elseif nametag_attributes1.text then
				table.insert(texts, {
					text = nametag_attributes1.text,
					text_separator = nametag_attributes1.text_separator,
					order = nametag_attributes1.order,
				})
			end
		elseif nametag_attributes1._texts then
			texts = nametag_attributes1._texts

			if nametag_attributes2._texts then
				table.insert_all(texts, nametag_attributes2._texts)
			elseif nametag_attributes2.text then
				table.insert(texts, {
					text = nametag_attributes2.text,
					text_separator = nametag_attributes2.text_separator,
					order = nametag_attributes2.order,
				})
			end
		else
			texts = {}

			if nametag_attributes1.text then
				table.insert(texts, {
					text = nametag_attributes1.text,
					text_separator = nametag_attributes1.text_separator,
					order = nametag_attributes1.order,
				})
			end

			if nametag_attributes2.text then
				table.insert(texts, {
					text = nametag_attributes2.text,
					text_separator = nametag_attributes2.text_separator,
					order = nametag_attributes2.order,
				})
			end
		end

		return {
			bgcolor = bgcolor,
			color = color,
			_texts = texts,
		}
	end,

	fold = function(values)
		local nametag_attributes1 = table.copy(name_monoid.monoid_def.identity)
		for _, nametag_attributes2 in pairs(values) do
			nametag_attributes1 = name_monoid.monoid_def.combine(nametag_attributes1, nametag_attributes2)
		end
		return nametag_attributes1
	end,

	apply = function(nametag_attributes, player)
		if nametag_attributes.hide_all then
			player:set_nametag_attributes({
				text = " ",
				color = { a = 0, r = 0, g = 0, b = 0 },
				bgcolor = { a = 0, r = 0, g = 0, b = 0 },
			})
		else
			local text
			if nametag_attributes._texts then
				local texts = nametag_attributes._texts
				if invert_composition then
					table.sort(texts, function(a, b)
						if a.order and b.order then
							return b.order < a.order
						elseif b.order then
							return true
						elseif a.order then
							return false
						end

						return false
					end)
				else
					table.sort(texts, function(a, b)
						if a.order and b.order then
							return a.order < b.order
						elseif a.order then
							return true
						elseif b.order then
							return false
						end

						return true
					end)
				end

				local parts = {}
				for i = 1, #texts do
					table.insert(parts, texts[i].text)
					if i < #texts then
						table.insert(parts, texts[i].text_separator or component_separator)
					end
				end

				text = table.concat(parts, "")
			else
				text = nametag_attributes.text
			end

			if text == "" then
				player:set_nametag_attributes({
					text = " ",
					color = { a = 0, r = 0, g = 0, b = 0 },
					bgcolor = { a = 0, r = 0, g = 0, b = 0 },
				})
			else
				player:set_nametag_attributes({
					text = text,
					color = nametag_attributes.color,
					bgcolor = nametag_attributes.bgcolor or false,
				})
			end
		end
	end,
}

name_monoid.monoid = player_monoids.make_monoid(name_monoid.monoid_def)
