--=====================================================================
-- LocalScript (StarterPlayer > StarterPlayerScripts)
-- Tel Aviv Menu v2 - Optimisé & Amélioré
--=====================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    camera = workspace.CurrentCamera
end)
local mouse = player:GetMouse()

----------------------------------------------------------------------
-- CONFIG
----------------------------------------------------------------------
local Config = {
    Keys = {
        Fly = { Enum.KeyCode.F },
        Noclip = { Enum.KeyCode.N },
        Aimbot = { Enum.KeyCode.G },
        SilentAim = { Enum.KeyCode.I },
        Camlock = { Enum.KeyCode.C },
        RapidFire = { Enum.KeyCode.U },
        ESP = { Enum.KeyCode.H },
        FlySpeedDown = { Enum.KeyCode.LeftBracket },
        FlySpeedUp = { Enum.KeyCode.RightBracket },
        WalkSpeedDown = { Enum.KeyCode.Minus },
        WalkSpeedUp = { Enum.KeyCode.Equals },
        JumpPowerDown = { Enum.KeyCode.Semicolon },
        JumpPowerUp = { Enum.KeyCode.Quote },
        ToggleMenu = { Enum.KeyCode.Return, Enum.KeyCode.KeypadEnter, Enum.KeyCode.K, Enum.KeyCode.RightControl },
        FastMod = { Enum.KeyCode.J },
        AutoFire = { Enum.KeyCode.O },
        ClickTP = { Enum.KeyCode.Y },
        InfJump = { Enum.KeyCode.M },
        TPNext = { Enum.KeyCode.PageDown },
        TPPrev = { Enum.KeyCode.PageUp },
        SavePos = { Enum.KeyCode.Insert },
        LoadPos = { Enum.KeyCode.Delete },
        BTools = { Enum.KeyCode.B },
        BToolsMode = { Enum.KeyCode.V },
        BToolsUndo = { Enum.KeyCode.Z },
        Bring = { Enum.KeyCode.L },
        ViewNext = { Enum.KeyCode.End },
        ViewStop = { Enum.KeyCode.Home },
    },

    SpinBot = { Enabled = false, Speed = 20, Step = 2 },
    Orbit = { Enabled = false, Speed = 3, Step = 0.5, Radius = 10, Height = 2, Target = "" },

    Fly = {
        Enabled = false,
        Speed = 60,
        Step = 10,
        UpKey = Enum.KeyCode.Space,
        DownKey = Enum.KeyCode.LeftControl,
    },

    Noclip = { Enabled = false },

    Walk = {
        Enabled = false,
        Speed = 16,
        Step = 4,
    },

    Jump = {
        Enabled = false,
        Power = 50,
        Step = 10,
        Min = 0,
        Max = 500,
    },

    Swim = {
        Enabled = false,
        Speed = 60,
        Step = 10,
    },

    Aimbot = {
        Enabled = false,
        FOV = 250,
        Smoothness = 0.25,
        TargetPart = "Head",
        TeamCheck = true,
        WallCheck = true,
        Prediction = true,
        PredictionFactor = 0.12,
        MaxDistance = math.huge,
        HoldToAim = false,
        UseMouseLock = true, -- NOUVEAU : Vraie lock souris
    },

    Camlock = {
        Enabled = false,
        TargetPart = "Head",
        Smoothness = 1,
        Prediction = true,
        PredictionFactor = 0.12,
        WallCheck = false,
        TeamCheck = true,
        Sticky = true,
        FOV = 100000,
        MaxDistance = math.huge,
        UseMouseLock = true, -- NOUVEAU : Force souris
    },

    RapidFire = {
        Enabled = false,
        Rate = 30,
        Step = 10,
        HoldOnly = true,
        ForceEnabled = true,
        Deactivate = true,
        MaxPerFrame = 60,
        PropertyHack = true, -- NOUVEAU : Modifie les props directement
    },

    Wallbang = {
        Enabled = false,
        Universal = true,
    },

    SilentAim = {
        Enabled = false,
        FOV = 250,
        TargetPart = "Head",
        TeamCheck = true,
        WallCheck = true,
        Prediction = true,
        PredictionFactor = 0.12,
        MaxDistance = math.huge,
        HitChance = 100,
    },

    ESP = {
        Enabled = false,
        TeamCheck = false,
        ShowNames = true,
        ShowDistance = true,
        MaxDistance = math.huge,
        FillColor = Color3.fromRGB(255, 60, 60),
        OutlineColor = Color3.new(1, 1, 1),
        FillTransparency = 0.6,
        OutlineTransparency = 0,
    },

    FOVCircle = { Show = true, Color = Color3.new(1, 1, 1), Thickness = 1.5 },

    NextbotSpam = { Active = false, Speed = 20 },

    WalkFling = {
        Enabled = false,
        Power = 5000,
        Min = 100,
        Max = 50000,
        Step = 1000,
        Spin = true,
        HeavyBody = true,
        OnlyNearPlayers = true,
        TriggerRange = 7,
        SafeReturn = true,
        SafeReturnDistance = 300,
    },

    TP = {
        ClickTP = false,
        HoldKey = Enum.KeyCode.LeftShift,
        MoveVehicle = true,
        Height = 3,
    },

    InfJump = { Enabled = false },

    Bring = {
        Enabled = false,
        Mode = "Player",
        Target = "",
        Formation = "Line",
        Distance = 8,
        Spacing = 4,
        Height = 0,
        Smooth = true,
        SmoothSpeed = 0.35,
        FaceMe = true,
        SkipSeated = false,
        TeamCheck = false,
    },

    Menu = {
        Name = "telavivmenu",
        Title = "Tel Aviv Menu",
        Accent = Color3.fromRGB(226, 211, 125),
        Blur = false,
        BlurSize = 20,
        Dim = 0,
        Animations = true,
        AnimBorder = false,
        Width = 760,
        Height = 540,
        DefaultWidth = 760,
        DefaultHeight = 540,
        StartPosition = UDim2.new(0.5, 0, 0.5, 0),
    }
}

----------------------------------------------------------------------
-- Utilitaires
----------------------------------------------------------------------
local refreshers = {}
local function refreshUI()
    for _, f in ipairs(refreshers) do f() end
end

local Notify = function() end

local function keyIn(list, key)
    for _, k in ipairs(list) do
        if k == key then return true end
    end
    return false
end

local function getChar()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if hum and root then return char, hum, root end
end

----------------------------------------------------------------------
-- Système de Nextbots Local (Spam Nextbot)
----------------------------------------------------------------------
local spawnedNextbots = {}

local function spawnLocalNextbot()
    local _, _, root = getChar()
    if not root then return end

    local nextbot = Instance.new("Part")
    nextbot.Name = "LocalNextbot"
    nextbot.Size = Vector3.new(4, 5, 2)

    local angle = math.random() * math.pi * 2
    local distance = math.random(15, 30)
    nextbot.Position = root.Position + Vector3.new(math.cos(angle) * distance, 3, math.sin(angle) * distance)

    nextbot.CanCollide = false
    nextbot.Anchored = false
    nextbot.BrickColor = BrickColor.random()
    nextbot.Material = Enum.Material.Neon
    nextbot.Parent = workspace

    local connection
    connection = RunService.RenderStepped:Connect(function(dt)
        local _, _, currentRoot = getChar()
        if not nextbot.Parent or not currentRoot then
            nextbot:Destroy()
            connection:Disconnect()
            return
        end

        local direction = (currentRoot.Position - nextbot.Position)
        local distanceToPlayer = direction.Magnitude

        if distanceToPlayer > 2 then
            nextbot.AssemblyLinearVelocity = direction.Unit * Config.NextbotSpam.Speed
            nextbot.CFrame = CFrame.lookAt(nextbot.Position, currentRoot.Position)
        else
            nextbot:Destroy()
            connection:Disconnect()
        end
    end)

    table.insert(spawnedNextbots, nextbot)
    nextbot.Destroying:Connect(function()
        local i = table.find(spawnedNextbots, nextbot)
        if i then table.remove(spawnedNextbots, i) end
    end)
end

----------------------------------------------------------------------
-- Fast Mod (Cooldown / Cadence / Reload / Tir auto / Modules)
----------------------------------------------------------------------
local menuFrameRef = nil
local fastPatchAll, restoreFastMod, addFastKeyword
do
    local originals = setmetatable({}, { __mode = "k" })
    local watchConns = setmetatable({}, { __mode = "k" })
    local patchedModules = setmetatable({}, { __mode = "k" })
    local hookedTools = setmetatable({}, { __mode = "k" })

    local function nameMatches(name, list)
        local n = name:lower()
        for _, kw in ipairs(list) do
            if n:find(kw, 1, true) then return true end
        end
        return false
    end

    local function remember(obj, key, value)
        local t = originals[obj]
        if not t then t = {}; originals[obj] = t end
        if t[key] == nil then t[key] = value end
    end

    local function patchedNumber(name, val)
        local fm = Config.FastMod
        if nameMatches(name, fm.DelayKeywords) then
            if val > fm.Delay then return fm.Delay end
        elseif nameMatches(name, fm.RateKeywords) then
            if val < fm.RateValue then return fm.RateValue end
        end
        return nil
    end

    local function addConn(inst, key, conn)
        local c = watchConns[inst]
        if not c then c = {}; watchConns[inst] = c end
        c[key] = conn
    end

    local function hasConn(inst, key)
        local c = watchConns[inst]
        return c and c[key] ~= nil
    end

    local function patchValue(inst)
        local fm = Config.FastMod
        local nv = patchedNumber(inst.Name, inst.Value)
        if nv ~= nil then
            remember(inst, "Value", inst.Value)
            inst.Value = nv
        end
        if fm.Watch and not hasConn(inst, "Value")
            and (nameMatches(inst.Name, fm.DelayKeywords) or nameMatches(inst.Name, fm.RateKeywords)) then
            addConn(inst, "Value", inst:GetPropertyChangedSignal("Value"):Connect(function()
                if not Config.FastMod.Enabled then return end
                local fixed = patchedNumber(inst.Name, inst.Value)
                if fixed ~= nil then
                    remember(inst, "Value", inst.Value)
                    inst.Value = fixed
                end
            end))
        end
    end

    local function patchAttributes(inst)
        local fm = Config.FastMod
        for name, val in pairs(inst:GetAttributes()) do
            if type(val) == "number" then
                local nv = patchedNumber(name, val)
                if nv ~= nil then
                    remember(inst, "@" .. name, val)
                    inst:SetAttribute(name, nv)
                end
                local key = "@" .. name
                if fm.Watch and not hasConn(inst, key)
                    and (nameMatches(name, fm.DelayKeywords) or nameMatches(name, fm.RateKeywords)) then
                    addConn(inst, key, inst:GetAttributeChangedSignal(name):Connect(function()
                        if not Config.FastMod.Enabled then return end
                        local cur = inst:GetAttribute(name)
                        if type(cur) == "number" then
                            local fixed = patchedNumber(name, cur)
                            if fixed ~= nil then
                                remember(inst, key, cur)
                                inst:SetAttribute(name, fixed)
                            end
                        end
                    end))
                end
            end
        end
    end

    local function patchTable(tbl, depth)
        if depth > 3 then return end
        for k, v in pairs(tbl) do
            if type(k) == "string" then
                if type(v) == "number" then
                    local nv = patchedNumber(k, v)
                    if nv ~= nil then
                        remember(tbl, k, v)
                        pcall(function() tbl[k] = nv end)
                    end
                elseif type(v) == "table" then
                    patchTable(v, depth + 1)
                end
            end
        end
    end

    local function patchModule(mod)
        local cached = patchedModules[mod]
        if cached == false then return end
        if cached == nil then
            local ok, res = pcall(require, mod)
            if not ok or type(res) ~= "table" then
                patchedModules[mod] = false
                return
            end
            patchedModules[mod] = res
            cached = res
        end
        patchTable(cached, 0)
    end

    local function patchInstance(inst)
        if inst:IsA("NumberValue") or inst:IsA("IntValue") then
            patchValue(inst)
        end
        patchAttributes(inst)
        if Config.FastMod.PatchModules and inst:IsA("ModuleScript") then
            patchModule(inst)
        end
    end

    local function patchTool(tool)
        patchInstance(tool)
        for _, d in ipairs(tool:GetDescendants()) do
            patchInstance(d)
        end
    end

    local function hookTool(tool)
        if hookedTools[tool] then return end
        hookedTools[tool] = true
        tool.DescendantAdded:Connect(function(d)
            if Config.FastMod.Enabled then patchInstance(d) end
        end)
    end

    function fastPatchAll()
        local fm = Config.FastMod
        local char = player.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if tool then hookTool(tool); patchTool(tool) end
        if fm.PatchBackpack then
            local bp = player:FindFirstChildOfClass("Backpack")
            if bp then
                for _, t in ipairs(bp:GetChildren()) do
                    if t:IsA("Tool") then hookTool(t); patchTool(t) end
                end
            end
        end
    end

    function restoreFastMod()
        for _, conns in pairs(watchConns) do
            for _, c in pairs(conns) do c:Disconnect() end
        end
        table.clear(watchConns)

        for obj, saved in pairs(originals) do
            if type(obj) == "table" then
                for key, val in pairs(saved) do
                    pcall(function() obj[key] = val end)
                end
            elseif obj.Parent then
                for key, val in pairs(saved) do
                    if key == "Value" then
                        obj.Value = val
                    elseif key:sub(1, 1) == "@" then
                        obj:SetAttribute(key:sub(2), val)
                    end
                end
            end
        end
        table.clear(originals)
    end

    function addFastKeyword(list, text)
        text = (text or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
        if text == "" or table.find(list, text) then return false end
        table.insert(list, text)
        return true
    end

    local function boostAnimations(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        if not animator then return end
        local speed = Config.FastMod.AnimSpeed
        for _, tr in ipairs(animator:GetPlayingAnimationTracks()) do
            local p = tr.Priority
            if p ~= Enum.AnimationPriority.Core and p.Value >= Enum.AnimationPriority.Action.Value then
                if tr.Speed ~= speed then tr:AdjustSpeed(speed) end
            end
        end
    end

    local fastAccum = 0
    RunService.Heartbeat:Connect(function(dt)
        local fm = Config.FastMod
        if not fm.Enabled then return end
        local char = player.Character
        if not char then return end

        local tool = char:FindFirstChildOfClass("Tool")
        if tool and fm.ForceToolEnabled and not tool.Enabled then
            tool.Enabled = true
        end
        if tool and fm.AnimBoost then boostAnimations(char) end

        fastAccum += dt
        if fastAccum >= fm.RefreshInterval then
            fastAccum = 0
            fastPatchAll()
        end
    end)

    local autoTimer = 0
    RunService.Heartbeat:Connect(function(dt)
        local fm = Config.FastMod
        if not (fm.Enabled and fm.AutoFire) or Config.RapidFire.Enabled then autoTimer = 0; return end
        if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then autoTimer = 0; return end
        if UIS:GetFocusedTextBox() then return end

        if menuFrameRef and menuFrameRef.Visible then
            local m = UIS:GetMouseLocation()
            local p, sz = menuFrameRef.AbsolutePosition, menuFrameRef.AbsoluteSize
            if m.X >= p.X and m.X <= p.X + sz.X and m.Y >= p.Y and m.Y <= p.Y + sz.Y then return end
        end

        local char = player.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        if not tool then return end

        autoTimer += dt
        if autoTimer >= fm.AutoFireDelay then
            autoTimer = 0
            tool:Activate()
        end
    end)
end

----------------------------------------------------------------------
-- Ciblage, FOV, Aimbot & Silent Aim
----------------------------------------------------------------------
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local function mouseOverMenu()
    if not (menuFrameRef and menuFrameRef.Visible) then return false end
    local m = UIS:GetMouseLocation()
    local p, sz = menuFrameRef.AbsolutePosition, menuFrameRef.AbsoluteSize
    return m.X >= p.X and m.X <= p.X + sz.X and m.Y >= p.Y and m.Y <= p.Y + sz.Y
end

local function isVisible(part)
    if Config.Wallbang.Enabled then return true end
    local origin = camera.CFrame.Position
    local dir = part.Position - origin
    local ignore = { player.Character }
    for _ = 1, 8 do
        rayParams.FilterDescendantsInstances = ignore
        local res = workspace:Raycast(origin, dir, rayParams)
        if not res then return true end
        local inst = res.Instance
        if inst:IsDescendantOf(part.Parent) then return true end
        if inst.Transparency >= 0.95 or not inst.CanCollide then
            table.insert(ignore, inst)
        else
            return false
        end
    end
    return false
end

local function aimCenter(useMouse)
    if useMouse and UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
        return UIS:GetMouseLocation()
    end
    return camera.ViewportSize / 2
end

local function resolveAimPart(char, partName)
    partName = partName or "Head"
    local part
    if partName == "Torso" or partName == "UpperTorso" then
        part = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    else
        part = char:FindFirstChild(partName)
    end
    return part or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
end

local function getClosestTarget(s, partName, useMouse)
    local center = aimCenter(useMouse)
    local camPos = camera.CFrame.Position
    local bestScreen, bestWorld, bestPart, bestPlr, bestDist = nil, nil, nil, nil, s.FOV

    for _, other in ipairs(Players:GetPlayers()) do
        local char = other.Character
        if other == player or not char then continue end
        if s.TeamCheck and other.Team ~= nil and other.Team == player.Team then continue end

        local hum = char:FindFirstChildOfClass("Humanoid")
        local part = resolveAimPart(char, partName)
        if not hum or not part or hum.Health <= 0 then continue end
        if (part.Position - camPos).Magnitude > s.MaxDistance then continue end

        local pos3D = part.Position
        if s.Prediction then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                pos3D += root.AssemblyLinearVelocity * (s.PredictionFactor or 0.12)
            end
        end

        local sp, onScreen = camera:WorldToViewportPoint(pos3D)
        if not onScreen or sp.Z <= 0 then continue end

        local v = Vector2.new(sp.X, sp.Y)
        local d = (v - center).Magnitude
        if d < bestDist and (not s.WallCheck or isVisible(part)) then
            bestScreen, bestWorld, bestPart, bestPlr, bestDist = v, pos3D, part, other, d
        end
    end
    return bestScreen, bestWorld, bestPart, bestPlr
end

----------------------------------------------------------------------
-- Cercle FOV
----------------------------------------------------------------------
do
    local fovGui = Instance.new("ScreenGui")
    fovGui.Name = "telavivfov"
    fovGui.ResetOnSpawn = false
    fovGui.IgnoreGuiInset = true
    fovGui.DisplayOrder = 49
    fovGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local fovCircle = Instance.new("Frame")
    fovCircle.Name = "Circle"
    fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
    fovCircle.BackgroundTransparency = 1
    fovCircle.BorderSizePixel = 0
    fovCircle.Active = false
    fovCircle.Visible = false
    fovCircle.Parent = fovGui

    local fovCorner = Instance.new("UICorner")
    fovCorner.CornerRadius = UDim.new(1, 0)
    fovCorner.Parent = fovCircle

    local fovStroke = Instance.new("UIStroke")
    fovStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    fovStroke.Parent = fovCircle

    task.spawn(function()
        local pg = player:WaitForChild("PlayerGui")
        local oldFov = pg:FindFirstChild("telavivfov")
        if oldFov then oldFov:Destroy() end
        fovGui.Parent = pg
    end)

    RunService.RenderStepped:Connect(function()
        local a, s, fc = Config.Aimbot, Config.SilentAim, Config.FOVCircle
        local radius, useMouse
        if a.Enabled then
            radius, useMouse = a.FOV, false
        elseif s.Enabled then
            radius, useMouse = s.FOV, true
        end
        if not (fc.Show and radius and radius > 0) then
            fovCircle.Visible = false
            return
        end
        local c = aimCenter(useMouse)
        fovCircle.Position = UDim2.fromOffset(c.X, c.Y)
        fovCircle.Size = UDim2.fromOffset(radius * 2, radius * 2)
        fovStroke.Color = fc.Color
        fovStroke.Thickness = fc.Thickness
        fovCircle.Visible = true
    end)
end

----------------------------------------------------------------------
-- Silent Aim
----------------------------------------------------------------------
do
    local silentCache = { part = nil, pos = nil, plr = nil }
    local silentRoll, silentRollT = true, 0

    RunService.RenderStepped:Connect(function()
        local s = Config.SilentAim
        if not s.Enabled then
            silentCache.part, silentCache.pos, silentCache.plr = nil, nil, nil
            return
        end
        local now = os.clock()
        if now - silentRollT > 0.1 then
            silentRollT = now
            silentRoll = math.random(1, 100) <= s.HitChance
        end
        if not silentRoll then
            silentCache.part, silentCache.pos, silentCache.plr = nil, nil, nil
            return
        end
        local _, world, part, plr = getClosestTarget(s, s.TargetPart, true)
        silentCache.part, silentCache.pos, silentCache.plr = part, world, plr
    end)

    _G.DevTools = _G.DevTools or {}
    function _G.DevTools.GetAimPosition(defaultPos)
        return silentCache.pos or defaultPos
    end
    function _G.DevTools.GetAimTarget()
        return silentCache.part
    end
    function _G.DevTools.GetAimDirection(origin, defaultDir)
        local p = silentCache.pos
        if p and (p - origin).Magnitude > 0.01 then return (p - origin).Unit end
        return defaultDir
    end

    pcall(function()
        if typeof(hookmetamethod) ~= "function" or typeof(checkcaller) ~= "function" then return end
        local old
        local wrap = typeof(newcclosure) == "function" and newcclosure or function(f) return f end
        old = hookmetamethod(game, "__index", wrap(function(self, key)
            if self == mouse and silentCache.pos and not checkcaller() then
                if key == "Hit" then
                    return CFrame.new(silentCache.pos)
                elseif key == "Target" then
                    return silentCache.part
                end
            end
            return old(self, key)
        end))
    end)
end

----------------------------------------------------------------------
-- Noclip
----------------------------------------------------------------------
local savedCollide = {}

local function onCharacter(char)
    table.clear(savedCollide)
end
if player.Character then onCharacter(player.Character) end
player.CharacterAdded:Connect(onCharacter)

RunService.Stepped:Connect(function()
    local char = player.Character
    if not char then return end

    local want = Config.Noclip.Enabled and not Config.WalkFling.Enabled
    if want then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                if savedCollide[p] == nil then savedCollide[p] = p.CanCollide end
                p.CanCollide = false
            end
        end
    elseif next(savedCollide) then
        for p, v in pairs(savedCollide) do
            if p.Parent then p.CanCollide = v end
        end
        table.clear(savedCollide)
    end
end)

----------------------------------------------------------------------
-- Boucle principale : Fly, Walk, Jump, Swim
----------------------------------------------------------------------
local lastHum = nil
local origWalk = nil
local origJump = nil
local origSwim = nil

local terrain = workspace.Terrain
local waterT, waterCache = 0, false
local function inWater(root, hum)
    if hum:GetState() == Enum.HumanoidStateType.Swimming then return true end
    local now = os.clock()
    if now - waterT < 0.1 then return waterCache end
    waterT = now
    waterCache = false
    local pos = root.Position
    local region = Region3.new(pos - Vector3.new(2, 2, 2), pos + Vector3.new(2, 2, 2)):ExpandToGrid(4)
    local ok, materials, occupancy = pcall(function() return terrain:ReadVoxels(region, 4) end)
    if ok and materials then
        local size = materials.Size
        for x = 1, size.X do
            for y = 1, size.Y do
                for z = 1, size.Z do
                    if materials[x][y][z] == Enum.Material.Water and occupancy[x][y][z] > 0.5 then
                        waterCache = true
                    end
                end
            end
        end
    end
    return waterCache
end

RunService.RenderStepped:Connect(function()
    local _, hum, root = getChar()
    if not hum then return end

    local fly = Config.Fly

    if hum ~= lastHum then
        lastHum = hum
        origWalk, origJump, origSwim = nil, nil, nil
    end

    -- WalkSpeed
    local walk = Config.Walk
    if walk.Enabled and not fly.Enabled then
        if origWalk == nil then origWalk = hum.WalkSpeed end
        hum.WalkSpeed = walk.Speed
    elseif not walk.Enabled and origWalk ~= nil then
        hum.WalkSpeed = origWalk
        origWalk = nil
    end

    -- JumpPower
    local jump = Config.Jump
    if jump.Enabled then
        if origJump == nil then origJump = { hum.UseJumpPower, hum.JumpPower } end
        hum.UseJumpPower = true
        hum.JumpPower = jump.Power
    elseif origJump ~= nil then
        hum.UseJumpPower = origJump[1]
        hum.JumpPower = origJump[2]
        origJump = nil
    end

    -- Swim
    local swim = Config.Swim
    local swimming = swim.Enabled and not fly.Enabled and inWater(root, hum)
    if swimming then
        if origSwim == nil then origSwim = hum.WalkSpeed end
        hum.WalkSpeed = swim.Speed

        if not UIS:GetFocusedTextBox() then
            local cf = camera.CFrame
            local dir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
            if UIS:IsKeyDown(fly.UpKey) then dir += Vector3.yAxis end
            if UIS:IsKeyDown(fly.DownKey) then dir -= Vector3.yAxis end
            if dir.Magnitude > 0 then
                root.AssemblyLinearVelocity = dir.Unit * swim.Speed
            end
        end
    elseif origSwim ~= nil then
        hum.WalkSpeed = origSwim
        origSwim = nil
    end
end)

----------------------------------------------------------------------
-- Orbit & Spin Bot
----------------------------------------------------------------------
do
    local angle, target, nextPick = 0, nil, 0
    local function valid(p)
        local c = p and p.Parent and p.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        return h and h.Health > 0 and c:FindFirstChild("HumanoidRootPart") ~= nil
    end
    RunService.Heartbeat:Connect(function(dt)
        local o = Config.Orbit
        if not o.Enabled then target = nil return end
        local _, hum, root = getChar()
        if not (hum and root and hum.Health > 0) then return end
        if o.Target ~= "" then
            local q, found = o.Target:lower(), nil
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and (p.Name:lower():find(q, 1, true) or p.DisplayName:lower():find(q, 1, true)) then
                    found = p
                    break
                end
            end
            target = found
        elseif not valid(target) or os.clock() > nextPick then
            nextPick = os.clock() + 1
            local best, bd = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and valid(p) then
                    local d = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
                    if d < bd then best, bd = p, d end
                end
            end
            target = best
        end
        if not valid(target) then return end
        local tr = target.Character.HumanoidRootPart
        angle = (angle + o.Speed * dt) % (math.pi * 2)
        local pos = tr.Position + Vector3.new(math.cos(angle) * o.Radius, o.Height, math.sin(angle) * o.Radius)
        hum.AutoRotate = false
        root.CFrame = CFrame.lookAt(pos, tr.Position)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
end

do
    local spinning = false
    RunService.Heartbeat:Connect(function(dt)
        local _, hum, root = getChar()
        local on = Config.SpinBot.Enabled and not Config.Fly.Enabled and not Config.Orbit.Enabled and hum and root and hum.Health > 0
        if not on then
            if spinning then
                spinning = false
                if hum then hum.AutoRotate = true end
            end
            return
        end
        spinning = true
        hum.AutoRotate = false
        local rot = math.rad(360 * math.max(Config.SpinBot.Speed, 0)) * dt
        root.CFrame = root.CFrame * CFrame.Angles(0, rot, 0)
    end)
end

----------------------------------------------------------------------
-- Fly Classique
----------------------------------------------------------------------
do
    local bv, bg

    local function clear()
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
        local _, hum = getChar()
        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    RunService.RenderStepped:Connect(function()
        local fly = Config.Fly
        local _, hum, root = getChar()
        if not (fly.Enabled and hum and root and hum.Health > 0) then
            if bv or bg then clear() end
            return
        end

        if not bv or bv.Parent ~= root then
            if bv then bv:Destroy() end
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.zero
            bv.Parent = root
        end
        if not bg or bg.Parent ~= root then
            if bg then bg:Destroy() end
            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 9e4
            bg.D = 1e3
            bg.CFrame = camera.CFrame
            bg.Parent = root
        end

        hum.PlatformStand = true

        local dir = Vector3.zero
        local cf = camera.CFrame
        if not UIS:GetFocusedTextBox() then
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
            if UIS:IsKeyDown(fly.UpKey) then dir += Vector3.yAxis end
            if UIS:IsKeyDown(fly.DownKey) then dir -= Vector3.yAxis end
        end
        bv.Velocity = dir.Magnitude > 0 and dir.Unit * math.max(fly.Speed, 0) or Vector3.zero
        bg.CFrame = cf
    end)
end

----------------------------------------------------------------------
-- Aimbot & Camlock : Mouse Locking (Cursor Snapping)
----------------------------------------------------------------------
local lastTargetPart = nil
local lastTargetPos = Vector3.new(0,0,0)
local camlockTarget = nil

pcall(function() RunService:UnbindFromRenderStep("TelAvivMouseAim") end)
RunService:BindToRenderStep("TelAvivMouseAim", Enum.RenderPriority.Camera.Value + 10, function(dt)
    local a = Config.Aimbot
    local c = Config.Camlock
    
    local isAiming = a.Enabled or c.Enabled
    if not isAiming then return end
    if UIS:GetFocusedTextBox() then return end
    if mouseOverMenu() and not c.Sticky then return end

    local targetPart = nil
    local useAim = a.Enabled and (not a.HoldToAim or UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2))
    
    if useAim then
        _, _, targetPart, _ = getClosestTarget(a, a.TargetPart, false)
    elseif c.Enabled then
        if not c.Sticky or not camlockTarget then
            camlockTarget = camPick(c)
        end
        
        if camlockTarget then
            local part, char = camValid(camlockTarget, c)
            if part then
                targetPart = part
                lastTargetPos = part.Position
                if c.Prediction then
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    if root then
                        lastTargetPos = lastTargetPos + root.AssemblyLinearVelocity * c.PredictionFactor
                    end
                end
            end
        end
    else
        targetPart = nil
    end

    if targetPart and a.UseMouseLock then
        local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
        if onScreen then
            UIS:SetMouseLocation(screenPos.X, screenPos.Y)
        end
    end
end)

----------------------------------------------------------------------
-- Camlock Helper Functions
----------------------------------------------------------------------
local function camValid(plr, c)
    local char = plr and plr.Parent and plr.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local part = resolveAimPart(char, c.TargetPart)
    if not hum or not part or hum.Health <= 0 then return nil end
    return part, char
end

local function camPick(c)
    local viewport = camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
    local best, bestDist = nil, c.FOV
    for _, other in ipairs(Players:GetPlayers()) do
        if other == player then continue end
        if c.TeamCheck and other.Team ~= nil and other.Team == player.Team then continue end
        local part = camValid(other, c)
        if not part then continue end
        if (part.Position - camera.CFrame.Position).Magnitude > c.MaxDistance then continue end
        if c.WallCheck and not isVisible(part) then continue end
        local sp = camera:WorldToViewportPoint(part.Position)
        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
        if d < bestDist then best, bestDist = other, d end
    end
    return best
end

----------------------------------------------------------------------
-- Wallbang Universel
----------------------------------------------------------------------
do
    local enemyChars = {}
    local nextBuild = 0
    
    local function updateEnemyList()
        local now = os.clock()
        if now > nextBuild then
            nextBuild = now + 0.25
            enemyChars = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChildOfClass("Humanoid").Health > 0 then
                    table.insert(enemyChars, p.Character)
                end
            end
        end
        return enemyChars
    end

    pcall(function()
        local oldRaycast = workspace.Raycast
        local wrap = typeof(newcclosure) == "function" and newcclosure or function(f) return f end
        
        if typeof(hookfunction) == "function" then
            hookfunction(oldRaycast, function(workspaceObj, origin, direction, params)
                if not Config.Wallbang.Enabled or not Config.Wallbang.Universal then
                    return oldRaycast(workspaceObj, origin, direction, params)
                end
                
                local filterDescendants = {}
                for _, char in ipairs(updateEnemyList()) do
                    table.insert(filterDescendants, char)
                end
                
                local np = RaycastParams.new()
                np.FilterType = Enum.RaycastFilterType.Include
                np.FilterDescendantsInstances = filterDescendants
                np.IgnoreWater = true
                
                return oldRaycast(workspaceObj, origin, direction, np)
            end)
        elseif typeof(hookmetamethod) == "function" then
            local oldIndex
            local wrapped = wrap(function(self, key)
                if self == workspace and key == "Raycast" then
                    return function(origin, dir, rp)
                        if not Config.Wallbang.Enabled then
                            return oldIndex(self, key)(origin, dir, rp)
                        end
                        
                        local filter = updateEnemyList()
                        local np = RaycastParams.new()
                        np.FilterType = Enum.RaycastFilterType.Include
                        np.FilterDescendantsInstances = filter
                        np.IgnoreWater = true
                        
                        return oldIndex(self, key)(origin, dir, np)
                    end
                end
                return oldIndex(self, key)
            end)
            oldIndex = hookmetamethod(game, "__index", wrapped)
        end
    end)
end

----------------------------------------------------------------------
-- Rapid Fire Amélioré
----------------------------------------------------------------------
do
    local acc = 0
    local lastTool = nil
    local originalProps = {} 

    local function hackWeaponProperties(tool)
        if not tool then return end
        
        local propsToHack = {
            FireRate = 9999,
            Cooldown = 0.001,
            ReloadTime = 0.001,
            ThrowDelay = 0.001,
            Windup = 0.001,
            AttackSpeed = 9999,
            RateOfFire = 9999,
            Ammo = math.huge,
            Clipsize = math.huge,
            Automatic = true,
        }

        for prop, value in pairs(propsToHack) do
            if tool:FindFirstChild(prop) then
                local instance = tool:FindFirstChild(prop)
                if instance:IsA("NumberValue") or instance:IsA("IntValue") or instance:IsA("Attribute") then
                    if not originalProps[tool] then originalProps[tool] = {} end
                    if originalProps[tool][prop] == nil then
                        originalProps[tool][prop] = instance.Value
                    end
                    
                    instance.Value = value
                elseif type(instance) == "table" and instance[prop] then
                     if not originalProps[tool] then originalProps[tool] = {} end
                     if originalProps[tool][prop] == nil then
                         originalProps[tool][prop] = instance[prop]
                     end
                     instance[prop] = value
                end
            end
        end
        
        if Config.RapidFire.ForceEnabled and not tool.Enabled then
            tool.Enabled = true
        end
    end

    RunService.Heartbeat:Connect(function(dt)
        local r = Config.RapidFire
        if not r.Enabled then 
            acc = 0 
            if lastTool and originalProps[lastTool] then
                for prop, val in pairs(originalProps[lastTool]) do
                    local inst = lastTool:FindFirstChild(prop)
                    if inst and (inst:IsA("NumberValue") or inst:IsA("IntValue")) then
                        inst.Value = val
                    end
                end
            end
            return 
        end

        local char = player.Character
        local tool = char and char:FindFirstChildOfClass("Tool")
        
        if tool ~= lastTool then
            lastTool = tool
            originalProps[lastTool] = nil
        end

        if tool then
            if r.PropertyHack then
                hackWeaponProperties(tool)
            end

            if r.HoldOnly and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then 
                acc = 0 
                return 
            end
            
            if not UIS:GetFocusedTextBox() and not mouseOverMenu() then
                acc += dt
                local interval = 1 / r.Rate
                if acc >= interval then
                    acc = 0
                    if r.Deactivate then
                        tool:Deactivate()
                        task.wait()
                    end
                    tool:Activate()
                end
            end
        end
    end)
end

----------------------------------------------------------------------
-- Menu UI (Simplifié pour gagner des lignes)
----------------------------------------------------------------------
do
    local menuGui = Instance.new("ScreenGui")
    menuGui.Name = Config.Menu.Name
    menuGui.ResetOnSpawn = false
    menuGui.DisplayOrder = 50
    menuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.fromOffset(Config.Menu.Width, Config.Menu.Height)
    mainFrame.Position = Config.Menu.StartPosition
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = menuGui

    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = Config.Menu.Title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothemBold
    titleLabel.TextSize = 14
    titleLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 30, 1, 0)
    closeBtn.Position = UDim2.new(1, -30, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = 14
    closeBtn.Parent = titleBar
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)

    menuFrameRef = mainFrame

    -- Exemple de bouton toggle simple (à étendre selon besoin)
    local function createToggle(parent, name, configKey, color)
        local btn = Instance.new("TextButton")
        btn.Name = name
        btn.Size = UDim2.new(1, -10, 0, 25)
        btn.Position = UDim2.new(0, 5, 0, 35 + (#parent:GetChildren() * 30))
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = name .. ": Off"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.Parent = parent

        btn.MouseButton1Click:Connect(function()
            Config[configKey].Enabled = not Config[configKey].Enabled
            btn.Text = name .. ": " .. (Config[configKey].Enabled and "On" or "Off")
            btn.BackgroundColor3 = Config[configKey].Enabled and color or Color3.fromRGB(40, 40, 40)
        end)
        return btn
    end

    -- Créer quelques boutons exemples
    createToggle(mainFrame, "Fly", "Fly", Color3.fromRGB(0, 150, 255))
    createToggle(mainFrame, "Noclip", "Noclip", Color3.fromRGB(255, 255, 0))
    createToggle(mainFrame, "Aimbot", "Aimbot", Color3.fromRGB(0, 255, 0))
    createToggle(mainFrame, "Camlock", "Camlock", Color3.fromRGB(255, 0, 255))
    createToggle(mainFrame, "RapidFire", "RapidFire", Color3.fromRGB(255, 100, 0))
    createToggle(mainFrame, "Wallbang", "Wallbang", Color3.fromRGB(100, 100, 100))
    createToggle(mainFrame, "SilentAim", "SilentAim", Color3.fromRGB(0, 200, 200))
    createToggle(mainFrame, "ESP", "ESP", Color3.fromRGB(200, 200, 0))
    createToggle(mainFrame, "SpinBot", "SpinBot", Color3.fromRGB(150, 0, 150))
    createToggle(mainFrame, "WalkSpeed", "Walk", Color3.fromRGB(0, 100, 200))
    createToggle(mainFrame, "JumpPower", "Jump", Color3.fromRGB(200, 50, 50))

    menuGui.Parent = player:WaitForChild("PlayerGui")
end
