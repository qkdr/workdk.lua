-- مكتبة Luna للواجهات الفخمة في Roblox
-- نسخة كاملة ومُحسنة: عند الضغط على مجلد يمكن طلب رمز (accessCode)
-- ضع هذا الملف كـ LocalScript داخل StarterPlayerScripts أو StarterGui حسب حاجتك.

local Luna = {}

---------------------------------------------
-- إعدادات عامة قابلة للتعديل
---------------------------------------------
local settings = {
    openSound = "rbxassetid://6042053626",
    buttonSound = "rbxassetid://6026984224",
    warningSound = "rbxassetid://6042055798",
    keySound = "rbxassetid://1843535974", -- صوت عند إدخال المفتاح بنجاح
    backgroundImage = "rbxassetid://13577851314", -- صورة خلفية الواجهة
    buttonColor = Color3.fromRGB(40, 40, 40),
    accentColor = Color3.fromRGB(0, 170, 100),
    textColor = Color3.fromRGB(255, 255, 255),
    cornerRadius = UDim.new(0, 12),
    transparency = 0.2,
    telegramLink = "https://t.me/YourChannelLink",
    folderIcon = "rbxassetid://123456789", -- أيقونة المجلد المفتوح (يمكن تغييرها)
    keyIconDefault = "rbxassetid://7734056608" -- أيقونة للمفتاح/modal
}

---------------------------------------------
-- بيانات المجلدات الخارجية
-- كل مجلد: folderName, folderDescription, scripts (كل عنصر: name, description, url),
-- يمكن إضافة: locked = true, accessCode = "1234", keyIcon = "rbxassetid://..."
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
    if not parentGui or not parentGui:IsA("Instance") then return end
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 50)
    notification.Position = UDim2.new(0.5, -150, 0, -60)
    notification.BackgroundColor3 = settings.accentColor
    notification.BackgroundTransparency = 0.3
    notification.BorderSizePixel = 0
    notification.Parent = parentGui
    notification.ZIndex = 50

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
    notifText.TextWrapped = true
    notifText.Parent = notification
    notifText.ZIndex = 51

    TweenService:Create(notification, TweenInfo.new(0.28, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 300, 0, 50),
        Position = UDim2.new(0.5, -150, 0, 20)
    }):Play()

    delay(2.2, function()
        if notification and notification.Parent then
            local hideTween = TweenService:Create(notification, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0, -60)
            })
            hideTween:Play()
            wait(0.32)
            if notification and notification.Parent then
                notification:Destroy()
            end
        end
    end)
end

---------------------------------------------
-- دالة مربع التأكيد (قابلة لإعادة الاستخدام)
---------------------------------------------
local function showConfirmationDialog(parentGui, message, confirmCallback)
    if not parentGui then return end
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
    confirmationFrame.BackgroundTransparency = 0.08
    confirmationFrame.BorderSizePixel = 0
    confirmationFrame.Parent = parentGui
    confirmationFrame.ZIndex = 80

    confirmationFrame.Size = UDim2.new(0, 0, 0, 0)
    confirmationFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(confirmationFrame, TweenInfo.new(0.32, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 400, 0, 200),
        Position = UDim2.new(0.5, -200, 0.5, -100)
    }):Play()

    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = settings.cornerRadius
    confirmCorner.Parent = confirmationFrame

    local warningIcon = Instance.new("ImageLabel")
    warningIcon.Name = "WarningIcon"
    warningIcon.Size = UDim2.new(0, 50, 0, 50)
    warningIcon.Position = UDim2.new(0.5, -25, 0, 20)
    warningIcon.BackgroundTransparency = 1
    warningIcon.Image = "rbxassetid://7734056608"
    warningIcon.ImageColor3 = Color3.fromRGB(255, 200, 0)
    warningIcon.Parent = confirmationFrame
    warningIcon.ZIndex = 81

    local confirmationText = Instance.new("TextLabel")
    confirmationText.Name = "ConfirmationText"
    confirmationText.Size = UDim2.new(0, 360, 0, 70)
    confirmationText.Position = UDim2.new(0.5, -180, 0, 80)
    confirmationText.BackgroundTransparency = 1
    confirmationText.Font = Enum.Font.GothamMedium
    confirmationText.Text = message or "هل أنت متأكد؟"
    confirmationText.TextSize = 16
    confirmationText.TextColor3 = settings.textColor
    confirmationText.TextWrapped = true
    confirmationText.Parent = confirmationFrame
    confirmationText.ZIndex = 81

    local confirmButton = Instance.new("TextButton")
    confirmButton.Name = "ConfirmButton"
    confirmButton.Size = UDim2.new(0, 140, 0, 40)
    confirmButton.Position = UDim2.new(0.5, -150, 0, 145)
    confirmButton.BackgroundColor3 = settings.accentColor
    confirmButton.Font = Enum.Font.GothamBold
    confirmButton.Text = "تأكيد"
    confirmButton.TextSize = 16
    confirmButton.TextColor3 = settings.textColor
    confirmButton.Parent = confirmationFrame
    confirmButton.ZIndex = 81

    local confirmButtonCorner = Instance.new("UICorner")
    confirmButtonCorner.CornerRadius = settings.cornerRadius
    confirmButtonCorner.Parent = confirmButton

    local cancelButton = Instance.new("TextButton")
    cancelButton.Name = "CancelButton"
    cancelButton.Size = UDim2.new(0, 120, 0, 40)
    cancelButton.Position = UDim2.new(0.5, 10, 0, 145)
    cancelButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    cancelButton.Font = Enum.Font.GothamBold
    cancelButton.Text = "إلغاء"
    cancelButton.TextSize = 16
    cancelButton.TextColor3 = settings.textColor
    cancelButton.Parent = confirmationFrame
    cancelButton.ZIndex = 81

    local cancelButtonCorner = Instance.new("UICorner")
    cancelButtonCorner.CornerRadius = settings.cornerRadius
    cancelButtonCorner.Parent = cancelButton

    local function closeConfirm()
        if confirmationFrame and confirmationFrame.Parent then
            TweenService:Create(confirmationFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }):Play()
            wait(0.26)
            if confirmationFrame and confirmationFrame.Parent then
                confirmationFrame:Destroy()
            end
        end
    end

    confirmButton.MouseEnter:Connect(function()
        TweenService:Create(confirmButton, TweenInfo.new(0.22), {BackgroundColor3 = Color3.fromRGB(0, 200, 120)}):Play()
    end)
    confirmButton.MouseLeave:Connect(function()
        TweenService:Create(confirmButton, TweenInfo.new(0.22), {BackgroundColor3 = settings.accentColor}):Play()
    end)
    cancelButton.MouseEnter:Connect(function()
        TweenService:Create(cancelButton, TweenInfo.new(0.22), {BackgroundColor3 = Color3.fromRGB(230, 70, 70)}):Play()
    end)
    cancelButton.MouseLeave:Connect(function()
        TweenService:Create(cancelButton, TweenInfo.new(0.22), {BackgroundColor3 = Color3.fromRGB(200, 60, 60)}):Play()
    end)

    confirmButton.MouseButton1Click:Connect(function()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        closeConfirm()
        if confirmCallback then
            spawn(confirmCallback)
        end
    end)
    cancelButton.MouseButton1Click:Connect(function()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        closeConfirm()
    end)
end

---------------------------------------------
-- دالة طلب رمز (Key Prompt) — فخمة، شفافة، مع ايقونة وصوت
---------------------------------------------
local function showKeyPrompt(parentGui, folderData, successCallback)
    if not parentGui then return end

    local prompt = Instance.new("Frame")
    prompt.Name = "KeyPrompt"
    prompt.Size = UDim2.new(0, 380, 0, 160)
    prompt.Position = UDim2.new(0.5, -190, 0.5, -80)
    prompt.BackgroundColor3 = Color3.fromRGB(20,20,20)
    prompt.BackgroundTransparency = 0.14
    prompt.BorderSizePixel = 0
    prompt.Parent = parentGui
    prompt.ZIndex = 100

    local promptCorner = Instance.new("UICorner")
    promptCorner.CornerRadius = UDim.new(0, 14)
    promptCorner.Parent = prompt

    -- Glass overlay subtle
    local glass = Instance.new("Frame")
    glass.Name = "GlassOverlay"
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.Position = UDim2.new(0, 0, 0, 0)
    glass.BackgroundColor3 = Color3.new(1,1,1)
    glass.BackgroundTransparency = 0.92
    glass.Parent = prompt

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 48)
    header.Position = UDim2.new(0, 0, 0, 0)
    header.BackgroundTransparency = 1
    header.Parent = prompt

    local icon = Instance.new("ImageLabel")
    icon.Name = "KeyIcon"
    icon.Size = UDim2.new(0, 38, 0, 38)
    icon.Position = UDim2.new(0, 12, 0, 5)
    icon.BackgroundTransparency = 1
    icon.Image = folderData.keyIcon or settings.keyIconDefault
    icon.Parent = header

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 300, 0, 48)
    title.Position = UDim2.new(0, 60, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = folderData.folderName or "الرجاء إدخال الرمز"
    title.TextSize = 18
    title.TextColor3 = settings.textColor
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local inputBox = Instance.new("TextBox")
    inputBox.Name = "KeyInput"
    inputBox.Size = UDim2.new(0, 340, 0, 40)
    inputBox.Position = UDim2.new(0, 20, 0, 60)
    inputBox.BackgroundTransparency = 0.64
    inputBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
    inputBox.PlaceholderText = "أدخل الرمز هنا..."
    inputBox.Text = ""
    inputBox.Font = Enum.Font.Gotham
    inputBox.ClearTextOnFocus = false
    inputBox.TextSize = 18
    inputBox.TextColor3 = settings.textColor
    inputBox.Parent = prompt

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputBox

    local submitButton = Instance.new("TextButton")
    submitButton.Name = "SubmitButton"
    submitButton.Size = UDim2.new(0, 140, 0, 36)
    submitButton.Position = UDim2.new(1, -160, 1, -48)
    submitButton.BackgroundColor3 = settings.accentColor
    submitButton.Font = Enum.Font.GothamBold
    submitButton.Text = "تحقق"
    submitButton.TextSize = 16
    submitButton.TextColor3 = settings.textColor
    submitButton.Parent = prompt

    local cancelButton = Instance.new("TextButton")
    cancelButton.Name = "CancelButton"
    cancelButton.Size = UDim2.new(0, 100, 0, 36)
    cancelButton.Position = UDim2.new(1, -270, 1, -48)
    cancelButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    cancelButton.Font = Enum.Font.GothamBold
    cancelButton.Text = "إلغاء"
    cancelButton.TextSize = 16
    cancelButton.TextColor3 = settings.textColor
    cancelButton.Parent = prompt

    local submitCorner = Instance.new("UICorner")
    submitCorner.CornerRadius = UDim.new(0, 8)
    submitCorner.Parent = submitButton

    local cancelCorner = Instance.new("UICorner")
    cancelCorner.CornerRadius = UDim.new(0, 8)
    cancelCorner.Parent = cancelButton

    local function destroyPrompt()
        if prompt and prompt.Parent then
            TweenService:Create(prompt, TweenInfo.new(0.2), {Size = UDim2.new(0, 0, 0, 0)}):Play()
            wait(0.22)
            if prompt and prompt.Parent then
                prompt:Destroy()
            end
        end
    end

    local function playSuccess()
        local s = Instance.new("Sound")
        s.SoundId = settings.keySound
        s.Volume = 0.6
        s.Parent = parentGui
        s:Play()
    end

    local function validateAndProceed()
        local entered = tostring(inputBox.Text or "")
        if folderData.accessCode and tostring(folderData.accessCode) ~= "" then
            if entered == tostring(folderData.accessCode) then
                playSuccess()
                showNotification(parentGui, "الرمز صحيح — جاري الفتح...")
                destroyPrompt()
                if successCallback then
                    spawn(successCallback)
                end
            else
                local warn = Instance.new("Sound")
                warn.SoundId = settings.warningSound
                warn.Volume = 0.7
                warn.Parent = parentGui
                warn:Play()
                showNotification(parentGui, "الرمز خاطئ، حاول مرة أخرى.")
                -- إهتزاز بسيط
                local startPos = prompt.Position
                local shakeTween = TweenService:Create(prompt, TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 6), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+6, startPos.Y.Scale, startPos.Y.Offset)})
                shakeTween:Play()
            end
        else
            -- إذا لم يكن هناك رمز محدد ننفذ مباشرة
            if successCallback then
                destroyPrompt()
                spawn(successCallback)
            end
        end
    end

    submitButton.MouseButton1Click:Connect(function()
        validateAndProceed()
    end)
    cancelButton.MouseButton1Click:Connect(function()
        destroyPrompt()
    end)

    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            validateAndProceed()
        end
    end)
end

---------------------------------------------
-- دالة تطبيق تأثير "زجاج" (Glass effect) على زر المجلد
---------------------------------------------
local function applyGlassEffect(folderButton)
    local glassEffect = Instance.new("Frame")
    glassEffect.Name = "GlassEffect"
    glassEffect.Size = UDim2.new(0, 80, 1, 0)
    glassEffect.Position = UDim2.new(-1, 0, 0, 0)
    glassEffect.BackgroundTransparency = 0.6
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
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.4, 0.3),
        NumberSequenceKeypoint.new(1, 0.9)
    })
    glassGradient.Parent = glassEffect

    local function tweenGlass()
        if not glassEffect or not glassEffect.Parent then return end
        local tween1 = TweenService:Create(glassEffect, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)})
        local tween2 = TweenService:Create(glassEffect, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(-1, 0, 0, 0)})
        tween1:Play()
        tween1.Completed:Wait()
        tween2:Play()
        tween2.Completed:Wait()
        tweenGlass()
    end
    spawn(tweenGlass)
end

---------------------------------------------
-- دالة إنشاء واجهة المجلدات (Folder Interface)
---------------------------------------------
local function createFolderInterface(parentGui, folderData)
    if not parentGui then return end
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
        itemFrame.Name = scriptData.name or "ScriptItem"
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
        scriptLabel.Text = (scriptData.name or "") .. "\n" .. (scriptData.description or "")
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
        viewButton.Text = "تنفيذ"
        viewButton.TextSize = 18
        viewButton.TextColor3 = settings.textColor
        viewButton.Parent = itemFrame

        local viewButtonCorner = Instance.new("UICorner")
        viewButtonCorner.CornerRadius = UDim.new(0, 8)
        viewButtonCorner.Parent = viewButton

        viewButton.MouseEnter:Connect(function()
            TweenService:Create(viewButton, TweenInfo.new(0.22), {BackgroundColor3 = Color3.fromRGB(0, 200, 120)}):Play()
        end)
        viewButton.MouseLeave:Connect(function()
            TweenService:Create(viewButton, TweenInfo.new(0.22), {BackgroundColor3 = settings.accentColor}):Play()
        end)

        viewButton.MouseButton1Click:Connect(function()
            local btnSound = Instance.new("Sound")
            btnSound.SoundId = settings.buttonSound
            btnSound.Volume = 0.5
            btnSound.Parent = parentGui
            btnSound:Play()
            showConfirmationDialog(parentGui, "هل أنت متأكد أنك تريد تشغيل " .. (scriptData.name or "السكربت") .. "؟", function()
                if scriptData.url and scriptData.url ~= "" then
                    local ok, res = pcall(function()
                        return loadstring(game:HttpGet(scriptData.url))()
                    end)
                    if ok then
                        showNotification(parentGui, "تم تشغيل " .. (scriptData.name or "السكربت") .. "!")
                    else
                        showNotification(parentGui, "خطأ بتشغيل: " .. tostring(res))
                    end
                else
                    showNotification(parentGui, "لا يوجد رابط للسكربت.")
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
    if not parentGui then return end
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
    TweenService:Create(mainFrame, TweenInfo.new(0.42, Enum.EasingStyle.Back), {
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
    backgroundImage.ImageTransparency = 0.22
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
    titleLabel.Text = "القائمة السكربتات"
    titleLabel.TextSize = 28
    titleLabel.TextColor3 = settings.textColor
    titleLabel.Parent = mainFrame

    -- صورة شخصية واسمه في أعلى اليسار
    local avatar = Instance.new("ImageLabel")
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 50, 0, 50)
    avatar.Position = UDim2.new(0, 10, 0, 10)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=150&h=150"
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
    playerNameLabel.Text = LocalPlayer.DisplayName or LocalPlayer.Name
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
    closeButton.BackgroundColor3 = settings.buttonColor
    closeButton.Text = "X"
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 24
    closeButton.TextColor3 = settings.textColor
    closeButton.Parent = mainFrame
    closeButton.ZIndex = 40

    closeButton.MouseButton1Click:Connect(function()
        local btnSound = Instance.new("Sound")
        btnSound.SoundId = settings.buttonSound
        btnSound.Volume = 0.5
        btnSound.Parent = parentGui
        btnSound:Play()
        TweenService:Create(mainFrame, TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Rotation = 5
        }):Play()
        wait(0.38)
        if mainFrame and mainFrame.Parent then
            mainFrame:Destroy()
        end
    end)

    -- زر البحث
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
    searchBox.PlaceholderText = "ابحث عن سكربتات..."
    searchBox.Text = ""
    searchBox.TextSize = 16
    searchBox.TextColor3 = settings.textColor
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchFrame

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

    searchBox.Changed:Connect(function(prop)
        if prop == "Text" then
            for _, folderButton in pairs(foldersFrame:GetChildren()) do
                if folderButton:IsA("TextButton") then
                    if string.find(string.lower(folderButton.Name), string.lower(searchBox.Text or "")) then
                        folderButton.Visible = true
                    else
                        folderButton.Visible = false
                    end
                end
            end
        end
    end)

    -- إنشاء أزرار المجلدات
    for _, folderData in ipairs(externalFolders) do
        local folderButton = Instance.new("TextButton")
        folderButton.Name = folderData.folderName or "Folder"
        folderButton.Size = UDim2.new(0, 450, 0, 60)
        folderButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        folderButton.BackgroundTransparency = 0.45
        folderButton.Font = Enum.Font.SourceSans
        folderButton.Text = ""
        folderButton.Parent = foldersFrame

        local folderCorner = Instance.new("UICorner")
        folderCorner.CornerRadius = settings.cornerRadius
        folderCorner.Parent = folderButton

        -- Glass effect
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
        folderDescLabel.TextSize = 14
        folderDescLabel.TextColor3 = settings.textColor
        folderDescLabel.TextXAlignment = Enum.TextXAlignment.Left
        folderDescLabel.TextWrapped = true
        folderDescLabel.Parent = folderButton

        local scriptCount = # (folderData.scripts or {})
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

        if folderData.locked then
            -- مجلد مغلق
            local lockIcon = Instance.new("ImageLabel")
            lockIcon.Name = "LockIcon"
            lockIcon.Size = UDim2.new(0, 30, 0, 30)
            lockIcon.Position = UDim2.new(0, 10, 0, 15)
            lockIcon.BackgroundTransparency = 1
            lockIcon.Image = "rbxassetid://4224275681"
            lockIcon.Parent = folderButton

            local lockedTextShadow = Instance.new("TextLabel")
            lockedTextShadow.Name = "LockedTextShadow"
            lockedTextShadow.Size = UDim2.new(0, 60, 0, 30)
            lockedTextShadow.Position = UDim2.new(0, 50, 0, 15)
            lockedTextShadow.BackgroundTransparency = 1
            lockedTextShadow.Font = Enum.Font.GothamBold
            lockedTextShadow.Text = "مغلق"
            lockedTextShadow.TextSize = 20
            lockedTextShadow.TextColor3 = Color3.new(0, 0, 0)
            lockedTextShadow.Parent = folderButton

            local lockedText = Instance.new("TextLabel")
            lockedText.Name = "LockedText"
            lockedText.Size = UDim2.new(0, 60, 0, 30)
            lockedText.Position = UDim2.new(0, 48, 0, 13)
            lockedText.BackgroundTransparency = 1
            lockedText.Font = Enum.Font.GothamBold
            lockedText.Text = "مغلق"
            lockedText.TextSize = 20
            lockedText.TextColor3 = Color3.fromRGB(200, 0, 0)
            lockedText.Parent = folderButton

            folderButton.MouseButton1Click:Connect(function()
                showNotification(parentGui, "هذا المجلد مغلق ولا يمكن فتحه.")
            end)
        else
            folderButton.MouseButton1Click:Connect(function()
                local btnSound = Instance.new("Sound")
                btnSound.SoundId = settings.buttonSound
                btnSound.Volume = 0.5
                btnSound.Parent = parentGui
                btnSound:Play()

                if folderData.accessCode and tostring(folderData.accessCode) ~= "" then
                    showKeyPrompt(parentGui, folderData, function()
                        createFolderInterface(parentGui, folderData)
                    end)
                else
                    createFolderInterface(parentGui, folderData)
                end
            end)
        end
    end

    return mainFrame
end

---------------------------------------------
-- دالة إنشاء لوحة الخيارات (Option Panel)
---------------------------------------------
local function createOptionPanel(parentGui)
    if not parentGui then return end
    if parentGui:FindFirstChild("OptionPanel") then
        parentGui.OptionPanel:Destroy()
    end

    local optionPanel = Instance.new("Frame")
    optionPanel.Name = "OptionPanel"
    optionPanel.Size = UDim2.new(0, 200, 0, 100)
    optionPanel.Position = UDim2.new(0.95, -220, 0.5, -50)
    optionPanel.BackgroundColor3 = settings.buttonColor
    optionPanel.BackgroundTransparency = 0.18
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
    mainButton.Text = "قائمة سكربتات"
    mainButton.TextSize = 18
    mainButton.TextColor3 = settings.textColor
    mainButton.Parent = optionPanel

    local mainButtonCorner = Instance.new("UICorner")
    mainButtonCorner.CornerRadius = settings.cornerRadius
    mainButtonCorner.Parent = mainButton

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
-- دالة إنشاء الواجهة الدائرية (Circular Menu) مع سحب سلس
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
    circularButton.Image = "rbxassetid://7059346373"
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

    -- السحب
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
        TweenService:Create(circularButton, TweenInfo.new(0.22), {
            Size = UDim2.new(0, 70, 0, 70),
            Position = UDim2.new(0.95, -35, 0.5, -35)
        }):Play()
        TweenService:Create(buttonUIStroke, TweenInfo.new(0.22), {Transparency = 0}):Play()
    end)

    circularButton.MouseLeave:Connect(function()
        TweenService:Create(circularButton, TweenInfo.new(0.22), {
            Size = UDim2.new(0, 60, 0, 60),
            Position = UDim2.new(0.95, -30, 0.5, -30)
        }):Play()
        TweenService:Create(buttonUIStroke, TweenInfo.new(0.22), {Transparency = 0.5}):Play()
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
-- دوال إضافة/إدارة المجلدات
---------------------------------------------
function Luna:AddFolder(folderData)
    if not folderData then return end
    if not folderData.timestamp then folderData.timestamp = os.time() end
    folderData.locked = false
    table.insert(externalFolders, folderData)
end

function Luna:AddLockedFolder(folderData)
    if not folderData then return end
    if not folderData.timestamp then folderData.timestamp = os.time() end
    folderData.locked = true
    table.insert(externalFolders, folderData)
end

function Luna:ClearFolders()
    externalFolders = {}
end

function Luna:GetFolders()
    return externalFolders
end

return Luna
