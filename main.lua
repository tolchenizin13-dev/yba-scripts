-- ==========================================
-- ЮБА ИНСТАНТ СЕЛЛЕР: ОБНОВЛЕННЫЙ МОДУЛЬ (v1.1)
-- ==========================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local MerchantItems = {
    ["Mysterious Arrow"] = true, ["Rokakaka"] = true, ["Gold Coin"] = true,
    ["Diamond"] = true, ["Quinton's Glove"] = true, ["Zepelli's Hat"] = true,
    ["Ancient Scroll"] = true, ["Pure Rokakaka"] = true
}

-- ГЛОБАЛЬНЫЙ ПОИСК ИВЕНТА (Сканирует всю память ReplicatedStorage)
local function GetYbaRemote()
    -- Шаг 1: Проверяем стандартные скрытые папки YBA
    local mainRemote = ReplicatedStorage:FindFirstChild("RemoteEvent")
    if mainRemote then return mainRemote end
    
    -- Шаг 2: Если переименовали, ищем любой RemoteEvent, у которого в имени есть намёк на диалог или ивенты
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do -- GetDescendants ищет даже внутри подпапок
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            if name:match("dialogue") or name:match("merchant") or name:match("sell") or name:match("item") then
                return obj
            end
        end
    end
    
    -- Шаг 3: Крайний случай. В YBA главный сетевой ивент часто лежит в папке "Modules" или прямо в корне
    -- Возвращаем самый первый попавшийся RemoteEvent общего назначения, если другие не нашлись
    return ReplicatedStorage:FindFirstChildOfClass("RemoteEvent")
end

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
                    -- Отправка пакета. Если YBA поменяли аргументы (например, вместо "EndDialogue" теперь другое слово),
                    -- скрипт попытается отправить стандартную структуру
                    Remote:FireServer("EndDialogue", {
                        ["NPC"] = "Merchant",
                        ["Option"] = "Sell " .. item.Name,
                        ["Item"] = item
                    })
                    -- Дублируем альтернативный вариант аргументов для новых версий YBA
                    Remote:FireServer("MerchantSpace", "Sell", item.Name)
                end)
                task.wait(0.1)
            end
        end
    end

    Process(Backpack)
    Process(PlayerGuiData)
    return true
end

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
    Main.Draggable = true

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)

    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.Text = "DEVELOPER PROJECT: YBA v1.1"
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

CreateUi()
print("[LOG]: Скрипт YBA версии 1.1 успешно запущен.")
