-- Luna v2 — مكتبة واجهات فخمة مطوّرة (كاملة)
-- مميزات مضافة: بلور خلفي، زجاج مُضلّل متحرك، أيقونات فخمة، أنميشنات، اختصارات للألعاب،
-- محرر كود داخل مجلدات الكود (عرض/تعديل/حفظ وتشغيل)، AddCodeFolder، اختصارات لوحة مفاتيح لفتح/إغلاق.

local Luna = {}

-- ==========================
-- الإعدادات العامة القابلة للتعديل
-- ==========================
local settings = {
    openSound = "rbxassetid://6042053626",
    buttonSound = "rbxassetid://6026984224",
    warningSound = "rbxassetid://6042055798",
    backgroundImage = "rbxassetid://13577851314", -- صورة خلفية الواجهة
    buttonColor = Color3.fromRGB(30, 30, 30),
    accentColor = Color3.fromRGB(0, 170, 120),
    textColor = Color3.fromRGB(245, 245, 245),
    cornerRadius = UDim.new(0, 14),
    transparency = 0.18,
    telegramLink = "https://t.me/YourChannelLink",
    folderIcon = "rbxassetid://1337133713", -- أيقونة افتراضية للمجلد
    openKey = Enum.KeyCode.RightControl, -- زر اختصار لفتح/إغلاق الواجهة
    blurMax = 18, -- شدة البلور عند فتح الواجهة
    uiScale = 1 -- مقياس الواجهة (يمكن تغييره)
}

-- ==========================
-- بيانات المجلدات
-- كل مجلد: { folderName, folderDescription, scripts = { {name, description, url, code (اختياري), icon} }, locked (bool), folderIcon }
-- ==========================
local externalFolders = {}

-- ==========================
-- خدمات وروّاد
-- ==========================
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Lighting = game:GetService("Lighting")

-- ==========================
-- مؤثر الـ Blur الخلفي (سينشأ عند الحاجة)
-- ==========================
local blurEffect
local function ensureBlur()
    if not blurEffect or not blurEffect.Parent then
        blurEffect = Instance.new("BlurEffect")
        blurEffect.Name = "LunaBlurEffect"
        blurEffect.Parent = Lighting
        blurEffect.Size = 0
    end
end

-- ==========================
-- مساعدة: تشغيل صوت
-- ==========================
local function playSound(parent, soundId, volume)
    local s = Instance.new("Sound")
    s.SoundId = soundId
    s.Volume = volume or 0.6
    s.Parent = parent
    s.PlayOnRemove = false
    s:Play()
    game:GetService("Debris"):AddItem(s, 3)
end

-- ==========================
-- دالة عرض إشعار أنيق
-- ==========================
local function showNotification(parentGui, message, time)
    time = time or 2
    local notification = Instance.new("Frame")
    notification.Name = "LunaNotification"
    notification.Size = UDim2.new(0, 340, 0, 56)
    notification.AnchorPoint = Vector2.new(0.5, 0)
    notification.Position = UDim2.new(0.5, 0, 0, -80)
    notification.BackgroundTransparency = 0.15
    notification.BackgroundColor3 = settings.accentColor
    notification.BorderSizePixel = 0
    notification.ZIndex = 9999
    notification.Parent = parentGui

    local nc = Instance.new("UICorner", notification)
    nc.CornerRadius = UDim.new(0, 12)

    -- ظل
    local shadow = Instance.new("ImageLabel", notification)
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 8, 1, 8)
    shadow.Position = UDim2.new(0, -4, 0, -4)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://7744054490" -- افتراضي صورة ظل (سيعمل كنمط)
    shadow.ImageTransparency = 0.85
    shadow.ZIndex = notification.ZIndex - 1

    local text = Instance.new("TextLabel", notification)
    text.Size = UDim2.new(1, -24, 1, 0)
    text.Position = UDim2.new(0, 12, 0, 0)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.GothamBold
    text.Text = message
    text.TextColor3 = Color3.new(1,1,1)
    text.TextSize = 16
    text.TextWrapped = true
    text.ZIndex = notification.ZIndex + 1

    -- انميشن صعود
    TweenService:Create(notification, TweenInfo.new(0.35, Enum.EasingStyle.Back), {
        Position = UDim2.new(0.5, 0, 0, 16),
        Size = UDim2.new(0, 340, 0, 56)
    }):Play()
    delay(time, function()
        local t = TweenService:Create(notification, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Position = UDim2.new(0.5, 0, 0, -80), Size = UDim2.new(0, 0, 0, 0)})
        t:Play()
        t.Completed:Wait()
        notification:Destroy()
    end)
end

-- ==========================
-- دالة مربع تأكيد (مودال)
-- ==========================
local function showConfirmationDialog(parentGui, message, confirmCallback)
    playSound(parentGui, settings.warningSound, 0.5)
    local overlay = Instance.new("Frame")
    overlay.Name = "LunaConfirmOverlay"
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.Position = UDim2.new(0,0,0,0)
    overlay.BackgroundTransparency = 0.6
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.ZIndex = 9998
    overlay.Parent = parentGui

    local dialog = Instance.new("Frame")
    dialog.Name = "LunaConfirmDialog"
    dialog.Size = UDim2.new(0, 420, 0, 220)
    dialog.Position = UDim2.new(0.5, -210, 0.5, -110)
    dialog.BackgroundColor3 = settings.buttonColor
    dialog.BackgroundTransparency = 0.05
    dialog.BorderSizePixel = 0
    dialog.ZIndex = overlay.ZIndex + 1
    dialog.Parent = overlay

    local dc = Instance.new("UICorner", dialog)
    dc.CornerRadius = settings.cornerRadius

    local wIcon = Instance.new("ImageLabel", dialog)
    wIcon.Name = "WIcon"
    wIcon.Size = UDim2.new(0, 64, 0, 64)
    wIcon.Position = UDim2.new(0.5, -32, 0, 16)
    wIcon.BackgroundTransparency = 1
    wIcon.Image = "rbxassetid://7734056608"
    wIcon.ImageColor3 = Color3.fromRGB(255, 200, 0)

    local txt = Instance.new("TextLabel", dialog)
    txt.Size = UDim2.new(1, -24, 0, 60)
    txt.Position = UDim2.new(0, 12, 0, 90)
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.GothamMedium
    txt.Text = message
    txt.TextColor3 = settings.textColor
    txt.TextSize = 16
    txt.TextWrapped = true

    local confirmBtn = Instance.new("TextButton", dialog)
    confirmBtn.Name = "ConfirmBtn"
    confirmBtn.Size = UDim2.new(0, 140, 0, 42)
    confirmBtn.Position = UDim2.new(0.5, -150, 1, -56)
    confirmBtn.BackgroundColor3 = settings.accentColor
    confirmBtn.Font = Enum.Font.GothamBold
    confirmBtn.Text = "تأكيد"
    confirmBtn.TextSize = 18
    confirmBtn.TextColor3 = settings.textColor
    local cbCorner = Instance.new("UICorner", confirmBtn)
    cbCorner.CornerRadius = settings.cornerRadius

    local cancelBtn = Instance.new("TextButton", dialog)
    cancelBtn.Name = "CancelBtn"
    cancelBtn.Size = UDim2.new(0, 140, 0, 42)
    cancelBtn.Position = UDim2.new(0.5, 10, 1, -56)
    cancelBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    cancelBtn.Font = Enum.Font.GothamBold
    cancelBtn.Text = "إلغاء"
    cancelBtn.TextSize = 18
    cancelBtn.TextColor3 = settings.textColor
    local canCorner = Instance.new("UICorner", cancelBtn)
    canCorner.CornerRadius = settings.cornerRadius

    confirmBtn.MouseEnter:Connect(function() TweenService:Create(confirmBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0,200,140)}):Play() end)
    confirmBtn.MouseLeave:Connect(function() TweenService:Create(confirmBtn, TweenInfo.new(0.2), {BackgroundColor3 = settings.accentColor}):Play() end)
    cancelBtn.MouseEnter:Connect(function() TweenService:Create(cancelBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(230,80,80)}):Play() end)
    cancelBtn.MouseLeave:Connect(function() TweenService:Create(cancelBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200,60,60)}):Play() end)

    confirmBtn.MouseButton1Click:Connect(function()
        playSound(parentGui, settings.buttonSound, 0.5)
        overlay:Destroy()
        if confirmCallback then pcall(confirmCallback) end
    end)
    cancelBtn.MouseButton1Click:Connect(function()
        playSound(parentGui, settings.buttonSound, 0.5)
        overlay:Destroy()
    end)
end

-- ==========================
-- دالة تطبيق تأثير "زجاج" (Glass effect) مع المزيد من التفاصيل
-- ==========================
local function applyGlassEffect(folderButton, opts)
    opts = opts or {}
    local glassEffect = Instance.new("Frame")
    glassEffect.Name = "GlassEffect"
    glassEffect.Size = UDim2.new(0, 56, 1, 0)
    glassEffect.Position = UDim2.new(-1, 0, 0, 0)
    glassEffect.BackgroundTransparency = 0.6
    glassEffect.BackgroundColor3 = Color3.new(1,1,1)
    glassEffect.ZIndex = folderButton.ZIndex + 2
    glassEffect.Parent = folderButton

    local glassGrad = Instance.new("UIGradient", glassEffect)
    glassGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,255,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
    })
    glassGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.9),
        NumberSequenceKeypoint.new(0.5, 0.05),
        NumberSequenceKeypoint.new(1, 0.9)
    })

    local stroke = Instance.new("UIStroke", folderButton)
    stroke.Thickness = 1.6
    stroke.Transparency = 0.8
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    -- تدرج خلفي خفيف لخشونة الزجاج
    local overlay = Instance.new("ImageLabel", folderButton)
    overlay.Name = "GlassOverlay"
    overlay.BackgroundTransparency = 1
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.Position = UDim2.new(0,0,0,0)
    overlay.Image = "rbxassetid://6995661393" -- texture overlay (مثال)
    overlay.ImageTransparency = 0.95
    overlay.ZIndex = folderButton.ZIndex + 1

    -- حركة سريعة للـ glass
    spawn(function()
        while glassEffect.Parent do
            local t1 = TweenService:Create(glassEffect, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)})
            t1:Play()
            t1.Completed:Wait()
            local t2 = TweenService:Create(glassEffect, TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(-1, 0, 0, 0)})
            t2:Play()
            t2.Completed:Wait()
        end
    end)
end

-- ==========================
-- دالة إنشاء محرر كود مبسط (داخل الواجهة) — عرض/تعديل/حفظ/تشغيل
-- يتوقع 'scriptEntry' أن يملك .code (نص الكود) أو .url
-- ==========================
local function openCodeEditor(parentGui, folderData, scriptEntry)
    -- نعرض نافذة محرر (متحركة) مع TextBox كبير
    local editor = Instance.new("Frame")
    editor.Name = "LunaCodeEditor"
    editor.Size = UDim2.new(0, 780, 0, 520)
    editor.Position = UDim2.new(0.5, -390, 0.5, -260)
    editor.BackgroundColor3 = settings.buttonColor
    editor.BackgroundTransparency = 0.05
    editor.BorderSizePixel = 0
    editor.Parent = parentGui
    editor.ZIndex = 9999

    local edCorner = Instance.new("UICorner", editor)
    edCorner.CornerRadius = UDim.new(0, 12)

    -- عنوان ومعلومات
    local title = Instance.new("TextLabel", editor)
    title.Size = UDim2.new(1, -24, 0, 36)
    title.Position = UDim2.new(0, 12, 0, 10)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = settings.textColor
    title.Text = "محرر الكود — " .. (scriptEntry.name or "Script")
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- زر غلق
    local closeBtn = Instance.new("TextButton", editor)
    closeBtn.Size = UDim2.new(0, 36, 0, 36)
    closeBtn.Position = UDim2.new(1, -48, 0, 10)
    closeBtn.BackgroundTransparency = 0.5
    closeBtn.BackgroundColor3 = settings.buttonColor
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.Text = "X"
    closeBtn.TextColor3 = settings.textColor
    closeBtn.ZIndex = 10000

    local cbCorner = Instance.new("UICorner", closeBtn)
    cbCorner.CornerRadius = UDim.new(0, 8)

    -- TextBox الكود
    local codeBox = Instance.new("TextBox", editor)
    codeBox.Name = "CodeBox"
    codeBox.Size = UDim2.new(1, -24, 1, -140)
    codeBox.Position = UDim2.new(0,12,0,56)
    codeBox.BackgroundTransparency = 0.02
    codeBox.ClearTextOnFocus = false
    codeBox.Font = Enum.Font.Code
    codeBox.TextSize = 14
    codeBox.TextWrapped = false
    codeBox.MultiLine = true
    codeBox.TextXAlignment = Enum.TextXAlignment.Left
    codeBox.TextYAlignment = Enum.TextYAlignment.Top
    codeBox.TextColor3 = settings.textColor
    codeBox.Text = scriptEntry.code or (scriptEntry.url and ("-- هذا سكربت خارجي من: " .. scriptEntry.url) or "-- لا يوجد كود")
    codeBox.TextEditable = true

    local codeBoxCorner = Instance.new("UICorner", codeBox)
    codeBoxCorner.CornerRadius = UDim.new(0, 8)

    -- أزرار أسفل المحرر: حفظ، تشغيل، نسخ
    local saveBtn = Instance.new("TextButton", editor)
    saveBtn.Size = UDim2.new(0, 140, 0, 40)
    saveBtn.Position = UDim2.new(0, 12, 1, -64)
    saveBtn.BackgroundColor3 = settings.accentColor
    saveBtn.Font = Enum.Font.GothamBold
    saveBtn.Text = "حفظ"
    saveBtn.TextSize = 18
    saveBtn.TextColor3 = settings.textColor
    local saveCorner = Instance.new("UICorner", saveBtn)
    saveCorner.CornerRadius = UDim.new(0,8)

    local runBtn = Instance.new("TextButton", editor)
    runBtn.Size = UDim2.new(0, 140, 0, 40)
    runBtn.Position = UDim2.new(0, 164, 1, -64)
    runBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
    runBtn.Font = Enum.Font.GothamBold
    runBtn.Text = "تشغيل"
    runBtn.TextSize = 18
    runBtn.TextColor3 = settings.textColor
    local runCorner = Instance.new("UICorner", runBtn)
    runCorner.CornerRadius = UDim.new(0,8)

    local copyBtn = Instance.new("TextButton", editor)
    copyBtn.Size = UDim2.new(0, 140, 0, 40)
    copyBtn.Position = UDim2.new(0, 316, 1, -64)
    copyBtn.BackgroundColor3 = Color3.fromRGB(140, 120, 220)
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.Text = "نسخ"
    copyBtn.TextSize = 18
    copyBtn.TextColor3 = settings.textColor
    local copyCorner = Instance.new("UICorner", copyBtn)
    copyCorner.CornerRadius = UDim.new(0,8)

    -- حفظ التغييرات في الذاكرة (لا يوجد تخزين دائم)
    saveBtn.MouseButton1Click:Connect(function()
        playSound(editor, settings.buttonSound, 0.5)
        scriptEntry.code = codeBox.Text
        showNotification(parentGui, "تم حفظ التغييرات مؤقتاً")
    end)

    -- تشغيل الكود الموجود في الصندوق (بحذر)
    runBtn.MouseButton1Click:Connect(function()
        playSound(editor, settings.buttonSound, 0.5)
        local code = codeBox.Text
        -- تنفيذ بأمان داخل pcall
        local ok, err = pcall(function()
            local func, compileErr = loadstring(code)
            if not func then error(compileErr) end
            func()
        end)
        if ok then
            showNotification(parentGui, "تم تشغيل الكود بنجاح")
        else
            showNotification(parentGui, "خطأ أثناء التشغيل: " .. tostring(err))
        end
    end)

    -- نسخ إلى الحافظة (إن وُجد setclipboard)
    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(codeBox.Text)
            showNotification(parentGui, "تم نسخ الكود إلى الحافظة")
        else
            showNotification(parentGui, "النسخ غير متاح هنا")
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        playSound(editor, settings.buttonSound, 0.5)
        editor:Destroy()
    end)
end

-- ==========================
-- دالة إنشاء واجهة المجلد (داخل MainInterface) - محسّنة وفخمة
-- ==========================
local function createFolderInterface(parentGui, folderData)
    local folderFrame = Instance.new("Frame")
    folderFrame.Name = "FolderInterface"
    folderFrame.Size = UDim2.new(0, 780, 0, 520)
    folderFrame.Position = UDim2.new(0.5, -390, 0.5, -260)
    folderFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
    folderFrame.BackgroundTransparency = settings.transparency
    folderFrame.BorderSizePixel = 0
    folderFrame.ClipsDescendants = true
    folderFrame.ZIndex = 9999
    folderFrame.Parent = parentGui

    local fCorner = Instance.new("UICorner", folderFrame)
    fCorner.CornerRadius = UDim.new(0, 12)

    -- عنوان المجلد
    local folderTitle = Instance.new("TextLabel", folderFrame)
    folderTitle.Name = "FolderTitle"
    folderTitle.Size = UDim2.new(1, -180, 0, 40)
    folderTitle.Position = UDim2.new(0, 20, 0, 12)
    folderTitle.BackgroundTransparency = 1
    folderTitle.Font = Enum.Font.GothamBold
    folderTitle.Text = folderData.folderName or "مجلد"
    folderTitle.TextSize = 24
    folderTitle.TextColor3 = settings.textColor
    folderTitle.TextXAlignment = Enum.TextXAlignment.Left

    local folderDesc = Instance.new("TextLabel", folderFrame)
    folderDesc.Name = "FolderDescLabel"
    folderDesc.Size = UDim2.new(1, -180, 0, 20)
    folderDesc.Position = UDim2.new(0, 20, 0, 46)
    folderDesc.BackgroundTransparency = 1
    folderDesc.Font = Enum.Font.Gotham
    folderDesc.Text = folderData.folderDescription or ""
    folderDesc.TextSize = 15
    folderDesc.TextColor3 = Color3.fromRGB(190,190,190)
    folderDesc.TextXAlignment = Enum.TextXAlignment.Left
    folderDesc.TextWrapped = true

    -- زر رجوع
    local backButton = Instance.new("TextButton", folderFrame)
    backButton.Name = "BackButton"
    backButton.Size = UDim2.new(0, 100, 0, 36)
    backButton.Position = UDim2.new(1, -140, 0, 12)
    backButton.BackgroundColor3 = settings.accentColor
    backButton.Font = Enum.Font.GothamBold
    backButton.Text = "رجوع"
    backButton.TextSize = 16
    backButton.TextColor3 = settings.textColor
    local backCorner = Instance.new("UICorner", backButton)
    backCorner.CornerRadius = UDim.new(0, 8)

    backButton.MouseEnter:Connect(function() TweenService:Create(backButton, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0,200,140)}):Play() end)
    backButton.MouseLeave:Connect(function() TweenService:Create(backButton, TweenInfo.new(0.15), {BackgroundColor3 = settings.accentColor}):Play() end)
    backButton.MouseButton1Click:Connect(function()
        playSound(folderFrame, settings.buttonSound, 0.5)
        folderFrame:Destroy()
    end)

    -- إطار السكربتات
    local scriptsFrame = Instance.new("ScrollingFrame", folderFrame)
    scriptsFrame.Name = "FolderScriptsFrame"
    scriptsFrame.Size = UDim2.new(1, -40, 1, -120)
    scriptsFrame.Position = UDim2.new(0, 20, 0, 80)
    scriptsFrame.BackgroundTransparency = 1
    scriptsFrame.BorderSizePixel = 0
    scriptsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scriptsFrame.ScrollBarThickness = 6

    local grid = Instance.new("UIGridLayout", scriptsFrame)
    grid.CellSize = UDim2.new(0, 240, 0, 220)
    grid.CellPadding = UDim2.new(0, 12, 0, 12)

    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scriptsFrame.CanvasSize = UDim2.new(0, grid.AbsoluteContentSize.X, 0, grid.AbsoluteContentSize.Y)
    end)

    -- إنشاء عناصر السكربتات
    for _, scriptData in ipairs(folderData.scripts or {}) do
        local item = Instance.new("Frame")
        item.Name = scriptData.name or "Script"
        item.Size = UDim2.new(0, 240, 0, 220)
        item.BackgroundColor3 = Color3.fromRGB(36,36,36)
        item.BackgroundTransparency = 0.07
        item.BorderSizePixel = 0
        item.Parent = scriptsFrame

        local ic = Instance.new("UICorner", item)
        ic.CornerRadius = UDim.new(0,10)

        -- أيقونة
        local icon = Instance.new("ImageLabel", item)
        icon.Size = UDim2.new(1,0,0,110)
        icon.Position = UDim2.new(0,0,0,0)
        icon.BackgroundTransparency = 1
        icon.Image = scriptData.icon or settings.folderIcon
        icon.ScaleType = Enum.ScaleType.Crop

        -- شريط اسم ووصف
        local nameLbl = Instance.new("TextLabel", item)
        nameLbl.Size = UDim2.new(1, -12, 0, 36)
        nameLbl.Position = UDim2.new(0, 6, 0, 116)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.Text = scriptData.name or "سكربت"
        nameLbl.TextColor3 = settings.textColor
        nameLbl.TextSize = 16
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left

        local descLbl = Instance.new("TextLabel", item)
        descLbl.Size = UDim2.new(1, -12, 0, 36)
        descLbl.Position = UDim2.new(0, 6, 0, 150)
        descLbl.BackgroundTransparency = 1
        descLbl.Font = Enum.Font.Gotham
        descLbl.Text = scriptData.description or ""
        descLbl.TextColor3 = Color3.fromRGB(190,190,190)
        descLbl.TextSize = 13
        descLbl.TextWrapped = true
        descLbl.TextXAlignment = Enum.TextXAlignment.Left

        -- أزرار: تنفيذ / تحرير (إن كان كود) / رابط
        local execBtn = Instance.new("TextButton", item)
        execBtn.Size = UDim2.new(0, 108, 0, 34)
        execBtn.Position = UDim2.new(1, -116, 1, -40)
        execBtn.BackgroundColor3 = settings.accentColor
        execBtn.Font = Enum.Font.GothamBold
        execBtn.Text = "تشغيل"
        execBtn.TextSize = 15
        execBtn.TextColor3 = settings.textColor
        local execCorner = Instance.new("UICorner", execBtn)
        execCorner.CornerRadius = UDim.new(0,8)

        local editBtn = Instance.new("TextButton", item)
        editBtn.Size = UDim2.new(0, 108, 0, 34)
        editBtn.Position = UDim2.new(0, 8, 1, -40)
        editBtn.BackgroundColor3 = Color3.fromRGB(100,100,100)
        editBtn.Font = Enum.Font.GothamBold
        editBtn.Text = scriptData.code and "تحرير" or (scriptData.url and "عرض" or "لا يوجد")
        editBtn.TextSize = 15
        editBtn.TextColor3 = settings.textColor
        local editCorner = Instance.new("UICorner", editBtn)
        editCorner.CornerRadius = UDim.new(0,8)

        -- تنفيذ السكربت
        execBtn.MouseButton1Click:Connect(function()
            playSound(item, settings.buttonSound, 0.5)
            showConfirmationDialog(parentGui, "هل أنت متأكد أنك تريد تشغيل " .. (scriptData.name or "هذا السكربت") .. "؟", function()
                -- إذا وُجد code مباشراً، ننفذه، وإلا نحمل من url
                if scriptData.code then
                    local ok, err = pcall(function()
                        local f, cErr = loadstring(scriptData.code)
                        if not f then error(cErr) end
                        f()
                    end)
                    if ok then showNotification(parentGui, "تم تشغيل السكربت بنجاح") else showNotification(parentGui, "خطأ: "..tostring(err)) end
                elseif scriptData.url then
                    local ok, err = pcall(function()
                        loadstring(game:HttpGet(scriptData.url))()
                    end)
                    if ok then showNotification(parentGui, "تم تحميل وتشغيل السكربت") else showNotification(parentGui, "خطأ أثناء التحميل: "..tostring(err)) end
                else
                    showNotification(parentGui, "لا يوجد سكربت لتشغيله هنا")
                end
            end)
        end)

        -- زر التحرير / العرض
        editBtn.MouseButton1Click:Connect(function()
            playSound(item, settings.buttonSound, 0.5)
            -- إن وُجد كود — افتح المحرر
            if scriptData.code or scriptData.url then
                -- لو كان لديه url لكن لا يوجد code: نحاول جلب الكود من الـ url (أو نعرض الرسالة)
                if scriptData.code then
                    openCodeEditor(parentGui, folderData, scriptData)
                else
                    -- محاولة تحميل المحتوى من url داخل pcall
                    local ok, res = pcall(function() return game:HttpGet(scriptData.url) end)
                    if ok and type(res) == "string" and #res > 0 then
                        scriptData.code = res
                        openCodeEditor(parentGui, folderData, scriptData)
                    else
                        showNotification(parentGui, "لم أتمكن من جلب الكود من الرابط.")
                    end
                end
            else
                showNotification(parentGui, "لا يوجد كود لعرضه أو تعديله.")
            end
        end)

        -- إضافة تأثير زجاجي وحركات خفيفة
        applyGlassEffect(item)

        -- Hover animation
        item.MouseEnter:Connect(function()
            TweenService:Create(item, TweenInfo.new(0.18), {Size = UDim2.new(0, 246, 0, 226)}):Play()
        end)
        item.MouseLeave:Connect(function()
            TweenService:Create(item, TweenInfo.new(0.18), {Size = UDim2.new(0, 240, 0, 220)}):Play()
        end)
    end

    return folderFrame
end

-- ==========================
-- دالة إنشاء الواجهة الرئيسية (Main Interface) — محسّنة وفخمة
-- ==========================
local function createMainInterface(parentGui)
    ensureBlur()
    -- مشغّل صوت فتح
    playSound(parentGui, settings.openSound, 0.45)

    -- تفعيل البلور تدريجياً
    local startBlur = blurEffect and blurEffect.Size or 0
    TweenService:Create(blurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {Size = settings.blurMax}):Play()

    -- في حال وجود واجهة مسبقة نحذفها
    if parentGui:FindFirstChild("MainInterface") then
        parentGui.MainInterface:Destroy()
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainInterface"
    mainFrame.Size = UDim2.new(0, math.floor(500 * settings.uiScale), 0, math.floor(400 * settings.uiScale))
    mainFrame.Position = UDim2.new(0.5, -math.floor(250 * settings.uiScale), 0.5, -math.floor(200 * settings.uiScale))
    mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    mainFrame.BackgroundTransparency = settings.transparency
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.ZIndex = 9998
    mainFrame.Parent = parentGui

    -- Entrance animation
    mainFrame.Rotation = -7
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, math.floor(500 * settings.uiScale), 0, math.floor(400 * settings.uiScale)),
        Position = UDim2.new(0.5, -math.floor(250 * settings.uiScale), 0.5, -math.floor(200 * settings.uiScale)),
        Rotation = 0
    }):Play()

    local mainCorner = Instance.new("UICorner", mainFrame)
    mainCorner.CornerRadius = settings.cornerRadius

    -- خلفية صورة مع تدرج
    local bg = Instance.new("ImageLabel", mainFrame)
    bg.Name = "BackgroundImage"
    bg.Size = UDim2.new(1,0,1,0)
    bg.Position = UDim2.new(0,0,0,0)
    bg.BackgroundTransparency = 1
    bg.Image = settings.backgroundImage
    bg.ImageTransparency = 0.22
    bg.ScaleType = Enum.ScaleType.Crop

    local grad = Instance.new("UIGradient", bg)
    grad.Rotation = 45
    grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(6,6,6)), ColorSequenceKeypoint.new(1, Color3.fromRGB(30,30,30))})
    grad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 0.8)})

    -- عنوان
    local titleLabel = Instance.new("TextLabel", mainFrame)
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(0, 360, 0, 48)
    titleLabel.Position = UDim2.new(0.5, -180, 0, 18)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBlack
    titleLabel.Text = "قائمة السكربتات — Luna"
    titleLabel.TextSize = 24
    titleLabel.TextColor3 = settings.textColor
    titleLabel.ZIndex = mainFrame.ZIndex + 1

    -- شريط اللاعب (صورة واسم)
    local avatar = Instance.new("ImageLabel", mainFrame)
    avatar.Name = "Avatar"
    avatar.Size = UDim2.new(0, 56, 0, 56)
    avatar.Position = UDim2.new(0, 12, 0, 12)
    avatar.BackgroundTransparency = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    avatar.ZIndex = mainFrame.ZIndex + 1
    local avC = Instance.new("UICorner", avatar)
    avC.CornerRadius = UDim.new(0, 28)

    local playerNameLabel = Instance.new("TextLabel", mainFrame)
    playerNameLabel.Name = "PlayerNameLabel"
    playerNameLabel.Size = UDim2.new(0, 160, 0, 56)
    playerNameLabel.Position = UDim2.new(0, 76, 0, 12)
    playerNameLabel.BackgroundTransparency = 1
    playerNameLabel.Font = Enum.Font.GothamBold
    playerNameLabel.Text = LocalPlayer.DisplayName or LocalPlayer.Name
    playerNameLabel.TextSize = 18
    playerNameLabel.TextColor3 = settings.textColor
    playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left
    playerNameLabel.ZIndex = mainFrame.ZIndex + 1

    -- زر إغلاق
    local closeBtn = Instance.new("TextButton", mainFrame)
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -52, 0, 12)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BackgroundColor3 = settings.buttonColor
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "X"
    closeBtn.TextSize = 20
    closeBtn.TextColor3 = settings.textColor
    closeBtn.ZIndex = mainFrame.ZIndex + 1
    local closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(0, 8)

    closeBtn.MouseButton1Click:Connect(function()
        playSound(mainFrame, settings.buttonSound, 0.5)
        -- تقليل البلور وإغلاق
        TweenService:Create(blurEffect, TweenInfo.new(0.35), {Size = 0}):Play()
        TweenService:Create(mainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            Rotation = 8
        }):Play()
        delay(0.45, function()
            if mainFrame and mainFrame.Parent then mainFrame:Destroy() end
        end)
    end)

    -- مربع البحث
    local searchFrame = Instance.new("Frame", mainFrame)
    searchFrame.Size = UDim2.new(0, 360, 0, 36)
    searchFrame.Position = UDim2.new(0, 140, 0, 66)
    searchFrame.BackgroundTransparency = 0.35
    searchFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local sCorner = Instance.new("UICorner", searchFrame)
    sCorner.CornerRadius = UDim.new(0, 8)

    local searchBox = Instance.new("TextBox", searchFrame)
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -12, 1, 0)
    searchBox.Position = UDim2.new(0, 6, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "ابحث عن مجلد أو سكربت..."
    searchBox.Text = ""
    searchBox.TextSize = 16
    searchBox.TextColor3 = settings.textColor
    searchBox.TextXAlignment = Enum.TextXAlignment.Left

    -- إطار المجلدات
    local foldersFrame = Instance.new("ScrollingFrame", mainFrame)
    foldersFrame.Name = "FoldersFrame"
    foldersFrame.Size = UDim2.new(1, -60, 0, 240)
    foldersFrame.Position = UDim2.new(0, 30, 0, 116)
    foldersFrame.BackgroundTransparency = 1
    foldersFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    foldersFrame.ScrollBarThickness = 6

    local foldersGrid = Instance.new("UIGridLayout", foldersFrame)
    foldersGrid.CellSize = UDim2.new(0, 420, 0, 68)
    foldersGrid.CellPadding = UDim2.new(0, 12, 0, 12)

    foldersGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        foldersFrame.CanvasSize = UDim2.new(0, foldersGrid.AbsoluteContentSize.X, 0, foldersGrid.AbsoluteContentSize.Y)
    end)

    -- تعبئة المجلدات من externalFolders
    for _, folderData in ipairs(externalFolders) do
        local folderButton = Instance.new("TextButton", foldersFrame)
        folderButton.Name = folderData.folderName or "Folder"
        folderButton.Size = UDim2.new(0, 420, 0, 68)
        folderButton.BackgroundColor3 = Color3.fromRGB(8,8,8)
        folderButton.BackgroundTransparency = 0.2
        folderButton.Font = Enum.Font.Gotham
        folderButton.Text = ""
        folderButton.ZIndex = mainFrame.ZIndex + 1

        local fc = Instance.new("UICorner", folderButton)
        fc.CornerRadius = UDim.new(0, 12)

        -- تأثير زجاجي
        applyGlassEffect(folderButton)

        -- أيقونة المجلد
        local fIcon = Instance.new("ImageLabel", folderButton)
        fIcon.Size = UDim2.new(0, 56, 0, 56)
        fIcon.Position = UDim2.new(0, 8, 0, 6)
        fIcon.BackgroundTransparency = 1
        fIcon.Image = folderData.folderIcon or settings.folderIcon
        local fIconCorner = Instance.new("UICorner", fIcon)
        fIconCorner.CornerRadius = UDim.new(0, 12)

        -- اسم ووصف
        local nameLabel = Instance.new("TextLabel", folderButton)
        nameLabel.Size = UDim2.new(0, 280, 0, 28)
        nameLabel.Position = UDim2.new(0, 74, 0, 8)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.Text = folderData.folderName or "مجلد"
        nameLabel.TextColor3 = settings.textColor
        nameLabel.TextSize = 16
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left

        local descLabel = Instance.new("TextLabel", folderButton)
        descLabel.Size = UDim2.new(0, 280, 0, 28)
        descLabel.Position = UDim2.new(0, 74, 0, 34)
        descLabel.BackgroundTransparency = 1
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = folderData.folderDescription or ""
        descLabel.TextColor3 = Color3.fromRGB(180,180,180)
        descLabel.TextSize = 13
        descLabel.TextWrapped = true
        descLabel.TextXAlignment = Enum.TextXAlignment.Left

        -- عدّاد السكربتات
        local countLabel = Instance.new("TextLabel", folderButton)
        countLabel.Size = UDim2.new(0, 96, 0, 28)
        countLabel.Position = UDim2.new(1, -110, 0, 8)
        countLabel.BackgroundTransparency = 1
        countLabel.Font = Enum.Font.GothamBold
        countLabel.Text = "سكربتات: " .. tostring(#(folderData.scripts or {}))
        countLabel.TextColor3 = settings.textColor
        countLabel.TextSize = 14
        countLabel.TextXAlignment = Enum.TextXAlignment.Right

        if folderData.locked then
            -- أيقونة قفل ونص مغلق
            local lockIcon = Instance.new("ImageLabel", folderButton)
            lockIcon.Name = "LockIcon"
            lockIcon.Size = UDim2.new(0, 36, 0, 36)
            lockIcon.Position = UDim2.new(1, -54, 0, 16)
            lockIcon.BackgroundTransparency = 1
            lockIcon.Image = "rbxassetid://4224275681"

            local lockedText = Instance.new("TextLabel", folderButton)
            lockedText.Size = UDim2.new(0, 90, 0, 26)
            lockedText.Position = UDim2.new(1, -200, 0, 20)
            lockedText.BackgroundTransparency = 1
            lockedText.Font = Enum.Font.GothamBold
            lockedText.Text = "مغلق"
            lockedText.TextColor3 = Color3.fromRGB(210, 80, 80)
            lockedText.TextSize = 16
            lockedText.TextXAlignment = Enum.TextXAlignment.Left

            folderButton.MouseButton1Click:Connect(function()
                playSound(folderButton, settings.warningSound, 0.6)
                showNotification(parentGui, "هذا المجلد مغلق ولا يمكن فتحه.")
            end)
        else
            folderButton.MouseButton1Click:Connect(function()
                playSound(folderButton, settings.buttonSound, 0.5)
                createFolderInterface(parentGui, folderData)
            end)
        end
    end

    -- فلترة البحث
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local text = string.lower(searchBox.Text or "")
        for _, child in ipairs(foldersFrame:GetChildren()) do
            if child:IsA("TextButton") then
                local name = string.lower(child.Name or "")
                local found = false
                if string.find(name, text) or text == "" then found = true end
                child.Visible = found
            end
        end
    end)

    return mainFrame
end

-- ==========================
-- اختصارات وأزرار سريعة داخل Option Panel (Shortcuts مفيدة للألعاب)
-- ==========================
local function createOptionPanel(parentGui)
    if parentGui:FindFirstChild("LunaOptionPanel") then parentGui.LunaOptionPanel:Destroy() end

    local optionPanel = Instance.new("Frame", parentGui)
    optionPanel.Name = "LunaOptionPanel"
    optionPanel.Size = UDim2.new(0, 240, 0, 140)
    optionPanel.Position = UDim2.new(1, -280, 0.5, -70)
    optionPanel.BackgroundColor3 = settings.buttonColor
    optionPanel.BackgroundTransparency = 0.05
    optionPanel.BorderSizePixel = 0
    optionPanel.ZIndex = 9999

    local oc = Instance.new("UICorner", optionPanel)
    oc.CornerRadius = settings.cornerRadius

    local title = Instance.new("TextLabel", optionPanel)
    title.Size = UDim2.new(1, -20, 0, 36)
    title.Position = UDim2.new(0, 10, 0, 8)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "اختصارات اللعب"
    title.TextSize = 16
    title.TextColor3 = settings.textColor
    title.TextXAlignment = Enum.TextXAlignment.Left

    -- زر تبديل سرعة
    local speedBtn = Instance.new("TextButton", optionPanel)
    speedBtn.Size = UDim2.new(0, 200, 0, 36)
    speedBtn.Position = UDim2.new(0, 20, 0, 50)
    speedBtn.BackgroundColor3 = Color3.fromRGB(60, 140, 220)
    speedBtn.Font = Enum.Font.GothamBold
    speedBtn.Text = "تبديل سرعة (Normal)"
    speedBtn.TextSize = 14
    speedBtn.TextColor3 = settings.textColor
    local speedCorner = Instance.new("UICorner", speedBtn)
    speedCorner.CornerRadius = UDim.new(0,8)

    local speedEnabled = false
    local originalWalkSpeed = nil
    speedBtn.MouseButton1Click:Connect(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            showNotification(optionPanel, "غير قادر على الوصول للشخصية الآن")
            return
        end
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not originalWalkSpeed then originalWalkSpeed = humanoid.WalkSpeed end
        speedEnabled = not speedEnabled
        if speedEnabled then
            humanoid.WalkSpeed = 80
            speedBtn.Text = "إيقاف سرعة (FAST)"
            showNotification(optionPanel, "السرعة مفعّلة")
        else
            humanoid.WalkSpeed = originalWalkSpeed or 16
            speedBtn.Text = "تبديل سرعة (Normal)"
            showNotification(optionPanel, "السرعة مُعطّلة")
        end
    end)

    -- زر تبديل قفز
    local jumpBtn = Instance.new("TextButton", optionPanel)
    jumpBtn.Size = UDim2.new(0, 200, 0, 36)
    jumpBtn.Position = UDim2.new(0, 20, 0, 92)
    jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 120)
    jumpBtn.Font = Enum.Font.GothamBold
    jumpBtn.Text = "تبديل قفز مرتفع"
    jumpBtn.TextSize = 14
    jumpBtn.TextColor3 = settings.textColor
    local jumpCorner = Instance.new("UICorner", jumpBtn)
    jumpCorner.CornerRadius = UDim.new(0,8)

    local jumpEnabled = false
    local originalJumpPower = nil
    jumpBtn.MouseButton1Click:Connect(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            showNotification(optionPanel, "غير قادر على الوصول للشخصية الآن")
            return
        end
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not originalJumpPower then originalJumpPower = humanoid.JumpPower end
        jumpEnabled = not jumpEnabled
        if jumpEnabled then
            humanoid.JumpPower = 120
            jumpBtn.Text = "إيقاف قفز مرتفع"
            showNotification(optionPanel, "قفزة مرتفعة مفعّلة")
        else
            humanoid.JumpPower = originalJumpPower or 50
            jumpBtn.Text = "تبديل قفز مرتفع"
            showNotification(optionPanel, "قفزة مرتفعة معطّلة")
        end
    end)

    -- زر تليم (انتقال إلى مؤشر الفأرة)
    local tpBtn = Instance.new("TextButton", optionPanel)
    tpBtn.Size = UDim2.new(0, 200, 0, 34)
    tpBtn.Position = UDim2.new(0, 20, 0, 132)
    tpBtn.BackgroundColor3 = Color3.fromRGB(240, 160, 40)
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.Text = "تليم إلى الماوس"
    tpBtn.TextSize = 14
    tpBtn.TextColor3 = settings.textColor
    local tpCorner = Instance.new("UICorner", tpBtn)
    tpCorner.CornerRadius = UDim.new(0,8)

    tpBtn.MouseButton1Click:Connect(function()
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            showNotification(optionPanel, "لا توجد شخصية نشطة")
            return
        end
        local mouse = LocalPlayer:GetMouse()
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if mouse and mouse.Hit then
            hrp.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
            showNotification(optionPanel, "تم النقل إلى موقع الماوس")
        else
            showNotification(optionPanel, "لم أتمكن من الحصول على موقع الماوس")
        end
    end)

    return optionPanel
end

-- ==========================
-- دالة إنشاء القائمة الدائرية (قابلة للسحب) — Circular Menu
-- ==========================
local function createCircularMenu()
    if PlayerGui:FindFirstChild("LunaCircularMenu") then PlayerGui.LunaCircularMenu:Destroy() end

    local circularMenuGUI = Instance.new("ScreenGui")
    circularMenuGUI.Name = "LunaCircularMenu"
    circularMenuGUI.ResetOnSpawn = false
    circularMenuGUI.Parent = PlayerGui
    circularMenuGUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local circularButton = Instance.new("ImageButton", circularMenuGUI)
    circularButton.Name = "CircularButton"
    circularButton.Size = UDim2.new(0, 64, 0, 64)
    circularButton.Position = UDim2.new(1, -80, 0.5, -32)
    circularButton.BackgroundColor3 = settings.accentColor
    circularButton.Image = "rbxassetid://7059346373"
    circularButton.ImageColor3 = Color3.new(1,1,1)
    circularButton.BackgroundTransparency = 0.05
    circularButton.ZIndex = 9999

    local buttonCorner = Instance.new("UICorner", circularButton)
    buttonCorner.CornerRadius = UDim.new(0, 36)

    local stroke = Instance.new("UIStroke", circularButton)
    stroke.Color = Color3.new(1,1,1)
    stroke.Thickness = 2
    stroke.Transparency = 0.6

    -- السحب السلس
    local dragging = false
    local dragStart
    local startPos
    local dragInput

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
            circularButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    circularButton.MouseEnter:Connect(function()
        TweenService:Create(circularButton, TweenInfo.new(0.22), {Size = UDim2.new(0, 74, 0, 74)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.22), {Transparency = 0}):Play()
    end)

    circularButton.MouseLeave:Connect(function()
        TweenService:Create(circularButton, TweenInfo.new(0.22), {Size = UDim2.new(0, 64, 0, 64)}):Play()
        TweenService:Create(stroke, TweenInfo.new(0.22), {Transparency = 0.6}):Play()
    end)

    -- عند الضغط: نفتح الـ Option Panel أو MainInterface
    circularButton.MouseButton1Click:Connect(function()
        playSound(circularMenuGUI, settings.buttonSound, 0.5)
        if PlayerGui:FindFirstChild("MainInterface") then
            PlayerGui.MainInterface:Destroy()
            if blurEffect then TweenService:Create(blurEffect, TweenInfo.new(0.35), {Size = 0}):Play() end
        else
            createMainInterface(PlayerGui)
        end
        createOptionPanel(PlayerGui)
    end)

    return circularButton, circularMenuGUI
end

-- ==========================
-- دوال إضافة مجلدات
-- ==========================
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

-- إضافة مجلد كـ "مجلد كود" مخصّص — يدعم تعديل الكود داخلياً
function Luna:AddCodeFolder(folderData)
    if not folderData then return end
    folderData.isCodeFolder = true
    if not folderData.timestamp then folderData.timestamp = os.time() end
    folderData.locked = folderData.locked or false
    table.insert(externalFolders, folderData)
end

-- ==========================
-- دالة إظهار المكتبة (Show)
-- ==========================
function Luna:Show()
    createCircularMenu()
    createOptionPanel(PlayerGui)
    createMainInterface(PlayerGui)
end

-- ==========================
-- دالة إخفاء المكتبة (Hide) — مفيدة
-- ==========================
function Luna:Hide()
    if PlayerGui:FindFirstChild("MainInterface") then PlayerGui.MainInterface:Destroy() end
    if PlayerGui:FindFirstChild("LunaOptionPanel") then PlayerGui.LunaOptionPanel:Destroy() end
    if PlayerGui:FindFirstChild("LunaCircularMenu") then PlayerGui.LunaCircularMenu:Destroy() end
    if blurEffect then TweenService:Create(blurEffect, TweenInfo.new(0.25), {Size = 0}):Play() end
end

-- ==========================
-- اختصار لوحة مفاتيح لفتح/إغلاق الواجهة
-- ==========================
local isOpen = false
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == settings.openKey then
        if isOpen then
            Luna:Hide()
            isOpen = false
        else
            Luna:Show()
            isOpen = true
        end
    end
end)

-- ==========================
-- أمثلة جاهزة (تقدر تحذفها أو تعدّلها) — لإضافة بعض المجلدات التجريبية
-- ==========================
-- ملاحظة: استبدل الروابط/الأيقونات بمصادرك الحقيقية عند الاستخدام
if #externalFolders == 0 then
    -- مجلد عادي
    Luna:AddFolder({
        folderName = "أساسيات اللعب",
        folderDescription = "اختصارات ونِصائح وأدوات مفيدة داخل اللعبة.",
        folderIcon = "rbxassetid://1337133713",
        scripts = {
            { name = "تيمبلايت : Hello", description = "سكربت تجريبي يطبع رسالة", code = [[print("Hello from Luna Script!")]] },
            { name = "Auto Heal (مثال)", description = "مثال: شغّل وظائف داخل اللعبة", url = "https://raw.githubusercontent.com/username/repo/main/heal.lua" }
        }
    })

    -- مجلد كود قابل للتحرير
    Luna:AddCodeFolder({
        folderName = "مجلد الكود",
        folderDescription = "تقدر تفتح وتعدل السكربتات هنا مباشرة.",
        folderIcon = "rbxassetid://1337133713",
        scripts = {
            { name = "MyScript", description = "سكربت قابل للكتابة", code = [[-- ابدأ كتابة كودك هنا\nprint('Luna Editor')]] }
        }
    })

    -- مجلد مغلق
    Luna:AddLockedFolder({
        folderName = "مجلد محمي",
        folderDescription = "محتوى خاص (مغلق).",
        folderIcon = "rbxassetid://1337133713",
        scripts = {}
    })
end

-- ==========================
-- إرجاع الجدول (API)
-- ==========================
return Luna
