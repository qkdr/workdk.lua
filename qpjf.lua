---------------------------------------------
-- مكتبة Luna للواجهات الفخمة في Roblox
-- تُتيح إضافة سكربتات خارجية وتشغيلها مع واجهة رئيسية مميزة
--
-- طريقة الاستخدام:
-- local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourRepo/YourScript.lua", true))()
-- Luna:AddScript({
--     name = "Silent Aim",
--     description = "يتيح لك التصويب الصامت على الأعداء.",
--     url = "https://raw.githubusercontent.com/ExampleUser/SilentAim.lua"
-- })
-- Luna:Show()
---------------------------------------------

local Luna = {}

---------------------------------------------
-- إعدادات عامة قابلة للتعديل
---------------------------------------------
local settings = {
    openSound = "rbxassetid://6042053626",
    buttonSound = "rbxassetid://6026984224",
    warningSound = "rbxassetid://6042055798",
    backgroundImage = "rbxassetid://13577851314", -- خلفية الواجهة الرئيسية
    buttonColor = Color3.fromRGB(40, 40, 40),
    accentColor = Color3.fromRGB(0, 170, 100),
    textColor = Color3.fromRGB(255, 255, 255),
    cornerRadius = UDim.new(0, 12),
    transparency = 0.2,
    telegramLink = "https://t.me/YourChannelLink"  -- رابط قناة التليجرام
}

---------------------------------------------
-- بيانات السكربتات الخارجية (تُضاف عبر AddScript)
---------------------------------------------
local externalScripts = {}

---------------------------------------------
-- خدمات Roblox
---------------------------------------------
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

---------------------------------------------
-- دالة عرض إشعار أنيق على الشاشة
---------------------------------------------
local function showNotification(parentGui, message)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(0.5, -150, 0, -60)
    notification.BackgroundColor3 = settings.accentColor
    notification.BackgroundTransparency = 0.3
    notification.BorderSizePixel = 0
    notification.Parent = parentGui

    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification

    local notifText = Instance.new("TextLabel")
    notifText.Name = "NotifText"
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Font = Enum.Font.GothamBold
    notifText.Text = message
    notifText.TextSize = 18
    notifText.TextColor3 = settings.textColor
    notifText.Parent = notification

    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 300, 0, 50),
        Position = UDim2.new(0.5, -150, 0, 20)
    }):Play()

    wait(2)
    local hideTween = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0, -60)
    })
    hideTween:Play()
    wait(0.3)
    notification:Destroy()
end

---------------------------------------------
-- دالة إنشاء مربع التأكيد
---------------------------------------------
local function showConfirmationDialog(parentGui, message, confirmCallback)
    local warningSound = Instance.new("Sound")
    warningSound.SoundId = settings.warningSound
    warningSound.Volume = 0.5
    warningSound.Parent = parentGui
    warningSound:Play()

    local confirmationFrame = Instance.new("Frame")
    confirmationFrame.Name = "ConfirmationDialog"
    confirmationFrame.Size = UDim2.new(0, 400, 0, 200)
    confirmationFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
    confirmationFrame.BackgroundColor3 = settings.buttonColor
    confirmationFrame.BackgroundTransparency = 0.1
    confirmationFrame.BorderSizePixel = 0
    confirmationFrame.Parent = parentGui

    confirmationFrame.Size = UDim2.new(0, 0, 0, 0)
    confirmationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(confirmationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 200),
        Position = UDim2.new(0.5, -200, 0.5, -100)
    }):Play()

    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = settings.cornerRadius
    confirmCorner.Parent = confirmationFrame

    local warningIcon = Instance.new("ImageLabel")
    warningIcon.Name = "WarningIcon"
    warningIcon.Size = UDim2.new(0, 50, 0, 50)
    warningIcon.Position = UDim2.new(0.5, -25, 0, 30)
    warningIcon.BackgroundTransparency = 1
    warningIcon.Image = "rbxassetid://7734056608"
    warningIcon.ImageColor3 = Color3.fromRGB(255, 200, 0)
    warningIcon.Parent = confirmationFrame

    local confirmationText = Instance.new("TextLabel")
    confirmationText.Name = "ConfirmationText"
    confirmationText.Size = UDim2.new(0, 350, 0, 60)
    confirmationText.Position = UDim2.new(0.5, -175, 0, 90)
    confirmationText.BackgroundTransparency = 1
    confirmationText.Font = Enum.Font.GothamMedium
    confirmationText.Text = message
    confirmationText.TextSize = 16
    confirmationText.TextColor3 = settings.textColor
    confirmationText.TextWrapped = true
    confirmationText.Parent = confirmationFrame

    local confirmButton = Instance.new("TextButton")
    confirmButton.Name = "ConfirmButton"
    confirmButton.Size = UDim2.new(0, 120, 0, 40)
    confirmButton.Position = UDim2.new(0.5, -130, 0, 140)
    confirmButton.BackgroundColor3 = settings.accentColor
    confirmButton.Font = Enum.Font.GothamBold
    confirmButton.Text = "تأكيد"
    confirmButton.TextSize = 16
    confirmButton.TextColor3 = settings.textColor
    confirmButton.Parent = confirmationFrame

    local confirmButtonCorner = Instance.new("UICorner")
    confirmButtonCorner.CornerRadius = settings.cornerRadius
    confirmButtonCorner.Parent = confirmButton

    local cancelButton = Instance.new("TextButton")
    cancelButton.Name = "CancelButton"
    cancelButton.Size = UDim2.new(0, 120, 0, 40)
    cancelButton.Position = UDim2.new(0.5, 10, 0, 140)
    cancelButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    cancelButton.Font = Enum.Font.GothamBold
    cancelButton.Text = "إلغاء"
    cancelButton.TextSize = 16
    cancelButton.TextColor3 = settings.textColor
    cancelButton.Parent = confirmationFrame

    local cancelButtonCorner = Instance.new("UICorner")
    cancelButtonCorner.CornerRadius = settings.cornerRadius
    cancelButtonCorner.Parent = cancelButton

    confirmButton.MouseEnter:Connect(function()
        TweenService:Create(confirmButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 200, 120)}):Play()
    end)
    confirmButton.MouseLeave:Connect(function()
        TweenService:Create(confirmButton, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor}):Play()
    end)
    cancelButton.MouseEnter:Connect(function()
        TweenService:Create(cancelButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(230, 70, 70)}):Play()
    end)
    cancelButton.MouseLeave:Connect(function()
        TweenService:Create(cancelButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play()
    end)

    confirmButton.MouseButton1Click:Connect(function()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        TweenService:Create(confirmationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.3)
        confirmationFrame:Destroy()
        if confirmCallback then
            confirmCallback()
        end
    end)
    cancelButton.MouseButton1Click:Connect(function()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        TweenService:Create(confirmationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        wait(0.3)
        confirmationFrame:Destroy()
    end)
end

---------------------------------------------
-- دالة إنشاء الواجهة الرئيسية (Main Interface)
---------------------------------------------
local function createMainInterface(parentGui)
    local openSound = Instance.new("Sound")
    openSound.SoundId = settings.openSound
    openSound.Volume = 0.5
    openSound.Parent = parentGui
    openSound:Play()

    if parentGui:FindFirstChild("MainInterface") then
        parentGui.MainInterface:Destroy()
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainInterface"
    mainFrame.Size = UDim2.new(0, 800, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -400, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = settings.transparency
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = parentGui

    mainFrame.Rotation = -5
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 800, 0, 500),
        Position = UDim2.new(0.5, -400, 0.5, -250),
        Rotation = 0
    }):Play()

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = settings.cornerRadius
    mainCorner.Parent = mainFrame

    local backgroundImage = Instance.new("ImageLabel")
    backgroundImage.Name = "BackgroundImage"
    backgroundImage.Size = UDim2.new(1, 0, 1, 0)
    backgroundImage.Position = UDim2.new(0, 0, 0, 0)
    backgroundImage.BackgroundTransparency = 1
    backgroundImage.Image = settings.backgroundImage
    backgroundImage.ImageTransparency = 0.2
    backgroundImage.ScaleType = Enum.ScaleType.Crop
    backgroundImage.Parent = mainFrame

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 45
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 30))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 0.8)
    })
    gradient.Parent = backgroundImage

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 400, 0, 50)
    titleLabel.Position = UDim2.new(0.5, -200, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "القائمة الرئيسية"
    titleLabel.TextSize = 28
    titleLabel.TextColor3 = settings.textColor
    titleLabel.Parent = mainFrame

    -------------------------------------------------
    -- قسم عرض السكربتات الخارجية مع عداد للتنفيذ
    -------------------------------------------------
    local extScriptsFrame = Instance.new("ScrollingFrame")
    extScriptsFrame.Name = "ExternalScriptsFrame"
    extScriptsFrame.Size = UDim2.new(1, -60, 0, 250)
    extScriptsFrame.Position = UDim2.new(0, 30, 0, 100)
    extScriptsFrame.BackgroundTransparency = 1
    extScriptsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    extScriptsFrame.ScrollBarThickness = 4
    extScriptsFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    extScriptsFrame.Parent = mainFrame

    local grid = Instance.new("UIGridLayout")
    grid.CellSize = UDim2.new(0, 200, 0, 240)
    grid.CellPadding = UDim2.new(0, 10, 0, 10)
    grid.Parent = extScriptsFrame

    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        extScriptsFrame.CanvasSize = UDim2.new(0, grid.AbsoluteContentSize.X, 0, grid.AbsoluteContentSize.Y)
    end)

    for _, scriptData in ipairs(externalScripts) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Name = scriptData.name
        itemFrame.Size = UDim2.new(0, 200, 0, 240)
        itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        itemFrame.BackgroundTransparency = 0.7
        itemFrame.Parent = extScriptsFrame

        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 10)
        itemCorner.Parent = itemFrame

        local scriptLabel = Instance.new("TextLabel")
        scriptLabel.Name = "ScriptLabel"
        scriptLabel.Size = UDim2.new(1, -20, 0, 120)
        scriptLabel.Position = UDim2.new(0, 10, 0, 10)
        scriptLabel.BackgroundTransparency = 1
        scriptLabel.Font = Enum.Font.GothamBold
        scriptLabel.Text = scriptData.name .. "\n" .. scriptData.description
        scriptLabel.TextSize = 16
        scriptLabel.TextColor3 = settings.textColor
        scriptLabel.TextWrapped = true
        scriptLabel.Parent = itemFrame

        local counterLabel = Instance.new("TextLabel")
        counterLabel.Name = "CounterLabel"
        counterLabel.Size = UDim2.new(1, -20, 0, 20)
        counterLabel.Position = UDim2.new(0, 10, 1, -30)
        counterLabel.BackgroundTransparency = 1
        counterLabel.Font = Enum.Font.GothamBold
        local counterName = "ScriptCounter_" .. scriptData.name
        local counterValue = workspace:FindFirstChild(counterName)
        if not counterValue then
            counterValue = Instance.new("NumberValue")
            counterValue.Name = counterName
            counterValue.Value = 0
            counterValue.Parent = workspace
        end
        counterLabel.Text = "التنفيذ: " .. counterValue.Value
        counterLabel.TextSize = 16
        counterLabel.TextColor3 = settings.textColor
        counterLabel.Parent = itemFrame

        local viewButton = Instance.new("TextButton")
        viewButton.Name = "ViewButton"
        viewButton.Size = UDim2.new(0, 180, 0, 40)
        viewButton.Position = UDim2.new(0, 10, 0, 130)
        viewButton.BackgroundColor3 = settings.accentColor
        viewButton.Font = Enum.Font.GothamBold
        viewButton.Text = "مشاهدة"
        viewButton.TextSize = 18
        viewButton.TextColor3 = settings.textColor
        viewButton.Parent = itemFrame

        local viewButtonCorner = Instance.new("UICorner")
        viewButtonCorner.CornerRadius = UDim.new(0, 8)
        viewButtonCorner.Parent = viewButton

        viewButton.MouseEnter:Connect(function()
            TweenService:Create(viewButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 200, 120)}):Play()
        end)
        viewButton.MouseLeave:Connect(function()
            TweenService:Create(viewButton, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor}):Play()
        end)

        viewButton.MouseButton1Click:Connect(function()
            local btnSound = Instance.new("Sound")
            btnSound.SoundId = settings.buttonSound
            btnSound.Volume = 0.5
            btnSound.Parent = parentGui
            btnSound:Play()
            TweenService:Create(viewButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 190, 0, 45)}):Play()
            wait(0.2)
            TweenService:Create(viewButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 180, 0, 40)}):Play()
            showConfirmationDialog(parentGui, "هل أنت متأكد أنك تريد تشغيل " .. scriptData.name .. "؟", function()
                loadstring(game:HttpGet(scriptData.url))()
                local counterName = "ScriptCounter_" .. scriptData.name
                local counterValue = workspace:FindFirstChild(counterName)
                if not counterValue then
                    counterValue = Instance.new("NumberValue")
                    counterValue.Name = counterName
                    counterValue.Value = 0
                    counterValue.Parent = workspace
                end
                counterValue.Value = counterValue.Value + 1
                counterLabel.Text = "التنفيذ: " .. counterValue.Value
                showNotification(parentGui, "تم تشغيل " .. scriptData.name .. "!")
            end)
        end)
    end

    -------------------------------------------------
    -- نهاية قسم السكربتات الخارجية
    -------------------------------------------------

    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundTransparency = 0.5
    closeButton.BackgroundColor3 = settings.buttonColor
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 24
    closeButton.TextColor3 = settings.textColor
    closeButton.Parent = mainFrame

    closeButton.MouseButton1Click:Connect(function()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Rotation = 5
        }):Play()
        wait(0.5)
        mainFrame:Destroy()
    end)

    local searchFrame = Instance.new("Frame")
    searchFrame.Name = "SearchFrame"
    searchFrame.Size = UDim2.new(0, 500, 0, 40)
    searchFrame.Position = UDim2.new(0.5, -250, 0, 60)
    searchFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    searchFrame.BackgroundTransparency = 0.5
    searchFrame.Parent = mainFrame

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 20)
    searchCorner.Parent = searchFrame

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Name = "SearchIcon"
    searchIcon.Size = UDim2.new(0, 20, 0, 20)
    searchIcon.Position = UDim2.new(0, 15, 0.5, -10)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://3605022185"
    searchIcon.ImageColor3 = settings.textColor
    searchIcon.Parent = searchFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -50, 1, 0)
    searchBox.Position = UDim2.new(0, 45, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "بحث..."
    searchBox.Text = ""
    searchBox.TextSize = 18
    searchBox.TextColor3 = settings.textColor
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchFrame

    local playerIcon = Instance.new("ImageLabel")
    playerIcon.Name = "PlayerIcon"
    playerIcon.Size = UDim2.new(0, 50, 0, 50)
    playerIcon.Position = UDim2.new(0, 30, 0, 110)
    playerIcon.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    playerIcon.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    playerIcon.Parent = mainFrame

    local playerIconCorner = Instance.new("UICorner")
    playerIconCorner.CornerRadius = UDim.new(0, 25)
    playerIconCorner.Parent = playerIcon

    local playerName = Instance.new("TextLabel")
    playerName.Name = "PlayerName"
    playerName.Size = UDim2.new(0, 200, 0, 30)
    playerName.Position = UDim2.new(0, 85, 0, 115)
    playerName.BackgroundTransparency = 1
    playerName.Font = Enum.Font.GothamSemibold
    playerName.Text = LocalPlayer.DisplayName
    playerName.TextSize = 18
    playerName.TextColor3 = settings.textColor
    playerName.TextXAlignment = Enum.TextXAlignment.Left
    playerName.Parent = mainFrame

    return mainFrame
end

---------------------------------------------
-- دالة إنشاء واجهة المعلومات (Info Interface)
---------------------------------------------
local function createInfoInterface(parentGui)
    local openSound = Instance.new("Sound")
    openSound.SoundId = settings.openSound
    openSound.Volume = 0.5
    openSound.Parent = parentGui
    openSound:Play()

    if parentGui:FindFirstChild("InfoInterface") then
        parentGui.InfoInterface:Destroy()
    end

    local infoFrame = Instance.new("Frame")
    infoFrame.Name = "InfoInterface"
    infoFrame.Size = UDim2.new(0, 600, 0, 600)
    infoFrame.Position = UDim2.new(0.5, -300, 0.5, -300)
    infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    infoFrame.BackgroundTransparency = settings.transparency
    infoFrame.BorderSizePixel = 0
    infoFrame.ClipsDescendants = true
    infoFrame.Parent = parentGui

    infoFrame.Rotation = -5
    infoFrame.Size = UDim2.new(0, 0, 0, 0)
    infoFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(infoFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 600, 0, 600),
        Position = UDim2.new(0.5, -300, 0.5, -300),
        Rotation = 0
    }):Play()

    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = settings.cornerRadius
    infoCorner.Parent = infoFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "InfoTitle"
    titleLabel.Size = UDim2.new(0, 400, 0, 50)
    titleLabel.Position = UDim2.new(0.5, -200, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "معلومات التطبيق"
    titleLabel.TextSize = 28
    titleLabel.TextColor3 = settings.textColor
    titleLabel.Parent = infoFrame

    -- إطار معلومات اللاعب (صورة صغيرة + بيانات)
    local infoContainer = Instance.new("Frame")
    infoContainer.Name = "InfoContainer"
    infoContainer.Size = UDim2.new(1, -40, 0, 120)
    infoContainer.Position = UDim2.new(0, 20, 0, 80)
    infoContainer.BackgroundTransparency = 0.5
    infoContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    infoContainer.Parent = infoFrame

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = infoContainer

    local smallPlayerIcon = Instance.new("ImageLabel")
    smallPlayerIcon.Name = "SmallPlayerIcon"
    smallPlayerIcon.Size = UDim2.new(0, 60, 0, 60)
    smallPlayerIcon.Position = UDim2.new(0, 10, 0, 30)
    smallPlayerIcon.BackgroundTransparency = 1
    smallPlayerIcon.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    smallPlayerIcon.Parent = infoContainer

    local smallIconCorner = Instance.new("UICorner")
    smallIconCorner.CornerRadius = UDim.new(0, 30)
    smallIconCorner.Parent = smallPlayerIcon

    local infoTextContainer = Instance.new("Frame")
    infoTextContainer.Name = "InfoTextContainer"
    infoTextContainer.Size = UDim2.new(1, -80, 1, 0)
    infoTextContainer.Position = UDim2.new(0, 70, 0, 0)
    infoTextContainer.BackgroundTransparency = 1
    infoTextContainer.Parent = infoContainer

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = "اسمك: " .. LocalPlayer.DisplayName
    nameLabel.TextSize = 18
    nameLabel.TextColor3 = settings.textColor
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = infoTextContainer

    local idLabel = Instance.new("TextLabel")
    idLabel.Name = "IDLabel"
    idLabel.Size = UDim2.new(1, 0, 0, 20)
    idLabel.Position = UDim2.new(0, 0, 0, 35)
    idLabel.BackgroundTransparency = 1
    idLabel.Font = Enum.Font.GothamBold
    idLabel.Text = "ايديك: " .. tostring(LocalPlayer.UserId)
    idLabel.TextSize = 18
    idLabel.TextColor3 = settings.textColor
    idLabel.TextXAlignment = Enum.TextXAlignment.Left
    idLabel.Parent = infoTextContainer

    local hackLabel = Instance.new("TextLabel")
    hackLabel.Name = "HackLabel"
    hackLabel.Size = UDim2.new(1, 0, 0, 20)
    hackLabel.Position = UDim2.new(0, 0, 0, 60)
    hackLabel.BackgroundTransparency = 1
    hackLabel.Font = Enum.Font.GothamBold
    hackLabel.Text = "الهاك: Luna Hack"
    hackLabel.TextSize = 18
    hackLabel.TextColor3 = settings.textColor
    hackLabel.TextXAlignment = Enum.TextXAlignment.Left
    hackLabel.Parent = infoTextContainer

    local keyLabel = Instance.new("TextLabel")
    keyLabel.Name = "KeyLabel"
    keyLabel.Size = UDim2.new(1, 0, 0, 20)
    keyLabel.Position = UDim2.new(0, 0, 0, 85)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.Text = "المفتاح: SecretKey"
    keyLabel.TextSize = 18
    keyLabel.TextColor3 = settings.textColor
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Parent = infoTextContainer

    -- قسم معلومات اللاعبين في الماب
    local playersFrame = Instance.new("ScrollingFrame")
    playersFrame.Name = "PlayersInfoFrame"
    playersFrame.Size = UDim2.new(1, -40, 0, 200)
    playersFrame.Position = UDim2.new(0, 20, 0, 220)
    playersFrame.BackgroundTransparency = 0.5
    playersFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    playersFrame.BorderSizePixel = 0
    playersFrame.ScrollBarThickness = 4
    playersFrame.Parent = infoFrame

    local playersGrid = Instance.new("UIListLayout")
    playersGrid.Padding = UDim.new(0, 5)
    playersGrid.Parent = playersFrame

    for _, player in ipairs(Players:GetPlayers()) do
        local entry = Instance.new("Frame")
        entry.Name = "PlayerEntry_" .. player.Name
        entry.Size = UDim2.new(1, -10, 0, 40)
        entry.BackgroundTransparency = 0.3
        entry.BackgroundColor3 = settings.buttonColor
        entry.Parent = playersFrame

        local entryCorner = Instance.new("UICorner")
        entryCorner.CornerRadius = UDim.new(0, 6)
        entryCorner.Parent = entry

        local nameText = Instance.new("TextLabel")
        nameText.Name = "NameText"
        nameText.Size = UDim2.new(0.4, 0, 1, 0)
        nameText.BackgroundTransparency = 1
        nameText.Font = Enum.Font.GothamBold
        nameText.Text = "اسمه: " .. player.Name
        nameText.TextSize = 16
        nameText.TextColor3 = settings.textColor
        nameText.Parent = entry

        local idText = Instance.new("TextLabel")
        idText.Name = "IDText"
        idText.Size = UDim2.new(0.3, 0, 1, 0)
        idText.Position = UDim2.new(0.41, 0, 0, 0)
        idText.BackgroundTransparency = 1
        idText.Font = Enum.Font.GothamBold
        idText.Text = "ايديه: " .. tostring(player.UserId)
        idText.TextSize = 16
        idText.TextColor3 = settings.textColor
        idText.Parent = entry

        local playTimeText = Instance.new("TextLabel")
        playTimeText.Name = "PlayTimeText"
        playTimeText.Size = UDim2.new(0.3, 0, 1, 0)
        playTimeText.Position = UDim2.new(0.72, 0, 0, 0)
        playTimeText.BackgroundTransparency = 1
        playTimeText.Font = Enum.Font.GothamBold
        local playTime = 0
        if player.TimeJoined then
            playTime = math.floor(os.time() - player.TimeJoined)
        end
        playTimeText.Text = "وقت العب: " .. playTime .. " ثواني"
        playTimeText.TextSize = 16
        playTimeText.TextColor3 = settings.textColor
        playTimeText.Parent = entry

        local teleportButton = Instance.new("TextButton")
        teleportButton.Name = "TeleportButton"
        teleportButton.Size = UDim2.new(0, 60, 1, 0)
        teleportButton.Position = UDim2.new(0.98, -60, 0, 0)
        teleportButton.BackgroundColor3 = settings.accentColor
        teleportButton.Font = Enum.Font.GothamBold
        teleportButton.Text = "تنقل"
        teleportButton.TextSize = 16
        teleportButton.TextColor3 = settings.textColor
        teleportButton.Parent = entry

        local teleportCorner = Instance.new("UICorner")
        teleportCorner.CornerRadius = UDim.new(0, 6)
        teleportCorner.Parent = teleportButton

        teleportButton.MouseButton1Click:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
            end
        end)
    end

    -- زر قناة تليجرام
    local telegramButton = Instance.new("TextButton")
    telegramButton.Name = "TelegramButton"
    telegramButton.Size = UDim2.new(0, 180, 0, 40)
    telegramButton.Position = UDim2.new(0.5, -90, 1, -50)
    telegramButton.BackgroundColor3 = settings.accentColor
    telegramButton.Font = Enum.Font.GothamBold
    telegramButton.Text = "قناة تليجرام"
    telegramButton.TextSize = 18
    telegramButton.TextColor3 = settings.textColor
    telegramButton.Parent = infoFrame

    local telegramButtonCorner = Instance.new("UICorner")
    telegramButtonCorner.CornerRadius = UDim.new(0, 8)
    telegramButtonCorner.Parent = telegramButton

    telegramButton.MouseEnter:Connect(function()
        TweenService:Create(telegramButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 200, 120)}):Play()
    end)
    telegramButton.MouseLeave:Connect(function()
        TweenService:Create(telegramButton, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor}):Play()
    end)

    telegramButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(settings.telegramLink)
            showNotification(parentGui, "تم نسخ رابط القناة!")
        else
            showNotification(parentGui, "غير متاح النسخ!")
        end
    end)

    -- زر إغلاق نافذة المعلومات (X)
    local infoCloseButton = Instance.new("TextButton")
    infoCloseButton.Name = "InfoCloseButton"
    infoCloseButton.Size = UDim2.new(0, 30, 0, 30)
    infoCloseButton.Position = UDim2.new(1, -40, 0, 10)
    infoCloseButton.BackgroundTransparency = 0.5
    infoCloseButton.BackgroundColor3 = settings.buttonColor
    infoCloseButton.Text = "X"
    infoCloseButton.Font = Enum.Font.GothamBold
    infoCloseButton.TextSize = 24
    infoCloseButton.TextColor3 = settings.textColor
    infoCloseButton.Parent = infoFrame

    infoCloseButton.MouseButton1Click:Connect(function()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        TweenService:Create(infoFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Rotation = 5
        }):Play()
        wait(0.5)
        infoFrame:Destroy()
    end)

    return infoFrame
end

---------------------------------------------
-- دالة إنشاء لوحة الخيارات (Option Panel)
---------------------------------------------
local function createOptionPanel(parentGui)
    if parentGui:FindFirstChild("OptionPanel") then
        parentGui.OptionPanel:Destroy()
    end

    local optionPanel = Instance.new("Frame")
    optionPanel.Name = "OptionPanel"
    optionPanel.Size = UDim2.new(0, 200, 0, 100)
    optionPanel.Position = UDim2.new(0.95, -220, 0.5, -50)
    optionPanel.BackgroundColor3 = settings.buttonColor
    optionPanel.BackgroundTransparency = 0.2
    optionPanel.BorderSizePixel = 0
    optionPanel.Parent = parentGui

    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = settings.cornerRadius
    optionCorner.Parent = optionPanel

    local infoButton = Instance.new("TextButton")
    infoButton.Name = "InfoButton"
    infoButton.Size = UDim2.new(1, -20, 0, 40)
    infoButton.Position = UDim2.new(0, 10, 0, 10)
    infoButton.BackgroundColor3 = settings.accentColor
    infoButton.Font = Enum.Font.GothamBold
    infoButton.Text = "معلومات"
    infoButton.TextSize = 18
    infoButton.TextColor3 = settings.textColor
    infoButton.Parent = optionPanel

    local infoButtonCorner = Instance.new("UICorner")
    infoButtonCorner.CornerRadius = UDim.new(0, 8)
    infoButtonCorner.Parent = infoButton

    infoButton.MouseEnter:Connect(function()
        TweenService:Create(infoButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 200, 120)}):Play()
    end)
    infoButton.MouseLeave:Connect(function()
        TweenService:Create(infoButton, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor}):Play()
    end)

    infoButton.MouseButton1Click:Connect(function()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        if parentGui:FindFirstChild("InfoInterface") then
            parentGui.InfoInterface:Destroy()
        else
            createInfoInterface(parentGui)
        end
        optionPanel:Destroy()
    end)

    local mainButton = Instance.new("TextButton")
    mainButton.Name = "MainButton"
    mainButton.Size = UDim2.new(1, -20, 0, 40)
    mainButton.Position = UDim2.new(0, 10, 0, 55)
    mainButton.BackgroundColor3 = settings.accentColor
    mainButton.Font = Enum.Font.GothamBold
    mainButton.Text = "الواجهة"
    mainButton.TextSize = 18
    mainButton.TextColor3 = settings.textColor
    mainButton.Parent = optionPanel

    local mainButtonCorner = Instance.new("UICorner")
    mainButtonCorner.CornerRadius = UDim.new(0, 8)
    mainButtonCorner.Parent = mainButton

    mainButton.MouseEnter:Connect(function()
        TweenService:Create(mainButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 200, 120)}):Play()
    end)
    mainButton.MouseLeave:Connect(function()
        TweenService:Create(mainButton, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor}):Play()
    end)

    mainButton.MouseButton1Click:Connect(function()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        if parentGui:FindFirstChild("MainInterface") then
            parentGui.MainInterface:Destroy()
        else
            createMainInterface(parentGui)
        end
        optionPanel:Destroy()
    end)

    return optionPanel
end

---------------------------------------------
-- دالة إنشاء القائمة الدائرية (Circular Menu)
---------------------------------------------
local function createCircularMenu()
    local player = LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    if playerGui:FindFirstChild("CircularMenuGUI") then
        playerGui.CircularMenuGUI:Destroy()
    end

    local circularMenuGUI = Instance.new("ScreenGui")
    circularMenuGUI.Name = "CircularMenuGUI"
    circularMenuGUI.ResetOnSpawn = false
    circularMenuGUI.Parent = playerGui

    local circularButton = Instance.new("ImageButton")
    circularButton.Name = "CircularButton"
    circularButton.Size = UDim2.new(0, 60, 0, 60)
    circularButton.Position = UDim2.new(0.95, -30, 0.5, -30)
    circularButton.BackgroundColor3 = settings.accentColor
    circularButton.Image = "rbxassetid://7059346373" -- أيقونة القائمة
    circularButton.ImageColor3 = Color3.new(1, 1, 1)
    circularButton.BackgroundTransparency = 0.1
    circularButton.Parent = circularMenuGUI

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(1, 0)
    buttonCorner.Parent = circularButton

    local buttonUIStroke = Instance.new("UIStroke")
    buttonUIStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonUIStroke.Thickness = 2
    buttonUIStroke.Transparency = 0.5
    buttonUIStroke.Parent = circularButton

    local originalSize = circularButton.Size
    circularButton.MouseEnter:Connect(function()
        TweenService:Create(circularButton, TweenInfo.new(0.3), {Size = UDim2.new(0, 70, 0, 70), Position = UDim2.new(0.95, -35, 0.5, -35)}):Play()
        TweenService:Create(buttonUIStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    end)
    circularButton.MouseLeave:Connect(function()
        TweenService:Create(circularButton, TweenInfo.new(0.3), {Size = originalSize, Position = UDim2.new(0.95, -30, 0.5, -30)}):Play()
        TweenService:Create(buttonUIStroke, TweenInfo.new(0.3), {Transparency = 0.5}):Play()
    end)

    circularButton.MouseButton1Click:Connect(function()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = circularMenuGUI
        btnSound:Play()
        createOptionPanel(circularMenuGUI)
    end)

    return circularButton, circularMenuGUI
end

---------------------------------------------
-- دالة إظهار الواجهة الرئيسية للمكتبة (Show)
---------------------------------------------
function Luna:Show()
    local _, screenGui = createCircularMenu()
    createMainInterface(screenGui)
end

---------------------------------------------
-- دالة إضافة سكربت خارجي إلى القائمة (AddScript)
---------------------------------------------
function Luna:AddScript(scriptData)
    table.insert(externalScripts, scriptData)
end

---------------------------------------------
-- يمكن إضافة المزيد من الوظائف حسب الحاجة
---------------------------------------------

return Luna
