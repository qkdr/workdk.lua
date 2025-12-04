-- مكتبة Luna Pro للواجهات الفخمة والأسطورية في Roblox
-- الإصدار: 2.0 (Epic Glassmorphism)
-- ميزات إضافية: مجلدات محمية بكود، اختصارات مفاتيح، أنميشن أسطوري، وتصميم زجاجي.

local Luna = {}

---------------------------------------------
-- إعدادات عامة قابلة للتعديل
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
local externalFolders = {
    {
        folderName = "Epic Scripts",
        folderDescription = "أفضل السكربتات المتميزة والمجانية",
        locked = false,
        codeProtected = false,
        scripts = {
            {name = "Speed Hack", description = "زيادة سرعة اللاعب", url = "https://example.com/speedhack.lua"},
            {name = "Jump Power", description = "زيادة قوة القفز", code = "game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100"},
        }
    },
    {
        folderName = "VIP Features",
        folderDescription = "ميزات حصرية لكبار الشخصيات",
        locked = true, -- مغلق بالكامل
        codeProtected = false,
        scripts = {}
    },
    {
        folderName = "Protected Files",
        folderDescription = "مجلد محمي بكود سري.",
        locked = false,
        codeProtected = true,
        code = "1234", -- الكود السري
        scripts = {
             {name = "Code Only", description = "سكربت داخل مجلد محمي", code = "print('Protected script activated!')"},
        }
    }
}
local shortcuts = { -- لتخزين الاختصارات
    {name = "Kill All", key = Enum.KeyCode.K, callback = function() print("Kill All Activated!") end},
} 

---------------------------------------------
-- خدمات Roblox
---------------------------------------------
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- تعريف دالة HttpGet لاستخدامها مع loadstring (ضرورية لتشغيل السكربتات من URL)
local function HttpGet(url)
    -- هذا افتراض لوجود دالة جلب خارجية
    -- في اللعبة الحقيقية، يجب أن تستبدل هذا بدالة 'get' فعلية من أداة تنفيذ الأكواد (Executor)
    warn("HttpGet: Mock function used. Replace this with your Executor's HTTP GET function.")
    return 'print("Script downloaded from ' .. url .. '")' -- قيمة وهمية للتشغيل
end
game.HttpGet = game.HttpGet or HttpGet -- استخدام الدالة الوهمية أو الدالة الفعلية للمنفذ

---------------------------------------------
-- دالة عرض إشعار أنيق على الشاشة
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
    cancelButton.MouseButton1Click:Connect(function()
        destroyDialog()
    end)
end

---------------------------------------------
-- دالة إنشاء نافذة إدخال الكود (للمجلدات المحمية)
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
                submitButton.Text = "مغلق"
                submitButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
                submitButton.MouseButton1Click:Disconnect() -- تعطيل حدث الضغط
                -- عرض إشعار
                showNotification(parentGui, "تم إغلاق المجلد مؤقتاً.", Color3.fromRGB(200, 50, 50))
            end
        end
    end

    submitButton.MouseButton1Click:Connect(checkCode)
end

---------------------------------------------
-- دالة تطبيق تأثير "زجاج" (Glass effect) متحرك على زر المجلد
---------------------------------------------
local function applyGlassEffect(folderButton)
    local glassEffect = Instance.new("Frame")
    glassEffect.Name = "GlassEffect"
    glassEffect.Size = UDim2.new(0, 50, 1, 0)
    glassEffect.Position = UDim2.new(-1, 0, 0, 0)
    glassEffect.BackgroundTransparency = 0.8
    glassEffect.BackgroundColor3 = Color3.new(1, 1, 1)
    glassEffect.Parent = folderButton
    glassEffect.ZIndex = folderButton.ZIndex + 1
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
        if glassEffect and glassEffect.Parent then
            glassEffect.Position = UDim2.new(-0.2, 0, 0, 0)
            task.wait(0.1)
            tweenGlass()
        end
    end
    task.spawn(tweenGlass)
end

---------------------------------------------
-- دالة إنشاء واجهة المجلدات (Folder Interface)
---------------------------------------------
local function createFolderInterface(parentGui, folderData)
    if parentGui:FindFirstChild("FolderInterface") then parentGui.FolderInterface:Destroy() end

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
        folderScriptsFrame.CanvasSize = UDim2.new(0, 0, 0, folderGrid.AbsoluteContentSize.Y) -- تغيير هذا السطر ليناسب التمرير العمودي
    end)

    for _, scriptData in ipairs(folderData.scripts or {}) do
        local itemFrame = Instance.new("Frame")
        itemFrame.Name = scriptData.name or "Script"
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
        scriptLabel.Text = (scriptData.name or "") .. "\n\n" .. (scriptData.description or "")
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
            showConfirmationDialog(parentGui, "هل أنت متأكد أنك تريد تشغيل " .. (scriptData.name or "السكربت") .. "؟ قد يؤثر على أداء اللعبة.", function()
                -- تحمي التنفيذ داخل pcall لمنع توقف الواجهة لو فشل السكربت
                local ok, err = pcall(function()
                    if scriptData.url then
                        loadstring(game:HttpGet(scriptData.url))()
                    elseif scriptData.code then
                        local f, e = loadstring(scriptData.code)
                        if f then f() end
                    else
                        -- لا شيء
                    end
                end)
                if ok then
                    showNotification(parentGui, "✅ تم تشغيل " .. (scriptData.name or "السكربت") .. "!")
                else
                    showNotification(parentGui, "❌ خطأ أثناء التشغيل: " .. tostring(err), Color3.fromRGB(200,50,50))
                end
            end)
        end)
    end

    return folderFrame
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
        return parentGui.MainInterface
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
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. (LocalPlayer and LocalPlayer.UserId or 0) .. "&w=150&h=150"
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
    playerNameLabel.Text = (LocalPlayer and (LocalPlayer.DisplayName or LocalPlayer.Name)) or "Player"
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

    local function filterFolders(searchText)
        for _, folderButton in pairs(mainFrame.FoldersFrame:GetChildren()) do
            if folderButton:IsA("TextButton") then
                -- فلترة بالاسم والوصف
                local folderName = folderButton.FolderNameLabel.Text
                local folderDesc = folderButton.FolderDescLabel.Text
                if string.find(string.lower(folderName), string.lower(searchText)) or string.find(string.lower(folderDesc), string.lower(searchText)) then
                    folderButton.Visible = true
                else
                    folderButton.Visible = false
                end
            end
        end
    end
    searchBox.Changed:Connect(function(prop)
        if prop == "Text" then
            filterFolders(searchBox.Text)
        end
    end)
    filterFolders("") -- لتشغيل الفلتر عند الإنشاء

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

    -- إضافة زر الإخفاء/إظهار
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleUI"
    toggleButton.Size = UDim2.new(1, -20, 0, 40)
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
        if parentGui:FindFirstChild("MainInterface") then
            closeMainFrame()
        else
            -- هذه الحالة لن تحدث لأنه لا يمكن الضغط عليه وهو مغلق، لكن احترازاً
            createMainInterface(parentGui)
        end
    end)

    -- إضافة باقي الاختصارات
    for _, shortcutData in ipairs(shortcuts) do
        local shortcutButton = Instance.new("TextButton")
        shortcutButton.Name = shortcutData.name
        shortcutButton.Size = UDim2.new(1, -20, 0, 40)
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

    -- إطار المجلدات
    local foldersFrame = mainFrame:FindFirstChild("FoldersFrame")
    if not foldersFrame then
        foldersFrame = Instance.new("ScrollingFrame")
        foldersFrame.Name = "FoldersFrame"
        foldersFrame.Size = UDim2.new(0, 300, 0, 250)
        foldersFrame.Position = UDim2.new(0, 30, 0, 110)
        foldersFrame.BackgroundTransparency = 1
        foldersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        foldersFrame.ScrollBarThickness = 4
        foldersFrame.Parent = mainFrame
    end

    local foldersList = Instance.new("UIListLayout")
    foldersList.Padding = UDim.new(0, 10)
    foldersList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    foldersList.Parent = foldersFrame

    foldersFrame:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        foldersFrame.CanvasSize = UDim2.new(0, 0, 0, foldersList.AbsoluteContentSize.Y)
    end)
    
    for _, folderButton in pairs(foldersFrame:GetChildren()) do
        if folderButton:IsA("TextButton") then folderButton:Destroy() end -- مسح القديم
    end

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
-- دالة إنشاء واجهة المعلومات (Info Interface)
---------------------------------------------
local function createInfoInterface(parentGui)
    local openSound = Instance.new("Sound")
    openSound.SoundId = settings.openSound
    openSound.Volume = 0.5
    openSound.Parent = parentGui
    openSound:Play()

    if parentGui:FindFirstChild("InfoInterface") then
        return parentGui.InfoInterface
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

    -- محتوى المعلومات
    local infoText = Instance.new("TextLabel")
    infoText.Name = "InfoText"
    infoText.Size = UDim2.new(1, -40, 0, 200)
    infoText.Position = UDim2.new(0, 20, 0, 60)
    infoText.BackgroundTransparency = 1
    infoText.Font = Enum.Font.Gotham
    infoText.Text = "مكتبة Luna Pro للواجهات الفخمة.\nالإصدار: 2.0 (Epic Glassmorphism).\nالمطور: مجهول.\n\nتتميز هذه الواجهة بالشفافية الزجاجية والزوايا الدائرية العصرية، مع أنميشنات دخول وخروج ديناميكية.\n\nتاريخ الإنشاء: " .. os.date("!%Y-%m-%d") .. "\nللمساعدة أو الاقتراحات: " .. settings.telegramLink
    infoText.TextSize = 16
    infoText.TextColor3 = settings.textColor
    infoText.TextXAlignment = Enum.TextXAlignment.Left
    infoText.TextYAlignment = Enum.TextYAlignment.Top
    infoText.TextWrapped = true
    infoText.Parent = infoFrame

    return infoFrame
end

---------------------------------------------
-- دالة إنشاء لوحة الخيارات (Option Panel) - مصلحة ومدمجة
---------------------------------------------
local function createOptionPanel(parentGui, toggleButton)
    
    local isPanelOpen = false

    local optionPanel = Instance.new("Frame")
    optionPanel.Name = "OptionPanel"
    optionPanel.Size = UDim2.new(0, 150, 0, 100)
    optionPanel.Position = UDim2.new(1, -210, 0.5, -50) -- موضع مبدئي (مخفي جزئياً)
    optionPanel.BackgroundColor3 = settings.buttonColor
    optionPanel.BackgroundTransparency = 0.2
    optionPanel.BorderSizePixel = 0
    optionPanel.Parent = parentGui
    optionPanel.ZIndex = 10
    optionPanel.Visible = false -- يبدأ مخفياً

    local optionCorner = Instance.new("UICorner")
    optionCorner.CornerRadius = settings.cornerRadius
    optionCorner.Parent = optionPanel

    local glassStroke = Instance.new("UIStroke")
    glassStroke.Color = Color3.fromRGB(255, 255, 255)
    glassStroke.Thickness = 1
    glassStroke.Transparency = 0.8
    glassStroke.Parent = optionPanel

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 10)
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    listLayout.Parent = optionPanel
    listLayout.Name = "ListLayout"

    local function createPanelButton(name, text, icon, clickCallback)
        local button = Instance.new("TextButton")
        button.Name = name
        button.Size = UDim2.new(1, -20, 0, 40)
        button.Position = UDim2.new(0, 10, 0, 0)
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
        buttonIcon.Position = UDim2.new(0, 5, 0, 5)
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
        buttonText.TextSize = 14
        buttonText.TextColor3 = settings.textColor
        buttonText.TextXAlignment = Enum.TextXAlignment.Left
        buttonText.Parent = button

        button.MouseButton1Click:Connect(function()
            local btnSound = Instance.new("Sound")
            btnSound.SoundId = settings.buttonSound
            btnSound.Volume = 0.5
            btnSound.Parent = parentGui
            btnSound:Play()
            togglePanel(false) -- إغلاق اللوحة عند الضغط على أحد الأزرار
            clickCallback()
        end)
        
        -- أنميشن التحويم
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 220, 220)}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor}):Play()
        end)

        return button
    end
    
    -- زر فتح القائمة الرئيسية
    createPanelButton("OpenMain", "الواجهة الرئيسية", settings.mainIcon, function() 
        if parentGui:FindFirstChild("MainInterface") then
            parentGui.MainInterface.CloseButton:Click() -- إغلاق الواجهة إذا كانت مفتوحة
        else
            createMainInterface(parentGui) 
        end
    end)

    -- زر فتح المعلومات
    createPanelButton("OpenInfo", "معلومات", settings.infoIcon, function() 
        if parentGui:FindFirstChild("InfoInterface") then
            parentGui.InfoInterface.InfoCloseButton:Click() -- إغلاق الواجهة إذا كانت مفتوحة
        else
            createInfoInterface(parentGui) 
        end
    end)
    
    -- ضبط حجم الإطار ليناسب الأزرار
    optionPanel.Size = UDim2.new(0, 200, 0, listLayout.AbsoluteContentSize.Y + 20)
    optionPanel.Position = UDim2.new(1, -210, 0.5, -(optionPanel.Size.Y.Offset / 2)) -- إعادة ضبط الموضع

    local panelHiddenPos = UDim2.new(1, -210, optionPanel.Position.Y.Scale, optionPanel.Position.Y.Offset)
    local panelVisiblePos = UDim2.new(1, -210, optionPanel.Position.Y.Scale, optionPanel.Position.Y.Offset)

    local function togglePanel(shouldOpen)
        local targetPosition
        local targetSize
        
        isPanelOpen = shouldOpen ~= nil and shouldOpen or not isPanelOpen
        
        optionPanel.Visible = true -- يجب أن يكون مرئياً لكي يظهر الأنميشن
        
        if isPanelOpen then
            targetPosition = UDim2.new(1, -210, optionPanel.Position.Y.Scale, optionPanel.Position.Y.Offset)
            targetSize = UDim2.new(0, 200, 0, listLayout.AbsoluteContentSize.Y + 20)
            TweenService:Create(optionPanel, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -210, optionPanel.Position.Y.Scale, optionPanel.Position.Y.Offset)
            }):Play()
        else
            targetPosition = UDim2.new(1, -210 + optionPanel.Size.X.Offset, optionPanel.Position.Y.Scale, optionPanel.Position.Y.Offset)
            targetSize = UDim2.new(0, 0, 0, 0) -- حجم وهمي للاخفاء البصري
            local hideTween = TweenService:Create(optionPanel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 10, optionPanel.Size.Y.Scale, optionPanel.Size.Y.Offset),
                Position = UDim2.new(1, -100, optionPanel.Position.Y.Scale, optionPanel.Position.Y.Offset)
            })
            hideTween:Play()
            hideTween.Completed:Wait()
            optionPanel.Visible = false
            optionPanel.BackgroundTransparency = 0.2
            optionPanel.Size = UDim2.new(0, 200, 0, listLayout.AbsoluteContentSize.Y + 20)
            optionPanel.Position = panelHiddenPos
        end
    end
    
    -- ربط الزر العائم بفتح وإغلاق لوحة الخيارات
    if toggleButton then
        toggleButton.MouseButton1Click:Connect(function()
            togglePanel(nil)
        end)
    end
    
    -- وظيفة فتح/إغلاق الواجهة الرئيسية أيضاً للزر العائم
    local function mainFrameToggle()
         if parentGui:FindFirstChild("MainInterface") then
            parentGui.MainInterface.CloseButton:Click()
        else
            createMainInterface(parentGui)
        end
    end
    
    -- إرجاع الدالة الرئيسية للتحكم بها من الخارج (اختصار الكيبورد)
    return togglePanel, mainFrameToggle
end

---------------------------------------------
-- دالة إنشاء الزر العائم (الToggle Button) - هذا هو الزر الدائري المفقود
---------------------------------------------
local function createToggleButton(parentGui)
    
    -- حاوية للزر العائم لوضعها في زاوية معينة
    local toggleContainer = Instance.new("Frame")
    toggleContainer.Name = "LunaToggleContainer"
    toggleContainer.Size = UDim2.new(0, 50, 0, 50)
    toggleContainer.Position = UDim2.new(1, -60, 0.5, 0) -- اليمين منتصف الشاشة
    toggleContainer.BackgroundTransparency = 1
    toggleContainer.Parent = parentGui
    toggleContainer.ZIndex = 15

    local toggleButton = Instance.new("ImageButton")
    toggleButton.Name = "LunaToggleButton"
    toggleButton.Size = UDim2.new(1, 0, 1, 0)
    toggleButton.Position = UDim2.new(0, 0, 0, 0)
    toggleButton.BackgroundColor3 = settings.accentColor
    toggleButton.BackgroundTransparency = 0.2
    toggleButton.Image = settings.mainIcon
    toggleButton.ImageColor3 = settings.textColor
    toggleButton.Parent = toggleContainer
    toggleButton.ZIndex = 15
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0.5, 0) -- دائري بالكامل
    toggleCorner.Parent = toggleButton
    
    local glassStroke = Instance.new("UIStroke")
    glassStroke.Color = Color3.fromRGB(255, 255, 255)
    glassStroke.Thickness = 2
    glassStroke.Transparency = 0.8
    glassStroke.Parent = toggleButton
    
    local function animateClick(button)
        TweenService:Create(button, TweenInfo.new(0.1), {ImageTransparency = 0.5}):Play()
        task.wait(0.1)
        TweenService:Create(button, TweenInfo.new(0.2), {ImageTransparency = 0}):Play()
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        animateClick(toggleButton)
    end)
    
    -- أنميشن التحويم
    toggleButton.MouseEnter:Connect(function()
        TweenService:Create(toggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 220, 220), BackgroundTransparency = 0.1}):Play()
        TweenService:Create(toggleButton, TweenInfo.new(0.3), {Rotation = 10}):Play()
    end)
    toggleButton.MouseLeave:Connect(function()
        TweenService:Create(toggleButton, TweenInfo.new(0.3), {BackgroundColor3 = settings.accentColor, BackgroundTransparency = 0.2}):Play()
        TweenService:Create(toggleButton, TweenInfo.new(0.3), {Rotation = 0}):Play()
    end)

    return toggleButton
end

---------------------------------------------
-- دالة تهيئة الواجهة
---------------------------------------------
local function InitializeLunaUI()
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "LunaPro_GUI"
    mainGui.ResetOnSpawn = false
    mainGui.Parent = PlayerGui

    -- 1. إنشاء الزر العائم الدائري
    local toggleButton = createToggleButton(mainGui)
    
    -- 2. إنشاء لوحة الخيارات وربطها بالزر العائم
    local togglePanel, mainFrameToggle = createOptionPanel(mainGui, toggleButton)

    -- 3. تفعيل اختصار الكيبورد
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == settings.shortcutKey then
            if mainGui:FindFirstChild("MainInterface") or mainGui:FindFirstChild("FolderInterface") or mainGui:FindFirstChild("InfoInterface") then
                -- إغلاق كل الواجهات
                if mainGui:FindFirstChild("MainInterface") then mainGui.MainInterface.CloseButton:Click() end
                if mainGui:FindFirstChild("FolderInterface") then mainGui.FolderInterface:Destroy() end
                if mainGui:FindFirstChild("InfoInterface") then mainGui.InfoInterface.InfoCloseButton:Click() end
                togglePanel(false) -- إغلاق لوحة الخيارات
            else
                -- فتح الواجهة الرئيسية
                mainFrameToggle()
            end
        end
    end)
    
    -- 4. إظهار لوحة الخيارات أول مرة (اختياري)
    task.wait(1)
    togglePanel(true)
    task.wait(3)
    togglePanel(false)
end

-- تشغيل السكربت بعد التأكد من وجود اللاعب
if LocalPlayer then
    InitializeLunaUI()
end

return Luna
