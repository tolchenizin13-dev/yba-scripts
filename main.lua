-- Шаблон создания графического интерфейса (GUI) в Roblox Studio
-- Этот скрипт помещается в StarterPlayer -> StarterPlayerScripts или StarterGui

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Ожидаем загрузки интерфейса игрока
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- 1. Создаем контейнер для интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ExampleProjectUi"
ScreenGui.ResetOnSpawn = false -- Меню не пропадет при перезагрузке персонажа
ScreenGui.Parent = PlayerGui

-- 2. Создаем главное окно
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 120)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -60) -- Центрирование на экране
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Скругление углов окна
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- 3. Добавляем текстовый заголовок
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "PROJECT MENU"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextSize = 16
TitleLabel.Parent = MainFrame

-- 4. Добавляем функциональную кнопку
local ActionButton = Instance.new("TextButton")
ActionButton.Name = "ActionButton"
ActionButton.Size = UDim2.new(0, 210, 0, 45)
ActionButton.Position = UDim2.new(0, 25, 0, 50)
ActionButton.BackgroundColor3 = Color3.fromRGB(70, 50, 150)
ActionButton.Text = "НАЖМИ МЕНЯ"
ActionButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ActionButton.Font = Enum.Font.SourceSansBold
ActionButton.TextSize = 14
ActionButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 6)
BtnCorner.Parent = ActionButton

-- 5. Обработка нажатия на кнопку
ActionButton.MouseButton1Click:Connect(function()
    ActionButton.Text = "ВЫПОЛНЕНО"
    ActionButton.BackgroundColor3 = Color3.fromRGB(40, 150, 80)
    
    -- Здесь описывается легальная логика вашей игры
    print("Кнопка интерфейса была успешно нажата игроком: " .. LocalPlayer.Name)
    
    task.wait(1.5)
    ActionButton.Text = "НАЖМИ МЕНЯ"
    ActionButton.BackgroundColor3 = Color3.fromRGB(70, 50, 150)
end)
