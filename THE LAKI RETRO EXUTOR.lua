local player = game.Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RetroExecutorGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 450, 0, 320)
frame.Position = UDim2.new(0.5, -225, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
frame.BorderColor3 = Color3.new(1, 0, 0)
frame.BorderSizePixel = 3
frame.Parent = screenGui

-- Подпись сверху
local signature = Instance.new("TextLabel")
signature.Size = UDim2.new(1, 0, 0, 20)
signature.Position = UDim2.new(0, 0, 0, 0)
signature.BackgroundTransparency = 1
signature.Text = "BY OMEGA_LAKI"
signature.Font = Enum.Font.GothamBold
signature.TextSize = 14
signature.TextColor3 = Color3.fromRGB(255, 0, 0)
signature.TextStrokeColor3 = Color3.new(0,0,0)
signature.TextStrokeTransparency = 0
signature.Parent = frame

-- Заголовок (сдвинут ниже подписи)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 20)
title.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
title.BorderSizePixel = 0
title.Text = "Retro Executor"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 20)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 20
closeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.Parent = frame

closeBtn.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

local codeBox = Instance.new("TextBox")
codeBox.Size = UDim2.new(1, -20, 1, -120)
codeBox.Position = UDim2.new(0, 10, 0, 60)
codeBox.BackgroundColor3 = Color3.fromRGB(10, 0, 0)
codeBox.BorderColor3 = Color3.fromRGB(255, 0, 0)
codeBox.BorderSizePixel = 2
codeBox.TextColor3 = Color3.fromRGB(255, 0, 0)
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 18
codeBox.TextWrapped = true
codeBox.ClearTextOnFocus = false
codeBox.MultiLine = true
codeBox.PlaceholderText = "Вставь Lua код или URL..."
codeBox.Parent = frame

local executeBtn = Instance.new("TextButton")
executeBtn.Size = UDim2.new(0, 120, 0, 30)
executeBtn.Position = UDim2.new(0, 10, 1, -50)
executeBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
executeBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
executeBtn.BorderSizePixel = 2
executeBtn.Text = "Execute"
executeBtn.Font = Enum.Font.GothamBold
executeBtn.TextSize = 20
executeBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
executeBtn.Parent = frame

local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0, 120, 0, 30)
copyBtn.Position = UDim2.new(0, 160, 1, -50)
copyBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
copyBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
copyBtn.BorderSizePixel = 2
copyBtn.Text = "Copy"
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 20
copyBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
copyBtn.Parent = frame

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 120, 0, 30)
clearBtn.Position = UDim2.new(0, 310, 1, -50)
clearBtn.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
clearBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
clearBtn.BorderSizePixel = 2
clearBtn.Text = "Clear"
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 20
clearBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
clearBtn.Parent = frame

local function executeCode(code)
    if code:match("^https?://") then
        local ok, result = pcall(function()
            return game:HttpGet(code)
        end)
        if not ok then
            warn("Не удалось загрузить код с URL: "..tostring(result))
            return
        end
        code = result
    end

    local success, err = pcall(function()
        loadstring(code)()
    end)
    if not success then
        warn("Ошибка выполнения кода: "..tostring(err))
    end
end

executeBtn.MouseButton1Click:Connect(function()
    local code = codeBox.Text
    if code == "" then return end
    executeCode(code)
end)

copyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(codeBox.Text)
        copyBtn.Text = "Copied!"
        wait(2)
        copyBtn.Text = "Copy"
    else
        warn("Функция setclipboard недоступна в твоём исполнителе")
    end
end)

clearBtn.MouseButton1Click:Connect(function()
    codeBox.Text = ""
end)

-- Перемещение окна

local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                             startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function dragStarted(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end

local function dragMoved(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end

-- Подключаем обработчики перемещения и на подписи, и на заголовке
signature.InputBegan:Connect(dragStarted)
signature.InputChanged:Connect(dragMoved)

title.InputBegan:Connect(dragStarted)
title.InputChanged:Connect(dragMoved)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
