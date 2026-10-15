-- Полностью исправленный и стабильный скрипт для YBA
print("[YBA Script] Запуск инициализации...")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Список предметов для продажи
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

-- Функция отправки сигнала на сервер
local function sellItem(itemName)
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent", 5)
    if remote then
        remote:FireServer("EndDialogue", {
            ["NPC"] = "ShiftPlox, The Travelling Merchant",
            ["Option"] = "Sell " .. itemName,
            ["Dialogue"] = "Dialogue2"
        })
    end
end

-- Функция для добавления плавного перетаскивания (Замена устаревшего .Draggable)
local function makeDraggable(gui)
    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position

            input.Changed:Connect(function()
                if input.UserInputRelation == Enum.UserInputRelation.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Основная логика создания меню
local success, err = pcall(function()
    -- Удаляем старое меню, если оно зависло в памяти
    if CoreGui:FindFirstChild("YbaAutoSellMenu") then
        CoreGui.YbaAutoSellMenu:Destroy()
        print("[YBA Script] Старое меню успешно удалено из памяти.")
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "YbaAutoSellMenu"
    ScreenGui.ResetOnSpawn = false
    
    -- Безопасное подключение к CoreGui
    ScreenGui.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 260, 0, 130)
    Frame.Position = UDim2.new(0.5, -130, 0.4, -65)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Parent = ScreenGui

    -- Включаем современное перетаскивание
    makeDraggable(Frame)

    -- Делаем красивые скругленные углы у меню
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 8)
    uiCorner.Parent = Frame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "YBA AUTO-SELL MENU"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 220, 0, 45)
    Button.Position = UDim2.new(0, 20, 0, 55)
    Button.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
    Button.Text = "Продать все предметы"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 14
    Button.Parent = Frame

    -- Скругление для кнопки
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = Button
    
    -- Обработка клика
    Button.MouseButton1Click:Connect(function()
        Button.Text = "Продажа..."
        Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        
        local soldCount = 0

        for _, itemName in ipairs(sellableItems) do
            local itemInBackpack = LocalPlayer.Backpack:FindFirstChild(itemName)
            local itemInCharacter = LocalPlayer.Character:FindFirstChild(itemName)
            
            while itemInBackpack or itemInCharacter do
                sellItem(itemName)
                soldCount = soldCount + 1
                task.wait(0.15) -- Увеличил задержку для максимальной стабильности под нагрузкой
                
                itemInBackpack = LocalPlayer.Backpack:FindFirstChild(itemName)
                itemInCharacter = LocalPlayer.Character:FindFirstChild(itemName)
            end
        end

        Button.Text = "Успешно продано!"
        Button.BackgroundColor3 = Color3.fromRGB(50, 180, 50)
        task.wait(1.5)
        Button.Text = "Продать все предметы"
        Button.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
    end)

    print("[YBA Script] Графическое меню успешно создано и выведено на экран!")
end)

if not success then
    warn("[YBA Script] Ошибка при создании GUI: " .. tostring(err))
end
