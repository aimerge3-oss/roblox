local RaritySystem = {}

RaritySystem.Colors = {
	Common = Color3.fromRGB(180, 180, 180),
	Uncommon = Color3.fromRGB(80, 200, 120),
	Rare = Color3.fromRGB(80, 140, 255),
	Legendary = Color3.fromRGB(255, 170, 0),
}

RaritySystem.Order = {
	Common = 1,
	Uncommon = 2,
	Rare = 3,
	Legendary = 4,
}

function RaritySystem.GetColor(rarity)
	return RaritySystem.Colors[rarity] or Color3.fromRGB(200, 200, 200)
end

function RaritySystem.IsHighValue(rarity)
	return rarity == "Rare" or rarity == "Legendary"
end

return RaritySystem
