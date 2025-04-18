-- Evita criar duplicado
local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
if gui:FindFirstChild("Trilhos_Mortos_Roblox") then return end

-- Cria o ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Trilhos_Mortos_Roblox"
screenGui.ResetOnSpawn = false
screenGui.Parent = gui

-- Função para permitir arrastar
local function makeDraggable(frame, dragBar)
	local dragging = false
	local offset

	dragBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			offset = input.Position - frame.Position
		end
	end)

	dragBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			frame.Position = UDim2.new(0, input.Position.X - offset.X, 0, input.Position.Y - offset.Y)
		end
	end)
end

-- Janela principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Barra de título
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Trilhos Mortos"
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.Position = UDim2.new(0, 5, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Botão minimizar
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "-"
minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
minimizeBtn.Position = UDim2.new(1, -30, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = titleBar

-- Área de scroll
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -40)
scrollFrame.Position = UDim2.new(0, 5, 0, 35)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 6
scrollFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
scrollFrame.BorderSizePixel = 0
scrollFrame.Parent = mainFrame

-- Layout dos botões
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = scrollFrame

-- Minimizar/Restaurar
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	scrollFrame.Visible = not minimized
	mainFrame.Size = minimized and UDim2.new(0, 300, 0, 30) or UDim2.new(0, 300, 0, 400)
end)

-- Torna a janela arrastável
makeDraggable(mainFrame, titleBar)

-- Função para criar botões
local function createButton(label, onClick)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -10, 0, 30)
	button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Text = label
	button.Font = Enum.Font.SourceSans
	button.TextSize = 16
	button.Parent = scrollFrame
	button.MouseButton1Click:Connect(onClick)
end

-- Busca automática dos scripts .lua do GitHub
local HttpService = game:GetService("HttpService")
local GITHUB_USER = "AdrainRazini"
local GITHUB_REPO = "Trilhos_Mortos_Roblox"
local SCRIPTS_FOLDER_URL = "https://api.github.com/repos/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/contents/script"

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
	warn("Erro ao buscar scripts do GitHub:", result)
end

-- Atualizar canvas após criação dos botões
task.wait(0.1)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
