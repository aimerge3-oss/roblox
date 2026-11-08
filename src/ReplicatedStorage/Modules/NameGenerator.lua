local Config = require(script.Parent.Config)

local NameGenerator = {}

local consonants = {"b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z"}
local vowels = {"a","e","i","o","u"}
local commonWords = {
	"cat", "dog", "sun", "moon", "star", "fire", "ice", "dark", "light", "pro",
	"max", "neo", "zen", "fox", "wolf", "bear", "king", "queen", "lord", "god",
	"ai", "bot", "dev", "code", "hack", "crypto", "moon", "pump", "ape", "gem",
	"vip", "og", "x", "z", "q", "v", "777", "xxx", "pro", "hub", "net"
}

local function randomLetter(isVowel)
	local list = isVowel and vowels or consonants
	return list[math.random(1, #list)]
end

local function generateShortName(length)
	if length == 3 and math.random() < 0.35 then
		-- иногда берём реальное короткое слово
		local word = commonWords[math.random(1, #commonWords)]
		if #word == 3 then return word end
	end

	local name = ""
	local startWithVowel = math.random() < 0.4
	for i = 1, length do
		local useVowel = (i % 2 == 1) == startWithVowel
		name = name .. randomLetter(useVowel)
	end
	return name
end

local function generateLongName()
	local patterns = {
		function() return generateShortName(math.random(4, 6)) end,
		function() return generateShortName(3) .. math.random(10, 99) end,
		function() return generateShortName(4) .. "_" .. generateShortName(3) end,
		function()
			local w = commonWords[math.random(1, #commonWords)]
			return w .. math.random(1, 999)
		end,
	}
	return patterns[math.random(1, #patterns)]()
end

function NameGenerator.Generate(playerData)
	local luckBonus = 0
	if playerData and playerData.upgrades and playerData.upgrades.Luck then
		luckBonus = playerData.upgrades.Luck or 0
	end

	-- Определяем редкость с учётом удачи
	local roll = math.random(1, 100)
	local rarity = "Common"

	local rareChance = Config.RarityChances.Rare + luckBonus
	local legendaryChance = Config.RarityChances.Legendary + math.floor(luckBonus / 2)

	if roll <= legendaryChance then
		rarity = "Legendary"
	elseif roll <= legendaryChance + rareChance then
		rarity = "Rare"
	elseif roll <= legendaryChance + rareChance + Config.RarityChances.Uncommon then
		rarity = "Uncommon"
	else
		rarity = "Common"
	end

	-- Генерируем имя в зависимости от редкости
	local name
	if rarity == "Legendary" then
		name = generateShortName(math.random(2, 3))
	elseif rarity == "Rare" then
		name = generateShortName(3)
	else
		name = generateLongName()
	end

	-- Добавляем зону
	local zone = "default"
	local availableZones = {"default"}

	if playerData and playerData.upgrades then
		if playerData.upgrades.ZoneCom then table.insert(availableZones, "com") end
		if playerData.upgrades.ZoneAI then table.insert(availableZones, "ai") end
		if playerData.upgrades.ZoneCrypto then table.insert(availableZones, "crypto") end
	end

	zone = availableZones[math.random(1, #availableZones)]
	local suffixes = Config.ZoneSuffixes[zone] or Config.ZoneSuffixes.default
	local suffix = suffixes[math.random(1, #suffixes)]

	local fullName = name .. suffix

	-- Цена
	local priceRange = Config.BasePrices[rarity]
	local basePrice = math.random(priceRange.min, priceRange.max)
	local mult = Config.ZoneMultipliers[zone] or 1
	local finalPrice = math.floor(basePrice * mult)

	return {
		name = fullName,
		rarity = rarity,
		price = finalPrice,
		zone = zone,
	}
end

return NameGenerator
