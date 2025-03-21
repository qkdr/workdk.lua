---------------------------------------------
-- مكتبة Luna للواجهات الفخمة في Roblox
-- تُتيح إضافة مجلدات تحتوي على سكربتات خارجية وتشغيلها عبر واجهة ثنائية المستوى
--
-- طريقة الاستخدام:
-- local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourRepo/YourScript.lua", true))()
-- Luna:AddFolder({
--     folderName = "اسم المجلد",
--     scripts = {
--         {
--             name = "Silent Aim",
--             description = "يتيح لك التصويب الصامت على الأعداء.",
--             url = "https://raw.githubusercontent.com/ExampleUser/SilentAim.lua"
--         },
--         -- المزيد من السكربتات...
--     }
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
    backgroundImage = "rbxassetid://13577851314", -- صورة خلفية الواجهة الرئيسية
    buttonColor = Color3.fromRGB(40, 40, 40),
    accentColor = Color3.fromRGB(0, 170, 100),
    textColor = Color3.fromRGB(255, 255, 255),
    cornerRadius = UDim.new(0, 12),
    transparency = 0.2,
    telegramLink = "https://t.me/YourChannelLink"
}

---------------------------------------------
-- بيانات المجلدات الخارجية (كل مجلد يحتوي على قائمة من السكربتات)
---------------------------------------------
local externalFolders = {}  -- تُضاف مجلدات عبر دالة AddFolder

---------------------------------------------
-- خدمات Roblox
---------------------------------------------
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
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
    notification.ZIndex = 10

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
    notifText.ZIndex = 10

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
    confirmationFrame.ZIndex = 10

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
    warningIcon.ZIndex = 10

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
    confirmationText.ZIndex = 10

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
    confirmButton.ZIndex = 10

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
    cancelButton.ZIndex = 10

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
-- دالة إنشاء واجهة المجلدات (Folder Interface)
---------------------------------------------
local function createFolderInterface(parentGui, folderData)
    local folderFrame = Instance.new("Frame")
    folderFrame.Name = "FolderInterface"
    folderFrame.Size = UDim2.new(0, 500, 0, 400)
    folderFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    folderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    folderFrame.BackgroundTransparency = settings.transparency
    folderFrame.BorderSizePixel = 0
    folderFrame.ClipsDescendants = true
    folderFrame.Parent = parentGui

    local folderCorner = Instance.new("UICorner")
    folderCorner.CornerRadius = settings.cornerRadius
    folderCorner.Parent = folderFrame

    local folderTitle = Instance.new("TextLabel")
    folderTitle.Name = "FolderTitle"
    folderTitle.Size = UDim2.new(0, 400, 0, 50)
    folderTitle.Position = UDim2.new(0.5, -200, 0, 10)
    folderTitle.BackgroundTransparency = 1
    folderTitle.Font = Enum.Font.GothamBold
    folderTitle.Text = folderData.folderName
    folderTitle.TextSize = 28
    folderTitle.TextColor3 = settings.textColor
    folderTitle.Parent = folderFrame

    local backButton = Instance.new("TextButton")
    backButton.Name = "BackButton"
    backButton.Size = UDim2.new(0, 80, 0, 40)
    backButton.Position = UDim2.new(0, 10, 0, 10)
    backButton.BackgroundColor3 = settings.accentColor
    backButton.Font = Enum.Font.GothamBold
    backButton.Text = "رجوع"
    backButton.TextSize = 18
    backButton.TextColor3 = settings.textColor
    backButton.Parent = folderFrame

    local backCorner = Instance.new("UICorner")
    backCorner.CornerRadius = UDim.new(0, 8)
    backCorner.Parent = backButton

    backButton.MouseButton1Click:Connect(function()
        folderFrame:Destroy()
    end)

    local folderScriptsFrame = Instance.new("ScrollingFrame")
    folderScriptsFrame.Name = "FolderScriptsFrame"
    folderScriptsFrame.Size = UDim2.new(1, -40, 0, 300)
    folderScriptsFrame.Position = UDim2.new(0, 20, 0, 70)
    folderScriptsFrame.BackgroundTransparency = 1
    folderScriptsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    folderScriptsFrame.ScrollBarThickness = 4
    folderScriptsFrame.Parent = folderFrame

    local folderGrid = Instance.new("UIGridLayout")
    folderGrid.CellSize = UDim2.new(0, 200, 0, 240)
    folderGrid.CellPadding = UDim2.new(0, 10, 0, 10)
    folderGrid.Parent = folderScriptsFrame

    folderGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        folderScriptsFrame.CanvasSize = UDim2.new(0, folderGrid.AbsoluteContentSize.X, 0, folderGrid.AbsoluteContentSize.Y)
    end)

    for _, scriptData in ipairs(folderData.scripts or {}) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Name = scriptData.name
        itemFrame.Size = UDim2.new(0, 200, 0, 240)
        itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        itemFrame.BackgroundTransparency = 0.7
        itemFrame.Parent = folderScriptsFrame

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
            showConfirmationDialog(parentGui, "هل أنت متأكد أنك تريد تشغيل " .. scriptData.name .. "؟", function()
                loadstring(game:HttpGet(scriptData.url))()
                showNotification(parentGui, "تم تشغيل " .. scriptData.name .. "!")
            end)
        end)
    end

    return folderFrame
end

---------------------------------------------
-- دالة إنشاء الواجهة الرئيسية (Main Interface)
-- الآن الحجم أصبح 500×400 كما في نافذة المعلومات
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
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = settings.transparency
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = parentGui

    mainFrame.Rotation = -5
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
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
    -- عرض المجلدات (Folders)
    -------------------------------------------------
    local foldersFrame = Instance.new("ScrollingFrame")
    foldersFrame.Name = "FoldersFrame"
    foldersFrame.Size = UDim2.new(1, -60, 0, 200)
    foldersFrame.Position = UDim2.new(0, 30, 0, 80)
    foldersFrame.BackgroundTransparency = 1
    foldersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    foldersFrame.ScrollBarThickness = 4
    foldersFrame.Parent = mainFrame

    local foldersGrid = Instance.new("UIGridLayout")
    foldersGrid.CellSize = UDim2.new(0, 200, 0, 80)
    foldersGrid.CellPadding = UDim2.new(0, 10, 0, 10)
    foldersGrid.Parent = foldersFrame

    foldersGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        foldersFrame.CanvasSize = UDim2.new(0, foldersGrid.AbsoluteContentSize.X, 0, foldersGrid.AbsoluteContentSize.Y)
    end)

    for _, folderData in ipairs(externalFolders) do
        local folderButton = Instance.new("TextButton")
        folderButton.Name = folderData.folderName
        folderButton.Size = UDim2.new(0, 200, 0, 80)
        folderButton.BackgroundColor3 = settings.accentColor
        folderButton.Font = Enum.Font.GothamBold
        folderButton.Text = folderData.folderName
        folderButton.TextSize = 24
        folderButton.TextColor3 = settings.textColor
        folderButton.Parent = foldersFrame

        local folderCorner = Instance.new("UICorner")
        folderCorner.CornerRadius = settings.cornerRadius
        folderCorner.Parent = folderButton

        folderButton.MouseButton1Click:Connect(function()
            createFolderInterface(parentGui, folderData)
        end)
    end

    -------------------------------------------------
    -- نهاية عرض المجلدات
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
    closeButton.ZIndex = 10

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
-- دالة إنشاء القائمة الدائرية (Circular Menu) مع إمكانية السحب
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

    -- تحسين آلية السحب لتكون أكثر سلاسة
    local dragging = false
    local dragStart, startPos

    circularButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = circularButton.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    circularButton.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            circularButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    circularButton.MouseEnter:Connect(function()
        TweenService:Create(circularButton, TweenInfo.new(0.3), {Size = UDim2.new(0, 70, 0, 70), Position = UDim2.new(0.95, -35, 0.5, -35)}):Play()
        TweenService:Create(buttonUIStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    end)
    circularButton.MouseLeave:Connect(function()
        TweenService:Create(circularButton, TweenInfo.new(0.3), {Size = UDim2.new(0, 60, 0, 60), Position = UDim2.new(0.95, -30, 0.5, -30)}):Play()
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
-- دالة إضافة مجلد يحتوي على سكربتات (AddFolder)
---------------------------------------------
function Luna:AddFolder(folderData)
    table.insert(externalFolders, folderData)
end

---------------------------------------------
-- يمكن إضافة المزيد من الوظائف حسب الحاجة
---------------------------------------------

return Luna
