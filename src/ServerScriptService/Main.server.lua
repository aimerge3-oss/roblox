local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local Modules = ReplicatedStorage:WaitForChild("Modules")
local Config = require(Modules:WaitForChild("Config"))
local NameGenerator = require(Modules:WaitForChild("NameGenerator"))
local RaritySystem = require(Modules:WaitForChild("RaritySystem"))

local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")
local GenerateName = Remotes:WaitForChild("GenerateName")
local SellName = Remotes:WaitForChild("SellName")
local BuyUpgrade = Remotes:WaitForChild("BuyUpgrade")
local UpdateCash = Remotes:WaitForChild("UpdateCash")
local UpdateSlots = Remotes:WaitForChild("UpdateSlots")
local BotSoldName = Remotes:WaitForChild("BotSoldName")
local ShowNotification = Remotes:WaitForChild("ShowNotification")

-- Простое хранилище в памяти (для теста). Потом можно подключить DataStore.
local playerData = {} -- [userId] = data

local function getDefaultData()
	return {
		cash = Config.StartingCash,
		slots = {}, -- список сгенерированных имён
		nextSlotId = 1,
		upgrades = {
			Slots = 1,
			AutoSniper = false,
			ZoneCom = false,
			ZoneAI = false,
			ZoneCrypto = false,
			Luck = 0,
		},
		lastGenerate = 0,
	}
end

local function getMaxSlots(data)
	return data.upgrades.Slots or 1
end

local function syncCash(player)
	local data = playerData[player.UserId]
	if data then
		UpdateCash:FireClient(player, data.cash)
	end
end

local function syncSlots(player)
	local data = playerData[player.UserId]
	if data then
		UpdateSlots:FireClient(player, data.slots)
	end
end

local function addCash(player, amount)
	local data = playerData[player.UserId]
	if not data then return end
	data.cash += amount
	syncCash(player)
end

-- ======================
-- Игрок зашёл
-- ======================
Players.PlayerAdded:Connect(function(player)
	playerData[player.UserId] = getDefaultData()
	task.wait(1) -- даём клиенту загрузиться
	syncCash(player)
	syncSlots(player)
	ShowNotification:FireClient(player, "Добро пожаловать в Domain & Handle Sniper!", "Common")
end)

Players.PlayerRemoving:Connect(function(player)
	playerData[player.UserId] = nil
end)

-- ======================
-- Генерация имени
-- ======================
GenerateName.OnServerEvent:Connect(function(player)
	local data = playerData[player.UserId]
	if not data then return end

	-- Кулдаун
	local now = os.clock()
	if now - data.lastGenerate < Config.GenerateCooldown then
		return
	end
	data.lastGenerate = now

	-- Проверяем свободные слоты
	if #data.slots >= getMaxSlots(data) then
		ShowNotification:FireClient(player, "Все слоты заняты! Продай что-нибудь.", "Common")
		return
	end

	local result = NameGenerator.Generate(data)

	-- Если Rare или Legendary — бот сразу выкупает
	if RaritySystem.IsHighValue(result.rarity) then
		addCash(player, result.price)
		BotSoldName:FireClient(player, result.name, result.price, result.rarity)
		ShowNotification:FireClient(player, "Бот-коллекционер выкупил " .. result.name .. "!", result.rarity)
	else
		-- Кладём в слот
		local slot = {
			id = data.nextSlotId,
			name = result.name,
			rarity = result.rarity,
			price = result.price,
			zone = result.zone,
		}
		data.nextSlotId += 1
		table.insert(data.slots, slot)
		syncSlots(player)
	end
end)

-- ======================
-- Продажа имени
-- ======================
SellName.OnServerEvent:Connect(function(player, slotId)
	local data = playerData[player.UserId]
	if not data then return end

	for i, slot in ipairs(data.slots) do
		if slot.id == slotId then
			addCash(player, slot.price)
			table.remove(data.slots, i)
			syncSlots(player)
			ShowNotification:FireClient(player, "Продано: " .. slot.name .. " за " .. slot.price, slot.rarity)
			return
		end
	end
end)

-- ======================
-- Покупка апгрейдов
-- ======================
BuyUpgrade.OnServerEvent:Connect(function(player, upgradeName)
	local data = playerData[player.UserId]
	if not data then return end

	local upgradesConfig = Config.Upgrades[upgradeName]
	if not upgradesConfig then return end

	local currentLevel = 0
	if upgradeName == "Slots" then
		currentLevel = data.upgrades.Slots or 1
	elseif upgradeName == "Luck" then
		currentLevel = data.upgrades.Luck or 0
	elseif upgradeName == "AutoSniper" then
		currentLevel = data.upgrades.AutoSniper and 1 or 0
	elseif upgradeName == "ZoneCom" then
		currentLevel = data.upgrades.ZoneCom and 1 or 0
	elseif upgradeName == "ZoneAI" then
		currentLevel = data.upgrades.ZoneAI and 1 or 0
	elseif upgradeName == "ZoneCrypto" then
		currentLevel = data.upgrades.ZoneCrypto and 1 or 0
	end

	local nextLevelData = nil
	for _, lvl in ipairs(upgradesConfig) do
		if lvl.level == currentLevel + 1 then
			nextLevelData = lvl
			break
		end
	end

	if not nextLevelData then
		ShowNotification:FireClient(player, "Максимальный уровень!", "Common")
		return
	end

	if data.cash < nextLevelData.price then
		ShowNotification:FireClient(player, "Недостаточно денег!", "Common")
		return
	end

	data.cash -= nextLevelData.price

	if upgradeName == "Slots" then
		data.upgrades.Slots = nextLevelData.value
	elseif upgradeName == "Luck" then
		data.upgrades.Luck = nextLevelData.value
	elseif upgradeName == "AutoSniper" then
		data.upgrades.AutoSniper = nextLevelData.value
	elseif upgradeName == "ZoneCom" then
		data.upgrades.ZoneCom = nextLevelData.value
	elseif upgradeName == "ZoneAI" then
		data.upgrades.ZoneAI = nextLevelData.value
	elseif upgradeName == "ZoneCrypto" then
		data.upgrades.ZoneCrypto = nextLevelData.value
	end

	syncCash(player)
	ShowNotification:FireClient(player, "Апгрейд куплен: " .. upgradeName, "Uncommon")
end)

-- ======================
-- Авто-снайпер (простая версия)
-- ======================
task.spawn(function()
	while true do
		task.wait(4)
		for _, player in ipairs(Players:GetPlayers()) do
			local data = playerData[player.UserId]
			if data and data.upgrades.AutoSniper then
				if #data.slots < getMaxSlots(data) then
					local result = NameGenerator.Generate(data)
					if RaritySystem.IsHighValue(result.rarity) then
						addCash(player, result.price)
						BotSoldName:FireClient(player, result.name, result.price, result.rarity)
					else
						local slot = {
							id = data.nextSlotId,
							name = result.name,
							rarity = result.rarity,
							price = result.price,
							zone = result.zone,
						}
						data.nextSlotId += 1
						table.insert(data.slots, slot)
						syncSlots(player)
					end
				end
			end
		end
	end
end)

print("[Domain & Handle Sniper] Server started")
