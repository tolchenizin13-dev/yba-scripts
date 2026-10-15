-- Стабильный шаблон создания GUI в Roblox Studio
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Безопасно получаем доступ к контейнеру интерфейса игрока
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 5)

if not PlayerGui then
    warn("Ошибка: Не удалось дождаться загрузки PlayerGui")
    return
end

-- Функция создания интерфейса, обернутая в pcall для защиты от вылетов
local success, err = pcall(function()
    -- Очищаем старую копию меню, если она была
    if PlayerGui:FindFirstChild("SafeDeveloperMenu") then
        PlayerGui.SafeDeveloperMenu:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SafeDeveloperMenu"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 260, 0, 120)
    Frame.Position = UDim2.new(0.5, -130, 0.4, -60)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "DEVELOPER GUI (STABLE)"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 14
    Title.BackgroundTransparency = 1
    Title.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 220, 0, 45)
    Button.Position = UDim2.new(0, 20, 0, 50)
    Button.BackgroundColor3 = Color3.fromRGB(80, 60, 200)
    Button.Text = "Взаимодействовать"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSans
    Button.TextSize = 16
    Button.Parent = Frame
    
    Button.MouseButton1Click:Connect(function()
        print("Кнопка легального интерфейса успешно нажата!")
    end)
end)

if not success then
    warn("Критическая ошибка при создании GUI: " .. tostring(err))
end
