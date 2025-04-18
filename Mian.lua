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
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local PlayerGui = player:WaitForChild("PlayerGui")

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = GITHUB_REPO
	ScreenGui.Parent = PlayerGui
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local ModMenu = Instance.new("Frame")
	ModMenu.Name = "ModMenu"
	ModMenu.Parent = ScreenGui
	ModMenu.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
	ModMenu.Size = UDim2.new(0, 240, 0, 320)
	ModMenu.Position = UDim2.new(0.05, 0, 0.1, 0)
	ModMenu.Active = true
	ModMenu.Draggable = true

	Instance.new("UICorner", ModMenu).CornerRadius = UDim.new(0, 10)
	local stroke = Instance.new("UIStroke", ModMenu)
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(60, 120, 255)

	local TitleBar = Instance.new("Frame")
	TitleBar.Name = "TitleBar"
	TitleBar.Parent = ModMenu
	TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
	TitleBar.Size = UDim2.new(1, 0, 0, 35)

	Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

	local Title = Instance.new("TextLabel")
	Title.Parent = TitleBar
	Title.Text = NAME_MOD_MENU
	Title.BackgroundTransparency = 1
	Title.TextColor3 = Color3.fromRGB(255, 255, 255)
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 18
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Size = UDim2.new(1, -40, 1, 0)
	Title.Position = UDim2.new(0, 10, 0, 0)

	local MinimizeButton = Instance.new("TextButton")
	MinimizeButton.Parent = TitleBar
	MinimizeButton.Text = "–"
	MinimizeButton.Font = Enum.Font.GothamBold
	MinimizeButton.TextSize = 22
	MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
	MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
	MinimizeButton.Position = UDim2.new(1, -30, 0, 0)
	Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(1, 0)

	local Content = Instance.new("ScrollingFrame")
	Content.Parent = ModMenu
	Content.Name = "Content"
	Content.Size = UDim2.new(1, 0, 1, -35)
	Content.Position = UDim2.new(0, 0, 0, 35)
	Content.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	Content.ScrollBarThickness = 6
	Content.CanvasSize = UDim2.new(0, 0, 0, 0)

	Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

	local layout = Instance.new("UIListLayout", Content)
	layout.Padding = UDim.new(0, 6)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder

	local Buttons = {}
	local isMinimized = false

	local function updateCanvasSize()
		local totalHeight = 0
		for _, btn in ipairs(Buttons) do
			totalHeight += btn.Size.Y.Offset + layout.Padding.Offset
		end
		Content.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
	end

	local activeAlerts = {}

	local function showAlertInMenu(menuGui, text, duration)
		if not menuGui then return end

		local alertFrame = Instance.new("Frame")
		alertFrame.Size = UDim2.new(0, 280, 0, 50)
		alertFrame.Position = UDim2.new(1, -300, 1, -60 - (#activeAlerts * 60))
		alertFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
		alertFrame.BackgroundTransparency = 0
		alertFrame.BorderSizePixel = 0
		alertFrame.AnchorPoint = Vector2.new(0, 1)
		alertFrame.Name = "LocalAlert"
		alertFrame.ZIndex = 999
		alertFrame.Parent = menuGui

		Instance.new("UICorner", alertFrame).CornerRadius = UDim.new(0, 8)

		local label = Instance.new("TextLabel", alertFrame)
		label.Size = UDim2.new(1, -20, 1, -10)
		label.Position = UDim2.new(0, 10, 0, 5)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Color3.new(1, 1, 1)
		label.Font = Enum.Font.Gotham
		label.TextSize = 16
		label.TextWrapped = true
		label.ZIndex = 1000

		table.insert(activeAlerts, alertFrame)

		task.delay(duration or 3, function()
			for i = 1, 10 do
				alertFrame.BackgroundTransparency += 0.05
				label.TextTransparency += 0.05
				task.wait(0.04)
			end
			alertFrame:Destroy()
			table.remove(activeAlerts, table.find(activeAlerts, alertFrame))
			for i, alert in ipairs(activeAlerts) do
				alert:TweenPosition(UDim2.new(1, -300, 1, -60 - ((i - 1) * 60)), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.25, true)
			end
		end)
	end

	local function alert(msg, dur)
		showAlertInMenu(ScreenGui, msg, dur or 4)
	end

	local function createButton(text, callback)
		local Button = Instance.new("TextButton")
		Button.Parent = Content
		Button.Size = UDim2.new(0.9, 0, 0, 40)
		Button.Text = text
		Button.BackgroundColor3 = Color3.fromRGB(60, 120, 255)
		Button.TextColor3 = Color3.new(1, 1, 1)
		Button.Font = Enum.Font.GothamBold
		Button.TextSize = 16
		Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

		Button.MouseButton1Click:Connect(function()
			alert("📦 Botão '" .. text .. "' executado", 3)
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
	minimizeImage.Image = IMG_ICON  -- Substitua IMG_ICON pela URL ou caminho da imagem desejada
	minimizeImage.Visible = false

	-- Adicionando bordas arredondadas
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)  -- Aqui ajustamos o arredondamento, se preferir mais ou menos, altere o valor
	corner.Parent = minimizeImage

	MinimizeButton.MouseButton1Click:Connect(function()
		isMinimized = not isMinimized

		-- Transições para o tamanho do menu
		local sizeTween = TweenService:Create(ModMenu, tweenInfo, {
			Size = isMinimized and UDim2.new(0, 50, 0, 50) or UDim2.new(0, 240, 0, 320)
		})

		-- Transições para a visibilidade do título
		local titleTween = TweenService:Create(Title, tweenInfo, {
			TextTransparency = isMinimized and 1 or 0
		})

		-- Controle da visibilidade do conteúdo
		Content.Visible = not isMinimized

		-- Transições para a imagem de minimizar
		local imageTween = TweenService:Create(minimizeImage, tweenInfo, {
			Transparency = isMinimized and 0 or 1
		})

		-- Torna a imagem visível durante a minimização
		minimizeImage.Visible = true
		imageTween:Play()

		-- Esconde a imagem de minimizar após a animação
		if not isMinimized then
			imageTween.Completed:Connect(function()
				minimizeImage.Visible = false
			end)
		end

		-- Executa as transições
		sizeTween:Play()
		titleTween:Play()
	end)



	-- Botão HD Admin
	createButton("HD ADMIN", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()
	end)

	-- Carregar scripts do GitHub
	local scripts = {
		{name = "frame", path = "frame_visor.lua"},
	}

	for _, script in ipairs(scripts) do
		createButton(script.name:upper(), function()
			local success, response = pcall(function()
				return game:HttpGet("https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/main/script/" .. script.path)
			end)
			if success then
				alert("🧠 Script '" .. script.name:upper() .. "' carregado!", 5)
				loadstring(response)()
			else
				alert("❌ Falha ao carregar '" .. script.name:upper() .. "'", 5)
			end
		end)
	end

	-- Mensagem inicial
	alert("👋 Bem-vindo, " .. player.Name .. "!", 6)
	alert("✅ Menu " .. GITHUB_REPO .. " ativado!", 5)
end






-- Executa o menu
criar_Gui_Frame()
