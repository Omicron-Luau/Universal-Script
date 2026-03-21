-- auto stats (versão igualitária, GUI persistente, sem verificações quando desativado)
-- Script para Delta Executor (Roblox)

-- Cria a interface gráfica no CoreGui (persiste após morte)
local gui = Instance.new("ScreenGui")
gui.Name = "AutoStatsGui"
gui.Parent = game:GetService("CoreGui")

-- Frame principal (arrastável)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Auto Stats"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.Parent = frame

-- Botão de toggle
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 40)
toggleButton.Position = UDim2.new(0.5, -80, 0.5, -10)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- começa vermelho (desativado)
toggleButton.Text = "Desativado"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.SourceSans
toggleButton.TextSize = 20
toggleButton.Parent = frame

-- Estado do toggle (inicia desativado)
local enabled = false

-- Atualiza aparência do botão
local function updateButton()
	if enabled then
		toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		toggleButton.Text = "Ativado"
		toggleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
	else
		toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		toggleButton.Text = "Desativado"
		toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
end
updateButton()

-- Alterna estado ao clicar (DEFINIDO ANTES DO LOOP INFINITO)
toggleButton.MouseButton1Click:Connect(function()
	enabled = not enabled
	updateButton()
end)

-- Função que gasta apenas múltiplos de 4 igualmente
local function spendPoints(total)
	local multiple = math.floor(total / 4) * 4
	if multiple < 4 then return end
	local cada = multiple / 4

	local player = game:GetService("Players").LocalPlayer
	local startevent = player:WaitForChild("startevent")

	startevent:FireServer("addstat", "chakra", cada)
	startevent:FireServer("addstat", "ninjutsu", cada)
	startevent:FireServer("addstat", "taijutsu", cada)
	startevent:FireServer("addstat", "health", cada)
end

-- Aguarda o jogador e os objetos necessários, e inicia o loop principal
local function start()
	local player = game:GetService("Players").LocalPlayer
	if not player then
		player = game:GetService("Players").PlayerAdded:Wait()
	end
	local statsFolder = player:WaitForChild("statz")
	local masteryFolder = statsFolder:WaitForChild("mastery")
	local pointsValue = masteryFolder:WaitForChild("points")

	-- Loop principal: só executa quando enabled = true
	while true do
		-- Se desativado, fica em espera até que enabled seja true
		while not enabled do
			wait(0.5)  -- espera sem consumir CPU intensivamente
		end
		
		-- Ativado: verifica e gasta pontos
		local pontos = pointsValue.Value
		if pontos >= 4 then
			spendPoints(pontos)
		end
		wait(0.5)
	end
end

-- Inicia o monitoramento quando o jogador carregar (após conectar o botão)
local player = game:GetService("Players").LocalPlayer
if player then
	start()
else
	game:GetService("Players").PlayerAdded:Connect(function(plr)
		if plr == game:GetService("Players").LocalPlayer then
			start()
		end
	end)
end
