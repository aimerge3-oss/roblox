# Domain & Handle Sniper

Симулятор перекупщика цифровых имён и доменов для Roblox.

## Как работает
- Генерируешь случайные имена (Telegram-каналы, сайты, игровые теги)
- Обычные имена продаются дёшево
- Редкие 3-буквенные имена сразу выкупает бот-коллекционер за миллионы
- Прокачка: слоты генерации, авто-снайпер, доступ к премиум-зонам (.com, .ai, .crypto)

## Установка в Roblox Studio

1. Создай новый Place
2. Создай папки точно как в структуре ниже
3. Скопируй содержимое файлов в соответствующие Script / ModuleScript / LocalScript
4. Создай RemoteEvents в `ReplicatedStorage/RemoteEvents`

### Структура в Roblox Studio

```
ReplicatedStorage
├── Modules
│   ├── Config (ModuleScript)
│   ├── NameGenerator (ModuleScript)
│   └── RaritySystem (ModuleScript)
└── RemoteEvents (Folder)
    ├── GenerateName (RemoteEvent)
    ├── SellName (RemoteEvent)
    ├── BuyUpgrade (RemoteEvent)
    ├── UpdateCash (RemoteEvent)
    ├── UpdateSlots (RemoteEvent)
    ├── BotSoldName (RemoteEvent)
    └── ShowNotification (RemoteEvent)

ServerScriptService
├── Main (Script)
└── PlayerData (Script) — сохранение

StarterGui
└── MainGUI (ScreenGui)
    └── Client (LocalScript)

StarterPlayer
└── StarterPlayerScripts
    └── (пусто, всё в GUI)
```

## Быстрый старт
1. Создай все RemoteEvents
2. Вставь модули
3. Вставь серверные скрипты
4. Создай простой UI (или используй готовый Client-скрипт — он создаёт элементы динамически)
5. Нажми Play

## Баланс (можно менять в Config.lua)
- Шанс Rare (3 буквы): 8%
- Шанс Legendary: 2%
- Бот выкупает Rare и Legendary автоматически

Удачной разработки!
