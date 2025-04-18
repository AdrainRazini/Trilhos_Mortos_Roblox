
-- Verificar se já existe um ScreenGui com o nome "ModMenu"
local existingScreenGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Trilhos_Mortos_Roblox")

-- Se já existir, retorna para evitar a criação do GUI
if existingScreenGui then
    return
end




-- Verificar se já existe um ScreenGui com o nome "ModMenu"
local existingScreenGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Trilhos_Mortos_Roblox")
if existingScreenGui then return end

-- URL da API do GitHub para listar os scripts
local GITHUB_USER = "AdrainRazini"
local GITHUB_REPO = "Trilhos_Mortos_Roblox"
local SCRIPTS_FOLDER_URL = "https://api.github.com/repos/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/contents/script"



-- Notificação de boas-vindas
game:GetService("StarterGui"):SetCore("SendNotification", { 
    Title = "MASTERMOD";
    Text = "Adrian75556435";
    Icon = "rbxthumb://type=Asset&id=102637810511338&w=150&h=150";
    Duration = 16;
})

local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

-- Criação do GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Trilhos_Mortos_Roblox"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local ModMenu = Instance.new("Frame")
ModMenu.Name = "ModMenu"
ModMenu.Parent = ScreenGui
ModMenu.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ModMenu.Size = UDim2.new(0, 200, 0, 300)
ModMenu.Position = UDim2.new(0.1, 0, 0.1, 0)
ModMenu.Active = true
ModMenu.Draggable = true

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = ModMenu
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TitleBar.Size = UDim2.new(1, 0, 0, 30)

local Title = Instance.new("TextLabel", TitleBar)
Title.Text = "MASTERMODS"
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.Text = "-"
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

local Content = Instance.new("ScrollingFrame")
Content.Name = "Content"
Content.Parent = ModMenu
Content.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
Content.Size = UDim2.new(1, 0, 1, -30)
Content.Position = UDim2.new(0, 0, 0, 30)
Content.CanvasSize = UDim2.new(0, 0, 1, 0)
Content.ScrollBarThickness = 8

local ListLayout = Instance.new("UIListLayout", Content)
ListLayout.Padding = UDim.new(0, 5)
ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Buttons = {}
local isMinimized = false
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local minimizeImage = Instance.new("ImageLabel")
minimizeImage.Parent = ModMenu
minimizeImage.Size = UDim2.new(1, 0, 1, 0)
minimizeImage.BackgroundTransparency = 1
minimizeImage.Image = "rbxassetid://117585506735209"
minimizeImage.Visible = false

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local sizeTween = TweenService:Create(ModMenu, tweenInfo, {
        Size = isMinimized and UDim2.new(0, 50, 0, 50) or UDim2.new(0, 200, 0, 300)
    })
    local titleTween = TweenService:Create(Title, tweenInfo, {
        TextTransparency = isMinimized and 1 or 0
    })

    Content.Visible = not isMinimized

    local imageTween = TweenService:Create(minimizeImage, tweenInfo, {
        Transparency = isMinimized and 0 or 1
    })
    minimizeImage.Visible = isMinimized
    imageTween:Play()

    if not isMinimized then
        imageTween.Completed:Connect(function()
            minimizeImage.Visible = false
        end)
    end

    sizeTween:Play()
    titleTween:Play()
end)

-- Atualizar CanvasSize
local function updateCanvasSize()
    local totalHeight = 0
    for _, button in ipairs(Buttons) do
        totalHeight = totalHeight + button.Size.Y.Offset + ListLayout.Padding.Offset
    end
    Content.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Criar botão
local function createButton(text, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = Content
    Button.Size = UDim2.new(0.8, 0, 0, 40)
    Button.Text = text
    Button.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.MouseButton1Click:Connect(callback)
    table.insert(Buttons, Button)
    updateCanvasSize()
end

-- Botão personalizado de exemplo
createButton("HD ADMIN", function()
    game:GetService("StarterGui"):SetCore("SendNotification", { 
        Title = "HD ADMIN";
        Text = "YIELD";
        Icon = "rbxthumb://type=Asset&id=93638563594123&w=150&h=150";
        Duration = 16;
    })
    loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
end)

-- Buscar arquivos .lua da pasta script/
local success, result = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(SCRIPTS_FOLDER_URL))
end)

if success and typeof(result) == "table" then
    for _, file in ipairs(result) do
        if file.name:match("%.lua$") then
            local scriptName = file.name:gsub("%.lua$", "")
            createButton(scriptName:upper(), function()
                local ok, response = pcall(function()
                    return game:HttpGet(file.download_url)
                end)
                if ok then
                    loadstring(response)()
                else
                    warn("Erro ao carregar script:", file.name)
                end
            end)
        end
    end
else
    warn("Erro ao buscar scripts no GitHub:", result)
end
