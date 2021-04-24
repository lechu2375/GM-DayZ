ix.currency.symbol = ""
ix.currency.singular = ""
ix.currency.plural = "RU"

ix.config.SetDefault("font", "Jura")
ix.config.SetDefault("genericFont", "Malgun Gothic")
ix.config.SetDefault("music", "music/hl2_song19.mp3")
ix.config.Set("maxAttributes", 0)
ix.config.Set("maxCharacters", 1)
ix.config.Set("allowVoice", true)
ix.config.SetDefault("communityURL", "https://steamcommunity.com/id/meow1337")
ix.config.Set("weaponAlwaysRaised", true)
ix.config.SetDefault("color", Color(75, 119, 190, 255))
ix.config.Set("thirdperson", true)

ix.config.Add("jumpStamina", 10, "How much stamina jumpes use up.", nil, {
	data = {min = 0, max = 100},
	category = "characters"
})

-- unload plugins
local noLoad = {
	saveitems = true,
	recognition = true,
	wepselect = true
}

function Schema:InitializedPlugins()
	local unloaded = ix.data.Get("unloaded", {}, true, true)

	for uniqueID in pairs(noLoad) do
		if (!unloaded[uniqueID]) then
			ix.plugin.SetUnloaded(uniqueID, true)
		end
	end

	do
		if (CLIENT) then
			for _, ITEM in pairs(ix.item.list) do
				if (ITEM.base == "base_ammo") then
					function ITEM:PaintOver(item, w, h)
						draw.SimpleText(item.ammoAmount, "ixMerchant.Num", 1, 5, Color(100, 255, 100), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black)
					end
				end
			end
		end
	end
end

Schema.countryIcon = {
	w = 16,
	h = 11
}

-- PreDrawOutlines
Schema.outlineItems = {
	["ix_item"] = true,
	["gmodz_grave"] = true,
	["ix_money"] = true,
	["ix_shipment"] = true
}

if (CLIENT) then
	ix.option.Add("minimalTooltips", ix.type.bool, true, {
		category = "appearance"
	})
end