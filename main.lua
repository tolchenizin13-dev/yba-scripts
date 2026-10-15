-- Список предметов, которые можно продавать (и их официальные игровые названия)
local sellableItems = {
    "Mysterious Arrow",
    "Rokakaka",
    "Pure Rokakaka",
    "Rib Cage of The Saint's Corpse",
    "Left Arm of The Saint's Corpse",
    "Green Baby",
    "Diamond",
    "Gold Coin",
    "Ancient Scroll",
    "DIO's Diary",
    "Quinton's Glove",
    "Steel Ball",
    "Stone Mask",
    "Zeppelin's Headband"
}

local player = game:GetService("Players").LocalPlayer

-- Функция для моментальной продажи одного предмета через RemoteEvent игры
local function sellItem(itemName)
    -- YBA использует событие EndDialogue для завершения сделки с торговцем ShiftPlox
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
    
    -- Отправляем серверу сигнал на продажу конкретного предмета
    remote:FireServer("EndDialogue", {
        ["NPC"] = "ShiftPlox, The Travelling Merchant",
        ["Option"] = "Sell " .. itemName,
        ["Dialogue"] = "Dialogue2"
    })
end

-- Основной цикл: проверяем инвентарь и продаем все доступные копии
print("[Auto-Sell] Запуск моментальной продажи предметов...")

for _, itemName in ipairs(sellableItems) do
    -- Ищем предмет в рюкзаке (Backpack) или прямо в руках персонажа
    local itemInBackpack = player.Backpack:FindFirstChild(itemName)
    local itemInCharacter = player.Character:FindFirstChild(itemName)
    
    -- Пока у нас есть этот предмет, отправляем запросы на продажу
    while itemInBackpack or itemInCharacter do
        sellItem(itemName)
        task.wait(0.1) -- Небольшая задержка, чтобы сервер YBA не кикнул за слишком частые запросы (Spam Remote)
        
        -- Обновляем проверку наличия предмета
        itemInBackpack = player.Backpack:FindFirstChild(itemName)
        itemInCharacter = player.Character:FindFirstChild(itemName)
    end
end

print("[Auto-Sell] Все возможные предметы успешно проданы!")
