---------------------------------------------
-- مكتبة Luna للواجهات الفخمة في Roblox
-- تُتيح إضافة مجلدات تحتوي على سكربتات خارجية وتشغيلها عبر واجهة ثنائية المستوى.
-- حجم الواجهة الرئيسية (MainInterface) ونافذة المعلومات (InfoInterface) هو 500×400.
-- كل مجلد يظهر كزر شفاف عريض (450×60) مع تأثير "زجاج" متحرك (يحرك غطاء شفاف يغطي المجلد بأكمله ثم يعود)
-- داخل الزر يظهر:
--    • أيقونة المجلد (يمكن تعديل معرف الصورة عبر settings.folderIcon)
--    • اسم المجلد (FolderNameLabel)
--    • وصف المجلد (FolderDescLabel)
--    • عرض عدد السكربتات (ScriptsLabel)
-- في نافذة الواجهة يتم عرض صورة اللاعب واسمه في أعلى اليسار، وزر إغلاق (X) صحيح في النافذة (دون نص الإصدار).
-- يوجد زر بحث لتصفية المجلدات، والزر الدائري (CircularButton) قابل للسحب بسلاسة.
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
    folderIcon = "rbxassetid://123456789" -- عدل معرف أيقونة المجلد هنا
}

---------------------------------------------
-- بيانات المجلدات الخارجية
-- يمكن تمرير folderDescription كحقل اختياري.
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
-- دالة إنشاء تأثير زجاج (Glass Effect) على زر المجلد
-- يُضيف إطار زجاجي يغطي الزر بأكمله ويتحرك من اليسار إلى اليمين ثم يعود.
---------------------------------------------
local function applyGlassEffect(folderButton)
    local glassEffect = Instance.new("Frame")
    glassEffect.Name = "GlassEffect"
    glassEffect.Size = UDim2.new(1, 0, 1, 0)
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

    local tweenInfo = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenForward = TweenService:Create(glassEffect, tweenInfo, {Position = UDim2.new(1, 0, 0, 0)})
    local tweenBackward = TweenService:Create(glassEffect, tweenInfo, {Position = UDim2.new(-1, 0, 0, 0)})

    local function animateGlass()
        tweenForward:Play()
        tweenForward.Completed:Wait()
        tweenBackward:Play()
        tweenBackward.Completed:Wait()
        animateGlass()
    end
    spawn(animateGlass)
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
-- بحجم 500×400 مع زر بحث، صورة شخصية واسمه في أعلى اليسار، وزر إغلاق (X) صحيح (دون نص إصدار).
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

    -- زر إغلاق (X) بدون نص الإصدار
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
        folderButton.BackgroundTransparency = 0.4
        folderButton.Font = Enum.Font.SourceSans
        folderButton.Text = ""
        folderButton.Parent = foldersFrame

        local folderCorner = Instance.new("UICorner")
        folderCorner.CornerRadius = settings.cornerRadius
        folderCorner.Parent = folderButton

        -- إزالة التأثير القديم (Glow) واستبداله بتأثير زجاج (Glass Effect)
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

        folderButton.MouseButton1Click:Connect(function()
            local btnSound = Instance.new("Sound")
            btnSound.SoundId = settings.buttonSound
            btnSound.Volume = 0.5
            btnSound.Parent = parentGui
            btnSound:Play()
            createFolderInterface(parentGui, folderData)
        end)
    end

    return mainFrame
end

---------------------------------------------
-- دالة إنشاء الواجهة الرئيسية (Main Interface)
-- بحجم 500×400 مع زر بحث، صورة شخصية واسمه في أعلى اليسار، وزر إغلاق (X) صحيح.
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

    -- زر إغلاق (X) بدون نص الإصدار
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
        folderButton.BackgroundTransparency = 0.4
        folderButton.Font = Enum.Font.SourceSans
        folderButton.Text = ""
        folderButton.Parent = foldersFrame

        local folderCorner = Instance.new("UICorner")
        folderCorner.CornerRadius = settings.cornerRadius
        folderCorner.Parent = folderButton

        -- إضافة تأثير الزجاج على زر المجلد
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

        folderButton.MouseButton1Click:Connect(function()
            local btnSound = Instance.new("Sound")
            btnSound.SoundId = settings.buttonSound
            btnSound.Volume = 0.5
            btnSound.Parent = parentGui
            btnSound:Play()
            createFolderInterface(parentGui, folderData)
        end)
    end

    return mainFrame
end

---------------------------------------------
-- دالة إنشاء الواجهة الرئيسية (Main Interface)
-- بحجم 500×400 مع زر بحث، صورة شخصية واسمه في أعلى اليسار، وزر إغلاق (X) صحيح.
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

    -- زر إغلاق (X) بدون نص الإصدار
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

    -- زر بحث عن مجلد (كما في السابق)
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
        folderButton.BackgroundTransparency = 0.4
        folderButton.Font = Enum.Font.SourceSans
        folderButton.Text = ""
        folderButton.Parent = foldersFrame

        local folderCorner = Instance.new("UICorner")
        folderCorner.CornerRadius = settings.cornerRadius
        folderCorner.Parent = folderButton

        -- تطبيق تأثير الزجاج على زر المجلد
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

        folderButton.MouseButton1Click:Connect(function()
            local btnSound = Instance.new("Sound")
            btnSound.SoundId = settings.buttonSound
            btnSound.Volume = 0.5
            btnSound.Parent = parentGui
            btnSound:Play()
            createFolderInterface(parentGui, folderData)
        end)
    end

    return mainFrame
end

---------------------------------------------
-- دالة إنشاء الواجهة الرئيسية للمكتبة (Show)
---------------------------------------------
function Luna:Show()
    local _, screenGui = createCircularMenu()
    local mainUI = createMainInterface(screenGui)
    mainUI.Name = "MainInterface"
end

---------------------------------------------
-- دالة إضافة مجلد يحتوي على سكربتات (AddFolder)
---------------------------------------------
function Luna:AddFolder(folderData)
    if not folderData.timestamp then
        folderData.timestamp = os.time()
    end
    table.insert(externalFolders, folderData)
end

---------------------------------------------
-- يمكن إضافة المزيد من الوظائف حسب الحاجة
---------------------------------------------

return Luna
