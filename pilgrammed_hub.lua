local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local BLOCK_REMOTE = Remotes:WaitForChild("Block")
local ROLL_REMOTE = Remotes:WaitForChild("Roll")
local CLIENT_EFFECT = Remotes:WaitForChild("ClientEffect")

pcall(function()
    LocalPlayer.PlayerGui:FindFirstChild("PilgrammedHub"):Destroy()
end)

local PRIM = Color3.fromRGB(50, 50, 68)
local PRIM_DARK = Color3.fromRGB(30, 30, 42)
local ACCENT = Color3.fromRGB(130, 130, 255)
local ACCENT_HOVER = Color3.fromRGB(160, 160, 255)
local TXT = Color3.fromRGB(210, 210, 230)
local TXT_DIM = Color3.fromRGB(120, 120, 150)
local ON_C = ACCENT
local OFF_C = Color3.fromRGB(60, 60, 78)
local WHITE = Color3.fromRGB(230, 230, 240)

local toggles = {}

local function findTool(ability)
    local char = LocalPlayer.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and t:FindFirstChild(ability) then
                return t
            end
        end
    end
    return nil
end

local function equipTool(ability)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChildOfClass("Humanoid") then return nil end
    local tool = findTool(ability)
    if tool then return tool end
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and t:FindFirstChild(ability) then
                char.Humanoid:EquipTool(t)
                task.wait(0.2)
                return t
            end
        end
    end
    return nil
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "PilgrammedHub"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local holder = Instance.new("Frame")
holder.Size = UDim2.new(1, 0, 1, 0)
holder.BackgroundTransparency = 1
holder.Parent = Gui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 280, 0, 380)
Main.Position = UDim2.new(0.5, -140, 0.5, -190)
Main.BackgroundColor3 = PRIM_DARK
Main.BackgroundTransparency = 0.04
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = holder
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local bgGlow = Instance.new("ImageLabel")
bgGlow.Size = UDim2.new(1, 40, 1, 40)
bgGlow.Position = UDim2.new(0, -20, 0, -20)
bgGlow.BackgroundTransparency = 1
bgGlow.Image = "rbxassetid://7669168585"
bgGlow.ImageColor3 = ACCENT
bgGlow.ImageTransparency = 0.85
bgGlow.ScaleType = Enum.ScaleType.Slice
bgGlow.SliceCenter = Rect.new(40, 40, 120, 120)
bgGlow.Parent = Main
Instance.new("UICorner", bgGlow).CornerRadius = UDim.new(0, 16)

local shadow = Instance.new("ImageLabel")
shadow.Size = UDim2.new(1, 60, 1, 60)
shadow.Position = UDim2.new(0, -30, 0, -30)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://7669168585"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.6
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(40, 40, 120, 120)
shadow.ZIndex = -1
shadow.Parent = Main
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 18)

local dragging, dragStart, startPos
Main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = i.Position; startPos = Main.Position
    end
end)
Main.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            local d = i.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 34)
topBar.BackgroundColor3 = PRIM_DARK
topBar.BackgroundTransparency = 0.02
topBar.BorderSizePixel = 0
topBar.Parent = Main
local tc = Instance.new("UICorner", topBar)
tc.CornerRadius = UDim.new(0, 12)
local tfix = Instance.new("Frame")
tfix.Size = UDim2.new(1, 0, 0, 8)
tfix.Position = UDim2.new(0, 0, 1, -8)
tfix.BackgroundColor3 = PRIM_DARK
tfix.BackgroundTransparency = 0.02
tfix.BorderSizePixel = 0
tfix.Parent = topBar

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(1, -60, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Pilgrammed"
titleLbl.TextColor3 = WHITE
titleLbl.TextSize = 14
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = ""
closeBtn.BorderSizePixel = 0
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
closeBtn.MouseButton1Click:Connect(function() Gui.Enabled = false end)

local Body = Instance.new("Frame")
Body.Size = UDim2.new(1, 0, 1, -34)
Body.Position = UDim2.new(0, 0, 0, 34)
Body.BackgroundTransparency = 1
Body.Parent = Main

local tabRow = Instance.new("Frame")
tabRow.Size = UDim2.new(1, -12, 0, 28)
tabRow.Position = UDim2.new(0, 6, 0, 6)
tabRow.BackgroundTransparency = 1
tabRow.Parent = Body
local tabLayout = Instance.new("UIListLayout", tabRow)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 2)

local curTab = "Combat"
local tabBtns = {}
local tabPages = {}

for i, name in ipairs({"Combat", "Farm", "Teleport", "Misc"}) do
    local tb = Instance.new("TextButton")
    tb.Size = UDim2.new(0, 65, 0, 24)
    tb.BackgroundColor3 = (name == curTab) and ACCENT or Color3.fromRGB(40, 40, 55)
    tb.BackgroundTransparency = (name == curTab) and 0 or 0.3
    tb.Text = name
    tb.TextColor3 = (name == curTab) and WHITE or TXT_DIM
    tb.TextSize = 10
    tb.Font = Enum.Font.GothamSemibold
    tb.BorderSizePixel = 0
    tb.LayoutOrder = i
    tb.Parent = tabRow
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
    tb.MouseButton1Click:Connect(function()
        curTab = name
        for n, b in pairs(tabBtns) do
            b.BackgroundColor3 = (n == curTab) and ACCENT or Color3.fromRGB(40, 40, 55)
            b.BackgroundTransparency = (n == curTab) and 0 or 0.3
            b.TextColor3 = (n == curTab) and WHITE or TXT_DIM
        end
        for n, p in pairs(tabPages) do
            p.Visible = (n == curTab)
        end
    end)
    tabBtns[name] = tb

    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, -12, 1, -46)
    page.Position = UDim2.new(0, 6, 0, 40)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = ACCENT
    page.ScrollBarImageTransparency = 0.5
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = (name == curTab)
    page.Parent = Body
    local pl = Instance.new("UIListLayout", page)
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    pl.Padding = UDim.new(0, 4)
    local pp = Instance.new("UIPadding", page)
    pp.PaddingLeft = UDim.new(0, 0)
    pp.PaddingRight = UDim.new(0, 0)
    pp.PaddingTop = UDim.new(0, 2)
    tabPages[name] = page
end

local function sec(parent, text, order)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 18)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = ACCENT
    l.TextSize = 9
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = order
    l.Parent = parent
end

local function makeToggle(parent, text, order, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 30)
    f.BackgroundColor3 = PRIM
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, -46, 1, 0)
    lb.Position = UDim2.new(0, 10, 0, 0)
    lb.BackgroundTransparency = 1
    lb.Text = text
    lb.TextColor3 = TXT
    lb.TextSize = 11
    lb.Font = Enum.Font.Gotham
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.Parent = f

    local sw = Instance.new("TextButton")
    sw.Size = UDim2.new(0, 34, 0, 16)
    sw.Position = UDim2.new(1, -40, 0.5, -8)
    sw.BackgroundColor3 = OFF_C
    sw.Text = ""
    sw.BorderSizePixel = 0
    sw.Parent = f
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1, 0)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 2, 0.5, -6)
    dot.BackgroundColor3 = WHITE
    dot.BorderSizePixel = 0
    dot.Parent = sw
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

    local isOn = false
    sw.MouseButton1Click:Connect(function()
        isOn = not isOn
        toggles[text] = isOn
        sw.BackgroundColor3 = isOn and ON_C or OFF_C
        TweenService:Create(dot, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {
            Position = isOn and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
        }):Play()
        cb(isOn)
    end)
    return f
end

local function makeSlider(parent, text, mn, mx, def, order, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 38)
    f.BackgroundColor3 = PRIM
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0
    f.LayoutOrder = order
    f.Parent = parent
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
    local lb = Instance.new("TextLabel")
    lb.Size = UDim2.new(1, -12, 0, 16)
    lb.Position = UDim2.new(0, 8, 0, 2)
    lb.BackgroundTransparency = 1
    lb.Text = text .. ": " .. def
    lb.TextColor3 = TXT
    lb.TextSize = 10
    lb.Font = Enum.Font.Gotham
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.Parent = f
    local tk = Instance.new("Frame")
    tk.Size = UDim2.new(1, -16, 0, 4)
    tk.Position = UDim2.new(0, 8, 0, 24)
    tk.BackgroundColor3 = OFF_C
    tk.BorderSizePixel = 0
    tk.Parent = f
    Instance.new("UICorner", tk).CornerRadius = UDim.new(1, 0)
    local fl = Instance.new("Frame")
    fl.Size = UDim2.new((def - mn) / (mx - mn), 0, 1, 0)
    fl.BackgroundColor3 = ACCENT
    fl.BorderSizePixel = 0
    fl.Parent = tk
    Instance.new("UICorner", fl).CornerRadius = UDim.new(1, 0)
    local hit = Instance.new("TextButton")
    hit.Size = UDim2.new(1, 0, 0, 14)
    hit.Position = UDim2.new(0, 0, 0.5, -5)
    hit.BackgroundTransparency = 1
    hit.Text = ""
    hit.Parent = tk
    local dg = false
    hit.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dg = true end end)
    hit.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dg = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if dg and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local rx = math.clamp((i.Position.X - tk.AbsolutePosition.X) / tk.AbsoluteSize.X, 0, 1)
            fl.Size = UDim2.new(rx, 0, 1, 0)
            local v = math.floor(mn + (mx - mn) * rx)
            lb.Text = text .. ": " .. v
            cb(v)
        end
    end)
end

local function getMobList()
    local names = {}
    local seen = {}
    local mf = workspace:FindFirstChild("Mobs")
    if mf then
        for _, folder in ipairs(mf:GetChildren()) do
            if folder:IsA("Folder") then
                for _, mob in ipairs(folder:GetChildren()) do
                    if mob:IsA("Model") and mob:FindFirstChildOfClass("Humanoid") and not seen[mob.Name] then
                        seen[mob.Name] = true
                        table.insert(names, mob.Name)
                    end
                end
            end
        end
    end
    table.sort(names)
    return names
end

-- ========================
-- COMBAT TAB
-- ========================
local Combat = tabPages["Combat"]

sec(Combat, "DEFENSE", 1)

makeToggle(Combat, "Auto-Parry", 2, function(on)
    if on then
        spawn(function()
            local cd = false
            local function doBlock()
                if cd then return end
                if not toggles["Auto-Parry"] then return end
                cd = true
                BLOCK_REMOTE:FireServer(true)
                task.wait(0.2)
                BLOCK_REMOTE:FireServer(false)
                task.wait(0.35)
                cd = false
            end
            local conn
            conn = CLIENT_EFFECT.OnClientEvent:Connect(function(action, data)
                if not toggles["Auto-Parry"] then return end
                if action == "StartParry" then
                    doBlock()
                end
            end)
            while toggles["Auto-Parry"] do
                task.wait(0.1)
            end
            conn:Disconnect()
        end)
    end
end)

makeToggle(Combat, "Auto-Roll", 3, function(on)
    if on then
        spawn(function()
            while toggles["Auto-Roll"] do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local freeRoll = char:FindFirstChild("FreeRoll")
                    local cooldown = char:FindFirstChild("Cooldown")
                    local rollCD = cooldown and cooldown:GetAttribute("Roll")
                    if not freeRoll and (not rollCD or rollCD <= 0) then
                        ROLL_REMOTE:FireServer()
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end)

sec(Combat, "ATTACK", 10)

local attackOn = false
makeToggle(Combat, "Auto-Attack", 11, function(on)
    attackOn = on
    if on then
        spawn(function()
            while attackOn do
                if not toggles["Auto-Attack"] then break end
                local tool = equipTool("Slash")
                if tool then
                    tool.Slash:FireServer(1)
                end
                task.wait(0.35)
            end
        end)
    end
end)

local heavyOn = false
makeToggle(Combat, "Auto-Heavy", 12, function(on)
    heavyOn = on
    if on then
        spawn(function()
            while heavyOn do
                local tool = equipTool("Slash")
                if tool then
                    tool.Slash:FireServer(2)
                    task.wait(0.1)
                    tool.Slash:FireServer(4)
                end
                task.wait(1.2)
            end
        end)
    end
end)

makeToggle(Combat, "Gun Auto-Fire", 13, function(on)
    if on then
        spawn(function()
            while toggles["Gun Auto-Fire"] do
                local char = LocalPlayer.Character
                local tool = equipTool("Shoot")
                if tool and char and char:FindFirstChild("HumanoidRootPart") then
                    local camCF = workspace.CurrentCamera.CFrame
                    tool.Shoot:FireServer(camCF * CFrame.new(0, 0, -50), 1)
                end
                task.wait(0.3)
            end
        end)
    end
end)

-- ========================
-- FARM TAB
-- ========================
local Farm = tabPages["Farm"]

sec(Farm, "AUTO FARM", 1)

local farmFrame = Instance.new("Frame")
farmFrame.Size = UDim2.new(1, 0, 0, 50)
farmFrame.BackgroundColor3 = PRIM
farmFrame.BackgroundTransparency = 0.2
farmFrame.BorderSizePixel = 0
farmFrame.LayoutOrder = 2
farmFrame.Parent = Farm
Instance.new("UICorner", farmFrame).CornerRadius = UDim.new(0, 8)

local farmLabel = Instance.new("TextLabel")
farmLabel.Size = UDim2.new(1, -12, 0, 14)
farmLabel.Position = UDim2.new(0, 8, 0, 4)
farmLabel.BackgroundTransparency = 1
farmLabel.Text = "Target: None"
farmLabel.TextColor3 = TXT_DIM
farmLabel.TextSize = 9
farmLabel.Font = Enum.Font.Gotham
farmLabel.TextXAlignment = Enum.TextXAlignment.Left
farmLabel.Parent = farmFrame

local mobDropdown = Instance.new("TextButton")
mobDropdown.Size = UDim2.new(1, -16, 0, 22)
mobDropdown.Position = UDim2.new(0, 8, 0, 20)
mobDropdown.BackgroundColor3 = PRIM_DARK
mobDropdown.BackgroundTransparency = 0.1
mobDropdown.Text = "  Select Mob..."
mobDropdown.TextColor3 = TXT
mobDropdown.TextSize = 10
mobDropdown.Font = Enum.Font.Gotham
mobDropdown.BorderSizePixel = 0
mobDropdown.TextXAlignment = Enum.TextXAlignment.Left
mobDropdown.Parent = farmFrame
Instance.new("UICorner", mobDropdown).CornerRadius = UDim.new(0, 6)
local ddArrow = Instance.new("TextLabel")
ddArrow.Size = UDim2.new(0, 20, 1, 0)
ddArrow.Position = UDim2.new(1, -20, 0, 0)
ddArrow.BackgroundTransparency = 1
ddArrow.Text = "\u25BC"
ddArrow.TextColor3 = TXT_DIM
ddArrow.TextSize = 8
ddArrow.Font = Enum.Font.GothamBold
ddArrow.Parent = mobDropdown

local dropdownList = Instance.new("ScrollingFrame")
dropdownList.Size = UDim2.new(1, -16, 0, 130)
dropdownList.Position = UDim2.new(0, 8, 0, 44)
dropdownList.BackgroundColor3 = PRIM_DARK
dropdownList.BackgroundTransparency = 0.05
dropdownList.BorderSizePixel = 0
dropdownList.Visible = false
dropdownList.ZIndex = 100
dropdownList.ScrollBarThickness = 2
dropdownList.ScrollBarImageColor3 = ACCENT
dropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
dropdownList.Parent = farmFrame
Instance.new("UICorner", dropdownList).CornerRadius = UDim.new(0, 6)
local ddl = Instance.new("UIListLayout", dropdownList)
ddl.SortOrder = Enum.SortOrder.LayoutOrder
ddl.Padding = UDim.new(0, 1)
local ddp = Instance.new("UIPadding", dropdownList)
ddp.PaddingLeft = UDim.new(0, 2)
ddp.PaddingRight = UDim.new(0, 2)
ddp.PaddingTop = UDim.new(0, 2)

local farmTarget = ""
local farmActive = false
local ddOpen = false

local function populateDropdown()
    for _, c in ipairs(dropdownList:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local names = getMobList()
    for i, name in ipairs(names) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 20)
        b.BackgroundColor3 = PRIM
        b.BackgroundTransparency = 0.2
        b.Text = "  " .. name
        b.TextColor3 = TXT
        b.TextSize = 9
        b.Font = Enum.Font.Gotham
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.BorderSizePixel = 0
        b.LayoutOrder = i
        b.ZIndex = 101
        b.Parent = dropdownList
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
        b.MouseEnter:Connect(function() b.BackgroundColor3 = ACCENT b.BackgroundTransparency = 0.5 end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = PRIM b.BackgroundTransparency = 0.2 end)
        b.MouseButton1Click:Connect(function()
            farmTarget = name
            mobDropdown.Text = "  " .. name
            farmLabel.Text = "Target: " .. name
            dropdownList.Visible = false
            ddOpen = false
        end)
    end
end

mobDropdown.MouseButton1Click:Connect(function()
    ddOpen = not ddOpen
    dropdownList.Visible = ddOpen
    if ddOpen then populateDropdown() end
end)

UserInputService.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        if ddOpen then
            local gm = UserInputService:GetMouseLocation()
            local fp = farmFrame.AbsolutePosition
            local fs = farmFrame.AbsoluteSize
            local inFrame = gm.X >= fp.X and gm.X <= fp.X + fs.X and gm.Y >= fp.Y and gm.Y <= fp.Y + fs.Y
            if not inFrame then
                ddOpen = false
                dropdownList.Visible = false
            end
        end
    end
end)

local farmBtn = Instance.new("TextButton")
farmBtn.Size = UDim2.new(1, 0, 0, 24)
farmBtn.BackgroundColor3 = OFF_C
farmBtn.BackgroundTransparency = 0
farmBtn.Text = "Start Farm"
farmBtn.TextColor3 = TXT
farmBtn.TextSize = 10
farmBtn.Font = Enum.Font.GothamBold
farmBtn.BorderSizePixel = 0
farmBtn.LayoutOrder = 3
farmBtn.Parent = Farm
Instance.new("UICorner", farmBtn).CornerRadius = UDim.new(0, 8)

farmBtn.MouseButton1Click:Connect(function()
    if farmTarget == "" then return end
    farmActive = not farmActive
    farmBtn.BackgroundColor3 = farmActive and ACCENT or OFF_C
    farmBtn.Text = farmActive and "Stop Farm" or "Start Farm"
    if farmActive then
        spawn(function()
            while farmActive do
                if not toggles["Auto-Attack"] then
                    local char = LocalPlayer.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then
                        task.wait(1)
                        continue
                    end
                    if char.Humanoid.Health <= 0 then task.wait(3) continue end

                    local best = nil
                    local bestDist = math.huge
                    local mFolders = workspace:FindFirstChild("Mobs")
                    if mFolders then
                        for _, folder in ipairs(mFolders:GetChildren()) do
                            if folder:IsA("Folder") then
                                for _, mob in ipairs(folder:GetChildren()) do
                                    if mob.Name == farmTarget and mob:FindFirstChild("HumanoidRootPart") then
                                        local mhum = mob:FindFirstChildOfClass("Humanoid")
                                        if mhum and mhum.Health > 0 and mob.HumanoidRootPart.Position.Y < 10000 then
                                            local dist = (mob.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude
                                            if dist < bestDist then
                                                bestDist = dist
                                                best = mob
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end

                    if best and best:FindFirstChild("HumanoidRootPart") and best:FindFirstChildOfClass("Humanoid") and best.Humanoid.Health > 0 then
                        local targetCF = best.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3.5)
                        char.HumanoidRootPart.CFrame = targetCF
                        task.wait(0.05)
                        local tool = equipTool("Slash")
                        if tool then
                            tool.Slash:FireServer(1)
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end)

sec(Farm, "LOOT & EVENTS", 10)

makeToggle(Farm, "Auto-Loot Drops", 11, function(on)
    if on then
        spawn(function()
            while toggles["Auto-Loot Drops"] do
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local hrp = char.HumanoidRootPart
                    for _, obj in ipairs(workspace:GetChildren()) do
                        if obj:IsA("Tool") then
                            local handle = obj:FindFirstChild("Handle")
                            if handle and (handle.Position - hrp.Position).Magnitude < 80 then
                                pcall(function()
                                    firetouchinterest(hrp, handle, 0)
                                    firetouchinterest(hrp, handle, 1)
                                end)
                            end
                        end
                    end
                    local drops = workspace:FindFirstChild("Drops") or workspace:FindFirstChild("LootDrops") or workspace:FindFirstChild("Drop")
                    if drops then
                        for _, d in ipairs(drops:GetChildren()) do
                            local part = d:IsA("BasePart") and d or d:FindFirstChildWhichIsA("BasePart")
                            if part and (part.Position - hrp.Position).Magnitude < 80 then
                                pcall(function()
                                    firetouchinterest(hrp, part, 0)
                                    firetouchinterest(hrp, part, 1)
                                end)
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

makeToggle(Farm, "Auto Rift", 12, function(on)
    if on then
        spawn(function()
            while toggles["Auto Rift"] do
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then task.wait(1) continue end
                local hrp = char.HumanoidRootPart
                local best = nil
                local bd = math.huge
                for _, o in ipairs(workspace:GetChildren()) do
                    if o.Name:find("Rift") and o:IsA("BasePart") and o:FindFirstChildWhichIsA("ProximityPrompt") then
                        local prompt = o:FindFirstChildWhichIsA("ProximityPrompt")
                        if prompt.Enabled then
                            local d = (o.Position - hrp.Position).Magnitude
                            if d < bd then bd = d; best = o end
                        end
                    end
                end
                if best then
                    local prompt = best:FindFirstChildWhichIsA("ProximityPrompt")
                    hrp.CFrame = best.CFrame + Vector3.new(0, 3, 0)
                    task.wait(1.5)
                    fireproximityinterest(prompt)
                end
                task.wait(3)
            end
        end)
    end
end)

makeToggle(Farm, "Auto Pitfall", 13, function(on)
    if on then
        spawn(function()
            while toggles["Auto Pitfall"] do
                local char = LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then task.wait(1) continue end
                local hrp = char.HumanoidRootPart
                local mapFolder = workspace:FindFirstChild("Map")
                if mapFolder then
                    local pf = mapFolder:FindFirstChild("Pitfall")
                    if pf and pf:IsA("BasePart") and pf:FindFirstChildWhichIsA("ProximityPrompt") then
                        local prompt = pf:FindFirstChildWhichIsA("ProximityPrompt")
                        if prompt.Enabled then
                            hrp.CFrame = pf.CFrame + Vector3.new(0, 5, 0)
                            task.wait(1.5)
                            fireproximityinterest(prompt)
                        end
                    end
                end
                task.wait(3)
            end
        end)
    end
end)

-- ========================
-- TELEPORT TAB
-- ========================
local Teleport = tabPages["Teleport"]

sec(Teleport, "MOBS", 1)

local mobSearch = Instance.new("TextBox")
mobSearch.Size = UDim2.new(1, 0, 0, 22)
mobSearch.BackgroundColor3 = PRIM
mobSearch.BackgroundTransparency = 0.2
mobSearch.Text = ""
mobSearch.PlaceholderText = "Search mobs..."
mobSearch.PlaceholderColor3 = TXT_DIM
mobSearch.TextColor3 = TXT
mobSearch.TextSize = 10
mobSearch.Font = Enum.Font.Gotham
mobSearch.BorderSizePixel = 0
mobSearch.ClearTextOnFocus = false
mobSearch.LayoutOrder = 2
mobSearch.Parent = Teleport
Instance.new("UICorner", mobSearch).CornerRadius = UDim.new(0, 6)

local mobRefresh = Instance.new("TextButton")
mobRefresh.Size = UDim2.new(0, 50, 0, 22)
mobRefresh.Position = UDim2.new(1, -52, 0, 0)
mobRefresh.BackgroundColor3 = ACCENT
mobRefresh.BackgroundTransparency = 0.5
mobRefresh.Text = "Refresh"
mobRefresh.TextColor3 = WHITE
mobRefresh.TextSize = 9
mobRefresh.Font = Enum.Font.GothamBold
mobRefresh.BorderSizePixel = 0
mobRefresh.LayoutOrder = 3
mobRefresh.ZIndex = 2
mobRefresh.Parent = Teleport
Instance.new("UICorner", mobRefresh).CornerRadius = UDim.new(0, 6)

local mobList = Instance.new("ScrollingFrame")
mobList.Size = UDim2.new(1, 0, 0, 130)
mobList.BackgroundColor3 = PRIM_DARK
mobList.BackgroundTransparency = 0.15
mobList.BorderSizePixel = 0
mobList.ScrollBarThickness = 2
mobList.ScrollBarImageColor3 = ACCENT
mobList.ScrollBarImageTransparency = 0.5
mobList.AutomaticCanvasSize = Enum.AutomaticSize.Y
mobList.CanvasSize = UDim2.new(0, 0, 0, 0)
mobList.LayoutOrder = 4
mobList.Parent = Teleport
Instance.new("UICorner", mobList).CornerRadius = UDim.new(0, 8)
local mll = Instance.new("UIListLayout", mobList)
mll.SortOrder = Enum.SortOrder.LayoutOrder
mll.Padding = UDim.new(0, 1)
local mlp = Instance.new("UIPadding", mobList)
mlp.PaddingLeft = UDim.new(0, 2)
mlp.PaddingRight = UDim.new(0, 2)
mlp.PaddingTop = UDim.new(0, 2)

local mobBtns = {}
local function fillMobs(filter)
    for _, b in ipairs(mobBtns) do b:Destroy() end
    mobBtns = {}
    local mf = workspace:FindFirstChild("Mobs")
    if not mf then return end
    local order = 0
    for _, folder in ipairs(mf:GetChildren()) do
        if folder:IsA("Folder") then
            for _, mob in ipairs(folder:GetChildren()) do
                if mob:IsA("Model") and mob:FindFirstChild("HumanoidRootPart") then
                    local mhum = mob:FindFirstChildOfClass("Humanoid")
                    local alive = mhum and mhum.Health > 0
                    local active = mob.HumanoidRootPart.Position.Y < 10000
                    if active then
                        local nm = mob.Name .. " [" .. folder.Name .. "]"
                        if filter and filter ~= "" and not nm:lower():find(filter:lower()) then continue end
                        if order >= 80 then break end
                        local b = Instance.new("TextButton")
                        b.Size = UDim2.new(1, 0, 0, 21)
                        b.BackgroundColor3 = alive and PRIM or Color3.fromRGB(45, 30, 35)
                        b.BackgroundTransparency = 0.25
                        b.Text = "  " .. nm .. (alive and "" or " [DEAD]")
                        b.TextColor3 = alive and TXT or TXT_DIM
                        b.TextSize = 9
                        b.Font = Enum.Font.Gotham
                        b.TextXAlignment = Enum.TextXAlignment.Left
                        b.BorderSizePixel = 0
                        b.LayoutOrder = order
                        b.Parent = mobList
                        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
                        b.MouseEnter:Connect(function() b.BackgroundColor3 = ACCENT b.BackgroundTransparency = 0.6 end)
                        b.MouseLeave:Connect(function() b.BackgroundColor3 = alive and PRIM or Color3.fromRGB(45, 30, 35) b.BackgroundTransparency = 0.25 end)
                        b.MouseButton1Click:Connect(function()
                            local char = LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("HumanoidRootPart") and alive then
                                char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 3, 5)
                            end
                        end)
                        b.MouseButton2Click:Connect(function()
                            farmTarget = mob.Name
                            mobDropdown.Text = "  " .. mob.Name
                            farmLabel.Text = "Target: " .. mob.Name
                        end)
                        table.insert(mobBtns, b)
                        order = order + 1
                    end
                end
            end
        end
        if order >= 80 then break end
    end
end

mobSearch:GetPropertyChangedSignal("Text"):Connect(function() fillMobs(mobSearch.Text) end)
mobRefresh.MouseButton1Click:Connect(function() fillMobs(mobSearch.Text) end)

sec(Teleport, "NPCs", 10)

local npcSearch = Instance.new("TextBox")
npcSearch.Size = UDim2.new(1, 0, 0, 22)
npcSearch.BackgroundColor3 = PRIM
npcSearch.BackgroundTransparency = 0.2
npcSearch.Text = ""
npcSearch.PlaceholderText = "Search NPCs..."
npcSearch.PlaceholderColor3 = TXT_DIM
npcSearch.TextColor3 = TXT
npcSearch.TextSize = 10
npcSearch.Font = Enum.Font.Gotham
npcSearch.BorderSizePixel = 0
npcSearch.ClearTextOnFocus = false
npcSearch.LayoutOrder = 11
npcSearch.Parent = Teleport
Instance.new("UICorner", npcSearch).CornerRadius = UDim.new(0, 6)

local npcRefresh = Instance.new("TextButton")
npcRefresh.Size = UDim2.new(0, 50, 0, 22)
npcRefresh.Position = UDim2.new(1, -52, 0, 0)
npcRefresh.BackgroundColor3 = ACCENT
npcRefresh.BackgroundTransparency = 0.5
npcRefresh.Text = "Refresh"
npcRefresh.TextColor3 = WHITE
npcRefresh.TextSize = 9
npcRefresh.Font = Enum.Font.GothamBold
npcRefresh.BorderSizePixel = 0
npcRefresh.LayoutOrder = 12
npcRefresh.ZIndex = 2
npcRefresh.Parent = Teleport
Instance.new("UICorner", npcRefresh).CornerRadius = UDim.new(0, 6)

local npcList = Instance.new("ScrollingFrame")
npcList.Size = UDim2.new(1, 0, 0, 120)
npcList.BackgroundColor3 = PRIM_DARK
npcList.BackgroundTransparency = 0.15
npcList.BorderSizePixel = 0
npcList.ScrollBarThickness = 2
npcList.ScrollBarImageColor3 = ACCENT
npcList.ScrollBarImageTransparency = 0.5
npcList.AutomaticCanvasSize = Enum.AutomaticSize.Y
npcList.CanvasSize = UDim2.new(0, 0, 0, 0)
npcList.LayoutOrder = 13
npcList.Parent = Teleport
Instance.new("UICorner", npcList).CornerRadius = UDim.new(0, 8)
Instance.new("UIListLayout", npcList).SortOrder = Enum.SortOrder.LayoutOrder
local nlp = Instance.new("UIPadding", npcList)
nlp.PaddingLeft = UDim.new(0, 2)
nlp.PaddingRight = UDim.new(0, 2)
nlp.PaddingTop = UDim.new(0, 2)

local npcBtns = {}
local function fillNPCs(filter)
    for _, b in ipairs(npcBtns) do b:Destroy() end
    npcBtns = {}
    local nf = workspace:FindFirstChild("NPCs")
    if not nf then return end
    local order = 0
    for _, npc in ipairs(nf:GetChildren()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and npc.HumanoidRootPart.Position.Y < 10000 then
            if filter and filter ~= "" and not npc.Name:lower():find(filter:lower()) then continue end
            if order >= 80 then break end
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 0, 21)
            b.BackgroundColor3 = PRIM
            b.BackgroundTransparency = 0.25
            b.Text = "  " .. npc.Name
            b.TextColor3 = TXT
            b.TextSize = 9
            b.Font = Enum.Font.Gotham
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.BorderSizePixel = 0
            b.LayoutOrder = order
            b.Parent = npcList
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            b.MouseEnter:Connect(function() b.BackgroundColor3 = ACCENT b.BackgroundTransparency = 0.6 end)
            b.MouseLeave:Connect(function() b.BackgroundColor3 = PRIM b.BackgroundTransparency = 0.25 end)
            b.MouseButton1Click:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame * CFrame.new(0, 3, 5)
                end
            end)
            table.insert(npcBtns, b)
            order = order + 1
        end
    end
end

npcSearch:GetPropertyChangedSignal("Text"):Connect(function() fillNPCs(npcSearch.Text) end)
npcRefresh.MouseButton1Click:Connect(function() fillNPCs(npcSearch.Text) end)

-- ========================
-- MISC TAB
-- ========================
local Misc = tabPages["Misc"]

sec(Misc, "MOVEMENT", 1)

local walkSpeedVal = 16
local jumpPowerVal = 50

makeSlider(Misc, "Walk Speed", 16, 200, 16, 2, function(v)
    walkSpeedVal = v
end)

makeSlider(Misc, "Jump Power", 50, 300, 50, 3, function(v)
    jumpPowerVal = v
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then
            if walkSpeedVal > 16 then
                h.WalkSpeed = walkSpeedVal
            end
            if jumpPowerVal > 50 then
                h.JumpPower = jumpPowerVal
            end
        end
    end
end)

sec(Misc, "TWEAKS", 10)

makeToggle(Misc, "No Fall Damage", 11, function(on)
    if on then
        spawn(function()
            while toggles["No Fall Damage"] do
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        local stateVal = hum:FindFirstChild("State")
                        if stateVal then pcall(function() stateVal:Destroy() end) end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

makeToggle(Misc, "Infinite Stamina", 12, function(on)
    if on then
        spawn(function()
            while toggles["Infinite Stamina"] do
                local char = LocalPlayer.Character
                if char then
                    local st = char:FindFirstChild("Stamina")
                    if st and st:IsA("NumberValue") then st.Value = 100 end
                    local bs = char:FindFirstChild("BatteryStamina")
                    if bs and bs:IsA("NumberValue") then bs.Value = 100 end
                end
                task.wait(0.1)
            end
        end)
    end
end)

makeToggle(Misc, "Anti-Ragdoll", 13, function(on)
    if on then
        spawn(function()
            while toggles["Anti-Ragdoll"] do
                local char = LocalPlayer.Character
                if char then
                    for _, v in ipairs(char:GetDescendants()) do
                        if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint") or v.Name == "Ragdoll" then
                            pcall(function() v:Destroy() end)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

makeToggle(Misc, "Auto-Heal", 14, function(on)
    if on then
        spawn(function()
            while toggles["Auto-Heal"] do
                local char = LocalPlayer.Character
                if char then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health < hum.MaxHealth * 0.5 then
                        local bp = LocalPlayer.Backpack
                        if bp then
                            for _, tool in ipairs(bp:GetChildren()) do
                                if tool:IsA("Tool") then
                                    local n = tool.Name:lower()
                                    if n:find("berry") or n:find("potion") or n:find("salmon") or n:find("bread") or n:find("stew") or n:find("meat") or n:find("fish") then
                                        hum:EquipTool(tool)
                                        task.wait(0.3)
                                        tool:Activate()
                                        task.wait(0.5)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

makeToggle(Misc, "Noclip", 15, function(on)
    if on then
        spawn(function()
            while toggles["Noclip"] do
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then
                            p.CanCollide = false
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0, 28, 0, 28)
OpenBtn.Position = UDim2.new(0, 6, 0.5, -14)
OpenBtn.BackgroundColor3 = PRIM_DARK
OpenBtn.BackgroundTransparency = 0.1
OpenBtn.Text = "P"
OpenBtn.TextColor3 = ACCENT
OpenBtn.TextSize = 12
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.BorderSizePixel = 0
OpenBtn.Parent = Gui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
local obs = Instance.new("UIStroke", OpenBtn)
obs.Color = ACCENT
obs.Thickness = 0.5
obs.Transparency = 0.5
OpenBtn.MouseButton1Click:Connect(function() Gui.Enabled = not Gui.Enabled end)

spawn(function()
    task.wait(3)
    fillMobs("")
    fillNPCs("")
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
end)
