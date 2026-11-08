local Config = {}

-- Экономика
Config.StartingCash = 500

-- Генерация
Config.MaxSlotsBase = 1
Config.GenerateCooldown = 1.2 -- секунды

-- Редкости и шансы (в сумме = 100)
Config.RarityChances = {
	Common = 70,
	Uncommon = 20,
	Rare = 8,       -- 3-буквенные
	Legendary = 2,  -- ультра-короткие + премиум
}

-- Базовые цены
Config.BasePrices = {
	Common = {min = 15, max = 80},
	Uncommon = {min = 120, max = 450},
	Rare = {min = 2500, max = 12000},
	Legendary = {min = 50000, max = 350000},
}

-- Множители зон
Config.ZoneMultipliers = {
	default = 1.0,
	com = 1.4,
	ai = 2.1,
	crypto = 3.5,
}

-- Апгрейды
Config.Upgrades = {
	Slots = {
		{level = 1, price = 0, value = 1},
		{level = 2, price = 2500, value = 2},
		{level = 3, price = 12000, value = 3},
		{level = 4, price = 45000, value = 4},
		{level = 5, price = 150000, value = 5},
	},
	AutoSniper = {
		{level = 0, price = 0, value = false},
		{level = 1, price = 35000, value = true},
	},
	ZoneCom = {
		{level = 0, price = 0, value = false},
		{level = 1, price = 8000, value = true},
	},
	ZoneAI = {
		{level = 0, price = 0, value = false},
		{level = 1, price = 45000, value = true},
	},
	ZoneCrypto = {
		{level = 0, price = 0, value = false},
		{level = 1, price = 180000, value = true},
	},
	Luck = { -- увеличивает шанс Rare/Legendary
		{level = 0, price = 0, value = 0},
		{level = 1, price = 20000, value = 3},
		{level = 2, price = 75000, value = 6},
		{level = 3, price = 250000, value = 10},
	},
}

-- Названия зон для генерации
Config.ZoneSuffixes = {
	default = {"", "_ch", "_tg", "_gg"},
	com = {".com", ".net", ".org"},
	ai = {".ai", ".io", ".gg"},
	crypto = {".crypto", ".eth", ".sol", ".btc"},
}

return Config
