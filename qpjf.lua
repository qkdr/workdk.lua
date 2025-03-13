-- سكربت Lua أنيق للروبلكس مع واجهة شفافة وأزرار للسرعة والقفز

-- متغيرات عامة
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local screenGui = Instance.new("ScreenGui")
local mainFrame = nil
local speedSlider = nil
local jumpSlider = nil
local titleLabel = nil
local maxSpeed = 250
local maxJump = 250

-- تعيين الخصائص الأساسية للواجهة
screenGui.Name = "PremiumGUI"
screenGui.Parent = player.PlayerGui
screenGui.ResetOnSpawn = false

-- دالة لإنشاء تأثير الشاشة المخوشة
local function createBlurEffect()
    local blurFrame = Instance.new("Frame")
    blurFrame.Name = "BlurEffect"
    blurFrame.Size = UDim2.new(1, 0, 1, 0)
    blurFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    blurFrame.BackgroundTransparency = 0.5
    blurFrame.Parent = screenGui
    
    local icon = Instance.new("ImageLabel")
    icon.Name = "LoadingIcon"
    icon.Size = UDim2.new(0, 100, 0, 100)
    icon.Position = UDim2.new(0.5, -50, 0.5, -50)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://6031251532" -- أيقونة تحميل دائرية (يمكن تغييرها)
    icon.Parent = blurFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "ScriptName"
    nameLabel.Size = UDim2.new(0, 300, 0, 50)
    nameLabel.Position = UDim2.new(0.5, -150, 0.6, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 24
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Text = "PREMIUM SCRIPT"
    nameLabel.Parent = blurFrame
    
    -- إزالة الشاشة المخوشة بعد 5 ثوانٍ
    game:GetService("Debris"):AddItem(blurFrame, 5)
    
    return blurFrame
end

-- دالة لإنشاء الواجهة الرئيسية
local function createMainUI()
    -- الإطار الرئيسي
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false -- سيصبح مرئيًا بعد اختفاء شاشة التحميل
    mainFrame.Parent = screenGui
    
    -- تأثير الزاوية المستديرة
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = mainFrame
    
    -- عنوان الواجهة
    titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- لون ذهبي فخم
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = "PREMIUM CONTROLLER"
    titleLabel.Parent = mainFrame
    
    -- تأثير التظليل للعنوان
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 165, 0))
    })
    titleGradient.Parent = titleLabel
    
    -- إنشاء زر السرعة
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(0, 100, 0, 30)
    speedLabel.Position = UDim2.new(0.05, 0, 0.3, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 16
    speedLabel.Font = Enum.Font.GothamSemibold
    speedLabel.Text = "السرعة:"
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = mainFrame
    
    -- قيمة السرعة الحالية
    local speedValue = Instance.new("TextLabel")
    speedValue.Name = "SpeedValue"
    speedValue.Size = UDim2.new(0, 50, 0, 30)
    speedValue.Position = UDim2.new(0.9, 0, 0.3, 0)
    speedValue.BackgroundTransparency = 1
    speedValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedValue.TextSize = 16
    speedValue.Font = Enum.Font.GothamSemibold
    speedValue.Text = "100"
    speedValue.TextXAlignment = Enum.TextXAlignment.Right
    speedValue.Parent = mainFrame
    
    -- شريط تمرير السرعة
    local speedFrame = Instance.new("Frame")
    speedFrame.Name = "SpeedSliderFrame"
    speedFrame.Size = UDim2.new(0.8, 0, 0, 10)
    speedFrame.Position = UDim2.new(0.1, 0, 0.45, 0)
    speedFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedFrame.BorderSizePixel = 0
    speedFrame.Parent = mainFrame
    
    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 5)
    speedCorner.Parent = speedFrame
    
    speedSlider = Instance.new("TextButton")
    speedSlider.Name = "SpeedSlider"
    speedSlider.Size = UDim2.new(0, 20, 0, 20)
    speedSlider.Position = UDim2.new(0.5, -10, 0, -5)
    speedSlider.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    speedSlider.BorderSizePixel = 0
    speedSlider.Text = ""
    speedSlider.Parent = speedFrame
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = speedSlider
    
    -- إنشاء زر القفز
    local jumpLabel = Instance.new("TextLabel")
    jumpLabel.Name = "JumpLabel"
    jumpLabel.Size = UDim2.new(0, 100, 0, 30)
    jumpLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
    jumpLabel.BackgroundTransparency = 1
    jumpLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpLabel.TextSize = 16
    jumpLabel.Font = Enum.Font.GothamSemibold
    jumpLabel.Text = "ارتفاع القفز:"
    jumpLabel.TextXAlignment = Enum.TextXAlignment.Left
    jumpLabel.Parent = mainFrame
    
    -- قيمة القفز الحالية
    local jumpValue = Instance.new("TextLabel")
    jumpValue.Name = "JumpValue"
    jumpValue.Size = UDim2.new(0, 50, 0, 30)
    jumpValue.Position = UDim2.new(0.9, 0, 0.6, 0)
    jumpValue.BackgroundTransparency = 1
    jumpValue.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpValue.TextSize = 16
    jumpValue.Font = Enum.Font.GothamSemibold
    jumpValue.Text = "50"
    jumpValue.TextXAlignment = Enum.TextXAlignment.Right
    jumpValue.Parent = mainFrame
    
    -- شريط تمرير القفز
    local jumpFrame = Instance.new("Frame")
    jumpFrame.Name = "JumpSliderFrame"
    jumpFrame.Size = UDim2.new(0.8, 0, 0, 10)
    jumpFrame.Position = UDim2.new(0.1, 0, 0.75, 0)
    jumpFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    jumpFrame.BorderSizePixel = 0
    jumpFrame.Parent = mainFrame
    
    local jumpCorner = Instance.new("UICorner")
    jumpCorner.CornerRadius = UDim.new(0, 5)
    jumpCorner.Parent = jumpFrame
    
    jumpSlider = Instance.new("TextButton")
    jumpSlider.Name = "JumpSlider"
    jumpSlider.Size = UDim2.new(0, 20, 0, 20)
    jumpSlider.Position = UDim2.new(0.5, -10, 0, -5)
    jumpSlider.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    jumpSlider.BorderSizePixel = 0
    jumpSlider.Text = ""
    jumpSlider.Parent = jumpFrame
    
    local jumpSliderCorner = Instance.new("UICorner")
    jumpSliderCorner.CornerRadius = UDim.new(0, 10)
    jumpSliderCorner.Parent = jumpSlider
    
    -- وظائف الأزرار والمؤثرات
    local isDraggingSpeed = false
    local isDraggingJump = false
    
    -- تحريك شريط السرعة
    speedSlider.MouseButton1Down:Connect(function()
        isDraggingSpeed = true
    end)
    
    -- تحريك شريط القفز
    jumpSlider.MouseButton1Down:Connect(function()
        isDraggingJump = true
    end)
    
    -- متابعة تحريك الأزرار
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDraggingSpeed = false
            isDraggingJump = false
        end
    end)
    
    -- تطبيق التغييرات عند تحريك الأزرار
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if isDraggingSpeed then
                local mousePosition = game:GetService("UserInputService"):GetMouseLocation()
                local framePosition = speedFrame.AbsolutePosition
                local frameSize = speedFrame.AbsoluteSize
                
                local relativeX = math.clamp((mousePosition.X - framePosition.X) / frameSize.X, 0, 1)
                speedSlider.Position = UDim2.new(relativeX, -10, 0, -5)
                
                local newSpeed = math.floor(relativeX * maxSpeed)
                speedValue.Text = tostring(newSpeed)
                
                -- تطبيق السرعة الجديدة
                humanoid.WalkSpeed = newSpeed
            end
            
            if isDraggingJump then
                local mousePosition = game:GetService("UserInputService"):GetMouseLocation()
                local framePosition = jumpFrame.AbsolutePosition
                local frameSize = jumpFrame.AbsoluteSize
                
                local relativeX = math.clamp((mousePosition.X - framePosition.X) / frameSize.X, 0, 1)
                jumpSlider.Position = UDim2.new(relativeX, -10, 0, -5)
                
                local newJump = math.floor(relativeX * maxJump)
                jumpValue.Text = tostring(newJump)
                
                -- تطبيق قوة القفز الجديدة
                humanoid.JumpPower = newJump
            end
        end
    end)
    
    -- إمكانية سحب الواجهة
    local isDraggingUI = false
    local dragStartPosition = nil
    local startPos = nil
    
    titleLabel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDraggingUI = true
            dragStartPosition = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleLabel.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDraggingUI = false
        end
    end)
    
    titleLabel.InputChanged:Connect(function(input)
        if isDraggingUI and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStartPosition
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- تعيين القيم الافتراضية
    humanoid.WalkSpeed = 100
    humanoid.JumpPower = 50
end

-- تنفيذ الكود الرئيسي
local blurEffect = createBlurEffect()
createMainUI()

-- إظهار الواجهة الرئيسية بعد اختفاء تأثير البداية
game:GetService("TweenService"):Create(
    blurEffect, 
    TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 4), 
    {BackgroundTransparency = 1}
):Play()

-- جعل الواجهة الرئيسية مرئية بعد 5 ثوانٍ
game.Debris:AddItem(blurEffect, 5)
wait(5)
mainFrame.Visible = true

-- تأثير ظهور الواجهة
game:GetService("TweenService"):Create(
    mainFrame, 
    TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
    {Position = UDim2.new(0.5, -150, 0.2, 0)}
):Play()

-- تحديث المزامنة عند تغيير الشخصية
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    
    -- استعادة الإعدادات السابقة إذا كانت الواجهة موجودة
    if mainFrame and mainFrame.Parent then
        local speedValue = mainFrame.SpeedValue
        local jumpValue = mainFrame.JumpValue
        
        if speedValue then
            humanoid.WalkSpeed = tonumber(speedValue.Text) or 100
        end
        
        if jumpValue then
            humanoid.JumpPower = tonumber(jumpValue.Text) or 50
        end
    end
end)

-- رسالة نجاح التنفيذ
print("تم تفعيل البرنامج بنجاح!")
