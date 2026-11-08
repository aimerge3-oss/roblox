-- Client LocalScript (положи внутрь MainGUI)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local MainGUI = script.Parent

-- Создаём UI программно, чтобы не пришлось вручную расставлять всё в Studio
local function createUI()
	-- Очищаем на всякий случай
	for _, child in ipairs(MainGUI:GetChildren()) do
		if not child:IsA("LocalScript") then
			child:Destroy()
		end
	end

	-- Currency
	local CurrencyFrame = Instance.new("Frame")
	CurrencyFrame.Name = "CurrencyFrame"
	CurrencyFrame.Size = UDim2.new(0.22, 0, 0.07, 0)
	CurrencyFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
	CurrencyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
	CurrencyFrame.BorderSizePixel = 0
	CurrencyFrame.Parent = MainGUI
	Instance.new("UICorner", CurrencyFrame).CornerRadius = UDim.new(0, 12)

	local CashLabel = Instance.new("TextLabel")
	CashLabel.Name = "CashLabel"
	CashLabel.Size = UDim2.new(1, -16, 1, -8)
	CashLabel.Position = UDim2.new(0, 8, 0, 4)
	CashLabel.BackgroundTransparency = 1
	CashLabel.Text = "💰 500"
	CashLabel.TextColor3 = Color3.fromRGB(255, 220, 50)
	CashLabel.TextScaled = true
	CashLabel.Font = Enum.Font.GothamBold
	CashLabel.Parent = CurrencyFrame

	-- Generate Button
	local GenerateButton = Instance.new("TextButton")
	GenerateButton.Name = "GenerateButton"
	GenerateButton.Size = UDim2.new(0.28, 0, 0.09, 0)
	GenerateButton.Position = UDim2.new(0.36, 0, 0.02, 0)
	GenerateButton.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
	GenerateButton.Text = "СГЕНЕРИРОВАТЬ ИМЯ"
	GenerateButton.TextColor3 = Color3.new(1, 1, 1)
	GenerateButton.TextScaled = true
	GenerateButton.Font = Enum.Font.GothamBold
	GenerateButton.Parent = MainGUI
	Instance.new("UICorner", GenerateButton).CornerRadius = UDim.new(0, 12)

	-- Upgrade Button
	local UpgradeButton = Instance.new("TextButton")
	UpgradeButton.Name = "UpgradeButton"
	UpgradeButton.Size = UDim2.new(0.18, 0, 0.08, 0)
	UpgradeButton.Position = UDim2.new(0.80, 0, 0.02, 0)
	UpgradeButton.BackgroundColor3 = Color3.fromRGB(140, 80, 220)
	UpgradeButton.Text = "Апгрейды"
	UpgradeButton.TextColor3 = Color3.new(1, 1, 1)
	UpgradeButton.TextScaled = true
	UpgradeButton.Font = Enum.Font.GothamBold
	UpgradeButton.Parent = MainGUI
	Instance.new("UICorner", UpgradeButton).CornerRadius = UDim.new(0, 12)

	-- Slots Frame
	local sSlots = Instance.new("ScrollingFrame")
	sSlots.Name = "SlotsFrame"
	sSlots.Size = UDim2.new(0.55, 0, 0.55, 0)
	sSlots.Position = UDim2.new(0.225, 0, 0.14, 0)
	sSlots.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	sSlots.BorderSizePixel = 0
	sSlots.ScrollBarThickness = 6
	sSlots.CanvasSize = UDim2.new(0, 0, 0, 0)
	sSlots.AutomaticCanvasSize = Enum.AutomaticSize.Y
	sSlots.Parent = MainGUI
	Instance.new("UICorner", sSlots).CornerRadius = UDim.new(0, 14)

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = sSlots

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 8)
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = sSlots

	-- Log Frame
	local LogFrame = Instance.new("ScrollingFrame")
	LogFrame.Name = "LogFrame"
	LogFrame.Size = UDim2.new(0.35, 0, 0.25, 0)
	LogFrame.Position = UDim2.new(0.63, 0, 0.72, 0)
	LogFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
	LogFrame.BorderSizePixel = 0
	LogFrame.ScrollBarThickness = 4
	LogFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	LogFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	LogFrame.Parent = MainGUI
	Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0, 12)

	local logLayout = Instance.new("UIListLayout")
	logLayout.Padding = UDim.new(0, 4)
	logLayout.Parent = LogFrame

	local logPadding = Instance.new("UIPadding")
	logPadding.PaddingTop = UDim.new(0, 6)
	logPadding.PaddingLeft = UDim.new(0, 8)
	logPadding.Parent = LogFrame

	-- Upgrade Frame (скрытый)
	local UpgradeFrame = Instance.new("Frame")
	UpgradeFrame.Name = "UpgradeFrame"
	UpgradeFrame.Size = UDim2.new(0.45, 0, 0.6, 0)
	UpgradeFrame.Position = UDim2.new(0.275, 0, 0.2, 0)
	UpgradeFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
	UpgradeFrame.BorderSizePixel = 0
	UpgradeFrame.Visible = false
	UpgradeFrame.Parent = MainGUI
	Instance.new("UICorner", UpgradeFrame).CornerRadius = UDim.new(0, 16)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0.1, 0)
	title.BackgroundTransparency = 1
	title.Text = "Апгрейды"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBold
	title.Parent = UpgradeFrame

	local CloseButton = Instance.new("TextButton")
	CloseButton.Name = "CloseButton"
	CloseButton.Size = UDim2.new(0.12, 0, 0.08, 0)
	CloseButton.Position = UDim2.new(0.85, 0, 0.02, 0)
	CloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	CloseButton.Text = "X"
	CloseButton.TextColor3 = Color3.new(1, 1, 1)
	CloseButton.TextScaled = true
	CloseButton.Font = Enum.Font.GothamBold
	CloseButton.Parent = UpgradeFrame
	Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)

	local UpgradesList = Instance.new("ScrollingFrame")
	UpgradesList.Name = "UpgradesList"
	UpgradesList.Size = UDim2.new(0.9, 0, 0.8, 0)
	UpgradesList.Position = UDim2.new(0.05, 0, 0.15, 0)
	UpgradesList.BackgroundTransparency = 1
	UpgradesList.ScrollBarThickness = 6
	UpgradesList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	UpgradesList.Parent = UpgradeFrame

	local upLayout = Instance.new("UIListLayout")
	upLayout.Padding = UDim.new(0, 10)
	upLayout.Parent = UpgradesList

	-- Notification template
	local NotificationFrame = Instance.new("Frame")
	NotificationFrame.Name = "NotificationFrame"
	NotificationFrame.Size = UDim2.new(0, 300, 0, 50)
	NotificationFrame.Position = UDim2.new(0.5, -150, 0, -60)
	NotificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
	NotificationFrame.BorderSizePixel = 0
	NotificationFrame.Visible = false
	NotificationFrame.Parent = MainGUI
	Instance.new("UICorner", NotificationFrame).CornerRadius = UDim.new(0, 10)

	return {
		CashLabel = CashLabel,
		GenerateButton = GenerateButton,
		UpgradeButton = UpgradeButton,
		SlotsFrame = sSlots,
		LogFrame = LogFrame,
		UpgradeFrame = UpgradeFrame,
		CloseButton = CloseButton,
		UpgradesList = UpgradesList,
		NotificationFrame = NotificationFrame,
	}
end

local ui = createUI()

-- RemoteEvents
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")
local GenerateName = Remotes:WaitForChild("GenerateName")
local SellName = Remotes:WaitForChild("SellName")
local BuyUpgrade = Remotes:WaitForChild("BuyUpgrade")
local UpdateCash = Remotes:WaitForChild("UpdateCash")
local UpdateSlots = Remotes:WaitForChild("UpdateSlots")
local BotSoldName = Remotes:WaitForChild("BotSoldName")
local ShowNotification = Remotes:WaitForChild("ShowNotification")

local RarityColors = {
	Common = Color3.fromRGB(180, 180, 180),
	Uncommon = Color3.fromRGB(80, 200, 120),
	Rare = Color3.fromRGB(80, 140, 255),
	Legendary = Color3.fromRGB(255, 170, 0),
}

-- Уведомления
local function showNotification(text, color)
	local notif = ui.NotificationFrame:Clone()
	notif.Name = "TempNotif"
	notif.Parent = MainGUI
	notif.Visible = true
	notif.BackgroundColor3 = color or Color3.fromRGB(40, 40, 50)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -16, 1, -8)
	label.Position = UDim2.new(0, 8, 0, 4)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = notif

	notif.Position = UDim2.new(0.5, -150, 0, -60)
	local tweenIn = TweenService:Create(notif, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
		Position = UDim2.new(0.5, -150, 0, 20)
	})
	tweenIn:Play()

	task.delay(2.8, function()
		local tweenOut = TweenService:Create(notif, TweenInfo.new(0.3), {
			Position = UDim2.new(0.5, -150, 0, -80),
			BackgroundTransparency = 1
		})
		tweenOut:Play()
		tweenOut.Completed:Wait()
		notif:Destroy()
	end)
end

UpdateCash.OnClientEvent:Connect(function(amount)
	ui.CashLabel.Text = "💰 " .. tostring(amount)
end)

local function createSlot(slotData)
	local slot = Instance.new("Frame")
	slot.Name = "Slot_" .. slotData.id
	slot.Size = UDim2.new(1, -10, 0, 70)
	slot.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
	slot.BorderSizePixel = 0
	slot.Parent = ui.SlotsFrame
	Instance.new("UICorner", slot).CornerRadius = UDim.new(0, 10)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.55, 0, 0.5, 0)
	nameLabel.Position = UDim2.new(0.03, 0, 0.08, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = slotData.name
	nameLabel.TextColor3 = RarityColors[slotData.rarity] or Color3.new(1,1,1)
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = slot

	local infoLabel = Instance.new("TextLabel")
	infoLabel.Size = UDim2.new(0.55, 0, 0.35, 0)
	infoLabel.Position = UDim2.new(0.03, 0, 0.55, 0)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Text = slotData.rarity .. "  •  " .. slotData.price .. " 💰"
	infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	infoLabel.TextScaled = true
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextXAlignment = Enum.TextXAlignment.Left
	infoLabel.Parent = slot

	local sellBtn = Instance.new("TextButton")
	sellBtn.Size = UDim2.new(0.35, 0, 0.7, 0)
	sellBtn.Position = UDim2.new(0.62, 0, 0.15, 0)
	sellBtn.BackgroundColor3 = Color3.fromRGB(60, 160, 80)
	sellBtn.Text = "Продать"
	sellBtn.TextColor3 = Color3.new(1,1,1)
	sellBtn.TextScaled = true
	sellBtn.Font = Enum.Font.GothamBold
	sellBtn.Parent = slot
	Instance.new("UICorner", sellBtn).CornerRadius = UDim.new(0, 8)

	sellBtn.MouseButton1Click:Connect(function()
		SellName:FireServer(slotData.id)
	end)
end

UpdateSlots.OnClientEvent:Connect(function(slots)
	for _, child in ipairs(ui.SlotsFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	for _, slotData in ipairs(slots) do
		createSlot(slotData)
	end
end)

ui.GenerateButton.MouseButton1Click:Connect(function()
	GenerateName:FireServer()
end)

BotSoldName.OnClientEvent:Connect(function(name, price, rarity)
	local logEntry = Instance.new("TextLabel")
	logEntry.Size = UDim2.new(1, -10, 0, 28)
	logEntry.BackgroundTransparency = 1
	logEntry.Text = "🤖 Бот выкупил: " .. name .. " за " .. price .. " 💰"
	logEntry.TextColor3 = RarityColors[rarity] or Color3.new(1,1,1)
	logEntry.TextScaled = true
	logEntry.Font = Enum.Font.Gotham
	logEntry.TextXAlignment = Enum.TextXAlignment.Left
	logEntry.Parent = ui.LogFrame

	local logs = {}
	for _, c in ipairs(ui.LogFrame:GetChildren()) do
		if c:IsA("TextLabel") then table.insert(logs, c) end
	end
	if #logs > 10 then logs[1]:Destroy() end

	showNotification("Бот-коллекционер выкупил " .. name .. "!", RarityColors[rarity])
end)

ShowNotification.OnClientEvent:Connect(function(text, colorName)
	local color = RarityColors[colorName] or Color3.fromRGB(60, 60, 70)
	showNotification(text, color)
end)

-- Магазин апгрейдов
local upgradeButtons = {
	{name = "Slots", title = "+1 Слот генерации"},
	{name = "Luck", title = "Удача (шанс Rare+)"},
	{name = "AutoSniper", title = "Авто-Снайпер"},
	{name = "ZoneCom", title = "Зона .com"},
	{name = "ZoneAI", title = "Зона .ai"},
	{name = "ZoneCrypto", title = "Зона .crypto"},
}

for _, info in ipairs(upgradeButtons) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 50)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
	btn.Text = info.title
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.Parent = ui.UpgradesList
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

	btn.MouseButton1Click:Connect(function()
		BuyUpgrade:FireServer(info.name)
	end)
end

ui.UpgradeButton.MouseButton1Click:Connect(function()
	ui.UpgradeFrame.Visible = not ui.UpgradeFrame.Visible
end)

ui.CloseButton.MouseButton1Click:Connect(function()
	ui.UpgradeFrame.Visible = false
end)

print("[Domain & Handle Sniper] Client loaded")
