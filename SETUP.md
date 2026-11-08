# Подробная инструкция по установке

## 1. Создай Place в Roblox Studio

## 2. Создай структуру папок

### ReplicatedStorage
1. Создай Folder → назови `Modules`
2. Внутри Modules создай 3 ModuleScript:
   - Config
   - NameGenerator
   - RaritySystem
3. Создай Folder → назови `RemoteEvents`
4. Внутри RemoteEvents создай RemoteEvent с именами:
   - GenerateName
   - SellName
   - BuyUpgrade
   - UpdateCash
   - UpdateSlots
   - BotSoldName
   - ShowNotification

### ServerScriptService
1. Создай Script → назови `Main`
2. Вставь код из `src/ServerScriptService/Main.server.lua`

### StarterGui
1. Создай ScreenGui → назови `MainGUI`
2. Внутри MainGUI создай LocalScript → назови `Client`
3. Вставь код из `src/StarterGui/MainGUI/Client.client.lua`

## 3. Готово
Нажми Play. Всё должно работать.

UI создаётся полностью из кода — ничего руками расставлять не нужно.

## Что можно улучшить потом
- DataStore для сохранения прогресса
- Более красивый магазин апгрейдов с ценами
- Звуки и эффекты при редких дропах
- Лидерборд самых дорогих имён
- Торговля между игроками
