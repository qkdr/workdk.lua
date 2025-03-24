---------------------------------------------
-- مكتبة Luna للواجهات الفخمة في Roblox
-- تُتيح إضافة مجلدات (مفتوحة أو مغلقة) تحتوي على سكربتات خارجية وتشغيلها عبر واجهة ثنائية المستوى.
-- حجم الواجهة الرئيسية (MainInterface) ونافذة المعلومات (InfoInterface) هو 500×400.
-- كل مجلد يظهر كزر شفاف عريض (450×60) مع تأثير "زجاج" (Glass effect) متحرك،
-- يحتوي داخل الزر على:
--    • (بالنسبة للمجلد المفتوح) أيقونة مجلد (المعرف في settings.folderIcon)؛
--    • (بالنسبة للمجلد المغلق) أيقونة قفل (نص "🔒")؛
--    • اسم المجلد (FolderNameLabel)؛
--    • وصف المجلد (FolderDescLabel)؛
--    • وعدد السكربتات: "سكربتات: X" (للملفات المفتوحة).
-- عند الضغط على مجلد مفتوح يتم فتحه، أما المجلد المغلق فيعرض إشعار بأن الملف مغلق.
-- في نافذة الواجهة يتم عرض صورة اللاعب واسمه في أعلى اليسار، وزر إغلاق (X) في أعلى اليمين.
-- كما يوجد زر بحث لتصفية المجلدات، والزر الدائري (CircularButton) قابل للسحب بسلاسة.
---------------------------------------------

local Luna = {}

---------------------------------------------
-- إعدادات عامة قابلة للتعديل
---------------------------------------------
local settings = {
    openSound = "rbxassetid://6042053626",
    buttonSound = "rbxassetid://6026984224",
    warningSound = "rbxassetid://6042055798",
    backgroundImage = "rbxassetid://13577851314", -- صورة خلفية الواجهة
    buttonColor = Color3.fromRGB(40, 40, 40),
    accentColor = Color3.fromRGB(0, 170, 100),
    textColor = Color3.fromRGB(255, 255, 255),
    cornerRadius = UDim.new(0, 12),
    transparency = 0.2,
    telegramLink = "https://t.me/YourChannelLink",
    folderIcon = "rbxassetid://123456789" -- ضع هنا معرف أيقونة المجلد للمجلد المفتوح
}

---------------------------------------------
-- بيانات المجلدات الخارجية
-- كل مجلد عبارة عن جدول يحتوي على folderName، folderDescription، scripts، وخاصية locked (اختياري)
---------------------------------------------
local externalFolders = {}

---------------------------------------------
-- خدمات Roblox
---------------------------------------------
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
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
-- دالة تطبيق تأثير "زجاج" (Glass effect) على زر المجلد
---------------------------------------------
local function applyGlassEffect(folderButton)
    local glassEffect = Instance.new("Frame")
    glassEffect.Name = "GlassEffect"
    glassEffect.Size = UDim2.new(0, 50, 1, 0)
    glassEffect.Position = UDim2.new(-1, 0, 0, 0)
    glassEffect.BackgroundTransparency = 0.5
    glassEffect.BackgroundColor3 = Color3.new(1, 1, 1)
    glassEffect.Parent = folderButton
    glassEffect.ZIndex = folderButton.ZIndex + 1

    local glassGradient = Instance.new("UIGradient")
    glassGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(0.5, Color3.new(1,1,1)),
        ColorSequenceKeypoint.new(1, Color3.new(1,1,1))
    })
    glassGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 0),
        NumberSequenceKeypoint.new(1, 0.8)
    })
    glassGradient.Parent = glassEffect

    local function tweenGlass()
        local tween1 = TweenService:Create(glassEffect, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)})
        local tween2 = TweenService:Create(glassEffect, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(-1, 0, 0, 0)})
        tween1:Play()
        tween1.Completed:Wait()
        tween2:Play()
        tween2.Completed:Wait()
        tweenGlass() -- حلقة مستمرة
    end
    spawn(tweenGlass)
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
    folderTitle.Size = UDim2.new(0, 400, 0, 30)
    folderTitle.Position = UDim2.new(0.5, -200, 0, 10)
    folderTitle.BackgroundTransparency = 1
    folderTitle.Font = Enum.Font.GothamBold
    folderTitle.Text = folderData.folderName or "مجلد"
    folderTitle.TextSize = 26
    folderTitle.TextColor3 = settings.textColor
    folderTitle.Parent = folderFrame

    local folderDesc = Instance.new("TextLabel")
    folderDesc.Name = "FolderDescLabel"
    folderDesc.Size = UDim2.new(0, 400, 0, 20)
    folderDesc.Position = UDim2.new(0.5, -200, 0, 40)
    folderDesc.BackgroundTransparency = 1
    folderDesc.Font = Enum.Font.Gotham
    folderDesc.Text = folderData.folderDescription or ""
    folderDesc.TextSize = 16
    folderDesc.TextColor3 = settings.textColor
    folderDesc.TextXAlignment = Enum.TextXAlignment.Left
    folderDesc.TextWrapped = true
    folderDesc.Parent = folderFrame

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
-- بحجم 500×400 مع زر بحث، صورة شخصية واسمه في أعلى اليسار، وزر إغلاق (X) في أعلى اليمين.
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

    -- صورة شخصية واسمه في أعلى اليسار
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 50, 0, 50)
    avatar.Position = UDim2.new(0, 10, 0, 10)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    avatar.Parent = mainFrame

    local avatarCorner = Instance.new("UICorner")
    avatarCorner.CornerRadius = UDim.new(0, 25)
    avatarCorner.Parent = avatar

    local playerNameLabel = Instance.new("TextLabel")
    playerNameLabel.Name = "PlayerNameLabel"
    playerNameLabel.Size = UDim2.new(0, 150, 0, 50)
    playerNameLabel.Position = UDim2.new(0, 70, 0, 10)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.Text = LocalPlayer.DisplayName
    playerNameLabel.TextSize = 18
    playerNameLabel.TextColor3 = settings.textColor
    playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerNameLabel.Parent = mainFrame

    -- زر إغلاق (X) في نافذة الواجهة (بدون نص الإصدار)
    local closeButton = Instance.new("TextButton")
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

    -- زر بحث عن مجلد
    local searchFrame = Instance.new("Frame")
    searchFrame.Name = "SearchFrame"
    searchFrame.Size = UDim2.new(0, 400, 0, 30)
    searchFrame.Position = UDim2.new(0, 50, 0, 60)
    searchFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    searchFrame.BackgroundTransparency = 0.5
    searchFrame.Parent = mainFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -10, 1, 0)
    searchBox.Position = UDim2.new(0, 5, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "ابحث عن مجلد..."
    searchBox.Text = ""
    searchBox.TextSize = 16
    searchBox.TextColor3 = settings.textColor
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchFrame

    searchBox.Changed:Connect(function(prop)
        if prop == "Text" then
            for _, folderButton in pairs(mainFrame.FoldersFrame:GetChildren()) do
                if folderButton:IsA("TextButton") then
                    if string.find(string.lower(folderButton.Name), string.lower(searchBox.Text)) then
                        folderButton.Visible = true
                    else
                        folderButton.Visible = false
                    end
                end
            end
        end
    end)

    local foldersFrame = mainFrame:FindFirstChild("FoldersFrame")
    if not foldersFrame then
        foldersFrame = Instance.new("ScrollingFrame")
        foldersFrame.Name = "FoldersFrame"
        foldersFrame.Size = UDim2.new(1, -60, 0, 250)
        foldersFrame.Position = UDim2.new(0, 30, 0, 100)
        foldersFrame.BackgroundTransparency = 1
        foldersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        foldersFrame.ScrollBarThickness = 4
        foldersFrame.Parent = mainFrame
    end

    local foldersGrid = Instance.new("UIGridLayout")
    foldersGrid.CellSize = UDim2.new(0, 450, 0, 60)
    foldersGrid.CellPadding = UDim2.new(0, 10, 0, 10)
    foldersGrid.Parent = foldersFrame

    foldersGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        foldersFrame.CanvasSize = UDim2.new(0, foldersGrid.AbsoluteContentSize.X, 0, foldersGrid.AbsoluteContentSize.Y)
    end)

    for _, folderData in ipairs(externalFolders) do
        local folderButton = Instance.new("TextButton")
        folderButton.Name = folderData.folderName or "Folder"
        folderButton.Size = UDim2.new(0, 450, 0, 60)
        folderButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        folderButton.BackgroundTransparency = folderData.locked and 0.8 or 0.4
        folderButton.Font = Enum.Font.SourceSans
        folderButton.Text = ""
        folderButton.Parent = foldersFrame

        local folderCorner = Instance.new("UICorner")
        folderCorner.CornerRadius = settings.cornerRadius
        folderCorner.Parent = folderButton

        -- تطبيق تأثير "زجاج" (Glass effect) على زر المجلد
        applyGlassEffect(folderButton)

        local folderNameLabel = Instance.new("TextLabel")
        folderNameLabel.Name = "FolderNameLabel"
        folderNameLabel.Size = UDim2.new(1, -20, 0, 25)
        folderNameLabel.Position = UDim2.new(0, 10, 0, 5)
        folderNameLabel.BackgroundTransparency = 1
        folderNameLabel.Font = Enum.Font.GothamBold
        folderNameLabel.Text = folderData.folderName or "مجلد"
        folderNameLabel.TextSize = 20
        folderNameLabel.TextColor3 = settings.textColor
        folderNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        folderNameLabel.Parent = folderButton

        local folderDescLabel = Instance.new("TextLabel")
        folderDescLabel.Name = "FolderDescLabel"
        folderDescLabel.Size = UDim2.new(1, -20, 0, 20)
        folderDescLabel.Position = UDim2.new(0, 10, 0, 30)
        folderDescLabel.BackgroundTransparency = 1
        folderDescLabel.Font = Enum.Font.Gotham
        folderDescLabel.Text = folderData.folderDescription or ""
        folderDescLabel.TextSize = 16
        folderDescLabel.TextColor3 = settings.textColor
        folderDescLabel.TextXAlignment = Enum.TextXAlignment.Left
        folderDescLabel.TextWrapped = true
        folderDescLabel.Parent = folderButton

        -- عرض عدد السكربتات (للمجلد المفتوح فقط)
        if not folderData.locked then
            local scriptCount = #folderData.scripts
            local scriptsLabel = Instance.new("TextLabel")
            scriptsLabel.Name = "ScriptsLabel"
            scriptsLabel.Size = UDim2.new(0, 120, 0, 20)
            scriptsLabel.Position = UDim2.new(1, -130, 0, 5)
            scriptsLabel.BackgroundTransparency = 1
            scriptsLabel.Font = Enum.Font.GothamBold
            scriptsLabel.Text = "سكربتات: " .. scriptCount
            scriptsLabel.TextSize = 16
            scriptsLabel.TextColor3 = settings.textColor
            scriptsLabel.TextXAlignment = Enum.TextXAlignment.Right
            scriptsLabel.Parent = folderButton
        end

        -- إذا كان المجلد مغلق، نعرض أيقونة قفل على شكل نص "🔒" في منتصف الزر
        if folderData.locked then
            local lockedLabel = Instance.new("TextLabel")
            lockedLabel.Name = "LockedLabel"
            lockedLabel.Size = UDim2.new(0, 30, 0, 30)
            lockedLabel.Position = UDim2.new(0, 10, 0.5, -15)
            lockedLabel.BackgroundTransparency = 1
            lockedLabel.Font = Enum.Font.GothamBold
            lockedLabel.Text = "🔒"
            lockedLabel.TextSize = 24
            lockedLabel.TextColor3 = settings.accentColor
            lockedLabel.Parent = folderButton
            folderButton.MouseButton1Click:Connect(function()
                showNotification(parentGui, "هذا الملف مغلق ولا يمكن فتحه.")
            end)
        else
            folderButton.MouseButton1Click:Connect(function()
                local btnSound = Instance.new("Sound")
                btnSound.SoundId = settings.buttonSound
                btnSound.Volume = 0.5
                btnSound.Parent = parentGui
                btnSound:Play()
                createFolderInterface(parentGui, folderData)
            end)
        end
    end

    return mainFrame
end

---------------------------------------------
-- دالة إنشاء واجهة المعلومات (Info Interface)
-- بحجم 500×400
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
    infoFrame.Size = UDim2.new(0, 500, 0, 400)
    infoFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    infoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    infoFrame.BackgroundTransparency = settings.transparency
    infoFrame.BorderSizePixel = 0
    infoFrame.ClipsDescendants = true
    infoFrame.Parent = parentGui

    infoFrame.Rotation = -5
    infoFrame.Size = UDim2.new(0, 0, 0, 0)
    infoFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(infoFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        Rotation = 0
    }):Play()

    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = settings.cornerRadius
    infoCorner.Parent = infoFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "InfoTitle"
    titleLabel.Size = UDim2.new(0, 400, 0, 50)
    titleLabel.Position = UDim2.new(0.5, -200, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "معلومات التطبيق"
    titleLabel.TextSize = 28
    titleLabel.TextColor3 = settings.textColor
    titleLabel.Parent = infoFrame

    local infoContainer = Instance.new("Frame")
    infoContainer.Name = "InfoContainer"
    infoContainer.Size = UDim2.new(1, -40, 0, 100)
    infoContainer.Position = UDim2.new(0, 20, 0, 70)
    infoContainer.BackgroundTransparency = 0.5
    infoContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    infoContainer.Parent = infoFrame

    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 8)
    containerCorner.Parent = infoContainer

    local smallPlayerIcon = Instance.new("ImageLabel")
    smallPlayerIcon.Name = "SmallPlayerIcon"
    smallPlayerIcon.Size = UDim2.new(0, 60, 0, 60)
    smallPlayerIcon.Position = UDim2.new(0, 10, 0, 20)
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
    nameLabel.Position = UDim2.new(0, 0, 0, 5)
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
    idLabel.Position = UDim2.new(0, 0, 0, 30)
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
    hackLabel.Position = UDim2.new(0, 0, 0, 55)
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
    keyLabel.Position = UDim2.new(0, 0, 0, 80)
    keyLabel.BackgroundTransparency = 1
    keyLabel.Font = Enum.Font.GothamBold
    keyLabel.Text = "المفتاح: SecretKey"
    keyLabel.TextSize = 18
    keyLabel.TextColor3 = settings.textColor
    keyLabel.TextXAlignment = Enum.TextXAlignment.Left
    keyLabel.Parent = infoTextContainer

    local playersFrame = Instance.new("ScrollingFrame")
    playersFrame.Name = "PlayersInfoFrame"
    playersFrame.Size = UDim2.new(1, -40, 0, 150)
    playersFrame.Position = UDim2.new(0, 20, 0, 180)
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
        nameText.Size = UDim2.new(0.5, 0, 1, 0)
        nameText.BackgroundTransparency = 1
        nameText.Font = Enum.Font.GothamBold
        nameText.Text = "اسمه: " .. player.Name
        nameText.TextSize = 16
        nameText.TextColor3 = settings.textColor
        nameText.Parent = entry

        local idText = Instance.new("TextLabel")
        idText.Name = "IDText"
        idText.Size = UDim2.new(0.4, 0, 1, 0)
        idText.Position = UDim2.new(0.51, 0, 0, 0)
        idText.BackgroundTransparency = 1
        idText.Font = Enum.Font.GothamBold
        idText.Text = "ايديه: " .. tostring(player.UserId)
        idText.TextSize = 16
        idText.TextColor3 = settings.textColor
        idText.Parent = entry

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
    infoCloseButton.ZIndex = 10

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
    infoButtonCorner.CornerRadius = settings.cornerRadius
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
            local infoUI = createInfoInterface(parentGui)
            infoUI.Name = "InfoInterface"
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
    mainButtonCorner.CornerRadius = settings.cornerRadius
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
            local mainUI = createMainInterface(parentGui)
            mainUI.Name = "MainInterface"
        end
        optionPanel:Destroy()
    end)

    return optionPanel
end

---------------------------------------------
-- دالة إنشاء القائمة الدائرية (Circular Menu) مع سحب سلس
---------------------------------------------
local function createCircularMenu()
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")

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
    buttonCorner.CornerRadius = settings.cornerRadius
    buttonCorner.Parent = circularButton

    local buttonUIStroke = Instance.new("UIStroke")
    buttonUIStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonUIStroke.Thickness = 2
    buttonUIStroke.Transparency = 0.5
    buttonUIStroke.Parent = circularButton

    -- السحب السلس
    local dragging = false
    local dragInput, dragStart, startPos

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
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            circularButton.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    circularButton.MouseEnter:Connect(function()
        TweenService:Create(circularButton, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 70, 0, 70),
            Position = UDim2.new(0.95, -35, 0.5, -35)
        }):Play()
        TweenService:Create(buttonUIStroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
    end)

    circularButton.MouseLeave:Connect(function()
        TweenService:Create(circularButton, TweenInfo.new(0.3), {
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(0.95, -30, 0.5, -30)
        }):Play()
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
    local mainUI = createMainInterface(screenGui)
    mainUI.Name = "MainInterface"
end

---------------------------------------------
-- دالة إضافة مجلد مفتوح يحتوي على سكربتات (AddFolder)
---------------------------------------------
function Luna:AddFolder(folderData)
    if not folderData.timestamp then
        folderData.timestamp = os.time()
    end
    folderData.locked = false
    table.insert(externalFolders, folderData)
end

---------------------------------------------
-- دالة إضافة مجلد مغلق يحتوي على سكربتات (AddLockedFolder)
-- هنا يتم إنشاء مجلد مغلق بحيث يظهر داخل زر المجلد نص "🔒" (قفل) بدلاً من أيقونة المجلد،
-- ويُظهر فقط اسم المجلد ووصفه، ولا يُمكن فتحه.
---------------------------------------------
function Luna:AddLockedFolder(folderData)
    if not folderData.timestamp then
        folderData.timestamp = os.time()
    end
    folderData.locked = true
    table.insert(externalFolders, folderData)
end

---------------------------------------------
-- يمكن إضافة المزيد من الوظائف حسب الحاجة
---------------------------------------------

return Luna
