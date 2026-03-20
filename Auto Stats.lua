-- auto stats (versão igualitária)
-- Script para Delta Executor (Roblox)

-- Cria a interface gráfica
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "AutoStatsGui"
local parent = player:FindFirstChild("PlayerGui") or game:GetService("CoreGui")
gui.Parent = parent

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
title.Text = "Auto Stats"  -- Alterado para apenas "Auto Stats"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.Parent = frame

-- Botão de toggle
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 160, 0, 40)
toggleButton.Position = UDim2.new(0.5, -80, 0.5, -10)
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- vermelho = desativado (agora inicia desligado)
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

-- Alterna estado ao clicar
toggleButton.MouseButton1Click:Connect(function()
	enabled = not enabled
	updateButton()
end)

-- Função que gasta apenas múltiplos de 4 igualmente
local function spendPoints(total)
	-- Calcula o maior múltiplo de 4 menor ou igual a total
	local multiple = math.floor(total / 4) * 4
	if multiple < 4 then return end  -- não há múltiplo suficiente

	local cada = multiple / 4  -- quantidade para cada atributo

	-- Obtém o remote
	local startevent = player:WaitForChild("startevent")

	-- Dispara os remotes com o mesmo valor para todos
	startevent:FireServer("addstat", "chakra", cada)
	startevent:FireServer("addstat", "ninjutsu", cada)
	startevent:FireServer("addstat", "taijutsu", cada)
	startevent:FireServer("addstat", "health", cada)
end

-- Aguarda a existência do caminho de pontos
local statsFolder = player:WaitForChild("statz")
local masteryFolder = statsFolder:WaitForChild("mastery")
local pointsValue = masteryFolder:WaitForChild("points")

-- Loop principal de verificação
while true do
	if enabled then
		local pontos = pointsValue.Value
		if pontos >= 4 then
			spendPoints(pontos)
		end
	end
	wait(0.5)  -- verifica a cada 0.5 segundos
end