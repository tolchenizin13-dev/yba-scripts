-- ==========================================
-- ЮБА ИНСТАНТ СЕЛЛЕР: ОСНОВНОЙ МОДУЛЬ (v1.0)
-- ==========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- Список предметов YBA для продажи
local MerchantItems = {
    ["Mysterious Arrow"] = true, ["Rokakaka"] = true, ["Gold Coin"] = true,
    ["Diamond"] = true, ["Quinton's Glove"] = true, ["Zepelli's Hat"] = true,
    ["Ancient Scroll"] = true, ["Pure Rokakaka"] = true
}

-- Динамический поиск сетевого ивента YBA
local function GetYbaRemote()
    local Remote = ReplicatedStorage:FindFirstChild("RemoteEvent") or ReplicatedStorage:FindFirstChild("DialogueTrigger")
    if not Remote then
        for _, obj in ipairs(ReplicatedStorage:GetChildren()) do
            if obj:IsA("RemoteEvent") and (obj.Name:match("Dialogue") or obj.Name:match("Merchant")) then
                Remote = obj
                break
            end
        end
    end
    return Remote
end

-- Функция оптовой продажи
local function SellAllItems()
    local Remote = GetYbaRemote()
    if not Remote then return false end

    local Backpack = LocalPlayer:FindFirstChild("Backpack")
    local PlayerGuiData = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Inventory")

    local function Process(container)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and MerchantItems[item.Name] then
                pcall(function()
                    Remote:FireServer("EndDialogue", {
                        ["NPC"] = "Merchant",
                        ["Option"] = "Sell " .. item.Name,
                        ["Item"] = item
                    })
                end)
                task.wait(0.1) -- Безопасный интервал защиты от античита
            end
        end
    end

    Process(Backpack)
    Process(PlayerGuiData)
    return true
end

-- Создание полноценного GUI разработчика
local function CreateUi()
    if CoreGui:FindFirstChild("CustomYbaSeller") then CoreGui.CustomYbaSeller:Destroy() end

    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "CustomYbaSeller"

    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 250, 0, 110)
    Main.Position = UDim2.new(0.5, -125, 0.4, -55)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true -- Перетаскивание меню

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Text = "DEVELOPER PROJECT: YBA"
    Title.TextColor3 = Color3.fromRGB(150, 100, 255)
    Title.Font = Enum.Font.Code
    Title.TextSize = 14
    Title.BackgroundTransparency = 1

    local ActionBtn = Instance.new("TextButton", Main)
    ActionBtn.Size = UDim2.new(0, 210, 0, 45)
    ActionBtn.Position = UDim2.new(0, 20, 0, 45)
    ActionBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    ActionBtn.Text = "[ EXECUTE BULK SELL ]"
    ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActionBtn.Font = Enum.Font.Code
    ActionBtn.TextSize = 13

    Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 4)

    ActionBtn.MouseButton1Click:Connect(function()
        ActionBtn.Text = "WORKING..."
        ActionBtn.TextColor3 = Color3.fromRGB(255, 200, 0)
        
        local res = SellAllItems()
        
        if res then
            ActionBtn.Text = "SUCCESSFULLY SOLD"
            ActionBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
        else
            ActionBtn.Text = "ERROR: EVENT NOT FOUND"
            ActionBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        end
        
        task.wait(1.5)
        ActionBtn.Text = "[ EXECUTE BULK SELL ]"
        ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)
end

-- Запуск интерфейса после загрузки
CreateUi()
print("[LOG]: Основной скрипт YBA успешно инициализирован.")
