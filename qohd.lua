---------------------------------------------
-- مكتبة Luna Pro للواجهات الفخمة والأسطورية في Roblox
-- الإصدار: 2.0 (Epic Glassmorphism)
-- المحدث: معالجة وإصلاح مشاكل الزر الدائري والسحب
-- ميزات إضافية: مجلدات محمية بكود، اختصارات مفاتيح، أنميشن أسطوري، وتصميم زجاجي.
---------------------------------------------

local Luna = {}

---------------------------------------------
-- إعدادات عامة قابلة للتعديل ⚙️
---------------------------------------------
local settings = {
    openSound = "rbxassetid://6042053626", -- صوت فتح الواجهة
    buttonSound = "rbxassetid://6026984224", -- صوت النقر على زر
    warningSound = "rbxassetid://6042055798", -- صوت تحذير/قفل
    backgroundImage = "rbxassetid://13577851314", -- صورة خلفية الواجهة (يمكن تغييرها)
    buttonColor = Color3.fromRGB(40, 40, 40), -- لون الأزرار الأساسي
    accentColor = Color3.fromRGB(0, 190, 190), -- اللون المميز (Azure/Cyan)
    textColor = Color3.fromRGB(255, 255, 255), -- لون النص
    cornerRadius = UDim.new(0, 16), -- نصف قطر الزوايا (للمظهر الزجاجي الفخم)
    transparency = 0.3, -- شفافية الإطارات الأساسية (لتأثير الزجاج المضلل)
    telegramLink = "https://t.me/YourChannelLink",
    folderIcon = "rbxassetid://7428741366", -- أيقونة المجلد المفتوح (New Epic Folder Icon)
    lockIcon = "rbxassetid://4224275681", -- أيقونة القفل
    infoIcon = "rbxassetid://7335759146", -- أيقونة المعلومات
    mainIcon = "rbxassetid://7335756476", -- أيقونة القائمة الرئيسية
    shortcutKey = Enum.KeyCode.Insert -- مفتاح اختصار لإخفاء/إظهار الواجهة
}

---------------------------------------------
-- بيانات المجلدات الخارجية واختصارات المفاتيح
---------------------------------------------
local externalFolders = {}
local shortcuts = {} -- لتخزين الاختصارات

---------------------------------------------
-- خدمات Roblox
---------------------------------------------
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

---------------------------------------------
-- دالة عرض إشعار أنيق على الشاشة 🔔
---------------------------------------------
local function showNotification(parentGui, message, color)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(0.5, -150, 0, -60)
    notification.BackgroundColor3 = color or settings.accentColor
    notification.BackgroundTransparency = 0.1 -- زجاج خفيف
    notification.BorderSizePixel = 0
    notification.Parent = parentGui
    notification.ZIndex = 10
    notification.ClipsDescendants = true

    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notification

    -- تأثير زجاجي خفيف داخل الإشعار
    local glassEffect = Instance.new("UIStroke")
    glassEffect.Color = Color3.fromRGB(255, 255, 255)
    glassEffect.Thickness = 1
    glassEffect.Transparency = 0.7
    glassEffect.Parent = notification

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

    -- أنميشن أسطوري للظهور
    TweenService:Create(notification, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0, 20)
    }):Play()

    task.wait(2)
    local hideTween = TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Position = UDim2.new(0.5, -150, 0, -60)
    })
    hideTween:Play()
    hideTween.Completed:Wait()
    notification:Destroy()
end

---------------------------------------------
-- دالة إنشاء مربع التأكيد ❓
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
    confirmationFrame.BackgroundTransparency = 0.05 -- زجاج قوي
    confirmationFrame.BorderSizePixel = 0
    confirmationFrame.Parent = parentGui
    confirmationFrame.ZIndex = 10
    confirmationFrame.ClipsDescendants = true

    -- أنميشن الظهور
    confirmationFrame.Size = UDim2.new(0, 0, 0, 0)
    confirmationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(confirmationFrame, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {
        Size = UDim2.new(0, 400, 0, 200),
        Position = UDim2.new(0.5, -200, 0.5, -100)
    }):Play()

    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = settings.cornerRadius
    confirmCorner.Parent = confirmationFrame

    -- تأثير الزجاج المضلل (Stroke)
    local glassStroke = Instance.new("UIStroke")
    glassStroke.Color = Color3.fromRGB(255, 255, 255)
    glassStroke.Thickness = 2
    glassStroke.Transparency = 0.8
    glassStroke.Parent = confirmationFrame

    local warningIcon = Instance.new("ImageLabel")
    warningIcon.Name = "WarningIcon"
    warningIcon.Size = UDim2.new(0, 50, 0, 50)
    warningIcon.Position = UDim2.new(0.5, -25, 0, 30)
    warningIcon.BackgroundTransparency = 1
    warningIcon.Image = "rbxassetid://7734056608" -- أيقونة تحذير
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
    confirmButtonCorner.CornerRadius = UDim.new(0, 8)
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
    cancelButtonCorner.CornerRadius = UDim.new(0, 8)
    cancelButtonCorner.Parent = cancelButton

    -- أنميشن الأزرار عند التحويم
    confirmButton.MouseEnter:Connect(function()
        TweenService:Create(confirmButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 220, 220)}):Play()
        TweenService:Create(confirmButton, TweenInfo.new(0.1), {TextSize = 18}):Play()
    end)
    confirmButton.MouseLeave:Connect(function()
        TweenService:Create(confirmButton, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor}):Play()
        TweenService:Create(confirmButton, TweenInfo.new(0.1), {TextSize = 16}):Play()
    end)
    cancelButton.MouseEnter:Connect(function()
        TweenService:Create(cancelButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(230, 70, 70)}):Play()
        TweenService:Create(cancelButton, TweenInfo.new(0.1), {TextSize = 18}):Play()
    end)
    cancelButton.MouseLeave:Connect(function()
        TweenService:Create(cancelButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play()
        TweenService:Create(cancelButton, TweenInfo.new(0.1), {TextSize = 16}):Play()
    end)

    local function destroyDialog()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        -- أنميشن الإخفاء
        TweenService:Create(confirmationFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }):Play()
        task.wait(0.3)
        confirmationFrame:Destroy()
    end

    confirmButton.MouseButton1Click:Connect(function()
        destroyDialog()
        if confirmCallback then
            confirmCallback()
        end
    end)
    cancelButton.MouseButton1Click:Connect(destroyDialog)
end

---------------------------------------------
-- دالة إنشاء نافذة إدخال الكود (للمجلدات المحمية) 🔒
---------------------------------------------
local function showCodeInputDialog(parentGui, folderData, successCallback)
    local warningSound = Instance.new("Sound")
    warningSound.SoundId = settings.warningSound
    warningSound.Volume = 0.5
    warningSound.Parent = parentGui
    warningSound:Play()

    local codeFrame = Instance.new("Frame")
    codeFrame.Name = "CodeInputDialog"
    codeFrame.Size = UDim2.new(0, 350, 0, 200)
    codeFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
    codeFrame.BackgroundColor3 = settings.buttonColor
    codeFrame.BackgroundTransparency = 0.1
    codeFrame.BorderSizePixel = 0
    codeFrame.Parent = parentGui
    codeFrame.ZIndex = 20

    -- أنميشن الظهور
    codeFrame.Size = UDim2.new(0, 0, 0, 0)
    codeFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(codeFrame, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {
        Size = UDim2.new(0, 350, 0, 200),
        Position = UDim2.new(0.5, -175, 0.5, -100)
    }):Play()

    local codeCorner = Instance.new("UICorner")
    codeCorner.CornerRadius = settings.cornerRadius
    codeCorner.Parent = codeFrame

    local glassStroke = Instance.new("UIStroke")
    glassStroke.Color = Color3.fromRGB(255, 255, 255)
    glassStroke.Thickness = 2
    glassStroke.Transparency = 0.8
    glassStroke.Parent = codeFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -40, 0, 40)
    titleLabel.Position = UDim2.new(0, 20, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "أدخل كود مجلد: " .. folderData.folderName
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = settings.textColor
    titleLabel.Parent = codeFrame

    local codeTextBox = Instance.new("TextBox")
    codeTextBox.Name = "CodeTextBox"
    codeTextBox.Size = UDim2.new(1, -60, 0, 40)
    codeTextBox.Position = UDim2.new(0.5, -145, 0, 60)
    codeTextBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    codeTextBox.BackgroundTransparency = 0.1
    codeTextBox.Font = Enum.Font.Gotham
    codeTextBox.PlaceholderText = "الكود السري هنا..."
    codeTextBox.Text = ""
    codeTextBox.TextSize = 18
    codeTextBox.TextColor3 = settings.textColor
    codeTextBox.TextXAlignment = Enum.TextXAlignment.Center
    codeTextBox.Parent = codeFrame

    local textboxCorner = Instance.new("UICorner")
    textboxCorner.CornerRadius = UDim.new(0, 8)
    textboxCorner.Parent = codeTextBox

    local errorLabel = Instance.new("TextLabel")
    errorLabel.Name = "ErrorLabel"
    errorLabel.Size = UDim2.new(1, -60, 0, 20)
    errorLabel.Position = UDim2.new(0.5, -145, 0, 105)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.Text = ""
    errorLabel.TextSize = 14
    errorLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    errorLabel.TextXAlignment = Enum.TextXAlignment.Center
    errorLabel.Parent = codeFrame

    local countdownLabel = Instance.new("TextLabel")
    countdownLabel.Name = "CountdownLabel"
    countdownLabel.Size = UDim2.new(1, -60, 0, 20)
    countdownLabel.Position = UDim2.new(0.5, -145, 0, 175)
    countdownLabel.BackgroundTransparency = 1
    countdownLabel.Font = Enum.Font.GothamBold
    countdownLabel.Text = "لديك 5 محاولات"
    countdownLabel.TextSize = 14
    countdownLabel.TextColor3 = settings.accentColor
    countdownLabel.TextXAlignment = Enum.TextXAlignment.Center
    countdownLabel.Parent = codeFrame

    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(1, -60, 0, 40)
    submitButton.Position = UDim2.new(0.5, -145, 0, 130)
    submitButton.BackgroundColor3 = settings.accentColor
    submitButton.Font = Enum.Font.GothamBold
    submitButton.Text = "فتح المجلد"
    submitButton.TextSize = 16
    submitButton.TextColor3 = settings.textColor
    submitButton.Parent = codeFrame

    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 8)
    submitCorner.Parent = submitButton

    submitButton.MouseEnter:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 220, 220)}):Play()
    end)
    submitButton.MouseLeave:Connect(function()
        TweenService:Create(submitButton, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor}):Play()
    end)

    local attemptsLeft = 5
    local function checkCode()
        local code = codeTextBox.Text
        if code == folderData.code then
            local btnSound = Instance.new("Sound")
            btnSound.SoundId = settings.buttonSound
            btnSound.Volume = 0.5
            btnSound.Parent = parentGui
            btnSound:Play()
            showNotification(parentGui, "تم فتح المجلد بنجاح!", settings.accentColor)
            TweenService:Create(codeFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
            task.wait(0.3)
            codeFrame:Destroy()
            if successCallback then
                successCallback()
            end
        else
            attemptsLeft = attemptsLeft - 1
            local warningSound = Instance.new("Sound")
            warningSound.SoundId = settings.warningSound
            warningSound.Volume = 0.5
            warningSound.Parent = parentGui
            warningSound:Play()

            if attemptsLeft > 0 then
                errorLabel.Text = "كود خاطئ. المحاولات المتبقية: " .. attemptsLeft
                countdownLabel.Text = "" -- لإخفاء النص
                codeTextBox.Text = ""
                TweenService:Create(codeTextBox, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Rotation = 5}):Play()
                task.wait(0.1)
                TweenService:Create(codeTextBox, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Rotation = -5}):Play()
                task.wait(0.1)
                TweenService:Create(codeTextBox, TweenInfo.new(0.1, Enum.EasingStyle.Bounce), {Rotation = 0}):Play()
            else
                errorLabel.Text = "نفدت محاولاتك! المجلد مغلق مؤقتاً."
                countdownLabel.Text = "🚫 مغلق"
                submitButton.Text = "مغلق"
                submitButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
                submitButton.MouseButton1Click:Disconnect() -- منع المزيد من النقرات
                showNotification(parentGui, "تم إغلاق المجلد مؤقتاً.", Color3.fromRGB(200, 50, 50))
            end
        end
    end

    submitButton.MouseButton1Click:Connect(checkCode)
    codeTextBox.TextLabel.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Return then -- لتشغيل الدالة عند ضغط Enter
            checkCode()
        end
    end)
end

---------------------------------------------
-- دالة تطبيق تأثير "زجاج" (Glass effect) متحرك على زر المجلد ✨
---------------------------------------------
local function applyGlassEffect(frame)
    local glassEffect = Instance.new("Frame")
    glassEffect.Name = "GlassEffect"
    glassEffect.Size = UDim2.new(0, 50, 1, 0)
    glassEffect.Position = UDim2.new(-1, 0, 0, 0)
    glassEffect.BackgroundTransparency = 0.8
    glassEffect.BackgroundColor3 = Color3.new(1, 1, 1)
    glassEffect.Parent = frame
    glassEffect.ZIndex = frame.ZIndex + 1
    glassEffect.Rotation = 30 -- ميل لإضافة ديناميكية

    local glassGradient = Instance.new("UIGradient")
    glassGradient.Rotation = 90
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

    local tweenInfo = TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function tweenGlass()
        TweenService:Create(glassEffect, tweenInfo, {Position = UDim2.new(1.2, 0, 0, 0)}):Play()
        task.wait(1.8)
        glassEffect.Position = UDim2.new(-0.2, 0, 0, 0)
        task.wait(0.1)
        tweenGlass()
    end
    task.spawn(tweenGlass)
end

---------------------------------------------
-- دالة إنشاء واجهة المجلدات (Folder Interface) 📂
---------------------------------------------
local function createFolderInterface(parentGui, folderData)
    -- إغلاق أي واجهة مجلد مفتوحة قبل فتح واجهة جديدة
    if parentGui:FindFirstChild("FolderInterface") then
        parentGui.FolderInterface:Destroy()
    end
    
    local folderFrame = Instance.new("Frame")
    folderFrame.Name = "FolderInterface"
    folderFrame.Size = UDim2.new(0, 500, 0, 400)
    folderFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    folderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    folderFrame.BackgroundTransparency = settings.transparency
    folderFrame.BorderSizePixel = 0
    folderFrame.ClipsDescendants = true
    folderFrame.Parent = parentGui
    folderFrame.ZIndex = 5

    -- أنميشن الظهور الأسطوري
    folderFrame.Rotation = -10
    folderFrame.Size = UDim2.new(0, 0, 0, 0)
    folderFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(folderFrame, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        Rotation = 0
    }):Play()

    local folderCorner = Instance.new("UICorner")
    folderCorner.CornerRadius = settings.cornerRadius
    folderCorner.Parent = folderFrame

    local glassStroke = Instance.new("UIStroke")
    glassStroke.Color = Color3.fromRGB(255, 255, 255)
    glassStroke.Thickness = 2
    glassStroke.Transparency = 0.8
    glassStroke.Parent = folderFrame

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

    local function closeFolder()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        -- أنميشن الإخفاء
        TweenService:Create(folderFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Rotation = 10
        }):Play()
        task.wait(0.4)
        folderFrame:Destroy()
    end
    backButton.MouseButton1Click:Connect(closeFolder)

    local folderScriptsFrame = Instance.new("ScrollingFrame")
    folderScriptsFrame.Name = "FolderScriptsFrame"
    folderScriptsFrame.Size = UDim2.new(1, -40, 0, 300)
    folderScriptsFrame.Position = UDim2.new(0, 20, 0, 70)
    folderScriptsFrame.BackgroundTransparency = 1
    folderScriptsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    folderScriptsFrame.ScrollBarThickness = 4
    folderScriptsFrame.Parent = folderFrame

    local folderGrid = Instance.new("UIGridLayout")
    folderGrid.CellSize = UDim2.new(0, 220, 0, 250)
    folderGrid.CellPadding = UDim2.new(0, 10, 0, 10)
    folderGrid.HorizontalAlignment = Enum.HorizontalAlignment.Center
    folderGrid.Parent = folderScriptsFrame

    folderScriptsFrame:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        folderScriptsFrame.CanvasSize = UDim2.new(0, folderGrid.AbsoluteContentSize.X, 0, folderGrid.AbsoluteContentSize.Y)
    end)

    for _, scriptData in ipairs(folderData.scripts or {}) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Name = scriptData.name
        itemFrame.Size = UDim2.new(0, 220, 0, 250)
        itemFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        itemFrame.BackgroundTransparency = 0.7 -- زجاج على الكروت
        itemFrame.Parent = folderScriptsFrame
        itemFrame.ClipsDescendants = true

        local itemCorner = Instance.new("UICorner")
        itemCorner.CornerRadius = UDim.new(0, 12)
        itemCorner.Parent = itemFrame

        local itemGlassStroke = Instance.new("UIStroke")
        itemGlassStroke.Color = Color3.fromRGB(255, 255, 255)
        itemGlassStroke.Thickness = 1
        itemGlassStroke.Transparency = 0.9
        itemGlassStroke.Parent = itemFrame

        -- تطبيق تأثير "زجاج" (Glass effect) على الكرت
        applyGlassEffect(itemFrame)

        local scriptLabel = Instance.new("TextLabel")
        scriptLabel.Name = "ScriptLabel"
        scriptLabel.Size = UDim2.new(1, -20, 0, 140)
        scriptLabel.Position = UDim2.new(0, 10, 0, 10)
        scriptLabel.BackgroundTransparency = 1
        scriptLabel.Font = Enum.Font.GothamBold
        scriptLabel.Text = "**"..scriptData.name.."**\n\n"..scriptData.description
        scriptLabel.TextSize = 16
        scriptLabel.TextColor3 = settings.textColor
        scriptLabel.TextWrapped = true
        scriptLabel.TextXAlignment = Enum.TextXAlignment.Left
        scriptLabel.Parent = itemFrame

        local viewButton = Instance.new("TextButton")
        viewButton.Name = "ViewButton"
        viewButton.Size = UDim2.new(0, 200, 0, 40)
        viewButton.Position = UDim2.new(0, 10, 0, 200)
        viewButton.BackgroundColor3 = settings.accentColor
        viewButton.Font = Enum.Font.GothamBold
        viewButton.Text = "🚀 تشغيل "
        viewButton.TextSize = 18
        viewButton.TextColor3 = settings.textColor
        viewButton.Parent = itemFrame

        local viewButtonCorner = Instance.new("UICorner")
        viewButtonCorner.CornerRadius = UDim.new(0, 8)
        viewButtonCorner.Parent = viewButton

        -- أنميشن التفاعل
        viewButton.MouseEnter:Connect(function()
            TweenService:Create(viewButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 220, 220)}):Play()
            TweenService:Create(viewButton, TweenInfo.new(0.3), {TextSize = 20}):Play()
        end)
        viewButton.MouseLeave:Connect(function()
            TweenService:Create(viewButton, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor}):Play()
            TweenService:Create(viewButton, TweenInfo.new(0.3), {TextSize = 18}):Play()
        end)

        viewButton.MouseButton1Click:Connect(function()
            local btnSound = Instance.new("Sound")
            btnSound.SoundId = settings.buttonSound
            btnSound.Volume = 0.5
            btnSound.Parent = parentGui
            btnSound:Play()
            showConfirmationDialog(parentGui, "هل أنت متأكد أنك تريد تشغيل " .. scriptData.name .. "؟ قد يؤثر على أداء اللعبة.", function()
                -- **تنبيه:** استخدام loadstring و game:HttpGet يتطلب صلاحيات عالية في الألعاب
                loadstring(game:HttpGet(scriptData.url))()
                showNotification(parentGui, "✅ تم تشغيل " .. scriptData.name .. "!")
            end)
        end)
    end

    return folderFrame
end

---------------------------------------------
-- دالة إنشاء الواجهة الرئيسية (Main Interface) 🖥️
---------------------------------------------
local function createMainInterface(parentGui)
    local openSound = Instance.new("Sound")
    openSound.SoundId = settings.openSound
    openSound.Volume = 0.5
    openSound.Parent = parentGui
    openSound:Play()

    -- إغلاق أي واجهة رئيسية سابقة
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
    mainFrame.ZIndex = 5

    -- أنميشن الظهور الأسطوري
    mainFrame.Rotation = -5
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        Rotation = 0
    }):Play()

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = settings.cornerRadius
    mainCorner.Parent = mainFrame

    local glassStroke = Instance.new("UIStroke")
    glassStroke.Color = Color3.fromRGB(255, 255, 255)
    glassStroke.Thickness = 2
    glassStroke.Transparency = 0.8
    glassStroke.Parent = mainFrame

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
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    gradient.Parent = backgroundImage

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 400, 0, 50)
    titleLabel.Position = UDim2.new(0.5, -200, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "القائمة السكربتات (Luna Pro)"
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

    -- زر إغلاق (X)
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundTransparency = 0.5
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.Text = "✖" -- أيقونة إغلاق فخمة
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 20
    closeButton.TextColor3 = settings.textColor
    closeButton.Parent = mainFrame
    closeButton.ZIndex = 10

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton

    local function closeMainFrame()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        -- أنميشن الإغلاق
        TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Rotation = 5
        }):Play()
        task.wait(0.5)
        mainFrame:Destroy()
    end
    closeButton.MouseButton1Click:Connect(closeMainFrame)

    -- زر بحث عن مجلد
    local searchFrame = Instance.new("Frame")
    searchFrame.Name = "SearchFrame"
    searchFrame.Size = UDim2.new(0, 300, 0, 30)
    searchFrame.Position = UDim2.new(0, 50, 0, 70)
    searchFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    searchFrame.BackgroundTransparency = 0.4
    searchFrame.Parent = mainFrame

    local searchCorner = Instance.new("UICorner")
    searchCorner.CornerRadius = UDim.new(0, 8)
    searchCorner.Parent = searchFrame

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Name = "SearchIcon"
    searchIcon.Size = UDim2.new(0, 20, 0, 20)
    searchIcon.Position = UDim2.new(0, 5, 0, 5)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://6037592928" -- أيقونة بحث فخمة
    searchIcon.ImageColor3 = settings.accentColor
    searchIcon.Parent = searchFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -35, 1, 0)
    searchBox.Position = UDim2.new(0, 30, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "ابحث عن سكربتات..."
    searchBox.Text = ""
    searchBox.TextSize = 16
    searchBox.TextColor3 = settings.textColor
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchFrame

    local foldersFrame = Instance.new("ScrollingFrame")
    foldersFrame.Name = "FoldersFrame"
    foldersFrame.Size = UDim2.new(0, 440, 0, 250)
    foldersFrame.Position = UDim2.new(0, 30, 0, 110)
    foldersFrame.BackgroundTransparency = 1
    foldersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    foldersFrame.ScrollBarThickness = 4
    foldersFrame.Parent = mainFrame

    local foldersList = Instance.new("UIListLayout")
    foldersList.Padding = UDim.new(0, 10)
    foldersList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    foldersList.Parent = foldersFrame

    foldersFrame:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        foldersFrame.CanvasSize = UDim2.new(0, 0, 0, foldersList.AbsoluteContentSize.Y)
    end)

    local function filterFolders(searchText)
        for _, folderButton in pairs(foldersFrame:GetChildren()) do
            if folderButton:IsA("TextButton") then
                if string.find(string.lower(folderButton.Name), string.lower(searchText)) then
                    folderButton.Visible = true
                else
                    folderButton.Visible = false
                end
            end
        end
        foldersFrame.CanvasSize = UDim2.new(0, 0, 0, foldersList.AbsoluteContentSize.Y) -- لتحديث حجم القائمة بعد الفلترة
    end
    
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        filterFolders(searchBox.Text)
    end)
    searchBox.Text = "" -- لتشغيل الفلتر عند الإنشاء

    -- إطار الاختصارات
    local shortcutsFrame = Instance.new("Frame")
    shortcutsFrame.Name = "ShortcutsFrame"
    shortcutsFrame.Size = UDim2.new(0, 150, 0, 300)
    shortcutsFrame.Position = UDim2.new(1, -160, 0, 60)
    shortcutsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    shortcutsFrame.BackgroundTransparency = 0.7 -- زجاج مضلل
    shortcutsFrame.Parent = mainFrame

    local shortcutsCorner = Instance.new("UICorner")
    shortcutsCorner.CornerRadius = UDim.new(0, 12)
    shortcutsCorner.Parent = shortcutsFrame

    local shortcutsTitle = Instance.new("TextLabel")
    shortcutsTitle.Name = "Title"
    shortcutsTitle.Size = UDim2.new(1, 0, 0, 30)
    shortcutsTitle.Position = UDim2.new(0, 0, 0, 5)
    shortcutsTitle.BackgroundTransparency = 1
    shortcutsTitle.Font = Enum.Font.GothamBold
    shortcutsTitle.Text = "🕹️ اختصارات (Shortcuts)"
    shortcutsTitle.TextSize = 16
    shortcutsTitle.TextColor3 = settings.textColor
    shortcutsTitle.Parent = shortcutsFrame

    local shortcutsLayout = Instance.new("UIListLayout")
    shortcutsLayout.Padding = UDim.new(0, 5)
    shortcutsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    shortcutsLayout.Parent = shortcutsFrame

    -- إضافة زر الإخفاء/الإظهار
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleUI"
    toggleButton.Size = UDim2.new(1, -20, 0, 40)
    toggleButton.Position = UDim2.new(0, 10, 0, 40)
    toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Text = string.format("إخفاء/إظهار (%s)", settings.shortcutKey.Name)
    toggleButton.TextSize = 14
    toggleButton.TextColor3 = settings.textColor
    toggleButton.Parent = shortcutsFrame

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 8)
    toggleCorner.Parent = toggleButton
    
    toggleButton.MouseButton1Click:Connect(function()
        local parentGui = mainFrame.Parent 
        if parentGui and parentGui:IsA("ScreenGui") then
            local circularMenuGUI = parentGui:FindFirstChild("CircularMenuGUI")
            if circularMenuGUI and circularMenuGUI:IsA("ScreenGui") then
                circularMenuGUI.Enabled = not circularMenuGUI.Enabled
                if circularMenuGUI.Enabled then
                    showNotification(parentGui, "⚙️ تم إظهار الواجهة!", settings.accentColor)
                else
                    showNotification(parentGui, "⚙️ تم إخفاء الواجهة!", Color3.fromRGB(150, 150, 150))
                end
            end
        end
        closeMainFrame() -- إغلاق الواجهة الرئيسية عند الإخفاء
    end)

    -- إضافة باقي الاختصارات
    for _, shortcutData in ipairs(shortcuts) do
        local shortcutButton = Instance.new("TextButton")
        shortcutButton.Name = shortcutData.name
        shortcutButton.Size = UDim2.new(1, -20, 0, 40)
        -- نعتمد على الـ UIListLayout لوضع العناصر تلقائياً
        shortcutButton.BackgroundColor3 = settings.accentColor
        shortcutButton.Font = Enum.Font.GothamBold
        shortcutButton.Text = string.format("%s (%s) ⚡", shortcutData.name, shortcutData.key.Name)
        shortcutButton.TextSize = 14
        shortcutButton.TextColor3 = settings.textColor
        shortcutButton.Parent = shortcutsFrame

        local shortcutCorner = Instance.new("UICorner")
        shortcutCorner.CornerRadius = UDim.new(0, 8)
        shortcutCorner.Parent = shortcutButton

        shortcutButton.MouseButton1Click:Connect(function()
            local btnSound = Instance.new("Sound")
            btnSound.SoundId = settings.buttonSound
            btnSound.Volume = 0.5
            btnSound.Parent = parentGui
            btnSound:Play()
            showConfirmationDialog(parentGui, "هل تريد تشغيل الإختصار " .. shortcutData.name .. "؟", function()
                shortcutData.callback()
                showNotification(parentGui, "⚡ تم تفعيل اختصار " .. shortcutData.name .. "!")
            end)
        end)
    end

    -- بناء أزرار المجلدات
    for _, folderData in ipairs(externalFolders) do
        local folderButton = Instance.new("TextButton")
        folderButton.Name = folderData.folderName or "Folder"
        folderButton.Size = UDim2.new(1, 0, 0, 60)
        folderButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        folderButton.BackgroundTransparency = 0.4
        folderButton.Font = Enum.Font.SourceSans
        folderButton.Text = ""
        folderButton.Parent = foldersFrame
        folderButton.ClipsDescendants = true

        local folderCorner = Instance.new("UICorner")
        folderCorner.CornerRadius = settings.cornerRadius
        folderCorner.Parent = folderButton

        local folderStroke = Instance.new("UIStroke")
        folderStroke.Color = Color3.fromRGB(255, 255, 255)
        folderStroke.Thickness = 1
        folderStroke.Transparency = 0.7
        folderStroke.Parent = folderButton

        -- تطبيق تأثير "زجاج" (Glass effect) على زر المجلد
        applyGlassEffect(folderButton)

        local icon
        if folderData.locked or folderData.codeProtected then
            icon = settings.lockIcon
        else
            icon = settings.folderIcon
        end

        local folderImage = Instance.new("ImageLabel")
        folderImage.Name = "FolderImage"
        folderImage.Size = UDim2.new(0, 40, 0, 40)
        folderImage.Position = UDim2.new(0, 10, 0, 10)
        folderImage.BackgroundTransparency = 1
        folderImage.Image = icon
        folderImage.ImageColor3 = settings.accentColor
        folderImage.Parent = folderButton

        local folderNameLabel = Instance.new("TextLabel")
        folderNameLabel.Name = "FolderNameLabel"
        folderNameLabel.Size = UDim2.new(1, -120, 0, 25)
        folderNameLabel.Position = UDim2.new(0, 60, 0, 5)
        folderNameLabel.BackgroundTransparency = 1
        folderNameLabel.Font = Enum.Font.GothamBold
        folderNameLabel.Text = folderData.folderName or "مجلد"
        folderNameLabel.TextSize = 20
        folderNameLabel.TextColor3 = settings.textColor
        folderNameLabel.TextXAlignment = Enum.TextXAlignment.Left
        folderNameLabel.Parent = folderButton

        local folderDescLabel = Instance.new("TextLabel")
        folderDescLabel.Name = "FolderDescLabel"
        folderDescLabel.Size = UDim2.new(1, -120, 0, 20)
        folderDescLabel.Position = UDim2.new(0, 60, 0, 30)
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
        scriptsLabel.Size = UDim2.new(0, 100, 0, 20)
        scriptsLabel.Position = UDim2.new(1, -110, 0, 20)
        scriptsLabel.BackgroundTransparency = 1
        scriptsLabel.Font = Enum.Font.GothamBold
        scriptsLabel.Text = "سكربتات: " .. scriptCount
        scriptsLabel.TextSize = 16
        scriptsLabel.TextColor3 = settings.textColor
        scriptsLabel.TextXAlignment = Enum.TextXAlignment.Right
        scriptsLabel.Parent = folderButton

        -- أنميشن التفاعل
        folderButton.MouseEnter:Connect(function()
            TweenService:Create(folderButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), BackgroundTransparency = 0.2}):Play()
            TweenService:Create(folderImage, TweenInfo.new(0.3), {ImageColor3 = Color3.new(1, 1, 1)}):Play()
        end)
        folderButton.MouseLeave:Connect(function()
            TweenService:Create(folderButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.4}):Play()
            TweenService:Create(folderImage, TweenInfo.new(0.3), {ImageColor3 = settings.accentColor}):Play()
        end)

        if folderData.locked then
            -- نص مغلق وظل فخم
            local lockedTextShadow = Instance.new("TextLabel")
            lockedTextShadow.Name = "LockedTextShadow"
            lockedTextShadow.Size = UDim2.new(0, 60, 0, 30)
            lockedTextShadow.Position = UDim2.new(0, 60, 0, 10)
            lockedTextShadow.BackgroundTransparency = 1
            lockedTextShadow.Font = Enum.Font.GothamBold
            lockedTextShadow.Text = "مغلق"
            lockedTextShadow.TextSize = 20
            lockedTextShadow.TextColor3 = Color3.new(0, 0, 0)
            lockedTextShadow.Parent = folderButton
            lockedTextShadow.ZIndex = 11

            local lockedText = Instance.new("TextLabel")
            lockedText.Name = "LockedText"
            lockedText.Size = UDim2.new(0, 60, 0, 30)
            lockedText.Position = UDim2.new(0, 58, 0, 8)
            lockedText.BackgroundTransparency = 1
            lockedText.Font = Enum.Font.GothamBold
            lockedText.Text = "مغلق"
            lockedText.TextSize = 20
            lockedText.TextColor3 = Color3.fromRGB(200, 0, 0)
            lockedText.Parent = folderButton
            lockedText.ZIndex = 12

            folderButton.MouseButton1Click:Connect(function()
                showNotification(parentGui, "🔒 هذا المجلد مغلق ولا يمكن فتحه.", Color3.fromRGB(200, 0, 0))
            end)
        elseif folderData.codeProtected then
            folderButton.MouseButton1Click:Connect(function()
                showCodeInputDialog(parentGui, folderData, function()
                    createFolderInterface(parentGui, folderData)
                end)
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
-- دالة إنشاء واجهة المعلومات (Info Interface) ℹ️
---------------------------------------------
local function createInfoInterface(parentGui)
    local openSound = Instance.new("Sound")
    openSound.SoundId = settings.openSound
    openSound.Volume = 0.5
    openSound.Parent = parentGui
    openSound:Play()

    -- إغلاق أي واجهة معلومات سابقة
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
    infoFrame.ZIndex = 5

    -- أنميشن الظهور الأسطوري
    infoFrame.Rotation = 5
    infoFrame.Size = UDim2.new(0, 0, 0, 0)
    infoFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(infoFrame, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        Rotation = 0
    }):Play()

    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = settings.cornerRadius
    infoCorner.Parent = infoFrame

    local glassStroke = Instance.new("UIStroke")
    glassStroke.Color = Color3.fromRGB(255, 255, 255)
    glassStroke.Thickness = 2
    glassStroke.Transparency = 0.8
    glassStroke.Parent = infoFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "InfoTitle"
    titleLabel.Size = UDim2.new(0, 400, 0, 50)
    titleLabel.Position = UDim2.new(0.5, -200, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "🌟 معلومات Luna Pro"
    titleLabel.TextSize = 28
    titleLabel.TextColor3 = settings.textColor
    titleLabel.Parent = infoFrame

    --... (باقي مكونات واجهة المعلومات كما هي مع تعديلات بسيطة في الأنماط)

    -- زر إغلاق (X)
    local infoCloseButton = Instance.new("TextButton")
    infoCloseButton.Name = "InfoCloseButton"
    infoCloseButton.Size = UDim2.new(0, 30, 0, 30)
    infoCloseButton.Position = UDim2.new(1, -40, 0, 10)
    infoCloseButton.BackgroundTransparency = 0.5
    infoCloseButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    infoCloseButton.Text = "✖"
    infoCloseButton.Font = Enum.Font.GothamBold
    infoCloseButton.TextSize = 20
    infoCloseButton.TextColor3 = settings.textColor
    infoCloseButton.Parent = infoFrame
    infoCloseButton.ZIndex = 10

    local infoCloseCorner = Instance.new("UICorner")
    infoCloseCorner.CornerRadius = UDim.new(0, 8)
    infoCloseCorner.Parent = infoCloseButton

    local function closeInfoFrame()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        -- أنميشن الإغلاق
        TweenService:Create(infoFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Rotation = -5
        }):Play()
        task.wait(0.5)
        infoFrame:Destroy()
    end
    infoCloseButton.MouseButton1Click:Connect(closeInfoFrame)
    
    --... (هنا يجب إضافة مكونات عرض المعلومات الفعلية لـ Info Interface)

    return infoFrame
end

---------------------------------------------
-- دالة إنشاء لوحة الخيارات (Option Panel) ⚙️
---------------------------------------------
local function createOptionPanel(parentGui, buttonPos)
    -- تدمير أي لوحة خيارات سابقة
    if parentGui:FindFirstChild("OptionPanel") then
        parentGui.OptionPanel:Destroy()
    end

    local optionPanel = Instance.new("Frame")
    optionPanel.Name = "OptionPanel"
    optionPanel.Size = UDim2.new(0, 200, 0, 100)
    -- وضع اللوحة بجوار الزر الدائري الذي نقر عليه
    optionPanel.Position = UDim2.new(buttonPos.X.Scale, buttonPos.X.Offset - 200 - 10, buttonPos.Y.Scale, buttonPos.Y.Offset - 20) 
    optionPanel.BackgroundColor3 = settings.buttonColor
    optionPanel.BackgroundTransparency = 0.2
    optionPanel.BorderSizePixel = 0
    optionPanel.Parent = parentGui
    optionPanel.ZIndex = 10
    
    -- أنميشن الظهور
    TweenService:Create(optionPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.05
    }):Play()

    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = settings.cornerRadius
    optionCorner.Parent = optionPanel

    local glassStroke = Instance.new("UIStroke")
    glassStroke.Color = Color3.fromRGB(255, 255, 255)
    glassStroke.Thickness = 1
    glassStroke.Transparency = 0.8
    glassStroke.Parent = optionPanel

    local panelLayout = Instance.new("UIListLayout")
    panelLayout.Padding = UDim.new(0, 5)
    panelLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    panelLayout.Parent = optionPanel

    local function createPanelButton(name, text, icon, clickCallback)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(1, -20, 0, 40)
        button.BackgroundColor3 = settings.accentColor
        button.Font = Enum.Font.GothamBold
        button.Text = "" -- النص يوضع داخل ImageLabel
        button.TextSize = 18
        button.TextColor3 = settings.textColor
        button.Parent = optionPanel

        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 8)
        buttonCorner.Parent = button

        local buttonIcon = Instance.new("ImageLabel")
        buttonIcon.Name = "Icon"
        buttonIcon.Size = UDim2.new(0, 30, 0, 30)
        buttonIcon.Position = UDim2.new(0, 10, 0, 5)
        buttonIcon.BackgroundTransparency = 1
        buttonIcon.Image = icon
        buttonIcon.ImageColor3 = Color3.new(1, 1, 1)
        buttonIcon.Parent = button

        local buttonText = Instance.new("TextLabel")
        buttonText.Name = "Text"
        buttonText.Size = UDim2.new(1, -50, 1, 0)
        buttonText.Position = UDim2.new(0, 40, 0, 0)
        buttonText.BackgroundTransparency = 1
        buttonText.Font = Enum.Font.GothamBold
        buttonText.Text = text
        buttonText.TextSize = 18
        buttonText.TextColor3 = settings.textColor
        buttonText.TextXAlignment = Enum.TextXAlignment.Left
        buttonText.Parent = button

        -- أنميشن التحويم
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 220, 220)}):Play()
            TweenService:Create(buttonIcon, TweenInfo.new(0.3), {Rotation = 10}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor}):Play()
            TweenService:Create(buttonIcon, TweenInfo.new(0.3), {Rotation = 0}):Play()
        end)

        button.MouseButton1Click:Connect(function()
            local btnSound = Instance.new("Sound")
            btnSound.SoundId = settings.buttonSound
            btnSound.Volume = 0.5
            btnSound.Parent = parentGui
            btnSound:Play()
            -- أنميشن الإخفاء
            TweenService:Create(optionPanel, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.2)
            optionPanel:Destroy()
            clickCallback()
        end)

        return button
    end

    local mainButton = createPanelButton("MainButton", "قائمة السكربتات", settings.mainIcon, function()
        createMainInterface(parentGui)
    end)
    
    local infoButton = createPanelButton("InfoButton", "معلومات", settings.infoIcon, function()
        createInfoInterface(parentGui)
    end)
    
    return optionPanel
end

---------------------------------------------
-- دالة إنشاء القائمة الدائرية (Circular Menu) مع سحب سلس ✅ (تم الإصلاح هنا)
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
    circularButton.Image = "rbxassetid://7059346373" -- أيقونة القائمة (New Epic Icon)
    circularButton.ImageColor3 = Color3.new(1, 1, 1)
    circularButton.BackgroundTransparency = 0.1 -- زجاج خفيف على الزر
    circularButton.Parent = circularMenuGUI
    circularButton.ZIndex = 10

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 30)
    buttonCorner.Parent = circularButton

    local buttonUIStroke = Instance.new("UIStroke")
    buttonUIStroke.Color = Color3.fromRGB(255, 255, 255)
    buttonUIStroke.Thickness = 3
    buttonUIStroke.Transparency = 0.5
    buttonUIStroke.Parent = circularButton
    
    -- أنميشن الدوران المستمر للزر الدائري
    local rotateTween = TweenService:Create(circularButton, TweenInfo.new(10, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1), {Rotation = 360})
    rotateTween:Play()

    -- السحب السلس
    local dragging = false
    local dragInput, dragStart, startPos
    local dragConnection, inputChangedConnection
    local isClick = true -- متغير جديد لتحديد ما إذا كانت نقرة وليست سحباً

    local function stopDragging()
        dragging = false
        if dragConnection then dragConnection:Disconnect() end
        if inputChangedConnection then inputChangedConnection:Disconnect() end
    end

    circularButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            isClick = true -- نفترض أنها نقرة في البداية
            dragStart = input.Position
            startPos = circularButton.Position

            dragConnection = UserInputService.InputChanged:Connect(function(inputChanged)
                if dragging and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch) then
                    local delta = inputChanged.Position - dragStart
                    -- إذا كان مقدار الحركة أكبر من عتبة معينة، اعتبرها سحباً
                    if (delta.X * delta.X + delta.Y * delta.Y) > 10 then 
                        isClick = false
                    end
                    
                    circularButton.Position = UDim2.new(
                        startPos.X.Scale,
                        math.clamp(startPos.X.Offset + delta.X, 0, circularMenuGUI.AbsoluteSize.X - circularButton.AbsoluteSize.X),
                        startPos.Y.Scale,
                        math.clamp(startPos.Y.Offset + delta.Y, 0, circularMenuGUI.AbsoluteSize.Y - circularButton.AbsoluteSize.Y)
                    )
                end
            end)

            inputChangedConnection = UserInputService.InputEnded:Connect(function(inputEnded)
                if inputEnded.UserInputType == Enum.UserInputType.MouseButton1 or inputEnded.UserInputType == Enum.UserInputType.Touch then
                    stopDragging()
                    if isClick then
                        -- **الإصلاح:** فقط إذا كانت نقرة بسيطة (isClick = true)
                        local btnSound = Instance.new("Sound")
                        btnSound.SoundId = settings.buttonSound
                        btnSound.Volume = 0.5
                        btnSound.Parent = circularMenuGUI
                        btnSound:Play()
                        createOptionPanel(circularMenuGUI, circularButton.Position)
                    end
                end
            end)
        end
    end)
    
    -- **ملاحظة:** تم حذف .MouseButton1Click:Connect لأنه قد يتعارض مع المنطق أعلاه وتم تضمين عمله داخل InputEnded

    -- مفتاح الاختصار لإخفاء/إظهار
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if input.KeyCode == settings.shortcutKey and not gameProcessedEvent then
            if circularMenuGUI.Enabled then
                circularMenuGUI.Enabled = false
                showNotification(playerGui, "⚙️ تم إخفاء الواجهة!", Color3.fromRGB(150, 150, 150))
            else
                circularMenuGUI.Enabled = true
                showNotification(playerGui, "⚙️ تم إظهار الواجهة!", settings.accentColor)
            end
            -- إغلاق أي واجهات مفتوحة أيضاً
            for _, child in ipairs(playerGui:GetChildren()) do
                if child.Name == "MainInterface" or child.Name == "FolderInterface" or child.Name == "InfoInterface" or child.Name == "OptionPanel" then
                    child:Destroy()
                end
            end
        end
    end)

    return circularButton, circularMenuGUI
end

---------------------------------------------
-- دالة إظهار الواجهة الرئيسية للمكتبة (Show)
---------------------------------------------
function Luna:Show()
    local _, screenGui = createCircularMenu()
    showNotification(screenGui, "🔥 Luna Pro جاهز للعمل! اضغط على الزر الدائري. مفتاح الإخفاء: "..settings.shortcutKey.Name, settings.accentColor)
end

---------------------------------------------
-- دالة إضافة مجلد مفتوح يحتوي على سكربتات (AddFolder)
---------------------------------------------
function Luna:AddFolder(folderData)
    folderData.locked = false
    folderData.codeProtected = false
    table.insert(externalFolders, folderData)
end

---------------------------------------------
-- دالة إضافة مجلد مغلق يحتوي على سكربتات (AddLockedFolder)
---------------------------------------------
function Luna:AddLockedFolder(folderData)
    folderData.locked = true
    folderData.codeProtected = false
    table.insert(externalFolders, folderData)
end

---------------------------------------------
-- دالة إضافة مجلد محمي بكود (AddCodeProtectedFolder)
-- يتطلب خاصية 'code' في جدول البيانات
---------------------------------------------
function Luna:AddCodeProtectedFolder(folderData, code)
    folderData.locked = false
    folderData.codeProtected = true
    folderData.code = tostring(code) -- التأكد من أن الكود هو نص
    table.insert(externalFolders, folderData)
end

---------------------------------------------
-- دالة إضافة اختصار (AddShortcut)
---------------------------------------------
function Luna:AddShortcut(name, key, callback)
    table.insert(shortcuts, {
        name = name,
        key = key, -- مثال: Enum.KeyCode.R
        callback = callback
    })
end

---------------------------------------------
-- يمكن إضافة المزيد من الوظائف حسب الحاجة
---------------------------------------------

return Luna
