local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- إنشاء الواجهة
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- زر فتح القائمة
local openButton = Instance.new("TextButton")
openButton.Name = "OpenMenuButton"
openButton.Size = UDim2.new(0, 100, 0, 40)
openButton.Position = UDim2.new(0, 10, 0, 10)
openButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Text = "فتح القائمة"
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 18
openButton.Parent = screenGui

-- الإطار الرئيسي
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 480)
frame.Position = UDim2.new(0.5, -150, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Visible = true
frame.Parent = screenGui

-- زر إغلاق القائمة
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Text = "X"
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = frame

closeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

openButton.MouseButton1Click:Connect(function()
	frame.Visible = true
end)

-- قائمة أسماء الأزرار (تعديلها هنا)
local buttonNames = {
	"إبينيفيرن",
	"Anti Seizure Meds",
	"‎ديكستروز",
	"‎أدوية الحمى",
	"‎هدرالازين",
	"‎أنسولين",
	"‎ميدودرين",
	"‎أدوية مضادة للغثيان",
	"‎مسكنات الألم",
	"‎مضاد الحيوية",
	"‎جهاز استنشاق"‘
  "‎هيبارين",
  "‎نالوكسون",
  "‎لاسيكس",
  "‎منع البيتا."
}

-- وظيفة عند الضغط على زر
local function onButtonClicked(index)
	print("تم الضغط على الزر: " .. buttonNames[index])

	-- ضع الأكواد الخاصة بكل زر هنا حسب الرقم
	if index == 1 then
		local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("epinephrine", 9e9):FireServer(unpack(args))

	elseif index == 2 then
		local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("ativan", 9e9):FireServer(unpack(args)) 
	elseif index == 3 then
		local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("dextrose", 9e9):FireServer(unpack(args))
  elseif index == 4 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("fevermeds", 9e9):FireServer(unpack(args))
    elseif index == 5 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("hydralazine", 9e9):FireServer(unpack(args)) 
    elseif index == 6 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("insulin", 9e9):FireServer(unpack(args))
    elseif index == 7 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("midodrine", 9e9):FireServer(unpack(args))
    elseif index == 8 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("nausea", 9e9):FireServer(unpack(args))
    elseif index == 9 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("painmeds", 9e9):FireServer(unpack(args))
    elseif index == 10 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("antibiotics", 9e9):FireServer(unpack(args))
    elseif index == 11 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("inhaler", 9e9):FireServer(unpack(args))
    elseif index == 12 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("heparin", 9e9):FireServer(unpack(args))
    elseif index == 13 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("naloxone", 9e9):FireServer(unpack(args))
    elseif index == 14 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("lasix", 9e9):FireServer(unpack(args))
    elseif index == 15 then
    local args = {}

game:GetService("ReplicatedStorage"):WaitForChild("Crumb", 9e9):WaitForChild("betablockers", 9e9):FireServer(unpack(args))
	end
	-- تابع بنفس النمط لبقية الأزرار
end

-- إنشاء الأزرار داخل القائمة
for i = 1, #buttonNames do
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.9, 0, 0, 30)
	button.Position = UDim2.new(0.05, 0, 0, (i - 1) * 35 + 40)
	button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Text = buttonNames[i]
	button.Font = Enum.Font.SourceSans
	button.TextSize = 18
	button.Parent = frame

	button.MouseButton1Click:Connect(function()
		onButtonClicked(i)
	end)
end
