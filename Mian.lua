-- Verificar se já existe um ScreenGui com o nome
local existingScreenGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Trilhos_Mortos_Roblox")
if existingScreenGui then return end

-- Constantes
local GITHUB_USER = "AdrainRazini"
local GITHUB_REPO = "Trilhos_Mortos_Roblox"
local IMG_ICON = "rbxassetid://117585506735209"
local NAME_MOD_MENU = "Trilhos_Mortos_Mod"




function criar_Gui_Frame()
	local TweenService = game:GetService("TweenService")
	local ScreenGui = Instance.new("ScreenGui")
	local ModMenu = Instance.new("Frame")
	local TitleBar = Instance.new("Frame")
	local MinimizeButton = Instance.new("TextButton")
	local Content = Instance.new("ScrollingFrame")
	local Buttons = {}

	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	ScreenGui.Name = GITHUB_REPO
	ModMenu.Name = "ModMenu"
	ModMenu.Parent = ScreenGui
	ModMenu.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	ModMenu.Size = UDim2.new(0, 200, 0, 300)
	ModMenu.Position = UDim2.new(0.1, 0, 0.1, 0)
	ModMenu.Active = true
	ModMenu.Draggable = true

	-- Title Bar
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = ModMenu
	TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	TitleBar.Size = UDim2.new(1, 0, 0, 30)

	local Title = Instance.new("TextLabel", TitleBar)
	Title.Text = NAME_MOD_MENU
	Title.Size = UDim2.new(1, -30, 1, 0)
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.TextScaled = true

	-- Minimize Button
	MinimizeButton.Name = "MinimizeButton"
	MinimizeButton.Parent = TitleBar
	MinimizeButton.Text = "-"
	MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
	MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
	MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

	-- Scrolling Content
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

	local isMinimized = false

	local function updateCanvasSize()
		local totalHeight = 0
		for _, button in pairs(Buttons) do
			totalHeight = totalHeight + button.Size.Y.Offset + ListLayout.Padding.Offset
		end
		Content.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
	end

	-- Função de alerta empilhável
	local activeAlerts = {}

	local function showAlertInMenu(menuGui, text, duration)
		if not menuGui then return end

		local alertFrame = Instance.new("Frame")
		alertFrame.Size = UDim2.new(0, 280, 0, 50)
		alertFrame.Position = UDim2.new(1, -300, 1, -60 - (#activeAlerts * 60))
		alertFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		alertFrame.BackgroundTransparency = 0.15
		alertFrame.BorderSizePixel = 0
		alertFrame.AnchorPoint = Vector2.new(0, 1)
		alertFrame.Name = "LocalAlert"
		alertFrame.ZIndex = 999
		alertFrame.Parent = menuGui

		table.insert(activeAlerts, alertFrame)

		local corner = Instance.new("UICorner", alertFrame)
		corner.CornerRadius = UDim.new(0, 8)

		local label = Instance.new("TextLabel", alertFrame)
		label.Size = UDim2.new(1, -20, 1, -10)
		label.Position = UDim2.new(0, 10, 0, 5)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.fromRGB(255, 255, 255)
		label.Font = Enum.Font.Gotham
		label.TextSize = 17
		label.TextWrapped = true
		label.ZIndex = 1000

		task.delay(duration or 3, function()
			for i = 1, 10 do
				alertFrame.BackgroundTransparency += 0.05
				label.TextTransparency += 0.05
				task.wait(0.04)
			end

			alertFrame:Destroy()

			for i, alert in ipairs(activeAlerts) do
				if alert == alertFrame then
					table.remove(activeAlerts, i)
					break
				end
			end

			for i, alert in ipairs(activeAlerts) do
				alert:TweenPosition(
					UDim2.new(1, -300, 1, -60 - ((i - 1) * 60)),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quad,
					0.25,
					true
				)
			end
		end)
	end

	-- Wrapper para facilitar alertas
	local function alert(msg, dur)
		showAlertInMenu(ScreenGui, msg, dur or 5)
	end

	local function createButton(text, callback)
		local Button = Instance.new("TextButton")
		Button.Parent = Content
		Button.Size = UDim2.new(0.8, 0, 0, 40)
		Button.Text = text
		Button.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
		Button.TextColor3 = Color3.new(1, 1, 1)
		Button.MouseButton1Click:Connect(function()
			alert("📦 Botão '" .. text .. "' executado", 4)
			callback()
		end)
		table.insert(Buttons, Button)
		updateCanvasSize()
	end

	-- Minimizar
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	local minimizeImage = Instance.new("ImageLabel")
	minimizeImage.Parent = ModMenu
	minimizeImage.Size = UDim2.new(1, 0, 1, 0)
	minimizeImage.BackgroundTransparency = 1
	minimizeImage.Image = IMG_ICON
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

		minimizeImage.Visible = true
		imageTween:Play()

		if not isMinimized then
			imageTween.Completed:Connect(function()
				minimizeImage.Visible = false
			end)
		end

		sizeTween:Play()
		titleTween:Play()
	end)

	-- Botão HD ADMIN
	createButton("HD ADMIM", function()	
		loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
	end)

	-- Scripts do GitHub
	local scripts = {
		{name = "frame", path = "frame_visor.lua"},
	}

	for _, script in ipairs(scripts) do
		createButton(script.name:upper(), function()
			local success, response = pcall(function()
				return game:HttpGet("https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/main/script/" .. script.path)
			end)
			if success then
				alert("🧠 Script '" .. script.name:upper() .. "' carregado com sucesso!", 5)
				loadstring(response)()
			else
				alert("❌ Erro ao carregar '" .. script.name:upper() .. "'", 5)
				warn("Erro ao carregar script:", script.path)
			end
		end)
	end

	-- Mensagem inicial
	local player = game.Players.LocalPlayer
	alert("👋 Bem-vindo, " .. player.Name .. "!", 6)
	alert("✅ Menu " ..GITHUB_REPO.. " ativado!", 5)
end





-- Executa o menu
criar_Gui_Frame()
