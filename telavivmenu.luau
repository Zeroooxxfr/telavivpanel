--=====================================================================
-- LocalScript (StarterPlayer > StarterPlayerScripts)
-- Menu : ScreenGui "telavivmenu"
-- Version 4 : UI pro + BTools complets (type F3X) + Walk Fling + aucune limite (1 fichier .luau)
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
		Fly           = { Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt },
		Noclip        = { Enum.KeyCode.N },
		Aimbot        = { Enum.KeyCode.G },
		SilentAim     = { Enum.KeyCode.K },
		ESP           = { Enum.KeyCode.H },
		FlySpeedDown  = { Enum.KeyCode.LeftBracket },
		FlySpeedUp    = { Enum.KeyCode.RightBracket },
		WalkSpeedDown = { Enum.KeyCode.Minus },
		WalkSpeedUp   = { Enum.KeyCode.Equals },
		WalkFling     = { Enum.KeyCode.T },
		FlingPowerDown = { Enum.KeyCode.Comma },
		FlingPowerUp   = { Enum.KeyCode.Period },
		JumpPowerDown  = { Enum.KeyCode.Semicolon },
		JumpPowerUp    = { Enum.KeyCode.Quote },
		ToggleMenu     = { Enum.KeyCode.RightControl },
		FastMod        = { Enum.KeyCode.J },
		AutoFire       = { Enum.KeyCode.U },
		ClickTP        = { Enum.KeyCode.Y },
		InfJump        = { Enum.KeyCode.M },
		TPNext         = { Enum.KeyCode.PageDown },
		TPPrev         = { Enum.KeyCode.PageUp },
		SavePos        = { Enum.KeyCode.Insert },
		LoadPos        = { Enum.KeyCode.Delete },
		BTools         = { Enum.KeyCode.B },
		BToolsMode     = { Enum.KeyCode.V },
		BToolsUndo     = { Enum.KeyCode.Z }, -- avec Ctrl
		Bring          = { Enum.KeyCode.L },
		ViewNext       = { Enum.KeyCode.End },
		ViewStop       = { Enum.KeyCode.Home },
	},

	Fly = {
		Enabled = false,
		Speed = 60,
		Step = 10,
		Noclip = true,
		Invisible = true,
		VehicleMode = true, -- assis dans un véhicule : le véhicule vole (sinon tu es éjecté du siège et tu voles)
		UpKey = Enum.KeyCode.Space,
		DownKey = Enum.KeyCode.LeftControl,
	},

	Noclip = {
		Enabled = false,
	},

	Walk = {
		Enabled = false, -- false = on ne touche pas au WalkSpeed du jeu
		Speed = 16,
		Step = 4,
	},

	Kills = {
		Enabled = true,   -- notification quand tu tues quelqu'un avec le fling
		Window = 6,       -- secondes max entre le contact du fling et la mort
	},

	View = {
		Enabled = false,
		Target = "",
	},

	Notify = {
		Toggles = true,   -- notification à chaque activation / désactivation d'un bouton
	},

	Bring = {
		Enabled = false,
		Mode = "Player",     -- Player (un joueur) / All (tous)
		Target = "",         -- nom du joueur ciblé
		Formation = "Line",  -- Line (en ligne devant) / Circle (cercle autour) / Behind (derrière) / Stack (empilés)
		Distance = 8,        -- distance (studs, aucune limite)
		Spacing = 4,         -- écart entre les joueurs (studs)
		Height = 0,
		Smooth = true,       -- déplacement fluide au lieu d'une téléportation sèche
		SmoothSpeed = 0.35,  -- 0.01 = très lent, 1 = instantané
		FaceMe = true,       -- les joueurs te regardent
		SkipSeated = false,  -- ignore les joueurs assis
		TeamCheck = false,   -- ignore ton équipe en mode All
	},

	Swim = {
		Enabled = false, -- false = on ne touche pas à la nage du jeu
		Speed = 60,      -- vitesse de nage (aucune limite)
		Step = 10,
	},

	Jump = {
		Enabled = false, -- false = on ne touche pas au saut du jeu
		Power = 50,   -- valeur par défaut de Roblox
		Step = 10,
		Min = 0,
		Max = 500,    -- max du SLIDER seulement (la case texte et les touches n'ont aucune limite)
	},

	FastMod = {
		Enabled = true,
		Delay = 0.01,              -- valeur max des délais/cooldowns/reload (secondes)
		RateValue = 100,           -- valeur min des valeurs "plus haut = plus rapide"
		ForceToolEnabled = true,   -- annule les cooldowns faits avec Tool.Enabled = false
		PatchBackpack = true,      -- applique aussi aux armes dans le sac
		RefreshInterval = 0.25,    -- réapplique toutes les X secondes (au cas où le jeu remet les valeurs)
		AutoFire = false,          -- maintenir le clic gauche = tir auto
		AutoFireDelay = 0.05,      -- délai entre 2 tirs auto (secondes)
		PatchModules = true,       -- modifie aussi les réglages dans les ModuleScripts de l'arme
		Watch = true,              -- si le jeu remet une valeur, elle est re-patchée instantanément
		AnimBoost = false,         -- animations d'attaque plus rapides (arme en main)
		AnimSpeed = 2,             -- vitesse des animations (x)
		-- mots-clés (minuscules) : valeur BASSE = plus rapide
		DelayKeywords = { "cooldown", "cool_down", "delay", "reload", "firerate", "fire_rate", "firedelay", "shootdelay", "attackdelay", "interval", "wait", "recoiltime", "debounce", "equiptime", "windup", "chargetime" },
		-- mots-clés (minuscules) : valeur HAUTE = plus rapide
		RateKeywords = { "rpm", "persecond", "attackspeed", "firespeed", "rateoffire", "shotspersecond" },
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

	FOVCircle = {
		Show = true,
		Color = Color3.new(1, 1, 1),
		Thickness = 1.5,
	},

	NextbotSpam = {
		Active = false,
		Speed = 20,
	},

	WalkFling = {
		Enabled = false,
		Power = 5000,     -- puissance actuelle (aucune limite max)
		Min = 100,        -- minimum du SLIDER seulement
		Max = 50000,      -- maximum du SLIDER seulement (la case texte et les touches n'ont aucune limite)
		Step = 1000,      -- pas des touches , et .
		Spin = true,      -- fait tourner le perso (plus efficace)
		HeavyBody = true, -- rend le perso très lourd pendant le fling
		OnlyNearPlayers = true,   -- ne fling que si un joueur est proche
		TriggerRange = 7,         -- distance de déclenchement (studs)
		SafeReturn = true,        -- revient à la dernière position sûre si tu es projeté trop loin
		SafeReturnDistance = 300, -- distance max avant le retour auto
	},

	TP = {
		ClickTP = false,                 -- maintenir HoldKey + clic gauche = téléportation
		HoldKey = Enum.KeyCode.LeftShift,
		MoveVehicle = true,              -- si assis, téléporte aussi le véhicule
		Height = 3,                      -- hauteur ajoutée à l'arrivée
	},

	BTools = {
		Enabled = false,
		Tool = "Move",
		IgnorePlayers = true,   -- ne cible pas les joueurs/PNJ
		ShowHover = true,       -- surbrillance de l'objet visé
		FreeDrag = true,        -- outil Déplacer : glisser l'objet directement
		LocalAxes = false,      -- poignées sur les axes de l'objet
		MoveStep = 1,           -- pas de déplacement (studs, 0 = libre)
		ResizeStep = 1,
		RotateStep = 15,        -- degrés
		ResizeBoth = false,     -- redimensionner des deux côtés
		SelRadius = 20,
		Color = Color3.fromRGB(196, 40, 28),
		Material = "Plastic",
		SurfaceFace = "All",
		SurfaceType = "Smooth",
		LightType = "PointLight",
		LightBrightness = 2,
		LightRange = 20,
		LightAngle = 90,
		LightFace = "Front",
		LightShadows = false,
		LightColor = Color3.fromRGB(255, 200, 120),
		FxType = "Fire",
		FxSize = 6,
		FxHeat = 9,
		FxColor = Color3.fromRGB(255, 120, 30),
		MeshType = "Sphere",
		MeshId = "",
		TextureId = "",
		MeshScale = 1,
		TexType = "Decal",
		TexFace = "Front",
		TexId = "",
		TexTransparency = 0,
		NewShape = "Block",
		NewSize = Vector3.new(4, 1, 2),
		NewAnchored = true,
		NewCollide = true,
	},

	InfJump = {
		Enabled = false,
	},

	Menu = {
		Name = "telavivmenu",
		Title = "Tel Aviv Menu",
		Accent = Color3.fromRGB(88, 140, 255),
		Blur = true,           -- flou d'arrière-plan quand le menu est ouvert
		BlurSize = 18,
		Dim = 0.35,            -- assombrissement derrière la fenêtre (0 = aucun)
		Animations = true,
		AnimBorder = true,     -- bordure animée
		Width = 940,
		Height = 640,
		DefaultWidth = 940,
		DefaultHeight = 640,
		StartPosition = UDim2.new(0.5, 0, 0.5, 0),
	},
}

----------------------------------------------------------------------
-- Utilitaires
----------------------------------------------------------------------
local refreshers = {}
local function refreshUI()
	for _, f in ipairs(refreshers) do f() end
end

local Notify = function() end -- remplacé par le GUI (U.notify)

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

	-- Apparition aléatoire autour du joueur
	local angle = math.random() * math.pi * 2
	local distance = math.random(15, 30)
	nextbot.Position = root.Position + Vector3.new(math.cos(angle) * distance, 3, math.sin(angle) * distance)

	nextbot.CanCollide = false
	nextbot.Anchored = false
	nextbot.BrickColor = BrickColor.random()
	nextbot.Material = Enum.Material.Neon
	nextbot.Parent = workspace

	-- Suivi en temps réel via RenderStepped
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
			-- Effet "Jumpscare" si le Nextbot touche le joueur
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
-- Fast Mod v2 (cooldown / cadence / reload / tir auto / modules de réglages / animations)
----------------------------------------------------------------------
local menuFrameRef = nil -- rempli plus bas par le GUI
local originals = setmetatable({}, { __mode = "k" })      -- [instance ou table] = { [clé] = valeur d'origine }
local watchConns = setmetatable({}, { __mode = "k" })     -- [instance] = { [clé] = connexion }
local patchedModules = setmetatable({}, { __mode = "k" }) -- [ModuleScript] = table requise (ou false)
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

-- renvoie la nouvelle valeur, ou nil si rien à changer
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

-- NumberValue / IntValue
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

-- Attributes numériques
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

-- Tables de réglages dans les ModuleScripts de l'arme (ex: { Cooldown = 1.5, FireRate = 0.2 })
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

-- patch immédiat de tout ce qui est ajouté plus tard dans l'arme
local function hookTool(tool)
	if hookedTools[tool] then return end
	hookedTools[tool] = true
	tool.DescendantAdded:Connect(function(d)
		if Config.FastMod.Enabled then patchInstance(d) end
	end)
end

local function fastPatchAll()
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

local function restoreFastMod()
	-- on coupe la surveillance d'abord pour ne pas re-patcher pendant la restauration
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

-- ajoute un mot-clé (minuscules) à une liste, renvoie true si ajouté
local function addFastKeyword(list, text)
	text = (text or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
	if text == "" or table.find(list, text) then return false end
	table.insert(list, text)
	return true
end

-- animations d'attaque plus rapides (uniquement avec une arme en main)
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

-- Tir auto : maintenir le clic gauche
local autoTimer = 0
RunService.Heartbeat:Connect(function(dt)
	local fm = Config.FastMod
	if not (fm.Enabled and fm.AutoFire) then autoTimer = 0; return end
	if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then autoTimer = 0; return end
	if UIS:GetFocusedTextBox() then return end

	-- pas de tir quand on clique dans le menu
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

----------------------------------------------------------------------
-- Ciblage & Aimbot
----------------------------------------------------------------------
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function isVisible(part)
	rayParams.FilterDescendantsInstances = { player.Character }
	local origin = camera.CFrame.Position
	local result = workspace:Raycast(origin, part.Position - origin, rayParams)
	return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

-- Renvoie (position écran, position monde) de la cible la plus proche du centre
local function getClosestTarget(s, partName)
	local viewport = camera.ViewportSize
	local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
	local bestScreen, bestWorld, bestDist = nil, nil, s.FOV

	for _, other in ipairs(Players:GetPlayers()) do
		local char = other.Character
		if other == player or not char then continue end
		if s.TeamCheck and other.Team ~= nil and other.Team == player.Team then continue end

		local hum = char:FindFirstChildOfClass("Humanoid")
		local part = char:FindFirstChild(partName or "Head") or char:FindFirstChild("HumanoidRootPart")
		if not hum or not part or hum.Health <= 0 then continue end
		if (part.Position - camera.CFrame.Position).Magnitude > s.MaxDistance then continue end
		if s.WallCheck and not isVisible(part) then continue end

		local pos3D = part.Position
		if s.Prediction then
			local root = char:FindFirstChild("HumanoidRootPart")
			if root then
				pos3D += root.AssemblyLinearVelocity * (s.PredictionFactor or 0.12)
			end
		end

		local screenPos, onScreen = camera:WorldToViewportPoint(pos3D)
		if not onScreen then continue end

		local v = Vector2.new(screenPos.X, screenPos.Y)
		local d = (v - center).Magnitude
		if d < bestDist then
			bestScreen, bestWorld, bestDist = v, pos3D, d
		end
	end
	return bestScreen, bestWorld
end

-- Silent Aim : à appeler depuis le script d'arme du jeu :
--   local target = _G.DevTools.GetAimPosition(mouse.Hit.Position)
_G.DevTools = _G.DevTools or {}
function _G.DevTools.GetAimPosition(defaultPos)
	local s = Config.SilentAim
	if s.Enabled and math.random(1, 100) <= s.HitChance then
		local _, world = getClosestTarget(s, s.TargetPart)
		if world then return world end
	end
	return defaultPos
end

----------------------------------------------------------------------
-- Invisibilité & Noclip
----------------------------------------------------------------------
local hidden = {}
local invisibleApplied = false

local function hideInst(d)
	if d:IsA("BasePart") or d:IsA("Decal") then
		if hidden[d] == nil then hidden[d] = d.Transparency end
		d.Transparency = 1
	end
end

local function setInvisible(state)
	if state == invisibleApplied then return end
	local char, hum = getChar()
	if not char then return end
	invisibleApplied = state

	if state then
		for _, d in ipairs(char:GetDescendants()) do hideInst(d) end
		hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	else
		for d, t in pairs(hidden) do
			if d.Parent then d.Transparency = t end
		end
		table.clear(hidden)
		hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
	end
end

local savedCollide = {}

local function onCharacter(char)
	invisibleApplied = false
	table.clear(hidden)
	table.clear(savedCollide)
	char.DescendantAdded:Connect(function(d)
		if invisibleApplied then hideInst(d) end
	end)
end
if player.Character then onCharacter(player.Character) end
player.CharacterAdded:Connect(onCharacter)

RunService.Stepped:Connect(function()
	local char = player.Character
	if not char then return end

	local want = (Config.Fly.Enabled and Config.Fly.Noclip) or (Config.Noclip.Enabled and not Config.WalkFling.Enabled)
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
-- Boucle principale
----------------------------------------------------------------------
local wasFlying = false
local seatedDisabled = false
local lastHum = nil
local origWalk = nil
local origJump = nil
local origSwim = nil

-- Détection de l'eau (état Swimming OU voxel d'eau du Terrain autour du perso)
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

	-- nouveau personnage (respawn) : on repart de zéro
	if hum ~= lastHum then
		lastHum = hum
		seatedDisabled = false
		origWalk, origJump, origSwim = nil, nil, nil
	end

	-- WalkSpeed : on ne touche à rien tant que "Walkspeed perso" est OFF
	local walk = Config.Walk
	if walk.Enabled and not fly.Enabled then
		if origWalk == nil then origWalk = hum.WalkSpeed end
		hum.WalkSpeed = walk.Speed
	elseif not walk.Enabled and origWalk ~= nil then
		hum.WalkSpeed = origWalk
		origWalk = nil
	end

	-- JumpPower : idem
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

	-- Vitesse de nage : détection d'eau + vélocité (marche même avec ragdoll / états custom)
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

	if fly.Enabled then
		wasFlying = true

		local dir = Vector3.zero
		local cf = camera.CFrame
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
		if UIS:IsKeyDown(fly.UpKey) then dir += Vector3.yAxis end
		if UIS:IsKeyDown(fly.DownKey) then dir -= Vector3.yAxis end
		local vel = (dir.Magnitude > 0 and dir.Unit or Vector3.zero) * fly.Speed

		local seat = hum.SeatPart
		if seat and fly.VehicleMode then
			-- Assis : c'est le véhicule qui vole
			if seatedDisabled then
				hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
				seatedDisabled = false
			end
			local base = seat.AssemblyRootPart or seat
			base.AssemblyLinearVelocity = vel
			base.AssemblyAngularVelocity = Vector3.zero
		else
			-- Pas de véhicule (ou mode détaché) : on éjecte du siège et on vole
			if seat then
				local w = seat:FindFirstChild("SeatWeld")
				if w then w:Destroy() end
				hum.Sit = false
			end
			if not seatedDisabled then
				hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
				seatedDisabled = true
			end
			hum.PlatformStand = true
			root.AssemblyLinearVelocity = vel
			local flat = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
			if flat.Magnitude > 0.01 then
				root.CFrame = CFrame.lookAt(root.Position, root.Position + flat)
			end
		end
	elseif wasFlying then
		wasFlying = false
		hum.PlatformStand = false
		if seatedDisabled then
			hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
			seatedDisabled = false
		end
	end

	setInvisible(fly.Enabled and fly.Invisible)
end)

-- Aimbot : la caméra vise la cible (appliqué APRÈS le script caméra de Roblox)
RunService:BindToRenderStep("TelAvivAimbot", Enum.RenderPriority.Camera.Value + 1, function()
	local a = Config.Aimbot
	if not a.Enabled then return end
	local _, world = getClosestTarget(a, a.TargetPart)
	if world then
		local camPos = camera.CFrame.Position
		camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camPos, world), math.clamp(a.Smoothness, 0.01, 1))
	end
end)

----------------------------------------------------------------------
-- ESP
----------------------------------------------------------------------
local espObjects = {}

local function clearESP(plr)
	local e = espObjects[plr]
	if e then
		e.hl:Destroy()
		if e.tag then e.tag:Destroy() end
		espObjects[plr] = nil
	end
end

local function applyESP(plr)
	local s = Config.ESP
	clearESP(plr)
	if plr == player or not plr.Character then return end
	if s.TeamCheck and plr.Team ~= nil and plr.Team == player.Team then return end

	local char = plr.Character
	local hl = Instance.new("Highlight")
	hl.FillColor = s.FillColor
	hl.OutlineColor = s.OutlineColor
	hl.FillTransparency = s.FillTransparency
	hl.OutlineTransparency = s.OutlineTransparency
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Adornee = char
	hl.Parent = char

	local entry = { hl = hl }
	local head = char:FindFirstChild("Head")
	if head and (s.ShowNames or s.ShowDistance) then
		local tag = Instance.new("BillboardGui")
		tag.AlwaysOnTop = true
		tag.Size = UDim2.new(0, 160, 0, 30)
		tag.StudsOffset = Vector3.new(0, 2.5, 0)
		tag.Adornee = head
		tag.Parent = head

		local lbl = Instance.new("TextLabel")
		lbl.BackgroundTransparency = 1
		lbl.Size = UDim2.new(1, 0, 1, 0)
		lbl.Font = Enum.Font.GothamBold
		lbl.TextSize = 14
		lbl.TextColor3 = s.OutlineColor
		lbl.TextStrokeTransparency = 0.4
		lbl.Text = plr.Name
		lbl.Parent = tag

		entry.tag, entry.label = tag, lbl
	end
	espObjects[plr] = entry
end

local function refreshESP()
	for _, plr in ipairs(Players:GetPlayers()) do
		if Config.ESP.Enabled then applyESP(plr) else clearESP(plr) end
	end
end

local function hookPlayer(plr)
	plr.CharacterAdded:Connect(function()
		task.wait(0.5)
		if Config.ESP.Enabled then applyESP(plr) end
	end)
end
Players.PlayerAdded:Connect(hookPlayer)
for _, plr in ipairs(Players:GetPlayers()) do hookPlayer(plr) end
Players.PlayerRemoving:Connect(clearESP)

RunService.RenderStepped:Connect(function()
	if not Config.ESP.Enabled then return end
	local s = Config.ESP
	local camPos = camera.CFrame.Position
	for plr, e in pairs(espObjects) do
		local head = plr.Character and plr.Character:FindFirstChild("Head")
		if head then
			local dist = (head.Position - camPos).Magnitude
			local visible = dist <= s.MaxDistance
			e.hl.Enabled = visible
			if e.tag then
				e.tag.Enabled = visible
				local text = s.ShowNames and plr.Name or ""
				if s.ShowDistance then
					text = (text ~= "" and (text .. " ") or "") .. "[" .. math.floor(dist) .. "m]"
				end
				e.label.Text = text
			end
		end
	end
end)

----------------------------------------------------------------------
-- Walk Fling (touche un joueur en marchant pour l'éjecter)
----------------------------------------------------------------------
local flingVel = Vector3.zero
local flingAng = Vector3.zero
local flingActive = false
local flingSavedProps = {}
local flingMassOn = false
local flingChar = nil
local lastSafeCF = nil

-- Perso très lourd (densité max) pendant le fling, restauré ensuite
local function setFlingMass(on)
	if on then
		local char = player.Character
		if flingChar ~= char then
			table.clear(flingSavedProps)
			flingChar = char
		end
		if char then
			for _, p in ipairs(char:GetDescendants()) do
				if p:IsA("BasePart") then
					if flingSavedProps[p] == nil then
						flingSavedProps[p] = p.CustomPhysicalProperties or false
					end
					p.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0.5, 1, 1)
				end
			end
		end
		flingMassOn = true
	else
		for p, saved in pairs(flingSavedProps) do
			if p.Parent then p.CustomPhysicalProperties = saved or nil end
		end
		table.clear(flingSavedProps)
		flingMassOn = false
	end
end

-- Y a-t-il un autre joueur dans la portée ?
local function nearOtherPlayer(root, range)
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player then
			local r = other.Character and other.Character:FindFirstChild("HumanoidRootPart")
			if r and (r.Position - root.Position).Magnitude <= range then
				return true
			end
		end
	end
	return false
end

RunService.Heartbeat:Connect(function()
	local wf = Config.WalkFling
	local active = wf.Enabled and not Config.Fly.Enabled
	if not active then
		if flingMassOn then setFlingMass(false) end
		lastSafeCF = nil
		return
	end

	local char, _, root = getChar()
	if not root then return end

	if wf.HeavyBody and (not flingMassOn or flingChar ~= player.Character) then
		setFlingMass(true)
	end

	-- retour auto si tu as été projeté trop loin
	if wf.SafeReturn and lastSafeCF
		and (root.Position - lastSafeCF.Position).Magnitude > wf.SafeReturnDistance then
		char:PivotTo(lastSafeCF)
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		return
	end

	-- pas de joueur proche : comportement normal
	if wf.OnlyNearPlayers and not nearOtherPlayer(root, wf.TriggerRange) then
		if wf.SafeReturn then lastSafeCF = root.CFrame end
		return
	end

	flingVel = root.AssemblyLinearVelocity
	flingAng = root.AssemblyAngularVelocity

	-- si le perso est immobile, on pousse quand même vers l'avant
	local base = flingVel
	if Vector3.new(base.X, 0, base.Z).Magnitude < 1 then
		base = root.CFrame.LookVector * 16
	end

	flingActive = true
	root.AssemblyLinearVelocity = base * wf.Power + Vector3.new(0, wf.Power, 0)
	if wf.Spin then
		root.AssemblyAngularVelocity = Vector3.new(0, wf.Power, 0)
	end
end)

RunService.RenderStepped:Connect(function()
	if not flingActive then return end
	local _, _, root = getChar()
	if root then
		root.AssemblyLinearVelocity = flingVel
		root.AssemblyAngularVelocity = flingAng
	end
end)

RunService.Stepped:Connect(function()
	if not flingActive then return end
	flingActive = false
	local _, _, root = getChar()
	if root then
		root.AssemblyLinearVelocity = flingVel + Vector3.new(0, 0.1, 0)
		root.AssemblyAngularVelocity = flingAng
	end
end)

----------------------------------------------------------------------
-- Notifications de kill (fling uniquement, aucun tag)
----------------------------------------------------------------------
local killCount = 0
local lastNear = {} -- [Player] = dernier moment où il était à portée de ton walk fling

RunService.Heartbeat:Connect(function()
	if not (Config.WalkFling.Enabled and Config.Kills.Enabled) then return end
	local _, _, root = getChar()
	if not root then return end
	local range = Config.WalkFling.TriggerRange + 3
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= player then
			local r = other.Character and other.Character:FindFirstChild("HumanoidRootPart")
			if r and (r.Position - root.Position).Magnitude <= range then
				lastNear[other] = os.clock()
			end
		end
	end
end)

local function announceKill(plr, how)
	killCount += 1
	Notify("Kill #" .. killCount .. " : " .. plr.Name .. " (" .. how .. ")")
end

local function hookKills(plr)
	if plr == player then return end
	local function onChar(char)
		local hum = char:WaitForChild("Humanoid", 10)
		if not hum then return end
		hum.Died:Connect(function()
			if not Config.Kills.Enabled then return end
			local t = lastNear[plr]
			if t and os.clock() - t <= Config.Kills.Window then
				announceKill(plr, "fling")
				lastNear[plr] = nil
			end
		end)
	end
	plr.CharacterAdded:Connect(onChar)
	if plr.Character then task.spawn(onChar, plr.Character) end
end
Players.PlayerAdded:Connect(hookKills)
for _, p in ipairs(Players:GetPlayers()) do hookKills(p) end
Players.PlayerRemoving:Connect(function(p) lastNear[p] = nil end)

----------------------------------------------------------------------
-- Téléportation (TP joueur, click TP, sauvegarde de position, spawn)
----------------------------------------------------------------------
local savedPos = nil
local tpIndex = 0

local function teleportTo(pos, height)
	local char, hum, root = getChar()
	if not char then return end
	local targetPos = pos + Vector3.new(0, height or Config.TP.Height, 0)

	local seat = hum.SeatPart
	if seat and Config.TP.MoveVehicle then
		-- assis : on déplace tout le véhicule
		local base = seat.AssemblyRootPart or seat
		base.CFrame = base.CFrame + (targetPos - root.Position)
		base.AssemblyLinearVelocity = Vector3.zero
	else
		local cf = root.CFrame
		char:PivotTo(CFrame.new(targetPos) * (cf - cf.Position))
		root.AssemblyLinearVelocity = Vector3.zero
	end
end

local function mouseWorldPos()
	local loc = UIS:GetMouseLocation()
	local ray = camera:ViewportPointToRay(loc.X, loc.Y)
	rayParams.FilterDescendantsInstances = { player.Character }
	local r = workspace:Raycast(ray.Origin, ray.Direction * 5000, rayParams)
	return r and r.Position
end

local function otherPlayers()
	local t = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			table.insert(t, p)
		end
	end
	table.sort(t, function(a, b) return a.Name:lower() < b.Name:lower() end)
	return t
end

local function tpToPlayer(plr)
	local c = plr and plr.Character
	local r = c and c:FindFirstChild("HumanoidRootPart")
	if r then teleportTo(r.Position) end
end

local function findPlayerByName(text)
	text = (text or ""):lower()
	if text == "" then return nil end
	local partial
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local n, d = p.Name:lower(), p.DisplayName:lower()
			if n == text or d == text then return p end
			if not partial and (n:sub(1, #text) == text or d:sub(1, #text) == text) then partial = p end
		end
	end
	if partial then return partial end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and (p.Name:lower():find(text, 1, true) or p.DisplayName:lower():find(text, 1, true)) then
			return p
		end
	end
end

local function tpByName(text) tpToPlayer(findPlayerByName(text)) end

local function tpCycle(step)
	local list = otherPlayers()
	if #list == 0 then return end
	tpIndex = ((tpIndex + step - 1) % #list) + 1
	tpToPlayer(list[tpIndex])
end

local function savePosition()
	local _, _, root = getChar()
	if root then savedPos = root.Position end
end

local function loadPosition()
	if savedPos then teleportTo(savedPos, 0) end
end

local function tpSpawn()
	local sp = workspace:FindFirstChildWhichIsA("SpawnLocation", true)
	if sp then teleportTo(sp.Position, sp.Size.Y / 2 + 3) end
end

-- Infinite Jump
UIS.JumpRequest:Connect(function()
	if not Config.InfJump.Enabled then return end
	local _, hum = getChar()
	if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

----------------------------------------------------------------------
-- Client Bring (ramène les autres joueurs devant toi : visuel côté client uniquement)
----------------------------------------------------------------------
local function bringTargets()
	local list = {}
	local B = Config.Bring
	local function ok(p)
		local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
		if not h or h.Health <= 0 then return false end
		if B.SkipSeated and h.Sit then return false end
		return p.Character:FindFirstChild("HumanoidRootPart") ~= nil
	end
	if B.Mode == "All" then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and ok(p) then
				if not (B.TeamCheck and p.Team ~= nil and p.Team == player.Team) then
					table.insert(list, p)
				end
			end
		end
		table.sort(list, function(x, y) return x.Name:lower() < y.Name:lower() end)
	else
		local p = findPlayerByName(B.Target)
		if p and ok(p) then table.insert(list, p) end
	end
	return list
end

-- position cible de chaque joueur selon la formation
local function bringSlot(root, i, n, B)
	local d = math.max(B.Distance, 0.5)
	local f = B.Formation
	local cf = root.CFrame
	local off = (i - (n + 1) / 2) * B.Spacing
	if f == "Circle" and n > 1 then
		local ang = (i / n) * math.pi * 2
		return root.Position + Vector3.new(math.cos(ang) * d, B.Height, math.sin(ang) * d)
	elseif f == "Behind" then
		return (cf * CFrame.new(off, B.Height, d)).Position
	elseif f == "Stack" then
		return (cf * CFrame.new(0, B.Height + (i - 1) * B.Spacing, -d)).Position
	end
	return (cf * CFrame.new(off, B.Height, -d)).Position -- Line
end

RunService.RenderStepped:Connect(function()
	local B = Config.Bring
	if not B.Enabled then return end
	local _, _, root = getChar()
	if not root then return end

	local list = bringTargets()
	local n = #list
	local alpha = math.clamp(B.SmoothSpeed, 0.01, 1)
	for i, p in ipairs(list) do
		local r = p.Character:FindFirstChild("HumanoidRootPart")
		if r then
			local pos = bringSlot(root, i, n, B)
			local goal
			if B.FaceMe then
				goal = CFrame.lookAt(pos, Vector3.new(root.Position.X, pos.Y, root.Position.Z))
			else
				goal = CFrame.new(pos) * (r.CFrame - r.CFrame.Position)
			end
			r.CFrame = B.Smooth and r.CFrame:Lerp(goal, alpha) or goal
			r.AssemblyLinearVelocity = Vector3.zero
			r.AssemblyAngularVelocity = Vector3.zero
		end
	end
end)

local function setBring(v) Config.Bring.Enabled = v; refreshUI() end
local function setBringMode(m) Config.Bring.Mode = m; refreshUI() end
local function setBringFormation(f) Config.Bring.Formation = f; refreshUI() end
local function bringPlayer(name)
	local p = findPlayerByName(name)
	if not p then return nil end
	Config.Bring.Mode = "Player"
	Config.Bring.Target = p.Name
	Config.Bring.Enabled = true
	refreshUI()
	return p
end

----------------------------------------------------------------------
-- View player (la caméra suit un autre joueur)
----------------------------------------------------------------------
local viewIndex = 0

local function stopView()
	Config.View.Enabled = false
	Config.View.Target = ""
	local _, hum = getChar()
	if hum then camera.CameraSubject = hum end
end

local function viewPlayer(plr)
	if not plr then return false end
	Config.View.Target = plr.Name
	Config.View.Enabled = true
	return true
end

local function viewCycle(step)
	local list = otherPlayers()
	if #list == 0 then return nil end
	viewIndex = ((viewIndex + step - 1) % #list) + 1
	local plr = list[viewIndex]
	viewPlayer(plr)
	return plr
end

RunService.RenderStepped:Connect(function()
	local V = Config.View
	if not V.Enabled then return end
	local plr = Players:FindFirstChild(V.Target)
	local hum = plr and plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		if camera.CameraSubject ~= hum then camera.CameraSubject = hum end
	elseif not plr then
		stopView()
	end
end)

----------------------------------------------------------------------
-- Actions (AUCUNE limite haute : vitesse, saut, fling, fly)
----------------------------------------------------------------------
local function setFly(v) Config.Fly.Enabled = v; refreshUI() end
local function setNoclip(v) Config.Noclip.Enabled = v; refreshUI() end
local function setAimbot(v) Config.Aimbot.Enabled = v; refreshUI() end
local function setSilent(v) Config.SilentAim.Enabled = v; refreshUI() end
local function setESP(v) Config.ESP.Enabled = v; refreshESP(); refreshUI() end

local function setWalkFling(v)
	Config.WalkFling.Enabled = v
	if not v then
		flingActive = false
		lastSafeCF = nil
		setFlingMass(false)
		local _, _, root = getChar()
		if root then
			root.AssemblyLinearVelocity = Vector3.zero
			root.AssemblyAngularVelocity = Vector3.zero
		end
	end
	refreshUI()
end
local function setClickTP(v) Config.TP.ClickTP = v; refreshUI() end
local function setInfJump(v) Config.InfJump.Enabled = v; refreshUI() end
local function setFlyVehicle(v) Config.Fly.VehicleMode = v; refreshUI() end
local function setFlingPower(v)
	Config.WalkFling.Power = math.floor(v) -- aucune limite
	refreshUI()
end
local function addFlingPower(d) setFlingPower(Config.WalkFling.Power + d) end

local function setFastMod(v)
	Config.FastMod.Enabled = v
	if not v then restoreFastMod() end
	refreshUI()
end
local function setAutoFire(v) Config.FastMod.AutoFire = v; refreshUI() end
local function setFastDelayMs(ms)
	Config.FastMod.Delay = math.floor(ms) / 1000
	refreshUI()
end

local function setJumpPower(v)
	Config.Jump.Power = math.floor(v) -- aucune limite
	Config.Jump.Enabled = true
	refreshUI()
end
local function addJumpPower(d) setJumpPower(Config.Jump.Power + d) end

local function setFlySpeed(v) Config.Fly.Speed = v; refreshUI() end -- aucune limite
local function addFlySpeed(d) setFlySpeed(Config.Fly.Speed + d) end
local function setWalkSpeed(v)
	Config.Walk.Speed = v -- aucune limite
	Config.Walk.Enabled = true
	refreshUI()
end
local function addWalkSpeed(d)
	if not Config.Walk.Enabled then
		local _, hum = getChar()
		if hum then Config.Walk.Speed = hum.WalkSpeed end
	end
	setWalkSpeed(Config.Walk.Speed + d)
end
local function setSwimSpeed(v) Config.Swim.Speed = v; Config.Swim.Enabled = true; refreshUI() end
local function setSwimEnabled(v) Config.Swim.Enabled = v; refreshUI() end

local function setWalkEnabled(v) Config.Walk.Enabled = v; refreshUI() end
local function setJumpEnabled(v) Config.Jump.Enabled = v; refreshUI() end

----------------------------------------------------------------------
-- GUI "telavivmenu" v3 : interface à onglets + BTools
----------------------------------------------------------------------
local U = {}     -- partage entre les blocs GUI
local BTf = {}   -- fonctions BTools (remplies plus bas)

----------------------------------------------------------------------
-- BLOC 1 : interface v5 (verre dépoli, flou, onglets + sous-onglets, recherche globale, animations)
----------------------------------------------------------------------
do
	local M = Config.Menu
	local Lighting = game:GetService("Lighting")
	local TextService = game:GetService("TextService")

	local T = {
		Bg        = Color3.fromRGB(11, 12, 17),
		Panel     = Color3.fromRGB(16, 18, 25),
		Card      = Color3.fromRGB(24, 27, 36),
		CardHover = Color3.fromRGB(33, 37, 49),
		Stroke    = Color3.fromRGB(44, 49, 64),
		Off       = Color3.fromRGB(58, 63, 80),
		Accent    = M.Accent,
		Text      = Color3.fromRGB(236, 238, 246),
		SubText   = Color3.fromRGB(139, 146, 166),
		On        = Color3.fromRGB(52, 199, 120),
		Danger    = Color3.fromRGB(240, 82, 82),
		Dark      = Color3.fromRGB(14, 15, 20),
	}
	U.T = T

	----------------------------------------------------------------
	-- Helpers
	----------------------------------------------------------------
	local function dur(t) return M.Animations and t or 0 end

	local function tw(inst, props, t, style, dir)
		local tween = TweenService:Create(inst,
			TweenInfo.new(dur(t or 0.18), style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
		tween:Play()
		return tween
	end

	local function corner(inst, r)
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, r or 8)
		c.Parent = inst
		return c
	end

	local function stroke(inst, color, th)
		local s = Instance.new("UIStroke")
		s.Color = color
		s.Thickness = th or 1
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		s.Parent = inst
		return s
	end

	local function newLabel(parent, text, size, color, font)
		local l = Instance.new("TextLabel")
		l.BackgroundTransparency = 1
		l.Font = font or Enum.Font.GothamMedium
		l.TextSize = size or 14
		l.TextColor3 = color or T.Text
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.Text = text
		l.Parent = parent
		return l
	end

	local function fmt(v)
		if type(v) == "number" then return tostring(math.floor(v * 100 + 0.5) / 100) end
		return tostring(v)
	end

	local function accent2(c)
		local h, s, v = c:ToHSV()
		return Color3.fromHSV((h + 0.12) % 1, s, v)
	end
	local function accentSeq(c)
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, c),
			ColorSequenceKeypoint.new(0.5, accent2(c)),
			ColorSequenceKeypoint.new(1, c),
		})
	end
	local gradReg = {}
	local function accentGradient(parent, rotation)
		local g = Instance.new("UIGradient")
		g.Color = accentSeq(T.Accent)
		g.Rotation = rotation or 0
		g.Parent = parent
		table.insert(gradReg, g)
		return g
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = M.Name
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 50
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = player:WaitForChild("PlayerGui")
	U.gui = gui
	U.corner, U.stroke, U.tw, U.newLabel = corner, stroke, tw, newLabel

	-- change la couleur d'accent partout (menu + panneau BTools)
	local colorProps = { "BackgroundColor3", "TextColor3", "ImageColor3", "ScrollBarImageColor3", "Color", "Color3", "SurfaceColor3" }
	local function nearColor(a, b)
		return math.abs(a.R - b.R) + math.abs(a.G - b.G) + math.abs(a.B - b.B) < 0.01
	end
	function U.setAccent(newC)
		local old = T.Accent
		T.Accent = newC
		M.Accent = newC
		for _, g in ipairs(gradReg) do g.Color = accentSeq(newC) end
		for _, d in ipairs(gui:GetDescendants()) do
			if not d:GetAttribute("keep") then
				for _, prop in ipairs(colorProps) do
					local ok, v = pcall(function() return d[prop] end)
					if ok and typeof(v) == "Color3" and nearColor(v, old) then
						pcall(function() d[prop] = newC end)
					end
				end
			end
		end
		refreshUI()
	end

	----------------------------------------------------------------
	-- Fond : assombrissement + flou
	----------------------------------------------------------------
	local dim = Instance.new("Frame")
	dim.Name = "Dim"
	dim.Size = UDim2.new(1, 0, 1, 0)
	dim.BackgroundColor3 = Color3.new(0, 0, 0)
	dim.BackgroundTransparency = 1
	dim.BorderSizePixel = 0
	dim.ZIndex = 0
	dim.Parent = gui

	local blur = Instance.new("BlurEffect")
	blur.Name = "TelAvivBlur"
	blur.Size = 0
	blur.Parent = Lighting

	----------------------------------------------------------------
	-- Fenêtre principale
	----------------------------------------------------------------
	local N = { pages = {}, order = {}, sections = {}, ord = 0, y = 14, open = true, minimized = false, compact = false }
	local V = {}
	local HEAD_H = 60
	local SIDE_W = 220
	local FULL = UDim2.new(0, M.Width, 0, M.Height)

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Position = M.StartPosition
	main.Size = FULL
	main.BackgroundColor3 = Color3.new(1, 1, 1)
	main.BackgroundTransparency = 0.03
	main.BorderSizePixel = 0
	main.Active = true
	main.ClipsDescendants = true
	main.Parent = gui
	corner(main, 16)
	V.main = main
	U.main = main
	menuFrameRef = main

	local scale = Instance.new("UIScale")
	scale.Parent = main

	do
		local bg = Instance.new("UIGradient")
		bg.Color = ColorSequence.new(Color3.fromRGB(22, 24, 34), Color3.fromRGB(10, 11, 16))
		bg.Rotation = 125
		bg.Parent = main

		-- bordure animée
		local ms = Instance.new("UIStroke")
		ms.Color = Color3.new(1, 1, 1)
		ms.Thickness = 1.6
		ms.Transparency = 0.2
		ms.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		ms.Parent = main
		local mg = accentGradient(ms, 0)
		RunService.Heartbeat:Connect(function()
			if M.AnimBorder and main.Visible then mg.Rotation = (os.clock() * 45) % 360 end
		end)
	end

	-- ripple (onde au clic) : l'hôte doit avoir ClipsDescendants = true
	local function ripple(host)
		local m = UIS:GetMouseLocation()
		local abs, s = host.AbsolutePosition, scale.Scale
		local d = math.max(host.AbsoluteSize.X, host.AbsoluteSize.Y) * 1.7 / s
		local r = Instance.new("Frame")
		r.AnchorPoint = Vector2.new(0.5, 0.5)
		r.Position = UDim2.fromOffset((m.X - abs.X) / s, (m.Y - abs.Y) / s)
		r.Size = UDim2.fromOffset(0, 0)
		r.BackgroundColor3 = T.Accent
		r.BackgroundTransparency = 0.78
		r.BorderSizePixel = 0
		r.ZIndex = 0
		r:SetAttribute("keep", true)
		r.Parent = host
		corner(r, 9999)
		tw(r, { Size = UDim2.fromOffset(d, d), BackgroundTransparency = 1 }, 0.55)
		task.delay(0.6, function() r:Destroy() end)
	end

	----------------------------------------------------------------
	-- Notifications (toasts animés)
	----------------------------------------------------------------
	do
		local holder = Instance.new("Frame")
		holder.Name = "Toasts"
		holder.BackgroundTransparency = 1
		holder.AnchorPoint = Vector2.new(0.5, 1)
		holder.Position = UDim2.new(0.5, 0, 1, -28)
		holder.Size = UDim2.new(0, 360, 0, 0)
		holder.AutomaticSize = Enum.AutomaticSize.Y
		holder.Parent = gui
		local tl = Instance.new("UIListLayout", holder)
		tl.Padding = UDim.new(0, 6)
		tl.HorizontalAlignment = Enum.HorizontalAlignment.Center
		tl.VerticalAlignment = Enum.VerticalAlignment.Bottom
		tl.SortOrder = Enum.SortOrder.LayoutOrder

		function U.notify(text)
			local kids = holder:GetChildren()
			local count = 0
			for _, k in ipairs(kids) do if k:IsA("Frame") then count += 1 end end
			if count >= 4 then
				for _, k in ipairs(kids) do
					if k:IsA("Frame") then k:Destroy() break end
				end
			end

			local slot = Instance.new("Frame")
			slot.Size = UDim2.new(1, 0, 0, 42)
			slot.BackgroundTransparency = 1
			slot.Parent = holder

			local f = Instance.new("Frame")
			f.Position = UDim2.new(0, 0, 0, 26)
			f.Size = UDim2.new(1, 0, 1, 0)
			f.BackgroundColor3 = T.Panel
			f.BackgroundTransparency = 1
			f.BorderSizePixel = 0
			f.Parent = slot
			corner(f, 11)
			local st = stroke(f, T.Accent, 1)
			st.Transparency = 1
			local dot = Instance.new("Frame")
			dot.AnchorPoint = Vector2.new(0, 0.5)
			dot.Position = UDim2.new(0, 14, 0.5, 0)
			dot.Size = UDim2.new(0, 8, 0, 8)
			dot.BackgroundColor3 = T.Accent
			dot.BackgroundTransparency = 1
			dot.BorderSizePixel = 0
			dot.Parent = f
			corner(dot, 4)
			local l = newLabel(f, text, 14, T.Text, Enum.Font.GothamMedium)
			l.Position = UDim2.new(0, 32, 0, 0)
			l.Size = UDim2.new(1, -44, 1, 0)
			l.TextTransparency = 1
			l.TextTruncate = Enum.TextTruncate.AtEnd

			tw(f, { Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0.04 }, 0.42, Enum.EasingStyle.Back)
			tw(st, { Transparency = 0.45 }, 0.3)
			tw(dot, { BackgroundTransparency = 0 }, 0.3)
			tw(l, { TextTransparency = 0 }, 0.3)

			task.delay(2.2, function()
				if not f.Parent then return end
				tw(f, { Position = UDim2.new(0, 0, 0, -8), BackgroundTransparency = 1 }, 0.3)
				tw(st, { Transparency = 1 }, 0.3)
				tw(dot, { BackgroundTransparency = 1 }, 0.3)
				tw(l, { TextTransparency = 1 }, 0.3)
				task.delay(dur(0.32), function() slot:Destroy() end)
			end)
		end
	end
	Notify = U.notify

	----------------------------------------------------------------
	-- Barre du haut
	----------------------------------------------------------------
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, HEAD_H)
	header.BackgroundColor3 = T.Panel
	header.BackgroundTransparency = 0.2
	header.BorderSizePixel = 0
	header.ZIndex = 5
	header.Parent = main
	V.header = header

	do
		local line = Instance.new("Frame")
		line.Position = UDim2.new(0, 0, 1, -1)
		line.Size = UDim2.new(1, 0, 0, 1)
		line.BackgroundColor3 = T.Stroke
		line.BorderSizePixel = 0
		line.ZIndex = 6
		line.Parent = header

		-- reflet qui traverse la barre
		local shim = Instance.new("Frame")
		shim.Position = UDim2.new(0, 0, 1, -2)
		shim.Size = UDim2.new(1, 0, 0, 2)
		shim.BackgroundColor3 = T.Accent
		shim.BorderSizePixel = 0
		shim.ZIndex = 7
		shim.Parent = header
		local sg = Instance.new("UIGradient")
		sg.Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.35, 1),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(0.65, 1),
			NumberSequenceKeypoint.new(1, 1),
		})
		sg.Offset = Vector2.new(-1, 0)
		sg.Parent = shim
		local shimTween = TweenService:Create(sg,
			TweenInfo.new(3.2, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1), { Offset = Vector2.new(1, 0) })
		shimTween:Play()
		function U.setShimmer(v)
			if v then shimTween:Play() else shimTween:Pause() end
			shim.Visible = v
		end

		-- logo
		local logo = Instance.new("Frame")
		logo.Position = UDim2.new(0, 16, 0.5, -19)
		logo.Size = UDim2.new(0, 38, 0, 38)
		logo.BackgroundColor3 = Color3.new(1, 1, 1)
		logo.BorderSizePixel = 0
		logo.ZIndex = 6
		logo.Parent = header
		corner(logo, 11)
		accentGradient(logo, 45)
		local lt = Instance.new("TextLabel")
		lt.BackgroundTransparency = 1
		lt.Size = UDim2.new(1, 0, 1, 0)
		lt.Font = Enum.Font.GothamBlack
		lt.TextSize = 20
		lt.TextColor3 = Color3.new(1, 1, 1)
		lt.Text = "T"
		lt.ZIndex = 7
		lt.Parent = logo

		local title = newLabel(header, M.Title, 16, T.Text, Enum.Font.GothamBold)
		title.Position = UDim2.new(0, 64, 0.5, -19)
		title.Size = UDim2.new(0, 160, 0, 20)
		title.ZIndex = 6
		local sub = newLabel(header, "menu client  •  v5", 11, T.SubText, Enum.Font.Gotham)
		sub.Position = UDim2.new(0, 64, 0.5, 2)
		sub.Size = UDim2.new(0, 160, 0, 16)
		sub.ZIndex = 6
		V.sub = sub
	end

	-- boutons de fenêtre
	do
		local function winBtn(text, xOff, hoverColor)
			local b = Instance.new("TextButton")
			b.AnchorPoint = Vector2.new(1, 0.5)
			b.Position = UDim2.new(1, xOff, 0.5, 0)
			b.Size = UDim2.new(0, 32, 0, 32)
			b.BackgroundColor3 = T.Card
			b.AutoButtonColor = false
			b.Font = Enum.Font.GothamBold
			b.TextSize = 15
			b.TextColor3 = T.SubText
			b.Text = text
			b.ZIndex = 8
			b.Parent = header
			corner(b, 16)
			b.MouseEnter:Connect(function()
				tw(b, { BackgroundColor3 = hoverColor }, 0.15)
				tw(b, { TextColor3 = Color3.new(1, 1, 1) }, 0.15)
			end)
			b.MouseLeave:Connect(function()
				tw(b, { BackgroundColor3 = T.Card }, 0.15)
				tw(b, { TextColor3 = T.SubText }, 0.15)
			end)
			return b
		end
		V.closeBtn = winBtn("✕", -14, T.Danger)
		V.miniBtn = winBtn("—", -52, T.CardHover)
	end

	-- pastilles d'état : FPS, ping, joueurs
	do
		local chips = Instance.new("Frame")
		chips.Name = "Chips"
		chips.BackgroundTransparency = 1
		chips.AnchorPoint = Vector2.new(1, 0.5)
		chips.Position = UDim2.new(1, -96, 0.5, 0)
		chips.Size = UDim2.new(0, 0, 0, 26)
		chips.AutomaticSize = Enum.AutomaticSize.X
		chips.ZIndex = 6
		chips.Parent = header
		local cl = Instance.new("UIListLayout", chips)
		cl.FillDirection = Enum.FillDirection.Horizontal
		cl.Padding = UDim.new(0, 6)
		cl.VerticalAlignment = Enum.VerticalAlignment.Center
		V.chips = chips

		local function chip(ord)
			local f = Instance.new("Frame")
			f.LayoutOrder = ord
			f.Size = UDim2.new(0, 0, 0, 26)
			f.AutomaticSize = Enum.AutomaticSize.X
			f.BackgroundColor3 = T.Card
			f.BorderSizePixel = 0
			f.ZIndex = 6
			f.Parent = chips
			corner(f, 13)
			local dot = Instance.new("Frame")
			dot.AnchorPoint = Vector2.new(0, 0.5)
			dot.Position = UDim2.new(0, 10, 0.5, 0)
			dot.Size = UDim2.new(0, 6, 0, 6)
			dot.BackgroundColor3 = T.On
			dot.BorderSizePixel = 0
			dot.ZIndex = 7
			dot.Parent = f
			dot:SetAttribute("keep", true)
			corner(dot, 3)
			local l = Instance.new("TextLabel")
			l.BackgroundTransparency = 1
			l.Position = UDim2.new(0, 16, 0, 0)
			l.Size = UDim2.new(0, 0, 1, 0)
			l.AutomaticSize = Enum.AutomaticSize.X
			l.Font = Enum.Font.GothamMedium
			l.TextSize = 12
			l.TextColor3 = T.SubText
			l.ZIndex = 7
			l.Text = "--"
			l.Parent = f
			local pd = Instance.new("UIPadding", l)
			pd.PaddingLeft = UDim.new(0, 2)
			pd.PaddingRight = UDim.new(0, 10)
			return l, dot
		end
		local fpsL, fpsDot = chip(1)
		local pingL, pingDot = chip(2)
		local plrL = chip(3)
		local frames, acc = 0, 0
		RunService.RenderStepped:Connect(function(dt)
			frames += 1
			acc += dt
			if acc >= 0.5 then
				local fps = math.floor(frames / acc + 0.5)
				fpsL.Text = fps .. " FPS"
				tw(fpsDot, { BackgroundColor3 = fps >= 50 and T.On or (fps >= 30 and Color3.fromRGB(245, 190, 60) or T.Danger) }, 0.3)
				local ok, ping = pcall(function() return player:GetNetworkPing() end)
				local ms = ok and math.floor(ping * 1000 + 0.5) or 0
				pingL.Text = ms .. " ms"
				tw(pingDot, { BackgroundColor3 = ms <= 90 and T.On or (ms <= 180 and Color3.fromRGB(245, 190, 60) or T.Danger) }, 0.3)
				plrL.Text = #Players:GetPlayers() .. " joueurs"
				frames, acc = 0, 0
			end
		end)
	end

	-- déplacement de la fenêtre par la barre
	do
		local dragging, dStart, dPos = false, nil, nil
		header.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging, dStart, dPos = true, i.Position, main.Position
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local d = i.Position - dStart
				main.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset + d.X, dPos.Y.Scale, dPos.Y.Offset + d.Y)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)
	end

	----------------------------------------------------------------
	-- Corps : barre latérale + contenu
	----------------------------------------------------------------
	local body = Instance.new("Frame")
	body.Name = "Body"
	body.BackgroundTransparency = 1
	body.Position = UDim2.new(0, 0, 0, HEAD_H)
	body.Size = UDim2.new(1, 0, 1, -HEAD_H)
	body.Parent = main
	V.body = body

	local sidebar = Instance.new("Frame")
	sidebar.Name = "Sidebar"
	sidebar.Size = UDim2.new(0, SIDE_W, 1, 0)
	sidebar.BackgroundColor3 = T.Panel
	sidebar.BackgroundTransparency = 0.35
	sidebar.BorderSizePixel = 0
	sidebar.ZIndex = 2
	sidebar.Parent = body
	V.sidebar = sidebar

	do
		local sl = Instance.new("Frame")
		sl.AnchorPoint = Vector2.new(1, 0)
		sl.Position = UDim2.new(1, 0, 0, 0)
		sl.Size = UDim2.new(0, 1, 1, 0)
		sl.BackgroundColor3 = T.Stroke
		sl.BorderSizePixel = 0
		sl.ZIndex = 3
		sl.Parent = sidebar

		local nav = Instance.new("Frame")
		nav.Name = "Nav"
		nav.BackgroundTransparency = 1
		nav.Size = UDim2.new(1, 0, 1, -80)
		nav.ZIndex = 3
		nav.Parent = sidebar
		V.nav = nav

		-- pastille qui glisse sous l'onglet actif
		local pill = Instance.new("Frame")
		pill.Name = "Pill"
		pill.Position = UDim2.new(0, 10, 0, 40)
		pill.Size = UDim2.new(1, -20, 0, 40)
		pill.BackgroundColor3 = T.Accent
		pill.BackgroundTransparency = 0.86
		pill.BorderSizePixel = 0
		pill.ZIndex = 3
		pill.Parent = nav
		corner(pill, 10)
		local pb = Instance.new("Frame")
		pb.Position = UDim2.new(0, 0, 0.22, 0)
		pb.Size = UDim2.new(0, 3, 0.56, 0)
		pb.BackgroundColor3 = T.Accent
		pb.BorderSizePixel = 0
		pb.ZIndex = 4
		pb.Parent = pill
		corner(pb, 2)
		V.pill = pill

		-- carte joueur
		local card = Instance.new("Frame")
		card.AnchorPoint = Vector2.new(0, 1)
		card.Position = UDim2.new(0, 10, 1, -10)
		card.Size = UDim2.new(1, -20, 0, 56)
		card.BackgroundColor3 = T.Card
		card.BorderSizePixel = 0
		card.ZIndex = 3
		card.Parent = sidebar
		corner(card, 12)
		stroke(card, T.Stroke, 1)
		local av = Instance.new("ImageLabel")
		av.Position = UDim2.new(0, 10, 0.5, -18)
		av.Size = UDim2.new(0, 36, 0, 36)
		av.BackgroundColor3 = T.CardHover
		av.BorderSizePixel = 0
		av.ZIndex = 4
		av.Parent = card
		corner(av, 18)
		task.spawn(function()
			local ok, img = pcall(function()
				return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			end)
			if ok and av.Parent then av.Image = img end
		end)
		local nm = newLabel(card, player.DisplayName, 13, T.Text, Enum.Font.GothamBold)
		nm.Position = UDim2.new(0, 56, 0, 9)
		nm.Size = UDim2.new(1, -64, 0, 18)
		nm.ZIndex = 4
		nm.TextTruncate = Enum.TextTruncate.AtEnd
		local st2 = newLabel(card, "@" .. player.Name, 11, T.SubText, Enum.Font.Gotham)
		st2.Position = UDim2.new(0, 56, 0, 28)
		st2.Size = UDim2.new(1, -64, 0, 16)
		st2.ZIndex = 4
		st2.TextTruncate = Enum.TextTruncate.AtEnd
		V.userNm, V.userSt = nm, st2
	end

	local content = Instance.new("Frame")
	content.Name = "Content"
	content.BackgroundTransparency = 1
	content.Position = UDim2.new(0, SIDE_W, 0, 0)
	content.Size = UDim2.new(1, -SIDE_W, 1, 0)
	content.ClipsDescendants = true
	content.ZIndex = 2
	content.Parent = body
	V.content = content

	----------------------------------------------------------------
	-- Recherche globale (barre du haut)
	----------------------------------------------------------------
	local registry = {} -- { text, page, tab, row }

	local function animateIn(pg)
		local base = pg.areaBase
		pg.area.GroupTransparency = 1
		pg.area.Position = base + UDim2.fromOffset(0, 16)
		tw(pg.area, { GroupTransparency = 0, Position = base }, 0.38)
	end

	function N.showTab(pg, tab, first)
		local t = pg.tabs[tab]
		if not t then return end
		pg.active = tab
		for n, tt in pairs(pg.tabs) do
			local on = (n == tab)
			tt.sf.Visible = on
			tw(tt.btn, { TextColor3 = on and T.Text or T.SubText }, 0.15)
		end
		if first then
			pg.ind.Position = UDim2.new(0, t.x, 0, 4)
			pg.ind.Size = UDim2.new(0, t.w, 1, -8)
		else
			tw(pg.ind, { Position = UDim2.new(0, t.x, 0, 4), Size = UDim2.new(0, t.w, 1, -8) }, 0.32, Enum.EasingStyle.Back)
			animateIn(pg)
		end
	end

	function N.selectPage(name)
		local pg = N.pages[name]
		if not pg then return end
		N.page = name
		for n, p in pairs(N.pages) do
			local on = (n == name)
			p.holder.Visible = on
			tw(p.txt, { TextColor3 = on and T.Text or T.SubText }, 0.15)
			tw(p.icon, { TextTransparency = on and 0 or 0.4 }, 0.15)
		end
		tw(V.pill, { Position = UDim2.new(0, 10, 0, pg.navY) }, 0.4, Enum.EasingStyle.Back)
		animateIn(pg)
	end

	do
		local sbox = Instance.new("Frame")
		sbox.Name = "SearchBox"
		sbox.AnchorPoint = Vector2.new(0, 0.5)
		sbox.Position = UDim2.new(0, 250, 0.5, 0)
		sbox.Size = UDim2.new(0, 230, 0, 34)
		sbox.BackgroundColor3 = T.Card
		sbox.BorderSizePixel = 0
		sbox.ZIndex = 6
		sbox.Parent = header
		corner(sbox, 17)
		local sst = stroke(sbox, T.Stroke, 1)
		V.sbox = sbox

		local ic = Instance.new("TextLabel")
		ic.BackgroundTransparency = 1
		ic.Position = UDim2.new(0, 12, 0, 0)
		ic.Size = UDim2.new(0, 20, 1, 0)
		ic.Font = Enum.Font.GothamMedium
		ic.TextSize = 14
		ic.TextColor3 = T.SubText
		ic.Text = "🔍"
		ic.ZIndex = 7
		ic.Parent = sbox

		local box = Instance.new("TextBox")
		box.BackgroundTransparency = 1
		box.Position = UDim2.new(0, 38, 0, 0)
		box.Size = UDim2.new(1, -48, 1, 0)
		box.Font = Enum.Font.GothamMedium
		box.TextSize = 13
		box.TextColor3 = T.Text
		box.PlaceholderText = "Rechercher une option..."
		box.PlaceholderColor3 = T.SubText
		box.Text = ""
		box.ClearTextOnFocus = false
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.ZIndex = 7
		box.Parent = sbox

		local drop = Instance.new("Frame")
		drop.Name = "Results"
		drop.Position = UDim2.new(0, 250, 0.5, 26)
		drop.Size = UDim2.new(0, 330, 0, 0)
		drop.BackgroundColor3 = T.Panel
		drop.BorderSizePixel = 0
		drop.ClipsDescendants = true
		drop.Visible = false
		drop.ZIndex = 20
		drop.Parent = header
		corner(drop, 12)
		stroke(drop, T.Stroke, 1)
		local dl = Instance.new("UIListLayout", drop)
		dl.SortOrder = Enum.SortOrder.LayoutOrder
		local dp = Instance.new("UIPadding", drop)
		dp.PaddingTop = UDim.new(0, 6)
		dp.PaddingBottom = UDim.new(0, 6)
		dp.PaddingLeft = UDim.new(0, 6)
		dp.PaddingRight = UDim.new(0, 6)

		local function pulse(row)
			local st = row:FindFirstChildOfClass("UIStroke")
			if st then
				tw(st, { Color = T.Accent, Thickness = 2 }, 0.2)
				task.delay(dur(1.1), function()
					if st.Parent then tw(st, { Color = T.Stroke, Thickness = 1 }, 0.5) end
				end)
			end
			local old = row.BackgroundColor3
			tw(row, { BackgroundColor3 = T.CardHover }, 0.2)
			task.delay(dur(0.9), function()
				if row.Parent then tw(row, { BackgroundColor3 = old }, 0.5) end
			end)
		end

		local function jump(e)
			box.Text = ""
			box:ReleaseFocus()
			N.selectPage(e.page)
			local pg = N.pages[e.page]
			N.showTab(pg, e.tab)
			task.delay(dur(0.15), function()
				local sf = pg.tabs[e.tab].sf
				if e.row and e.row.Parent then
					local y = e.row.AbsolutePosition.Y - sf.AbsolutePosition.Y + sf.CanvasPosition.Y
					sf.CanvasPosition = Vector2.new(0, math.max(0, (y - 14) / scale.Scale))
					pulse(e.row)
				end
			end)
		end

		local function rebuild()
			for _, c in ipairs(drop:GetChildren()) do
				if c:IsA("GuiObject") then c:Destroy() end
			end
			local q = box.Text:lower()
			if q == "" then
				drop.Visible = false
				return
			end
			local results = {}
			for _, e in ipairs(registry) do
				if e.text:lower():find(q, 1, true) then table.insert(results, e) end
			end
			if #results < 8 then
				for _, e in ipairs(registry) do
					if not table.find(results, e) and (e.tab:lower():find(q, 1, true) or e.page:lower():find(q, 1, true)) then
						table.insert(results, e)
					end
				end
			end
			local shown = math.min(#results, 8)
			if shown == 0 then
				local l = newLabel(drop, "Aucun résultat", 13, T.SubText, Enum.Font.GothamMedium)
				l.Size = UDim2.new(1, 0, 0, 34)
				l.ZIndex = 21
				local pd = Instance.new("UIPadding", l)
				pd.PaddingLeft = UDim.new(0, 10)
				shown = 0
			end
			for i = 1, shown do
				local e = results[i]
				local b = Instance.new("TextButton")
				b.LayoutOrder = i
				b.Size = UDim2.new(1, 0, 0, 40)
				b.BackgroundColor3 = T.Accent
				b.BackgroundTransparency = 1
				b.AutoButtonColor = false
				b.Text = ""
				b.ZIndex = 21
				b.Parent = drop
				corner(b, 8)
				local t1 = newLabel(b, e.text, 13, T.Text, Enum.Font.GothamMedium)
				t1.Position = UDim2.new(0, 10, 0, 4)
				t1.Size = UDim2.new(1, -20, 0, 18)
				t1.ZIndex = 22
				t1.TextTruncate = Enum.TextTruncate.AtEnd
				local t2 = newLabel(b, e.page .. "  ›  " .. e.tab, 11, T.SubText, Enum.Font.Gotham)
				t2.Position = UDim2.new(0, 10, 0, 21)
				t2.Size = UDim2.new(1, -20, 0, 15)
				t2.ZIndex = 22
				b.MouseEnter:Connect(function() tw(b, { BackgroundTransparency = 0.88 }, 0.1) end)
				b.MouseLeave:Connect(function() tw(b, { BackgroundTransparency = 1 }, 0.1) end)
				b.MouseButton1Down:Connect(function() jump(e) end)
			end
			local h = (shown == 0 and 34 or shown * 40) + 12
			if not drop.Visible then
				drop.Size = UDim2.new(0, 330, 0, 0)
				drop.Visible = true
			end
			tw(drop, { Size = UDim2.new(0, 330, 0, h) }, 0.25)
		end

		box:GetPropertyChangedSignal("Text"):Connect(rebuild)
		box.Focused:Connect(function()
			tw(sbox, { Size = UDim2.new(0, 330, 0, 34) }, 0.3, Enum.EasingStyle.Back)
			tw(sst, { Color = T.Accent }, 0.2)
			rebuild()
		end)
		box.FocusLost:Connect(function(enter)
			tw(sbox, { Size = UDim2.new(0, 230, 0, 34) }, 0.25)
			tw(sst, { Color = T.Stroke }, 0.2)
			if enter then
				local first = nil
				local q = box.Text:lower()
				for _, e in ipairs(registry) do
					if q ~= "" and e.text:lower():find(q, 1, true) then first = e break end
				end
				if first then jump(first) end
			end
			task.delay(0.25, function()
				if not box:IsFocused() then
					drop.Visible = false
				end
			end)
		end)
	end

	----------------------------------------------------------------
	-- Widgets
	----------------------------------------------------------------
	local function nextOrder()
		N.ord += 1
		return N.ord
	end

	local function register(row, text)
		table.insert(registry, { text = text, page = N.cur.name, tab = N.cur.active_build, row = row })
	end

	local function makeRow(h)
		local row = Instance.new("Frame")
		row.LayoutOrder = nextOrder()
		row.Size = UDim2.new(1, 0, 0, h or 48)
		row.BackgroundColor3 = T.Card
		row.BorderSizePixel = 0
		row.ClipsDescendants = true
		row.Parent = N.scroll
		corner(row, 11)
		local st = stroke(row, T.Stroke, 1)
		return row, st
	end

	local function rowLabel(row, text, reserve)
		local l = newLabel(row, text, 14, T.Text, Enum.Font.GothamMedium)
		l.Position = UDim2.new(0, 16, 0, 0)
		l.Size = UDim2.new(1, -(reserve or 140), 1, 0)
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.ZIndex = 3
		return l
	end

	local function hoverRow(row, st, hit)
		hit.MouseEnter:Connect(function()
			tw(row, { BackgroundColor3 = T.CardHover }, 0.14)
			tw(st, { Color = T.Stroke:Lerp(T.Accent, 0.55) }, 0.14)
		end)
		hit.MouseLeave:Connect(function()
			tw(row, { BackgroundColor3 = T.Card }, 0.18)
			tw(st, { Color = T.Stroke }, 0.18)
		end)
	end

	local function makeHeader(text)
		local f = Instance.new("Frame")
		f.LayoutOrder = nextOrder()
		f.Size = UDim2.new(1, 0, 0, 34)
		f.BackgroundTransparency = 1
		f.Parent = N.scroll
		local l = newLabel(f, text:upper(), 11, T.Accent, Enum.Font.GothamBold)
		l.Position = UDim2.new(0, 4, 0, 10)
		l.Size = UDim2.new(0, 0, 0, 16)
		l.AutomaticSize = Enum.AutomaticSize.X
		local w = TextService:GetTextSize(text:upper(), 11, Enum.Font.GothamBold, Vector2.new(600, 20)).X
		local ln = Instance.new("Frame")
		ln.Position = UDim2.new(0, w + 16, 0, 18)
		ln.Size = UDim2.new(1, -(w + 20), 0, 1)
		ln.BackgroundColor3 = T.Stroke
		ln.BorderSizePixel = 0
		ln.Parent = f
	end

	local function makeNote(text)
		local l = newLabel(N.scroll, text, 13, T.SubText, Enum.Font.Gotham)
		l.LayoutOrder = nextOrder()
		l.Size = UDim2.new(1, 0, 0, 0)
		l.AutomaticSize = Enum.AutomaticSize.Y
		l.TextWrapped = true
		l.TextYAlignment = Enum.TextYAlignment.Top
		local pd = Instance.new("UIPadding", l)
		pd.PaddingLeft = UDim.new(0, 4)
		pd.PaddingRight = UDim.new(0, 4)
	end

	local function makeToggle(text, getter, setter, keyText)
		local row, st = makeRow(48)
		rowLabel(row, text, keyText and 200 or 96)

		local track = Instance.new("Frame")
		track.AnchorPoint = Vector2.new(1, 0.5)
		track.Position = UDim2.new(1, -16, 0.5, 0)
		track.Size = UDim2.new(0, 46, 0, 24)
		track.BackgroundColor3 = T.Off
		track.BorderSizePixel = 0
		track.ZIndex = 3
		track.Parent = row
		corner(track, 12)
		local knob = Instance.new("Frame")
		knob.AnchorPoint = Vector2.new(0, 0.5)
		knob.Position = UDim2.new(0, 3, 0.5, 0)
		knob.Size = UDim2.new(0, 18, 0, 18)
		knob.BackgroundColor3 = Color3.new(1, 1, 1)
		knob.BorderSizePixel = 0
		knob.ZIndex = 4
		knob.Parent = track
		knob:SetAttribute("keep", true)
		corner(knob, 9)

		if keyText then
			local badge = Instance.new("TextLabel")
			badge.AnchorPoint = Vector2.new(1, 0.5)
			badge.Position = UDim2.new(1, -76, 0.5, 0)
			badge.Size = UDim2.new(0, 0, 0, 24)
			badge.AutomaticSize = Enum.AutomaticSize.X
			badge.BackgroundColor3 = T.Bg
			badge.BorderSizePixel = 0
			badge.Font = Enum.Font.GothamBold
			badge.TextSize = 11
			badge.TextColor3 = T.SubText
			badge.Text = keyText
			badge.ZIndex = 3
			badge.Parent = row
			corner(badge, 6)
			stroke(badge, T.Stroke, 1)
			local bp = Instance.new("UIPadding", badge)
			bp.PaddingLeft = UDim.new(0, 9)
			bp.PaddingRight = UDim.new(0, 9)
		end

		local hit = Instance.new("TextButton")
		hit.BackgroundTransparency = 1
		hit.Size = UDim2.new(1, 0, 1, 0)
		hit.Text = ""
		hit.ZIndex = 5
		hit.Parent = row
		hoverRow(row, st, hit)
		hit.MouseButton1Click:Connect(function()
			ripple(row)
			setter(not getter())
		end)

		local prev = nil
		table.insert(refreshers, function()
			local on = getter()
			if prev ~= nil and prev ~= on and Config.Notify.Toggles then
				U.notify(text .. " : " .. (on and "ON" or "OFF"))
			end
			prev = on
			tw(track, { BackgroundColor3 = on and T.Accent or T.Off }, 0.22)
			tw(knob, { Position = on and UDim2.new(0, 25, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }, 0.3, Enum.EasingStyle.Back)
		end)
		register(row, text)
	end

	local function makeButton(text, callback, danger)
		local row, st = makeRow(46)
		local l = rowLabel(row, text, 50)
		if danger then l.TextColor3 = T.Danger end
		local arrow = newLabel(row, "›", 22, T.SubText, Enum.Font.GothamBold)
		arrow.AnchorPoint = Vector2.new(1, 0.5)
		arrow.Position = UDim2.new(1, -16, 0.5, -1)
		arrow.Size = UDim2.new(0, 20, 1, 0)
		arrow.TextXAlignment = Enum.TextXAlignment.Right
		arrow.ZIndex = 3
		local hit = Instance.new("TextButton")
		hit.BackgroundTransparency = 1
		hit.Size = UDim2.new(1, 0, 1, 0)
		hit.Text = ""
		hit.ZIndex = 5
		hit.Parent = row
		hoverRow(row, st, hit)
		hit.MouseEnter:Connect(function() tw(arrow, { Position = UDim2.new(1, -10, 0.5, -1), TextColor3 = T.Accent }, 0.18) end)
		hit.MouseLeave:Connect(function() tw(arrow, { Position = UDim2.new(1, -16, 0.5, -1), TextColor3 = T.SubText }, 0.18) end)
		hit.MouseButton1Click:Connect(function()
			ripple(row)
			callback()
		end)
		register(row, (text:gsub("%s+%[.-%]", "")))
	end

	local function makeBox(parent, w, h, font, size)
		local box = Instance.new("TextBox")
		box.AnchorPoint = Vector2.new(1, 0.5)
		box.Size = UDim2.new(0, w, 0, h)
		box.BackgroundColor3 = T.Bg
		box.BorderSizePixel = 0
		box.Font = font or Enum.Font.GothamBold
		box.TextSize = size or 14
		box.TextColor3 = T.Text
		box.ClearTextOnFocus = false
		box.ZIndex = 4
		box.Parent = parent
		corner(box, 8)
		local st = stroke(box, T.Stroke, 1)
		box.Focused:Connect(function() tw(st, { Color = T.Accent, Thickness = 1.5 }, 0.15) end)
		box.FocusLost:Connect(function() tw(st, { Color = T.Stroke, Thickness = 1 }, 0.2) end)
		return box
	end

	local function makeInputBox(text, getter, setter)
		local row, st = makeRow(48)
		rowLabel(row, text, 160)
		local box = makeBox(row, 124, 30)
		box.Position = UDim2.new(1, -14, 0.5, 0)
		hoverRow(row, st, row)
		table.insert(refreshers, function() box.Text = fmt(getter()) end)
		box.FocusLost:Connect(function()
			local v = tonumber(box.Text)
			if v then setter(v) else refreshUI() end
		end)
		register(row, text)
	end

	local function makeSlider(text, min, max, getter, setter)
		local row, st = makeRow(70)
		local lbl = rowLabel(row, text, 150)
		lbl.Size = UDim2.new(1, -150, 0, 44)
		local box = makeBox(row, 108, 28, Enum.Font.GothamBold, 13)
		box.Position = UDim2.new(1, -14, 0, 22)

		local hit = Instance.new("Frame")
		hit.BackgroundTransparency = 1
		hit.Position = UDim2.new(0, 16, 0, 44)
		hit.Size = UDim2.new(1, -32, 0, 22)
		hit.Active = true
		hit.ZIndex = 4
		hit.Parent = row
		local track = Instance.new("Frame")
		track.Position = UDim2.new(0, 0, 0.5, -3)
		track.Size = UDim2.new(1, 0, 0, 6)
		track.BackgroundColor3 = T.Off
		track.BorderSizePixel = 0
		track.ZIndex = 4
		track.Parent = hit
		corner(track, 3)
		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(0, 0, 1, 0)
		fill.BackgroundColor3 = T.Accent
		fill.BorderSizePixel = 0
		fill.ZIndex = 5
		fill.Parent = track
		corner(fill, 3)
		accentGradient(fill, 0)
		local knob = Instance.new("Frame")
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.new(1, 0, 0.5, 0)
		knob.Size = UDim2.new(0, 14, 0, 14)
		knob.BackgroundColor3 = Color3.new(1, 1, 1)
		knob.BorderSizePixel = 0
		knob.ZIndex = 6
		knob.Parent = fill
		knob:SetAttribute("keep", true)
		corner(knob, 7)

		local dragging = false
		local function setFromX(x)
			local rel = math.clamp((x - hit.AbsolutePosition.X) / hit.AbsoluteSize.X, 0, 1)
			setter(min + (max - min) * rel)
		end
		hit.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				tw(knob, { Size = UDim2.new(0, 20, 0, 20) }, 0.15, Enum.EasingStyle.Back)
				setFromX(input.Position.X)
			end
		end)
		hit.MouseEnter:Connect(function() if not dragging then tw(knob, { Size = UDim2.new(0, 18, 0, 18) }, 0.15) end end)
		hit.MouseLeave:Connect(function() if not dragging then tw(knob, { Size = UDim2.new(0, 14, 0, 14) }, 0.15) end end)
		UIS.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				setFromX(input.Position.X)
			end
		end)
		UIS.InputEnded:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				dragging = false
				tw(knob, { Size = UDim2.new(0, 14, 0, 14) }, 0.2)
			end
		end)

		box.FocusLost:Connect(function()
			local v = tonumber(box.Text)
			if v then setter(v) else refreshUI() end
		end)
		table.insert(refreshers, function()
			local v = getter()
			box.Text = fmt(v)
			tw(fill, { Size = UDim2.new(math.clamp((v - min) / (max - min), 0, 1), 0, 1, 0) }, 0.12)
		end)
		register(row, text)
	end

	local function makeTextAction(text, placeholder, buttonText, callback)
		local row, st = makeRow(48)
		local lbl = rowLabel(row, text, 0)
		lbl.Size = UDim2.new(0.3, 0, 1, 0)
		local box = makeBox(row, 0, 30, Enum.Font.GothamMedium, 13)
		box.Size = UDim2.new(0.4, 0, 0, 30)
		box.Position = UDim2.new(1, -104, 0.5, 0)
		box.PlaceholderText = placeholder
		box.PlaceholderColor3 = T.SubText
		box.Text = ""
		local btn = Instance.new("TextButton")
		btn.AnchorPoint = Vector2.new(1, 0.5)
		btn.Position = UDim2.new(1, -14, 0.5, 0)
		btn.Size = UDim2.new(0, 80, 0, 30)
		btn.BackgroundColor3 = T.Accent
		btn.BorderSizePixel = 0
		btn.AutoButtonColor = true
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 13
		btn.TextColor3 = T.Dark
		btn.Text = buttonText
		btn.ZIndex = 4
		btn.Parent = row
		corner(btn, 8)
		hoverRow(row, st, row)
		btn.MouseButton1Click:Connect(function()
			ripple(row)
			callback(box.Text)
		end)
		box.FocusLost:Connect(function(enter) if enter then callback(box.Text) end end)
		register(row, text)
	end

	local function makeSegment(text, options, getter, setter)
		local row, st = makeRow(48)
		rowLabel(row, text, 380)
		hoverRow(row, st, row)
		local holder = Instance.new("Frame")
		holder.BackgroundTransparency = 1
		holder.AnchorPoint = Vector2.new(1, 0.5)
		holder.Position = UDim2.new(1, -12, 0.5, 0)
		holder.Size = UDim2.new(0, 0, 0, 30)
		holder.AutomaticSize = Enum.AutomaticSize.X
		holder.ZIndex = 3
		holder.Parent = row
		local hl = Instance.new("UIListLayout", holder)
		hl.FillDirection = Enum.FillDirection.Horizontal
		hl.Padding = UDim.new(0, 6)
		hl.VerticalAlignment = Enum.VerticalAlignment.Center
		local btns = {}
		for _, opt in ipairs(options) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(0, 0, 0, 30)
			b.AutomaticSize = Enum.AutomaticSize.X
			b.BorderSizePixel = 0
			b.AutoButtonColor = false
			b.Font = Enum.Font.GothamMedium
			b.TextSize = 13
			b.Text = opt[1]
			b.ZIndex = 4
			b.Parent = holder
			corner(b, 8)
			local p = Instance.new("UIPadding", b)
			p.PaddingLeft = UDim.new(0, 13)
			p.PaddingRight = UDim.new(0, 13)
			b.MouseButton1Click:Connect(function() setter(opt[2]) end)
			btns[opt[2]] = b
		end
		table.insert(refreshers, function()
			local cur = getter()
			for val, b in pairs(btns) do
				local on = (val == cur)
				tw(b, { BackgroundColor3 = on and T.Accent or T.Bg, TextColor3 = on and T.Dark or T.Text }, 0.2)
			end
		end)
		register(row, text)
	end

	local function makeSwatches(text, colors, onPick)
		local row, st = makeRow(48)
		rowLabel(row, text, 300)
		hoverRow(row, st, row)
		local holder = Instance.new("Frame")
		holder.BackgroundTransparency = 1
		holder.AnchorPoint = Vector2.new(1, 0.5)
		holder.Position = UDim2.new(1, -14, 0.5, 0)
		holder.Size = UDim2.new(0, #colors * 32, 0, 26)
		holder.ZIndex = 3
		holder.Parent = row
		local l = Instance.new("UIListLayout", holder)
		l.FillDirection = Enum.FillDirection.Horizontal
		l.Padding = UDim.new(0, 6)
		for _, c in ipairs(colors) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(0, 26, 0, 26)
			b.BackgroundColor3 = c
			b.BorderSizePixel = 0
			b.Text = ""
			b.AutoButtonColor = false
			b.ZIndex = 4
			b:SetAttribute("keep", true)
			b.Parent = holder
			corner(b, 13)
			local bs = stroke(b, Color3.new(1, 1, 1), 0)
			bs.Transparency = 0.2
			b:SetAttribute("keep", true)
			b.MouseEnter:Connect(function() tw(bs, { Thickness = 2 }, 0.12) end)
			b.MouseLeave:Connect(function() tw(bs, { Thickness = 0 }, 0.12) end)
			b.MouseButton1Click:Connect(function() onPick(c) end)
		end
		register(row, text)
	end

	local function keyLabel(keys) return keys[1].Name end

	----------------------------------------------------------------
	-- Pages, onglets (barre latérale) et sous-onglets
	----------------------------------------------------------------
	local function makeSection(text)
		local l = newLabel(V.nav, text, 11, T.SubText, Enum.Font.GothamBold)
		l.Position = UDim2.new(0, 18, 0, N.y + 6)
		l.Size = UDim2.new(1, -36, 0, 16)
		l.ZIndex = 4
		table.insert(N.sections, l)
		N.y += 30
	end

	local function makePage(name, icon, desc)
		local pg = { name = name, tabs = {}, tabOrder = {}, navY = N.y, barW = 4 }

		local item = Instance.new("TextButton")
		item.Name = "Nav_" .. name
		item.Position = UDim2.new(0, 10, 0, N.y)
		item.Size = UDim2.new(1, -20, 0, 40)
		item.BackgroundTransparency = 1
		item.AutoButtonColor = false
		item.Text = ""
		item.ZIndex = 5
		item.Parent = V.nav
		local ic = Instance.new("TextLabel")
		ic.BackgroundTransparency = 1
		ic.Position = UDim2.new(0, 0, 0, 0)
		ic.Size = UDim2.new(0, 46, 1, 0)
		ic.Font = Enum.Font.GothamMedium
		ic.TextSize = 18
		ic.TextColor3 = T.Text
		ic.TextTransparency = 0.4
		ic.Text = icon
		ic.ZIndex = 6
		ic.Parent = item
		local tx = newLabel(item, name, 14, T.SubText, Enum.Font.GothamMedium)
		tx.Position = UDim2.new(0, 46, 0, 0)
		tx.Size = UDim2.new(1, -50, 1, 0)
		tx.ZIndex = 6
		tx.TextTruncate = Enum.TextTruncate.AtEnd
		item.MouseEnter:Connect(function()
			if N.page ~= name then tw(tx, { TextColor3 = T.Text }, 0.12) end
		end)
		item.MouseLeave:Connect(function()
			if N.page ~= name then tw(tx, { TextColor3 = T.SubText }, 0.12) end
		end)
		item.MouseButton1Click:Connect(function() N.selectPage(name) end)
		pg.item, pg.txt, pg.icon = item, tx, ic
		N.y += 44

		local holder = Instance.new("Frame")
		holder.Name = "Page_" .. name
		holder.BackgroundTransparency = 1
		holder.Size = UDim2.new(1, 0, 1, 0)
		holder.Visible = false
		holder.ZIndex = 2
		holder.Parent = V.content
		pg.holder = holder

		local title = newLabel(holder, name, 26, T.Text, Enum.Font.GothamBold)
		title.Position = UDim2.new(0, 28, 0, 16)
		title.Size = UDim2.new(1, -56, 0, 32)
		local d = newLabel(holder, desc or "", 13, T.SubText, Enum.Font.Gotham)
		d.Position = UDim2.new(0, 28, 0, 48)
		d.Size = UDim2.new(1, -56, 0, 18)
		d.TextTruncate = Enum.TextTruncate.AtEnd

		local bar = Instance.new("Frame")
		bar.Position = UDim2.new(0, 28, 0, 80)
		bar.Size = UDim2.new(0, 10, 0, 38)
		bar.BackgroundColor3 = T.Card
		bar.BorderSizePixel = 0
		bar.ZIndex = 3
		bar.Parent = holder
		corner(bar, 11)
		stroke(bar, T.Stroke, 1)
		local ind = Instance.new("Frame")
		ind.BackgroundColor3 = T.Accent
		ind.BackgroundTransparency = 0.82
		ind.BorderSizePixel = 0
		ind.ZIndex = 3
		ind.Parent = bar
		corner(ind, 8)
		stroke(ind, T.Accent, 1).Transparency = 0.55
		pg.bar, pg.ind = bar, ind

		local area = Instance.new("CanvasGroup")
		area.BackgroundTransparency = 1
		area.BorderSizePixel = 0
		area.ZIndex = 2
		area.Parent = holder
		pg.area = area
		pg.areaBase = UDim2.new(0, 28, 0, 130)
		area.Position = pg.areaBase
		area.Size = UDim2.new(1, -56, 1, -130)

		N.pages[name] = pg
		table.insert(N.order, name)
		N.cur = pg
		return pg
	end

	local function makeTab(name)
		local pg = N.cur
		pg.active_build = name

		local sf = Instance.new("ScrollingFrame")
		sf.Name = "Tab_" .. name
		sf.Size = UDim2.new(1, 0, 1, 0)
		sf.BackgroundTransparency = 1
		sf.BorderSizePixel = 0
		sf.CanvasSize = UDim2.new()
		sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
		sf.ScrollBarThickness = 4
		sf.ScrollBarImageColor3 = T.Accent
		sf.Visible = false
		sf.ZIndex = 2
		sf.Parent = pg.area
		local pd = Instance.new("UIPadding", sf)
		pd.PaddingTop = UDim.new(0, 4)
		pd.PaddingBottom = UDim.new(0, 20)
		pd.PaddingRight = UDim.new(0, 8)
		local ll = Instance.new("UIListLayout", sf)
		ll.Padding = UDim.new(0, 8)
		ll.SortOrder = Enum.SortOrder.LayoutOrder

		local w = TextService:GetTextSize(name, 13, Enum.Font.GothamMedium, Vector2.new(400, 30)).X + 30
		local btn = Instance.new("TextButton")
		btn.Position = UDim2.new(0, pg.barW, 0, 4)
		btn.Size = UDim2.new(0, w, 1, -8)
		btn.BackgroundTransparency = 1
		btn.AutoButtonColor = false
		btn.Font = Enum.Font.GothamMedium
		btn.TextSize = 13
		btn.TextColor3 = T.SubText
		btn.Text = name
		btn.ZIndex = 5
		btn.Parent = pg.bar
		btn.MouseEnter:Connect(function()
			if pg.active ~= name then tw(btn, { TextColor3 = T.Text }, 0.12) end
		end)
		btn.MouseLeave:Connect(function()
			if pg.active ~= name then tw(btn, { TextColor3 = T.SubText }, 0.12) end
		end)
		btn.MouseButton1Click:Connect(function() N.showTab(pg, name) end)

		pg.tabs[name] = { sf = sf, btn = btn, x = pg.barW, w = w }
		table.insert(pg.tabOrder, name)
		pg.barW += w + 4
		pg.bar.Size = UDim2.new(0, pg.barW, 0, 38)

		N.scroll = sf
		N.ord = 0
	end

	----------------------------------------------------------------
	-- Contenu des pages
	----------------------------------------------------------------
	makeSection("JOUEUR")

	makePage("Mouvement", "🏃", "Vol, vitesse, saut et nage")
	makeTab("Vol")
	makeToggle("Fly", function() return Config.Fly.Enabled end, setFly, keyLabel(Config.Keys.Fly))
	makeToggle("Fly : le véhicule vole (sinon éjecté)", function() return Config.Fly.VehicleMode end, setFlyVehicle)
	makeToggle("Noclip", function() return Config.Noclip.Enabled end, setNoclip, keyLabel(Config.Keys.Noclip))
	makeToggle("Saut infini", function() return Config.InfJump.Enabled end, setInfJump, keyLabel(Config.Keys.InfJump))
	makeInputBox("Vitesse de vol (sans limite)", function() return Config.Fly.Speed end, setFlySpeed)
	makeTab("Vitesse")
	makeToggle("Walkspeed perso", function() return Config.Walk.Enabled end, setWalkEnabled)
	makeInputBox("Walkspeed (sans limite)", function() return Config.Walk.Speed end, setWalkSpeed)
	makeToggle("Jump perso", function() return Config.Jump.Enabled end, setJumpEnabled)
	makeSlider("Jump Power (case = sans limite)", Config.Jump.Min, Config.Jump.Max, function() return Config.Jump.Power end, setJumpPower)
	makeTab("Nage")
	makeToggle("Vitesse de nage perso", function() return Config.Swim.Enabled end, setSwimEnabled)
	makeInputBox("Vitesse de nage (sans limite)", function() return Config.Swim.Speed end, setSwimSpeed)
	makeNote("La nage utilise une détection d'eau du Terrain : elle fonctionne même si le jeu gère des ragdolls.")

	makePage("Téléportation", "📍", "Se déplacer, observer et ramener les joueurs")
	makeTab("Téléport")
	makeToggle("Click TP (Shift + clic)", function() return Config.TP.ClickTP end, setClickTP, keyLabel(Config.Keys.ClickTP))
	makeTextAction("TP à un joueur", "nom (ou début)", "TP", tpByName)
	makeButton("TP au joueur suivant   [PgDn]", function() tpCycle(1) end)
	makeButton("TP au joueur précédent   [PgUp]", function() tpCycle(-1) end)
	makeTab("Positions")
	makeButton("Sauvegarder la position   [Insert]", function() savePosition(); U.notify("Position sauvegardée") end)
	makeButton("Retourner à la position   [Delete]", function() loadPosition(); U.notify("Retour à la position") end)
	makeButton("TP au spawn", tpSpawn)
	makeTab("Observer")
	makeTextAction("View un joueur", "nom (ou début)", "View", function(t)
		local p = findPlayerByName(t)
		if p and viewPlayer(p) then U.notify("View : " .. p.Name) else U.notify("Joueur introuvable") end
	end)
	makeButton("View joueur suivant   [End]", function()
		local p = viewCycle(1)
		U.notify(p and ("View : " .. p.Name) or "Aucun joueur")
	end)
	makeButton("View joueur précédent", function()
		local p = viewCycle(-1)
		U.notify(p and ("View : " .. p.Name) or "Aucun joueur")
	end)
	makeButton("Arrêter le view   [Home]", function() stopView(); U.notify("View arrêté") end)
	makeTab("Bring")
	makeNote("Visuel côté client : tu vois les joueurs devant toi, mais ils ne bougent pas pour les autres.")
	makeToggle("Client Bring", function() return Config.Bring.Enabled end, setBring, keyLabel(Config.Keys.Bring))
	makeSegment("Cible", { { "Un joueur", "Player" }, { "Tous", "All" } },
		function() return Config.Bring.Mode end, setBringMode)
	makeTextAction("Bring un joueur", "nom (ou début)", "Bring", function(t)
		local p = bringPlayer(t)
		U.notify(p and ("Bring : " .. p.Name) or "Joueur introuvable")
	end)
	makeSegment("Formation", { { "Ligne", "Line" }, { "Cercle", "Circle" }, { "Derrière", "Behind" }, { "Empilés", "Stack" } },
		function() return Config.Bring.Formation end, setBringFormation)
	makeInputBox("Distance devant toi (studs)", function() return Config.Bring.Distance end,
		function(v) Config.Bring.Distance = v; refreshUI() end)
	makeInputBox("Hauteur", function() return Config.Bring.Height end,
		function(v) Config.Bring.Height = v; refreshUI() end)
	makeInputBox("Écart entre joueurs (studs)", function() return Config.Bring.Spacing end,
		function(v) Config.Bring.Spacing = v; refreshUI() end)
	makeToggle("Déplacement fluide", function() return Config.Bring.Smooth end,
		function(v) Config.Bring.Smooth = v; refreshUI() end)
	makeInputBox("Vitesse du fluide (0.01 à 1)", function() return Config.Bring.SmoothSpeed end,
		function(v) Config.Bring.SmoothSpeed = v; refreshUI() end)
	makeToggle("Ils me regardent", function() return Config.Bring.FaceMe end,
		function(v) Config.Bring.FaceMe = v; refreshUI() end)
	makeToggle("Ignorer les joueurs assis", function() return Config.Bring.SkipSeated end,
		function(v) Config.Bring.SkipSeated = v; refreshUI() end)
	makeToggle("Ignorer mon équipe (mode Tous)", function() return Config.Bring.TeamCheck end,
		function(v) Config.Bring.TeamCheck = v; refreshUI() end)

	makeSection("COMBAT")

	makePage("Combat", "🎯", "Visée, ESP et réglages d'armes")
	makeTab("Visée")
	makeToggle("Aimbot", function() return Config.Aimbot.Enabled end, setAimbot, keyLabel(Config.Keys.Aimbot))
	makeToggle("Silent Aim", function() return Config.SilentAim.Enabled end, setSilent, keyLabel(Config.Keys.SilentAim))
	makeToggle("ESP", function() return Config.ESP.Enabled end, setESP, keyLabel(Config.Keys.ESP))
	makeInputBox("FOV (Aimbot + Silent)", function() return Config.Aimbot.FOV end,
		function(v) Config.Aimbot.FOV = v; Config.SilentAim.FOV = v; refreshUI() end)
	makeTab("Armes")
	makeToggle("Fast Mod", function() return Config.FastMod.Enabled end, setFastMod, keyLabel(Config.Keys.FastMod))
	makeToggle("Tir auto", function() return Config.FastMod.AutoFire end, setAutoFire, keyLabel(Config.Keys.AutoFire))
	makeSlider("Délai max Fast Mod (ms)", 0, 500, function() return math.floor(Config.FastMod.Delay * 1000 + 0.5) end, setFastDelayMs)
	makeInputBox("Cadence du tir auto (s)", function() return Config.FastMod.AutoFireDelay end,
		function(v) Config.FastMod.AutoFireDelay = v; refreshUI() end)
	makeButton("Réappliquer le Fast Mod maintenant", function()
		if Config.FastMod.Enabled then fastPatchAll(); U.notify("Fast Mod réappliqué") else U.notify("Active d'abord le Fast Mod") end
	end)
	makeTab("Fast Mod avancé")
	makeToggle("Modifier les modules de l'arme", function() return Config.FastMod.PatchModules end,
		function(v) Config.FastMod.PatchModules = v; refreshUI() end)
	makeToggle("Surveiller les valeurs (anti-reset)", function() return Config.FastMod.Watch end,
		function(v) Config.FastMod.Watch = v; refreshUI() end)
	makeToggle("Animations d'attaque rapides", function() return Config.FastMod.AnimBoost end,
		function(v) Config.FastMod.AnimBoost = v; refreshUI() end)
	makeInputBox("Vitesse des animations (x)", function() return Config.FastMod.AnimSpeed end,
		function(v) Config.FastMod.AnimSpeed = v; refreshUI() end)
	makeInputBox("Valeur min des cadences", function() return Config.FastMod.RateValue end,
		function(v) Config.FastMod.RateValue = v; refreshUI() end)
	makeTextAction("Mot-clé délai", "ex: cooldown", "Ajouter", function(t)
		U.notify(addFastKeyword(Config.FastMod.DelayKeywords, t) and "Mot-clé ajouté" or "Déjà présent ou vide")
	end)
	makeTextAction("Mot-clé cadence", "ex: rpm", "Ajouter", function(t)
		U.notify(addFastKeyword(Config.FastMod.RateKeywords, t) and "Mot-clé ajouté" or "Déjà présent ou vide")
	end)

	makePage("Walk Fling", "💥", "Fling au contact et notifications de kill")
	makeTab("Fling")
	makeToggle("Walk Fling", function() return Config.WalkFling.Enabled end, setWalkFling, keyLabel(Config.Keys.WalkFling))
	makeToggle("Seulement près des joueurs",
		function() return Config.WalkFling.OnlyNearPlayers end,
		function(v) Config.WalkFling.OnlyNearPlayers = v; refreshUI() end)
	makeInputBox("Portée du fling (studs)",
		function() return Config.WalkFling.TriggerRange end,
		function(v) Config.WalkFling.TriggerRange = v; refreshUI() end)
	makeToggle("Retour auto à la position sûre",
		function() return Config.WalkFling.SafeReturn end,
		function(v) Config.WalkFling.SafeReturn = v; if not v then lastSafeCF = nil end; refreshUI() end)
	makeSlider("Puissance (case = sans limite)", Config.WalkFling.Min, Config.WalkFling.Max, function() return Config.WalkFling.Power end, setFlingPower)
	makeNote("Touches , et . pour baisser / monter la puissance.")
	makeTab("Kills")
	makeToggle("Notifier mes kills (pseudo)", function() return Config.Kills.Enabled end,
		function(v) Config.Kills.Enabled = v; refreshUI() end)
	makeInputBox("Délai contact → mort (s)", function() return Config.Kills.Window end,
		function(v) Config.Kills.Window = v; refreshUI() end)

	makeSection("MONDE")

	makePage("BTools", "🔨", "Boîte à outils de construction type F3X")
	makeTab("Général")
	makeNote("Déplacer, redimensionner, pivoter, couleur, matière, surfaces, lumières, effets, mesh, textures, soudures, physique, création. Tout se passe chez toi (côté client) : les autres joueurs ne voient pas les changements.")
	makeToggle("BTools (ouvre le panneau)", function() return Config.BTools.Enabled end, function(v) BTf.setEnabled(v) end, keyLabel(Config.Keys.BTools))
	makeToggle("Ignorer les joueurs et PNJ", function() return Config.BTools.IgnorePlayers end,
		function(v) Config.BTools.IgnorePlayers = v; refreshUI() end)
	makeToggle("Surbrillance au survol", function() return Config.BTools.ShowHover end,
		function(v) Config.BTools.ShowHover = v; refreshUI() end)
	makeToggle("Glisser les objets directement", function() return Config.BTools.FreeDrag end,
		function(v) Config.BTools.FreeDrag = v; refreshUI() end)
	makeInputBox("Pas de déplacement (studs)", function() return Config.BTools.MoveStep end,
		function(v) Config.BTools.MoveStep = math.max(v, 0); refreshUI() end)
	makeInputBox("Pas de taille (studs)", function() return Config.BTools.ResizeStep end,
		function(v) Config.BTools.ResizeStep = math.max(v, 0); refreshUI() end)
	makeInputBox("Pas de rotation (degrés)", function() return Config.BTools.RotateStep end,
		function(v) Config.BTools.RotateStep = math.max(v, 0); refreshUI() end)
	makeTab("Historique")
	makeButton("Annuler   [Ctrl+Z]", function() BTf.undo() end)
	makeButton("Rétablir   [Ctrl+Y]", function() BTf.redo() end)
	makeButton("Tout annuler", function() BTf.undoAll() end, true)
	makeNote("Raccourcis : V = changer d'outil • Ctrl+Z / Ctrl+Y = annuler / rétablir • Ctrl+D = cloner • Retour arrière = supprimer. Clic = sélectionner, Ctrl+clic = multi-sélection, Shift+clic = modèle entier.")

	makePage("Réglages", "⚙️", "Apparence de l'interface et extras")
	makeTab("Apparence")
	makeSwatches("Couleur d'accent", {
		Color3.fromRGB(124, 108, 255), Color3.fromRGB(70, 150, 255), Color3.fromRGB(50, 210, 220),
		Color3.fromRGB(60, 200, 120), Color3.fromRGB(255, 190, 60), Color3.fromRGB(255, 120, 70),
		Color3.fromRGB(240, 80, 80), Color3.fromRGB(255, 95, 160),
	}, function(c) U.setAccent(c) end)
	makeToggle("Flou d'arrière-plan", function() return M.Blur end, function(v) M.Blur = v; U.updateFx(); refreshUI() end)
	makeSlider("Intensité du flou", 0, 40, function() return M.BlurSize end,
		function(v) M.BlurSize = math.clamp(math.floor(v), 0, 56); U.updateFx(); refreshUI() end)
	makeToggle("Assombrir l'arrière-plan", function() return M.Dim end, function(v) M.Dim = v; U.updateFx(); refreshUI() end)
	makeToggle("Animations", function() return M.Animations end, function(v) M.Animations = v; refreshUI() end)
	makeToggle("Bordure et barre animées", function() return M.AnimBorder end,
		function(v) M.AnimBorder = v; U.setShimmer(v); refreshUI() end)
	makeToggle("Notifications des boutons", function() return Config.Notify.Toggles end,
		function(v) Config.Notify.Toggles = v; refreshUI() end)
	makeButton("Réinitialiser la taille et la position", function() U.resetWindow() end)
	makeTab("Nextbot")
	makeButton("Spam Nextbot (spawn 1)", function() spawnLocalNextbot() end)
	makeInputBox("Vitesse du Nextbot", function() return Config.NextbotSpam.Speed end,
		function(v) Config.NextbotSpam.Speed = v; refreshUI() end)

	----------------------------------------------------------------
	-- Finalisation des pages (barre de sous-onglets masquée si un seul)
	----------------------------------------------------------------
	for _, name in ipairs(N.order) do
		local pg = N.pages[name]
		if #pg.tabOrder <= 1 then
			pg.bar.Visible = false
			pg.areaBase = UDim2.new(0, 28, 0, 86)
			pg.area.Position = pg.areaBase
			pg.area.Size = UDim2.new(1, -56, 1, -86)
		end
		local first = pg.tabOrder[1]
		if first then N.showTab(pg, first, true) end
	end

	----------------------------------------------------------------
	-- Ouverture / fermeture / réduction / flou
	----------------------------------------------------------------
	function U.updateFx()
		local showFx = N.open and not N.minimized
		tw(blur, { Size = (showFx and M.Blur) and M.BlurSize or 0 }, 0.4)
		tw(dim, { BackgroundTransparency = (showFx and M.Dim) and 0.74 or 1 }, 0.4)
	end

	function U.setOpen(v)
		if v == N.open then return end
		N.open = v
		if v then
			main.Visible = true
			scale.Scale = 0.9
			tw(scale, { Scale = 1 }, 0.45, Enum.EasingStyle.Back)
		else
			tw(scale, { Scale = 0.94 }, 0.2)
			task.delay(dur(0.2), function()
				if not N.open then main.Visible = false end
			end)
		end
		U.updateFx()
	end

	function U.toggleMenu() U.setOpen(not N.open) end

	function U.setMinimized(v)
		N.minimized = v
		if v then
			tw(main, { Size = UDim2.new(0, math.min(FULL.X.Offset, 600), 0, HEAD_H) }, 0.35, Enum.EasingStyle.Quint)
			task.delay(dur(0.33), function()
				if N.minimized then body.Visible = false end
			end)
			V.sbox.Visible = false
			V.miniBtn.Text = "▢"
		else
			body.Visible = true
			tw(main, { Size = FULL }, 0.4, Enum.EasingStyle.Back)
			V.sbox.Visible = not N.compact
			V.miniBtn.Text = "—"
		end
		U.updateFx()
	end

	V.miniBtn.MouseButton1Click:Connect(function() U.setMinimized(not N.minimized) end)
	V.closeBtn.MouseButton1Click:Connect(function()
		U.setOpen(false)
		U.notify("Menu masqué : appuie sur RightCtrl pour le rouvrir")
	end)

	local function applyLayout()
		local vp = camera.ViewportSize
		local w = math.min(M.Width, vp.X - 20)
		local h = math.min(M.Height, vp.Y - 40)
		FULL = UDim2.new(0, w, 0, h)
		N.compact = w < 780
		local sbw = N.compact and 68 or SIDE_W
		V.sidebar.Size = UDim2.new(0, sbw, 1, 0)
		V.content.Position = UDim2.new(0, sbw, 0, 0)
		V.content.Size = UDim2.new(1, -sbw, 1, 0)
		for _, p in pairs(N.pages) do p.txt.Visible = not N.compact end
		for _, s in ipairs(N.sections) do s.Visible = not N.compact end
		V.userNm.Visible = not N.compact
		V.userSt.Visible = not N.compact
		V.chips.Visible = not N.compact
		V.sub.Visible = not N.compact
		V.sbox.Visible = not N.minimized
		if not N.minimized then main.Size = FULL end
	end

	function U.resetWindow()
		M.Width, M.Height = M.DefaultWidth, M.DefaultHeight
		main.Position = M.StartPosition
		applyLayout()
	end

	applyLayout()
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(applyLayout)

	-- poignée de redimensionnement
	do
		local grip = Instance.new("TextButton")
		grip.Name = "Grip"
		grip.AnchorPoint = Vector2.new(1, 1)
		grip.Position = UDim2.new(1, -5, 1, -5)
		grip.Size = UDim2.new(0, 20, 0, 20)
		grip.BackgroundTransparency = 1
		grip.Font = Enum.Font.GothamBold
		grip.TextSize = 14
		grip.TextColor3 = T.SubText
		grip.Text = "◢"
		grip.ZIndex = 30
		grip.Parent = main
		local gDrag, gStart, gW, gH = false, nil, 0, 0
		grip.MouseEnter:Connect(function() tw(grip, { TextColor3 = T.Accent }, 0.12) end)
		grip.MouseLeave:Connect(function() tw(grip, { TextColor3 = T.SubText }, 0.12) end)
		grip.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				gDrag, gStart, gW, gH = true, i.Position, M.Width, M.Height
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if gDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local d = i.Position - gStart
				M.Width = math.clamp(gW + d.X * 2, 640, 1100) -- la fenêtre est centrée : ×2 pour suivre le curseur
				M.Height = math.clamp(gH + d.Y * 2, 420, 760)
				applyLayout()
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				gDrag = false
			end
		end)
	end

	-- animation d'apparition au lancement
	scale.Scale = 0.88
	N.selectPage("Mouvement")
	tw(scale, { Scale = 1 }, 0.6, Enum.EasingStyle.Back)
	U.updateFx()
	U.setShimmer(M.AnimBorder)
	refreshUI()
end

----------------------------------------------------------------------
-- BLOC 2 : BTools complets (type F3X) - côté client uniquement
----------------------------------------------------------------------
do
	local BT = Config.BTools
	local gui, T, notify = U.gui, U.T, U.notify
	local corner, stroke, tw, newLabel = U.corner, U.stroke, U.tw, U.newLabel
	local S, A, W = {}, {}, {} -- S = sélection / géométrie, A = actions, W = widgets du panneau

	local selection, selSet, selListeners = {}, {}, {}
	local undoStack, redoStack = {}, {}
	local dragState, freeDrag, clickDown = nil, nil, nil
	local handleBusy, handleUpAt, pickMode = false, 0, nil
	local infoLabel, opts, dock = nil, nil, nil
	local toolButtons, builders = {}, {}

	local PALETTE = {
		Color3.fromRGB(242, 243, 243), Color3.fromRGB(163, 162, 165), Color3.fromRGB(99, 95, 98), Color3.fromRGB(27, 42, 53),
		Color3.fromRGB(196, 40, 28), Color3.fromRGB(218, 133, 65), Color3.fromRGB(245, 205, 48), Color3.fromRGB(164, 189, 71),
		Color3.fromRGB(40, 127, 71), Color3.fromRGB(18, 238, 212), Color3.fromRGB(4, 175, 236), Color3.fromRGB(13, 105, 172),
		Color3.fromRGB(0, 32, 96), Color3.fromRGB(98, 37, 209), Color3.fromRGB(255, 0, 191), Color3.fromRGB(255, 152, 220),
		Color3.fromRGB(124, 92, 70), Color3.fromRGB(217, 133, 108), Color3.fromRGB(215, 197, 154), Color3.fromRGB(255, 176, 0),
		Color3.fromRGB(0, 255, 0), Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 0, 255), Color3.fromRGB(167, 94, 155),
	}
	local MATERIALS = {
		"Plastic", "SmoothPlastic", "Neon", "Glass", "ForceField", "Metal", "DiamondPlate", "CorrodedMetal",
		"Foil", "Wood", "WoodPlanks", "Brick", "Concrete", "Granite", "Marble", "Slate", "Cobblestone",
		"Pebble", "Sand", "Grass", "Ice", "Fabric",
	}
	local FACES = { "Top", "Bottom", "Front", "Back", "Left", "Right" }
	local FACE_OPTIONS = {
		{ "Haut", "Top" }, { "Bas", "Bottom" }, { "Devant", "Front" },
		{ "Derrière", "Back" }, { "Gauche", "Left" }, { "Droite", "Right" },
	}
	local SURF_PROP = {
		Top = "TopSurface", Bottom = "BottomSurface", Front = "FrontSurface",
		Back = "BackSurface", Left = "LeftSurface", Right = "RightSurface",
	}
	-- { id, icône, nom } ; les ids qui commencent par @ sont des actions immédiates
	local TOOLS = {
		{ "Select", "◎", "Choisir" }, { "Move", "↔", "Déplacer" }, { "Resize", "⤢", "Taille" }, { "Rotate", "⟳", "Pivoter" },
		{ "Paint", "🎨", "Couleur" }, { "Material", "🧱", "Matière" }, { "Surface", "▦", "Surface" }, { "Light", "💡", "Lumière" },
		{ "Decorate", "🔥", "Effets" }, { "Mesh", "◆", "Mesh" }, { "Texture", "🖼", "Texture" }, { "Weld", "🔗", "Souder" },
		{ "Physics", "⚓", "Physique" }, { "Create", "➕", "Créer" }, { "@Clone", "⧉", "Cloner" }, { "@Delete", "🗑", "Suppr." },
	}
	local TOOL_TITLES = {}
	for _, t in ipairs(TOOLS) do TOOL_TITLES[t[1]] = t[3] end

	----------------------------------------------------------------
	-- Utilitaires
	----------------------------------------------------------------
	function S.snap(v, step)
		if step and step > 0 then return math.round(v / step) * step end
		return v
	end

	function S.num(v)
		if type(v) ~= "number" then return tostring(v or "") end
		return tostring(math.floor(v * 100 + 0.5) / 100)
	end

	function S.valid(p)
		return typeof(p) == "Instance" and p:IsA("BasePart") and p.Parent ~= nil and not p:IsA("Terrain")
	end

	function S.ctrl() return UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl) end
	function S.shift() return UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift) end

	function S.parseColor(text)
		text = (text or ""):gsub("%s", "")
		local r, g, b = text:match("^(%d+),(%d+),(%d+)$")
		if r then
			return Color3.fromRGB(math.clamp(tonumber(r), 0, 255), math.clamp(tonumber(g), 0, 255), math.clamp(tonumber(b), 0, 255))
		end
		local hex = text:gsub("^#", "")
		if #hex == 6 and hex:match("^%x+$") then
			return Color3.fromRGB(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
		end
		return nil
	end

	function S.hex(c)
		return string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
	end

	function S.assetId(text)
		text = (text or ""):gsub("%s", "")
		if text == "" then return "" end
		if tonumber(text) then return "rbxassetid://" .. text end
		return text
	end

	----------------------------------------------------------------
	-- Sélection
	----------------------------------------------------------------
	local boxes = Instance.new("Folder")
	boxes.Name = "BToolsSelection"
	boxes.Parent = gui

	function S.fire()
		for _, f in ipairs(selListeners) do pcall(f) end
	end

	function S.prune()
		local changed = false
		for i = #selection, 1, -1 do
			local p = selection[i]
			if not S.valid(p) then
				local sb = selSet[p]
				if sb then sb:Destroy() end
				selSet[p] = nil
				table.remove(selection, i)
				changed = true
			end
		end
		if changed then S.fire() end
	end

	function S.add(part)
		if selSet[part] then return end
		local sb = Instance.new("SelectionBox")
		sb.Adornee = part
		sb.Color3 = T.Accent
		sb.SurfaceColor3 = T.Accent
		sb.SurfaceTransparency = 0.85
		sb.LineThickness = 0.03
		sb.Parent = boxes
		selSet[part] = sb
		table.insert(selection, part)
	end

	function S.remove(part)
		local sb = selSet[part]
		if sb then sb:Destroy() end
		selSet[part] = nil
		local i = table.find(selection, part)
		if i then table.remove(selection, i) end
	end

	function S.clear()
		for _, sb in pairs(selSet) do sb:Destroy() end
		table.clear(selSet)
		table.clear(selection)
	end

	function S.copy()
		S.prune()
		return table.clone(selection)
	end

	-- boîte englobante alignée sur le monde : renvoie (centre, taille)
	function S.aabb(parts)
		local mn = Vector3.new(math.huge, math.huge, math.huge)
		local mx = Vector3.new(-math.huge, -math.huge, -math.huge)
		for _, p in ipairs(parts) do
			local cf, half = p.CFrame, p.Size / 2
			for sx = -1, 1, 2 do
				for sy = -1, 1, 2 do
					for sz = -1, 1, 2 do
						local w = cf:PointToWorldSpace(Vector3.new(sx * half.X, sy * half.Y, sz * half.Z))
						mn = Vector3.new(math.min(mn.X, w.X), math.min(mn.Y, w.Y), math.min(mn.Z, w.Z))
						mx = Vector3.new(math.max(mx.X, w.X), math.max(mx.Y, w.Y), math.max(mx.Z, w.Z))
					end
				end
			end
		end
		return (mn + mx) / 2, mx - mn
	end

	function S.summary()
		local n = #selection
		if n == 0 then return "Aucun objet sélectionné" end
		if n == 1 then
			local p = selection[1]
			return string.format("%s  (%s)\nTaille %.2f × %.2f × %.2f", p.Name, p.ClassName, p.Size.X, p.Size.Y, p.Size.Z)
		end
		return n .. " objets sélectionnés"
	end

	----------------------------------------------------------------
	-- Historique (annuler / rétablir)
	----------------------------------------------------------------
	function S.push(label, undoFn, redoFn)
		table.insert(undoStack, { label = label, undo = undoFn, redo = redoFn })
		if #undoStack > 200 then table.remove(undoStack, 1) end
		table.clear(redoStack)
	end

	function S.snapshot(parts)
		local s = {}
		for _, p in ipairs(parts) do
			table.insert(s, { p = p, cf = p.CFrame, size = p.Size })
		end
		return s
	end

	function S.restore(snap)
		for _, e in ipairs(snap) do
			if e.p.Parent then
				e.p.Size = e.size
				e.p.CFrame = e.cf
			end
		end
	end

	function S.pushT(label, before, after)
		S.push(label, function() S.restore(before) end, function() S.restore(after) end)
	end

	function S.commit(label, created, removed)
		S.push(label,
			function()
				for _, c in ipairs(created) do c.inst.Parent = nil end
				for _, r in ipairs(removed) do r.inst.Parent = r.parent end
			end,
			function()
				for _, r in ipairs(removed) do r.inst.Parent = nil end
				for _, c in ipairs(created) do c.inst.Parent = c.parent end
			end)
	end

	function BTf.undo(silent)
		local e = table.remove(undoStack)
		if not e then
			if not silent then notify("Rien à annuler") end
			return
		end
		pcall(e.undo)
		table.insert(redoStack, e)
		S.prune()
		if not silent then notify("Annulé : " .. e.label) end
	end

	function BTf.redo()
		local e = table.remove(redoStack)
		if not e then
			notify("Rien à rétablir")
			return
		end
		pcall(e.redo)
		table.insert(undoStack, e)
		S.prune()
		notify("Rétabli : " .. e.label)
	end

	function BTf.undoAll()
		local n = #undoStack
		while #undoStack > 0 do BTf.undo(true) end
		notify(n .. " action(s) annulée(s)")
	end

	----------------------------------------------------------------
	-- Actions sur la sélection
	----------------------------------------------------------------
	function A.need()
		local parts = S.copy()
		if #parts == 0 then
			notify("Sélectionne d'abord un objet")
			return nil
		end
		return parts
	end

	-- props : table, ou fonction(part) -> table
	function A.edit(parts, props, label)
		local before, after = {}, {}
		for _, p in ipairs(parts) do
			local pr = type(props) == "function" and props(p) or props
			local b = {}
			for k in pairs(pr) do b[k] = p[k] end
			before[p] = b
			after[p] = pr
			for k, v in pairs(pr) do
				pcall(function() p[k] = v end)
			end
		end
		local function apply(map)
			for p, vals in pairs(map) do
				for k, v in pairs(vals) do
					pcall(function() p[k] = v end)
				end
			end
		end
		S.push(label, function() apply(before) end, function() apply(after) end)
	end

	function A.replace(parts, className, props, label, nameOverride)
		local created, removed = {}, {}
		local nm = nameOverride or ("BTools" .. className)
		for _, p in ipairs(parts) do
			local old = p:FindFirstChild(nm)
			if old then
				table.insert(removed, { inst = old, parent = p })
				old.Parent = nil
			end
			local inst = Instance.new(className)
			inst.Name = nm
			for k, v in pairs(props) do
				pcall(function() inst[k] = v end)
			end
			inst.Parent = p
			table.insert(created, { inst = inst, parent = p })
		end
		S.commit(label, created, removed)
		notify(label .. " : " .. #parts .. " objet(s)")
	end

	function A.removeNamed(parts, names, label)
		local removed = {}
		for _, p in ipairs(parts) do
			for _, nm in ipairs(names) do
				local c = p:FindFirstChild(nm)
				if c then
					table.insert(removed, { inst = c, parent = p })
					c.Parent = nil
				end
			end
		end
		if #removed == 0 then
			notify("Rien à retirer")
			return
		end
		S.commit(label, {}, removed)
		notify(label)
	end

	function A.delete()
		local parts = A.need()
		if not parts then return end
		local parents = {}
		for _, p in ipairs(parts) do parents[p] = p.Parent end
		S.clear()
		S.fire()
		for _, p in ipairs(parts) do p.Parent = nil end
		S.push("Suppression",
			function() for _, p in ipairs(parts) do p.Parent = parents[p] end end,
			function() for _, p in ipairs(parts) do p.Parent = nil end end)
		notify(#parts .. " objet(s) supprimé(s)")
	end

	function A.clone()
		local parts = A.need()
		if not parts then return end
		local clones, parents = {}, {}
		for _, p in ipairs(parts) do
			local ok, c = pcall(function() return p:Clone() end)
			if ok and c then
				parents[c] = p.Parent
				c.Parent = p.Parent
				table.insert(clones, c)
			end
		end
		if #clones == 0 then
			notify("Impossible de cloner")
			return
		end
		S.clear()
		for _, c in ipairs(clones) do S.add(c) end
		S.fire()
		S.push("Clonage",
			function() for _, c in ipairs(clones) do c.Parent = nil end end,
			function() for _, c in ipairs(clones) do c.Parent = parents[c] end end)
		notify(#clones .. " objet(s) cloné(s)")
	end

	function A.create()
		local shape = BT.NewShape
		local className = "Part"
		if shape == "Wedge" then className = "WedgePart" elseif shape == "CornerWedge" then className = "CornerWedgePart" end
		local p = Instance.new(className)
		p.Name = "BToolsPart"
		p.Size = BT.NewSize
		if className == "Part" then
			if shape == "Ball" then p.Shape = Enum.PartType.Ball
			elseif shape == "Cylinder" then p.Shape = Enum.PartType.Cylinder
			else p.Shape = Enum.PartType.Block end
		end
		p.Color = BT.Color
		pcall(function() p.Material = Enum.Material[BT.Material] end)
		p.Anchored = BT.NewAnchored
		p.CanCollide = BT.NewCollide
		local cam = camera.CFrame
		local pos = cam.Position + cam.LookVector * math.max(10, p.Size.Magnitude * 1.5)
		p.CFrame = CFrame.new(Vector3.new(S.snap(pos.X, BT.MoveStep), S.snap(pos.Y, BT.MoveStep), S.snap(pos.Z, BT.MoveStep)))
		p.Parent = workspace
		S.clear()
		S.add(p)
		S.fire()
		S.push("Création",
			function() p.Parent = nil end,
			function() p.Parent = workspace end)
		notify("Objet créé")
	end

	function A.paint()
		local parts = A.need()
		if not parts then return end
		A.edit(parts, { Color = BT.Color }, "Couleur")
	end

	function A.material(name)
		BT.Material = name
		local parts = S.copy()
		if #parts == 0 then return end
		local ok, mat = pcall(function() return Enum.Material[name] end)
		if ok and mat then A.edit(parts, { Material = mat }, "Matière") end
	end

	function A.surface()
		local parts = A.need()
		if not parts then return end
		local st = Enum.SurfaceType[BT.SurfaceType]
		local props = {}
		if BT.SurfaceFace == "All" then
			for _, prop in pairs(SURF_PROP) do props[prop] = st end
		else
			props[SURF_PROP[BT.SurfaceFace]] = st
		end
		A.edit(parts, props, "Surface")
	end

	function A.applyLight()
		local parts = A.need()
		if not parts then return end
		local cls = BT.LightType
		local props = {
			Brightness = BT.LightBrightness,
			Range = BT.LightRange,
			Color = BT.LightColor,
			Shadows = BT.LightShadows,
			Enabled = true,
		}
		if cls ~= "PointLight" then
			props.Angle = BT.LightAngle
			props.Face = Enum.NormalId[BT.LightFace]
		end
		A.replace(parts, cls, props, "Lumière")
	end

	function A.removeLights()
		local parts = A.need()
		if not parts then return end
		A.removeNamed(parts, { "BToolsPointLight", "BToolsSpotLight", "BToolsSurfaceLight" }, "Lumières retirées")
	end

	function A.preset(name)
		if name == "candle" then
			BT.LightType, BT.LightBrightness, BT.LightRange, BT.LightColor = "PointLight", 1.5, 14, Color3.fromRGB(255, 170, 80)
		elseif name == "neon" then
			BT.LightType, BT.LightBrightness, BT.LightRange, BT.LightColor = "PointLight", 3, 24, Color3.fromRGB(0, 255, 200)
		elseif name == "cold" then
			BT.LightType, BT.LightBrightness, BT.LightRange, BT.LightColor = "PointLight", 2, 22, Color3.fromRGB(150, 200, 255)
		elseif name == "red" then
			BT.LightType, BT.LightBrightness, BT.LightRange, BT.LightColor = "PointLight", 3, 18, Color3.fromRGB(255, 30, 30)
		elseif name == "lamp" then
			BT.LightType, BT.LightBrightness, BT.LightRange, BT.LightColor = "SurfaceLight", 2, 26, Color3.fromRGB(255, 235, 200)
			BT.LightAngle, BT.LightFace = 120, "Bottom"
		elseif name == "spot" then
			BT.LightType, BT.LightBrightness, BT.LightRange, BT.LightColor = "SpotLight", 6, 60, Color3.fromRGB(255, 255, 255)
			BT.LightAngle, BT.LightFace = 45, "Front"
		end
		if #S.copy() > 0 then A.applyLight() end
		W.refresh()
	end

	function A.applyFx()
		local parts = A.need()
		if not parts then return end
		local cls = BT.FxType
		local props
		if cls == "Fire" then
			props = { Color = BT.FxColor, SecondaryColor = BT.FxColor, Size = BT.FxSize, Heat = BT.FxHeat, Enabled = true }
		elseif cls == "Smoke" then
			props = { Color = BT.FxColor, Size = BT.FxSize, Opacity = 0.5, RiseVelocity = 4, Enabled = true }
		else
			props = { SparkleColor = BT.FxColor, Enabled = true }
		end
		A.replace(parts, cls, props, "Effet")
	end

	function A.removeFx()
		local parts = A.need()
		if not parts then return end
		A.removeNamed(parts, { "BToolsFire", "BToolsSmoke", "BToolsSparkles" }, "Effets retirés")
	end

	function A.applyMesh()
		local parts = A.need()
		if not parts then return end
		local props = { MeshType = Enum.MeshType[BT.MeshType], Scale = Vector3.one * BT.MeshScale }
		if BT.MeshType == "FileMesh" then
			props.MeshId = S.assetId(BT.MeshId)
			props.TextureId = S.assetId(BT.TextureId)
		end
		A.replace(parts, "SpecialMesh", props, "Mesh")
	end

	function A.removeMesh()
		local parts = A.need()
		if not parts then return end
		A.removeNamed(parts, { "BToolsSpecialMesh" }, "Mesh retiré")
	end

	function A.applyTexture()
		local parts = A.need()
		if not parts then return end
		local id = S.assetId(BT.TexId)
		if id == "" then
			notify("Entre un ID d'image")
			return
		end
		local faces = BT.TexFace == "All" and FACES or { BT.TexFace }
		for _, f in ipairs(faces) do
			local props = { Texture = id, Face = Enum.NormalId[f], Transparency = BT.TexTransparency }
			if BT.TexType == "Texture" then
				props.StudsPerTileU = 4
				props.StudsPerTileV = 4
			end
			A.replace(parts, BT.TexType, props, "Texture", "BToolsTex_" .. f)
		end
	end

	function A.removeTexture()
		local parts = A.need()
		if not parts then return end
		local names = {}
		for _, f in ipairs(FACES) do table.insert(names, "BToolsTex_" .. f) end
		A.removeNamed(parts, names, "Textures retirées")
	end

	function A.weld()
		local parts = A.need()
		if not parts then return end
		if #parts < 2 then
			notify("Sélectionne au moins 2 objets")
			return
		end
		local base = parts[1]
		local created = {}
		for i = 2, #parts do
			local w = Instance.new("WeldConstraint")
			w.Name = "BToolsWeld"
			w.Part0 = base
			w.Part1 = parts[i]
			w.Parent = parts[i]
			table.insert(created, { inst = w, parent = parts[i] })
		end
		S.commit("Soudure", created, {})
		notify("Soudé à " .. base.Name)
	end

	function A.unweld()
		local parts = A.need()
		if not parts then return end
		local removed = {}
		for _, p in ipairs(parts) do
			for _, c in ipairs(p:GetChildren()) do
				if c:IsA("WeldConstraint") or c:IsA("Weld") then
					table.insert(removed, { inst = c, parent = p })
					c.Parent = nil
				end
			end
		end
		if #removed == 0 then
			notify("Aucune soudure")
			return
		end
		S.commit("Soudures cassées", {}, removed)
		notify(#removed .. " soudure(s) cassée(s)")
	end

	function A.anchor(v)
		local parts = A.need()
		if not parts then return end
		A.edit(parts, { Anchored = v }, v and "Ancrage" or "Libération")
	end

	function A.collide(v)
		local parts = A.need()
		if not parts then return end
		A.edit(parts, { CanCollide = v }, v and "Collision ON" or "Collision OFF")
	end

	function A.setSize(ax, v)
		local parts = A.need()
		if not parts then return end
		v = math.clamp(v, 0.05, 2048)
		A.edit(parts, function(p)
			local s = p.Size
			return { Size = Vector3.new(ax == "X" and v or s.X, ax == "Y" and v or s.Y, ax == "Z" and v or s.Z) }
		end, "Taille")
	end

	function A.centerComp(ax)
		if #selection == 0 then return 0 end
		local c = S.aabb(selection)
		return c[ax]
	end

	function A.setPos(ax, v)
		local parts = A.need()
		if not parts then return end
		local c = S.aabb(parts)
		local d = Vector3.new(ax == "X" and v - c.X or 0, ax == "Y" and v - c.Y or 0, ax == "Z" and v - c.Z or 0)
		A.edit(parts, function(p) return { CFrame = p.CFrame + d } end, "Position")
	end

	function A.drop()
		local parts = A.need()
		if not parts then return end
		local center, size = S.aabb(parts)
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		local ex = table.clone(parts)
		if player.Character then table.insert(ex, player.Character) end
		params.FilterDescendantsInstances = ex
		local r = workspace:Raycast(center, Vector3.new(0, -5000, 0), params)
		if not r then
			notify("Aucun sol trouvé")
			return
		end
		local dy = r.Position.Y - (center.Y - size.Y / 2)
		local before = S.snapshot(parts)
		for _, p in ipairs(parts) do p.CFrame = p.CFrame + Vector3.new(0, dy, 0) end
		S.pushT("Poser au sol", before, S.snapshot(parts))
	end

	function A.rotate(axis, deg)
		local parts = A.need()
		if not parts then return end
		local center = S.aabb(parts)
		local before = S.snapshot(parts)
		local rot = CFrame.new(center) * CFrame.fromAxisAngle(axis, math.rad(deg)) * CFrame.new(-center)
		for _, p in ipairs(parts) do p.CFrame = rot * p.CFrame end
		S.pushT("Pivoter", before, S.snapshot(parts))
	end

	function A.resetRot()
		local parts = A.need()
		if not parts then return end
		local before = S.snapshot(parts)
		for _, p in ipairs(parts) do p.CFrame = CFrame.new(p.Position) end
		S.pushT("Rotation remise à 0", before, S.snapshot(parts))
	end

	function A.selectModels()
		local parts = A.need()
		if not parts then return end
		local n = 0
		for _, p in ipairs(parts) do
			local top = p:FindFirstAncestorOfClass("Model")
			while top and top.Parent and top.Parent:IsA("Model") do top = top.Parent end
			if top then
				for _, d in ipairs(top:GetDescendants()) do
					if S.valid(d) and not selSet[d] and n < 500 then
						S.add(d)
						n += 1
					end
				end
			end
		end
		S.fire()
		notify(n .. " objet(s) ajouté(s)")
	end

	function A.selectRadius()
		local parts = A.need()
		if not parts then return end
		local center = S.aabb(parts)
		local params = OverlapParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		if player.Character then params.FilterDescendantsInstances = { player.Character } end
		local n = 0
		for _, p in ipairs(workspace:GetPartBoundsInRadius(center, BT.SelRadius, params)) do
			if S.valid(p) and not selSet[p] and n < 500 then
				local model = p:FindFirstAncestorOfClass("Model")
				if not (BT.IgnorePlayers and model and model:FindFirstChildOfClass("Humanoid")) then
					S.add(p)
					n += 1
				end
			end
		end
		S.fire()
		notify(n .. " objet(s) ajouté(s)")
	end

	function A.selectSameName()
		local parts = A.need()
		if not parts then return end
		local ref = parts[1]
		local n = 0
		for _, d in ipairs(workspace:GetDescendants()) do
			if d.Name == ref.Name and d.ClassName == ref.ClassName and S.valid(d) and not selSet[d] and n < 500 then
				S.add(d)
				n += 1
			end
		end
		S.fire()
		notify(n .. " objet(s) ajouté(s)")
	end

	----------------------------------------------------------------
	-- Poignées (déplacer / redimensionner / pivoter)
	----------------------------------------------------------------
	local proxy = Instance.new("Part")
	proxy.Name = "BToolsProxy"
	proxy.Anchored = true
	proxy.CanCollide = false
	proxy.CanQuery = false
	proxy.CanTouch = false
	proxy.CastShadow = false
	proxy.Transparency = 1
	proxy.Size = Vector3.new(1, 1, 1)
	proxy.Locked = true
	proxy.Parent = workspace

	local moveHandles = Instance.new("Handles")
	moveHandles.Name = "BToolsMove"
	moveHandles.Style = Enum.HandlesStyle.Movement
	moveHandles.Color3 = T.Accent
	moveHandles.Parent = gui

	local resizeHandles = Instance.new("Handles")
	resizeHandles.Name = "BToolsResize"
	resizeHandles.Style = Enum.HandlesStyle.Resize
	resizeHandles.Color3 = T.Accent
	resizeHandles.Parent = gui

	local rotateHandles = Instance.new("ArcHandles")
	rotateHandles.Name = "BToolsRotate"
	rotateHandles.Color3 = T.Accent
	rotateHandles.Parent = gui

	local hoverBox = Instance.new("SelectionBox")
	hoverBox.Name = "BToolsHover"
	hoverBox.Color3 = Color3.new(1, 1, 1)
	hoverBox.LineThickness = 0.02
	hoverBox.SurfaceColor3 = Color3.new(1, 1, 1)
	hoverBox.SurfaceTransparency = 0.9
	hoverBox.Parent = gui

	-- repère des poignées pour l'outil actif
	function S.frame(tool)
		S.prune()
		if #selection == 0 then return nil end
		local useLocal = (tool == "Resize") or BT.LocalAxes
		if #selection == 1 and useLocal then
			return selection[1].CFrame, selection[1].Size
		end
		local c, s = S.aabb(selection)
		return CFrame.new(c), s
	end

	function S.updateHandles()
		local tool = BT.Tool
		local cf, size
		if tool == "Move" or tool == "Resize" or tool == "Rotate" then
			cf, size = S.frame(tool)
		end
		if cf then
			proxy.CFrame = cf
			proxy.Size = Vector3.new(math.max(size.X, 0.3), math.max(size.Y, 0.3), math.max(size.Z, 0.3))
		end
		moveHandles.Adornee = (cf and tool == "Move") and proxy or nil
		resizeHandles.Adornee = (cf and tool == "Resize") and proxy or nil
		rotateHandles.Adornee = (cf and tool == "Rotate") and proxy or nil
	end

	function S.hideHandles()
		moveHandles.Adornee = nil
		resizeHandles.Adornee = nil
		rotateHandles.Adornee = nil
		hoverBox.Adornee = nil
	end

	function S.beginHandle(kind)
		S.prune()
		if #selection == 0 then return end
		handleBusy = true
		dragState = {
			kind = kind,
			parts = table.clone(selection),
			cf0 = {},
			size0 = {},
			anch = {},
			proxyCF = proxy.CFrame,
			proxySize = proxy.Size,
			before = S.snapshot(selection),
		}
		for _, p in ipairs(dragState.parts) do
			dragState.cf0[p] = p.CFrame
			dragState.size0[p] = p.Size
			dragState.anch[p] = p.Anchored
			p.Anchored = true
		end
	end

	function S.endHandle()
		local d = dragState
		dragState = nil
		handleBusy = false
		handleUpAt = os.clock()
		if not d then return end
		for _, p in ipairs(d.parts) do
			if p.Parent then p.Anchored = d.anch[p] end
		end
		local labels = { Move = "Déplacer", Resize = "Redimensionner", Rotate = "Pivoter" }
		S.pushT(labels[d.kind] or "Modifier", d.before, S.snapshot(d.parts))
		S.fire()
	end

	moveHandles.MouseButton1Down:Connect(function() S.beginHandle("Move") end)
	moveHandles.MouseButton1Up:Connect(function() S.endHandle() end)
	moveHandles.MouseDrag:Connect(function(face, dist)
		local d = dragState
		if not d or d.kind ~= "Move" then return end
		local n = d.proxyCF:VectorToWorldSpace(Vector3.FromNormalId(face))
		local off = n * S.snap(dist, BT.MoveStep)
		for _, p in ipairs(d.parts) do
			if p.Parent then p.CFrame = d.cf0[p] + off end
		end
	end)

	resizeHandles.MouseButton1Down:Connect(function() S.beginHandle("Resize") end)
	resizeHandles.MouseButton1Up:Connect(function() S.endHandle() end)
	resizeHandles.MouseDrag:Connect(function(face, dist)
		local d = dragState
		if not d or d.kind ~= "Resize" then return end
		local ln = Vector3.FromNormalId(face)
		local n = d.proxyCF:VectorToWorldSpace(ln)
		local ps = d.proxySize
		local ext = math.abs(ln.X) * ps.X + math.abs(ln.Y) * ps.Y + math.abs(ln.Z) * ps.Z
		local delta = S.snap(dist, BT.ResizeStep)
		local newExt = BT.ResizeBoth and (ext + 2 * delta) or (ext + delta)
		newExt = math.max(newExt, 0.05)
		local f = newExt / ext
		local pivot = BT.ResizeBoth and d.proxyCF.Position or (d.proxyCF.Position - n * (ext / 2))
		for _, p in ipairs(d.parts) do
			if p.Parent then
				local cf = d.cf0[p]
				local o = (cf.Position - pivot):Dot(n)
				local newPos = cf.Position + n * (o * (f - 1))
				-- axe local de l'objet le plus aligné avec la poignée
				local dots = { math.abs(cf.RightVector:Dot(n)), math.abs(cf.UpVector:Dot(n)), math.abs(cf.LookVector:Dot(n)) }
				local idx = 1
				if dots[2] > dots[idx] then idx = 2 end
				if dots[3] > dots[idx] then idx = 3 end
				local sz = d.size0[p]
				local comps = { sz.X, sz.Y, sz.Z }
				comps[idx] = math.clamp(comps[idx] * f, 0.05, 2048)
				p.Size = Vector3.new(comps[1], comps[2], comps[3])
				p.CFrame = CFrame.new(newPos) * cf.Rotation
			end
		end
	end)

	rotateHandles.MouseButton1Down:Connect(function() S.beginHandle("Rotate") end)
	rotateHandles.MouseButton1Up:Connect(function() S.endHandle() end)
	rotateHandles.MouseDrag:Connect(function(axis, rel)
		local d = dragState
		if not d or d.kind ~= "Rotate" then return end
		local deg = math.deg(rel)
		if BT.RotateStep > 0 then deg = math.round(deg / BT.RotateStep) * BT.RotateStep end
		local axisW = d.proxyCF:VectorToWorldSpace(Vector3.FromAxis(axis))
		local pivot = d.proxyCF.Position
		local rot = CFrame.new(pivot) * CFrame.fromAxisAngle(axisW, math.rad(deg)) * CFrame.new(-pivot)
		for _, p in ipairs(d.parts) do
			if p.Parent then p.CFrame = rot * d.cf0[p] end
		end
	end)

	----------------------------------------------------------------
	-- Souris : sélection par clic, glisser direct, survol
	----------------------------------------------------------------
	function S.overRect(f)
		if not f or not f.Visible then return false end
		local m = UIS:GetMouseLocation()
		local p, sz = f.AbsolutePosition, f.AbsoluteSize
		return m.X >= p.X and m.X <= p.X + sz.X and m.Y >= p.Y and m.Y <= p.Y + sz.Y
	end

	function S.overGui()
		return S.overRect(U.main) or S.overRect(dock)
	end

	-- renvoie (objet visé, rayon, point d'impact)
	function S.target()
		local loc = UIS:GetMouseLocation()
		local ray = camera:ViewportPointToRay(loc.X, loc.Y)
		rayParams.FilterDescendantsInstances = { player.Character }
		local r = workspace:Raycast(ray.Origin, ray.Direction * 10000, rayParams)
		if not r then return nil, ray, nil end
		local part = r.Instance
		if not S.valid(part) then return nil, ray, r.Position end
		if BT.IgnorePlayers then
			local model = part:FindFirstAncestorOfClass("Model")
			if model and model:FindFirstChildOfClass("Humanoid") then return nil, ray, r.Position end
		end
		return part, ray, r.Position
	end

	function S.clickSelect(part)
		if pickMode == "color" then
			if part then
				BT.Color = part.Color
				notify("Couleur prise : " .. S.hex(part.Color))
			end
			pickMode = nil
			W.refresh()
			return
		end
		local ctrl, shift = S.ctrl(), S.shift()
		if not part then
			if not ctrl then
				S.clear()
				S.fire()
			end
			return
		end
		if ctrl then
			if selSet[part] then S.remove(part) else S.add(part) end
		elseif shift then
			S.clear()
			local top = part:FindFirstAncestorOfClass("Model")
			while top and top.Parent and top.Parent:IsA("Model") do top = top.Parent end
			if top then
				local n = 0
				for _, d in ipairs(top:GetDescendants()) do
					if S.valid(d) and n < 500 then
						S.add(d)
						n += 1
					end
				end
			else
				S.add(part)
			end
		else
			S.clear()
			S.add(part)
		end
		S.fire()
	end

	function S.beginFree(ray, hit)
		S.prune()
		if #selection == 0 then return end
		freeDrag = {
			parts = table.clone(selection),
			cf0 = {},
			anch = {},
			hit = hit,
			dist = (hit - ray.Origin).Magnitude,
			moved = false,
			before = S.snapshot(selection),
		}
		for _, p in ipairs(freeDrag.parts) do
			freeDrag.cf0[p] = p.CFrame
			freeDrag.anch[p] = p.Anchored
			p.Anchored = true
		end
	end

	function S.endFree(commitMove)
		local fd = freeDrag
		freeDrag = nil
		if not fd then return false end
		for _, p in ipairs(fd.parts) do
			if p.Parent then p.Anchored = fd.anch[p] end
		end
		if commitMove and fd.moved then
			S.pushT("Déplacer", fd.before, S.snapshot(fd.parts))
			S.fire()
		elseif not commitMove then
			S.restore(fd.before)
		end
		return fd.moved
	end

	function BTf.onPress()
		if not BT.Enabled or S.overGui() then return false end
		clickDown = { pos = UIS:GetMouseLocation() }
		if BT.Tool == "Move" and BT.FreeDrag and not pickMode then
			local part, ray, hit = S.target()
			if part and hit then
				if not selSet[part] then
					if not S.ctrl() then S.clear() end
					S.add(part)
					S.fire()
					clickDown.preSelected = true
				end
				S.beginFree(ray, hit)
			end
		end
		return true
	end

	function BTf.onRelease()
		if dragState then S.endHandle() end
		local moved = S.endFree(true)
		local cd = clickDown
		clickDown = nil
		if not cd or moved then return end
		if handleBusy or os.clock() - handleUpAt < 0.2 then return end
		if (UIS:GetMouseLocation() - cd.pos).Magnitude > 6 then return end
		if cd.preSelected then return end
		local part = S.target()
		S.clickSelect(part)
	end

	function BTf.onWheel(delta)
		if freeDrag then freeDrag.dist = math.max(2, freeDrag.dist + delta * 4) end
	end

	RunService.RenderStepped:Connect(function()
		if not BT.Enabled then return end
		S.prune()

		if freeDrag then
			local loc = UIS:GetMouseLocation()
			local ray = camera:ViewportPointToRay(loc.X, loc.Y)
			local newHit = ray.Origin + ray.Direction * freeDrag.dist
			local delta = newHit - freeDrag.hit
			delta = Vector3.new(S.snap(delta.X, BT.MoveStep), S.snap(delta.Y, BT.MoveStep), S.snap(delta.Z, BT.MoveStep))
			if delta.Magnitude > 0.05 then freeDrag.moved = true end
			for _, p in ipairs(freeDrag.parts) do
				if p.Parent then p.CFrame = freeDrag.cf0[p] + delta end
			end
		end

		if BT.ShowHover and not freeDrag and not handleBusy and not S.overGui() then
			local part = S.target()
			hoverBox.Adornee = (part and not selSet[part]) and part or nil
		else
			hoverBox.Adornee = nil
		end

		if not handleBusy and not freeDrag then S.updateHandles() end
	end)

	----------------------------------------------------------------
	-- Widgets du panneau
	----------------------------------------------------------------
	local oo = 0
	local optRefresh = {}

	function W.refresh()
		for _, f in ipairs(optRefresh) do pcall(f) end
	end

	local function nextO()
		oo += 1
		return oo
	end

	function W.clear()
		table.clear(optRefresh)
		infoLabel = nil
		for _, c in ipairs(opts:GetChildren()) do
			if c:IsA("GuiObject") then c:Destroy() end
		end
		oo = 0
	end

	function W.header(text)
		local l = newLabel(opts, text:upper(), 11, T.Accent, Enum.Font.GothamBold)
		l.LayoutOrder = nextO()
		l.Size = UDim2.new(1, 0, 0, 22)
		l.TextYAlignment = Enum.TextYAlignment.Bottom
		return l
	end

	function W.note(text)
		local l = newLabel(opts, text, 12, T.SubText, Enum.Font.Gotham)
		l.LayoutOrder = nextO()
		l.Size = UDim2.new(1, 0, 0, 0)
		l.AutomaticSize = Enum.AutomaticSize.Y
		l.TextWrapped = true
		l.TextYAlignment = Enum.TextYAlignment.Top
		return l
	end

	function W.card(h)
		local f = Instance.new("Frame")
		f.LayoutOrder = nextO()
		f.Size = UDim2.new(1, 0, 0, h or 34)
		f.BackgroundColor3 = T.Card
		f.BorderSizePixel = 0
		f.Parent = opts
		corner(f, 8)
		stroke(f, T.Stroke, 1)
		return f
	end

	function W.button(text, cb, kind)
		local b = Instance.new("TextButton")
		b.LayoutOrder = nextO()
		b.Size = UDim2.new(1, 0, 0, 32)
		b.BackgroundColor3 = kind == "primary" and T.Accent or T.Card
		b.BorderSizePixel = 0
		b.AutoButtonColor = true
		b.Font = Enum.Font.GothamMedium
		b.TextSize = 13
		b.TextColor3 = kind == "primary" and T.Dark or (kind == "danger" and T.Danger or T.Text)
		b.Text = text
		b.Parent = opts
		corner(b, 8)
		if kind ~= "primary" then stroke(b, T.Stroke, 1) end
		b.MouseButton1Click:Connect(cb)
		return b
	end

	function W.input(label, get, set, isText)
		local row = W.card(34)
		local l = newLabel(row, label, 13, T.Text, Enum.Font.GothamMedium)
		l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -124, 1, 0)
		l.TextTruncate = Enum.TextTruncate.AtEnd
		local box = Instance.new("TextBox")
		box.AnchorPoint = Vector2.new(1, 0.5)
		box.Position = UDim2.new(1, -8, 0.5, 0)
		box.Size = UDim2.new(0, 104, 0, 24)
		box.BackgroundColor3 = T.Bg
		box.BorderSizePixel = 0
		box.Font = Enum.Font.GothamBold
		box.TextSize = 13
		box.TextColor3 = T.Text
		box.ClearTextOnFocus = false
		box.Parent = row
		corner(box, 6)
		local st = stroke(box, T.Stroke, 1)
		local function refresh()
			if not box:IsFocused() then
				local v = get()
				box.Text = isText and tostring(v or "") or S.num(v)
			end
		end
		refresh()
		table.insert(optRefresh, refresh)
		box.Focused:Connect(function() tw(st, { Color = T.Accent }) end)
		box.FocusLost:Connect(function()
			tw(st, { Color = T.Stroke })
			if isText then
				set(box.Text)
			else
				local v = tonumber(box.Text)
				if v then set(v) end
			end
			W.refresh()
		end)
		return box
	end

	function W.toggle(label, get, set)
		local row = W.card(34)
		local l = newLabel(row, label, 13, T.Text, Enum.Font.GothamMedium)
		l.Position = UDim2.new(0, 12, 0, 0)
		l.Size = UDim2.new(1, -70, 1, 0)
		l.TextTruncate = Enum.TextTruncate.AtEnd
		local track = Instance.new("Frame")
		track.AnchorPoint = Vector2.new(1, 0.5)
		track.Position = UDim2.new(1, -10, 0.5, 0)
		track.Size = UDim2.new(0, 38, 0, 20)
		track.BorderSizePixel = 0
		track.Parent = row
		corner(track, 10)
		local knob = Instance.new("Frame")
		knob.AnchorPoint = Vector2.new(0, 0.5)
		knob.Size = UDim2.new(0, 14, 0, 14)
		knob.BackgroundColor3 = Color3.new(1, 1, 1)
		knob.BorderSizePixel = 0
		knob.Parent = track
		corner(knob, 7)
		local function refresh()
			local on = get()
			track.BackgroundColor3 = on and T.On or T.Stroke
			knob.Position = on and UDim2.new(0, 21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
		end
		refresh()
		table.insert(optRefresh, refresh)
		local hit = Instance.new("TextButton")
		hit.BackgroundTransparency = 1
		hit.Size = UDim2.new(1, 0, 1, 0)
		hit.Text = ""
		hit.Parent = row
		hit.MouseButton1Click:Connect(function()
			set(not get())
			W.refresh()
		end)
	end

	-- options : liste de "texte" ou { "texte", valeur } ; get peut être nil (boutons d'action)
	function W.segment(options, get, set, cols)
		cols = cols or 3
		local pad, ch = 6, 28
		local rows = math.ceil(#options / cols)
		local holder = Instance.new("Frame")
		holder.LayoutOrder = nextO()
		holder.BackgroundTransparency = 1
		holder.Size = UDim2.new(1, 0, 0, rows * ch + (rows - 1) * pad)
		holder.Parent = opts
		local grid = Instance.new("UIGridLayout")
		grid.CellPadding = UDim2.new(0, pad, 0, pad)
		grid.CellSize = UDim2.new(1 / cols, -((cols - 1) * pad) / cols - 0.5, 0, ch)
		grid.SortOrder = Enum.SortOrder.LayoutOrder
		grid.Parent = holder
		local btns = {}
		local function refresh()
			local cur = get and get()
			for val, b in pairs(btns) do
				local on = (cur ~= nil and val == cur)
				b.BackgroundColor3 = on and T.Accent or T.Card
				b.TextColor3 = on and T.Dark or T.Text
			end
		end
		for i, opt in ipairs(options) do
			local label, value = opt, opt
			if type(opt) == "table" then label, value = opt[1], opt[2] end
			local b = Instance.new("TextButton")
			b.LayoutOrder = i
			b.BorderSizePixel = 0
			b.AutoButtonColor = false
			b.Font = Enum.Font.GothamMedium
			b.TextSize = 12
			b.Text = label
			b.TextTruncate = Enum.TextTruncate.AtEnd
			b.Parent = holder
			corner(b, 6)
			b.MouseButton1Click:Connect(function()
				set(value)
				refresh()
			end)
			btns[value] = b
		end
		refresh()
		table.insert(optRefresh, refresh)
	end

	function W.palette(set)
		local cols, pad, ch = 8, 5, 24
		local rows = math.ceil(#PALETTE / cols)
		local holder = Instance.new("Frame")
		holder.LayoutOrder = nextO()
		holder.BackgroundTransparency = 1
		holder.Size = UDim2.new(1, 0, 0, rows * ch + (rows - 1) * pad)
		holder.Parent = opts
		local grid = Instance.new("UIGridLayout")
		grid.CellPadding = UDim2.new(0, pad, 0, pad)
		grid.CellSize = UDim2.new(1 / cols, -((cols - 1) * pad) / cols - 0.5, 0, ch)
		grid.SortOrder = Enum.SortOrder.LayoutOrder
		grid.Parent = holder
		for i, c in ipairs(PALETTE) do
			local b = Instance.new("TextButton")
			b.LayoutOrder = i
			b.BackgroundColor3 = c
			b.BorderSizePixel = 0
			b.AutoButtonColor = true
			b.Text = ""
			b:SetAttribute("keep", true)
			b.Parent = holder
			corner(b, 6)
			b.MouseButton1Click:Connect(function() set(c) end)
		end
	end

	function W.colorInput(label, get, set)
		W.input(label, function() return S.hex(get()) end, function(t)
			local c = S.parseColor(t)
			if c then set(c) end
		end, true)
	end

	----------------------------------------------------------------
	-- Pages d'options de chaque outil
	----------------------------------------------------------------
	builders.Select = function()
		W.button("Tout désélectionner", function()
			S.clear()
			S.fire()
		end)
		W.button("Sélectionner le modèle entier", A.selectModels)
		W.input("Rayon (studs)", function() return BT.SelRadius end, function(v) BT.SelRadius = math.max(v, 0) end)
		W.button("Sélectionner dans le rayon", A.selectRadius)
		W.button("Sélectionner le même nom", A.selectSameName)
		W.toggle("Ignorer joueurs et PNJ", function() return BT.IgnorePlayers end, function(v) BT.IgnorePlayers = v end)
		W.toggle("Surbrillance au survol", function() return BT.ShowHover end, function(v) BT.ShowHover = v end)
		W.note("Clic = sélectionner • Ctrl+clic = ajouter / retirer • Shift+clic = tout le modèle.")
	end

	builders.Move = function()
		W.input("Pas (studs, 0 = libre)", function() return BT.MoveStep end, function(v) BT.MoveStep = math.max(v, 0) end)
		W.toggle("Axes locaux", function() return BT.LocalAxes end, function(v) BT.LocalAxes = v end)
		W.toggle("Glisser directement (molette = distance)", function() return BT.FreeDrag end, function(v) BT.FreeDrag = v end)
		W.header("Position exacte")
		for _, ax in ipairs({ "X", "Y", "Z" }) do
			W.input("Position " .. ax, function() return A.centerComp(ax) end, function(v) A.setPos(ax, v) end)
		end
		W.button("Poser sur le sol", A.drop)
	end

	builders.Resize = function()
		W.input("Pas (studs, 0 = libre)", function() return BT.ResizeStep end, function(v) BT.ResizeStep = math.max(v, 0) end)
		W.toggle("Des deux côtés", function() return BT.ResizeBoth end, function(v) BT.ResizeBoth = v end)
		W.header("Taille exacte")
		for _, ax in ipairs({ "X", "Y", "Z" }) do
			W.input("Taille " .. ax, function()
				local p = selection[1]
				return p and p.Size[ax] or 0
			end, function(v) A.setSize(ax, v) end)
		end
		W.note("Plusieurs objets sélectionnés : ils sont mis à l'échelle ensemble.")
	end

	builders.Rotate = function()
		W.input("Pas (degrés, 0 = libre)", function() return BT.RotateStep end, function(v) BT.RotateStep = math.max(v, 0) end)
		W.toggle("Axes locaux", function() return BT.LocalAxes end, function(v) BT.LocalAxes = v end)
		W.header("Rotation rapide de 90°")
		W.segment({ { "Axe X", "x" }, { "Axe Y", "y" }, { "Axe Z", "z" } }, nil, function(v)
			local axis = v == "x" and Vector3.xAxis or (v == "y" and Vector3.yAxis or Vector3.zAxis)
			A.rotate(axis, 90)
		end, 3)
		W.button("Remettre droit (rotation 0)", A.resetRot)
	end

	builders.Paint = function()
		W.palette(function(c)
			BT.Color = c
			A.paint()
			W.refresh()
		end)
		W.colorInput("Couleur (#RRGGBB)", function() return BT.Color end, function(c)
			BT.Color = c
			A.paint()
		end)
		W.button("Pipette : copier la couleur d'un objet", function()
			pickMode = "color"
			notify("Clique sur un objet pour copier sa couleur")
		end)
		W.button("Appliquer la couleur actuelle", A.paint, "primary")
	end

	builders.Material = function()
		W.segment(MATERIALS, function() return BT.Material end, A.material, 3)
		W.header("Apparence")
		W.input("Transparence (0 à 1)", function()
			local p = selection[1]
			return p and p.Transparency or 0
		end, function(v)
			local parts = A.need()
			if parts then A.edit(parts, { Transparency = math.clamp(v, 0, 1) }, "Transparence") end
		end)
		W.input("Réflectance (0 à 1)", function()
			local p = selection[1]
			return p and p.Reflectance or 0
		end, function(v)
			local parts = A.need()
			if parts then A.edit(parts, { Reflectance = math.clamp(v, 0, 1) }, "Réflectance") end
		end)
		W.toggle("Projette une ombre", function()
			local p = selection[1]
			return p and p.CastShadow or false
		end, function(v)
			local parts = A.need()
			if parts then A.edit(parts, { CastShadow = v }, "Ombre") end
		end)
	end

	builders.Surface = function()
		W.header("Face")
		W.segment({ { "Haut", "Top" }, { "Bas", "Bottom" }, { "Devant", "Front" }, { "Derrière", "Back" },
			{ "Gauche", "Left" }, { "Droite", "Right" }, { "Toutes", "All" } },
			function() return BT.SurfaceFace end, function(v) BT.SurfaceFace = v end, 4)
		W.header("Type de surface (appliqué au clic)")
		W.segment({ "Smooth", "Studs", "Inlet", "Universal", "Glue", "Weld", "SmoothNoOutlines" },
			function() return BT.SurfaceType end, function(v)
				BT.SurfaceType = v
				A.surface()
			end, 3)
	end

	builders.Light = function()
		W.segment({ { "Point", "PointLight" }, { "Spot", "SpotLight" }, { "Surface", "SurfaceLight" } },
			function() return BT.LightType end, function(v) BT.LightType = v end, 3)
		W.input("Luminosité", function() return BT.LightBrightness end, function(v) BT.LightBrightness = math.max(v, 0) end)
		W.input("Portée", function() return BT.LightRange end, function(v) BT.LightRange = math.max(v, 0) end)
		W.input("Angle (Spot / Surface)", function() return BT.LightAngle end, function(v) BT.LightAngle = math.clamp(v, 0, 180) end)
		W.segment(FACE_OPTIONS, function() return BT.LightFace end, function(v) BT.LightFace = v end, 3)
		W.toggle("Ombres", function() return BT.LightShadows end, function(v) BT.LightShadows = v end)
		W.header("Couleur de la lumière")
		W.palette(function(c)
			BT.LightColor = c
			W.refresh()
		end)
		W.colorInput("Couleur (#RRGGBB)", function() return BT.LightColor end, function(c) BT.LightColor = c end)
		W.button("Ajouter / mettre à jour la lumière", A.applyLight, "primary")
		W.button("Retirer les lumières", A.removeLights, "danger")
		W.header("Préréglages")
		W.segment({ { "Bougie", "candle" }, { "Néon", "neon" }, { "Froid", "cold" },
			{ "Rouge", "red" }, { "Lampe", "lamp" }, { "Projecteur", "spot" } }, nil, A.preset, 3)
	end

	builders.Decorate = function()
		W.segment({ { "Feu", "Fire" }, { "Fumée", "Smoke" }, { "Étincelles", "Sparkles" } },
			function() return BT.FxType end, function(v) BT.FxType = v end, 3)
		W.input("Taille", function() return BT.FxSize end, function(v) BT.FxSize = math.max(v, 0) end)
		W.input("Chaleur (feu)", function() return BT.FxHeat end, function(v) BT.FxHeat = math.max(v, 0) end)
		W.header("Couleur")
		W.palette(function(c)
			BT.FxColor = c
			W.refresh()
		end)
		W.colorInput("Couleur (#RRGGBB)", function() return BT.FxColor end, function(c) BT.FxColor = c end)
		W.button("Ajouter / mettre à jour l'effet", A.applyFx, "primary")
		W.button("Retirer les effets", A.removeFx, "danger")
	end

	builders.Mesh = function()
		W.segment({ { "Bloc", "Brick" }, { "Sphère", "Sphere" }, { "Cylindre", "Cylinder" },
			{ "Wedge", "Wedge" }, { "Mesh ID", "FileMesh" } },
			function() return BT.MeshType end, function(v) BT.MeshType = v end, 3)
		W.input("Mesh ID", function() return BT.MeshId end, function(t) BT.MeshId = t end, true)
		W.input("Texture ID", function() return BT.TextureId end, function(t) BT.TextureId = t end, true)
		W.input("Échelle", function() return BT.MeshScale end, function(v) BT.MeshScale = v end)
		W.button("Appliquer le mesh", A.applyMesh, "primary")
		W.button("Retirer le mesh", A.removeMesh, "danger")
		W.note("Mesh ID et Texture ID ne servent qu'avec « Mesh ID ». Un simple numéro suffit.")
	end

	builders.Texture = function()
		W.segment({ { "Decal", "Decal" }, { "Texture", "Texture" } },
			function() return BT.TexType end, function(v) BT.TexType = v end, 2)
		W.header("Face")
		W.segment({ { "Haut", "Top" }, { "Bas", "Bottom" }, { "Devant", "Front" }, { "Derrière", "Back" },
			{ "Gauche", "Left" }, { "Droite", "Right" }, { "Toutes", "All" } },
			function() return BT.TexFace end, function(v) BT.TexFace = v end, 4)
		W.input("Image ID", function() return BT.TexId end, function(t) BT.TexId = t end, true)
		W.input("Transparence", function() return BT.TexTransparency end, function(v) BT.TexTransparency = math.clamp(v, 0, 1) end)
		W.button("Appliquer la texture", A.applyTexture, "primary")
		W.button("Retirer les textures", A.removeTexture, "danger")
	end

	builders.Weld = function()
		W.note("Le premier objet sélectionné sert de base : les autres sont soudés dessus.")
		W.button("Souder la sélection", A.weld, "primary")
		W.button("Casser les soudures", A.unweld, "danger")
	end

	builders.Physics = function()
		W.header("Ancrage")
		W.segment({ { "Ancrer", "a" }, { "Libérer", "f" } }, nil, function(v) A.anchor(v == "a") end, 2)
		W.header("Collision")
		W.segment({ { "Collision ON", "on" }, { "Collision OFF", "off" } }, nil, function(v) A.collide(v == "on") end, 2)
	end

	builders.Create = function()
		W.segment({ { "Bloc", "Block" }, { "Sphère", "Ball" }, { "Cylindre", "Cylinder" },
			{ "Wedge", "Wedge" }, { "Coin", "CornerWedge" } },
			function() return BT.NewShape end, function(v) BT.NewShape = v end, 3)
		for _, ax in ipairs({ "X", "Y", "Z" }) do
			W.input("Taille " .. ax, function() return BT.NewSize[ax] end, function(v)
				v = math.clamp(v, 0.05, 2048)
				local s = BT.NewSize
				BT.NewSize = Vector3.new(ax == "X" and v or s.X, ax == "Y" and v or s.Y, ax == "Z" and v or s.Z)
			end)
		end
		W.toggle("Ancré", function() return BT.NewAnchored end, function(v) BT.NewAnchored = v end)
		W.toggle("Collision", function() return BT.NewCollide end, function(v) BT.NewCollide = v end)
		W.note("L'objet prend la couleur et la matière choisies dans Couleur et Matière.")
		W.button("Créer devant la caméra", A.create, "primary")
	end

	function W.build()
		W.clear()
		local card = W.card(46)
		infoLabel = newLabel(card, S.summary(), 12, T.Text, Enum.Font.GothamMedium)
		infoLabel.Position = UDim2.new(0, 12, 0, 0)
		infoLabel.Size = UDim2.new(1, -24, 1, 0)
		infoLabel.TextWrapped = true
		W.header(TOOL_TITLES[BT.Tool] or BT.Tool)
		local b = builders[BT.Tool]
		if b then b() end
		opts.CanvasPosition = Vector2.zero
	end

	function BTf.setTool(name)
		if not builders[name] then return end
		BT.Tool = name
		pickMode = nil
		for n, b in pairs(toolButtons) do
			local on = (n == name)
			b.BackgroundColor3 = on and T.Accent or T.Card
			b.TextColor3 = on and T.Dark or T.Text
		end
		W.build()
		refreshUI()
	end

	function BTf.cycleMode()
		local list = {}
		for _, t in ipairs(TOOLS) do
			if t[1]:sub(1, 1) ~= "@" then table.insert(list, t[1]) end
		end
		local idx = table.find(list, BT.Tool) or 0
		BTf.setTool(list[(idx % #list) + 1])
		notify("Outil : " .. (TOOL_TITLES[BT.Tool] or BT.Tool))
	end

	BTf.clone = A.clone
	BTf.delete = A.delete

	function BTf.setEnabled(v)
		BT.Enabled = v and true or false
		dock.Visible = BT.Enabled
		if not BT.Enabled then
			if dragState then S.endHandle() end
			S.endFree(false)
			clickDown = nil
			pickMode = nil
			S.clear()
			S.fire()
			S.hideHandles()
		end
		refreshUI()
	end

	----------------------------------------------------------------
	-- Panneau flottant
	----------------------------------------------------------------
	do
		local DOCK_W = 312
		dock = Instance.new("Frame")
		dock.Name = "BToolsDock"
		dock.AnchorPoint = Vector2.new(1, 0.5)
		dock.Position = UDim2.new(1, -16, 0.5, 0)
		dock.Size = UDim2.new(0, DOCK_W, 0, 580)
		dock.BackgroundColor3 = T.Bg
		dock.BorderSizePixel = 0
		dock.Visible = false
		dock.Active = true
		dock.ClipsDescendants = true
		dock.Parent = gui
		corner(dock, 12)
		stroke(dock, T.Stroke, 1)
		U.dock = dock

		-- barre de titre
		local titleBar = Instance.new("Frame")
		titleBar.Size = UDim2.new(1, 0, 0, 40)
		titleBar.BackgroundColor3 = T.Panel
		titleBar.BorderSizePixel = 0
		titleBar.Parent = dock
		local line = Instance.new("Frame")
		line.Position = UDim2.new(0, 0, 1, -2)
		line.Size = UDim2.new(1, 0, 0, 2)
		line.BackgroundColor3 = T.Accent
		line.BorderSizePixel = 0
		line.Parent = titleBar
		local title = newLabel(titleBar, "🔨  BTools", 16, T.Text, Enum.Font.GothamBlack)
		title.Position = UDim2.new(0, 14, 0, 0)
		title.Size = UDim2.new(0.5, 0, 1, -2)
		local selChip = newLabel(titleBar, "0 sél.", 12, T.SubText, Enum.Font.GothamMedium)
		selChip.AnchorPoint = Vector2.new(1, 0.5)
		selChip.Position = UDim2.new(1, -50, 0.5, -1)
		selChip.Size = UDim2.new(0, 80, 0, 20)
		selChip.TextXAlignment = Enum.TextXAlignment.Right
		local closeD = Instance.new("TextButton")
		closeD.AnchorPoint = Vector2.new(1, 0.5)
		closeD.Position = UDim2.new(1, -8, 0.5, -1)
		closeD.Size = UDim2.new(0, 28, 0, 28)
		closeD.BackgroundColor3 = T.Card
		closeD.AutoButtonColor = false
		closeD.Font = Enum.Font.GothamBold
		closeD.TextSize = 14
		closeD.TextColor3 = T.Text
		closeD.Text = "X"
		closeD.Parent = titleBar
		corner(closeD, 7)
		closeD.MouseEnter:Connect(function() tw(closeD, { BackgroundColor3 = T.Danger }) end)
		closeD.MouseLeave:Connect(function() tw(closeD, { BackgroundColor3 = T.Card }) end)
		closeD.MouseButton1Click:Connect(function() BTf.setEnabled(false) end)

		-- déplacement du panneau
		local dragging, dStart, dPos = false, nil, nil
		titleBar.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging, dStart, dPos = true, i.Position, dock.Position
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local d = i.Position - dStart
				dock.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset + d.X, dPos.Y.Scale, dPos.Y.Offset + d.Y)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging = false
			end
		end)

		-- grille des outils
		local grid = Instance.new("Frame")
		grid.BackgroundTransparency = 1
		grid.Position = UDim2.new(0, 12, 0, 48)
		grid.Size = UDim2.new(1, -24, 0, 208)
		grid.Parent = dock
		local gl = Instance.new("UIGridLayout")
		gl.CellSize = UDim2.new(0, 66, 0, 46)
		gl.CellPadding = UDim2.new(0, 8, 0, 8)
		gl.SortOrder = Enum.SortOrder.LayoutOrder
		gl.Parent = grid

		for i, t in ipairs(TOOLS) do
			local id, icon, label = t[1], t[2], t[3]
			local b = Instance.new("TextButton")
			b.LayoutOrder = i
			b.BackgroundColor3 = T.Card
			b.BorderSizePixel = 0
			b.AutoButtonColor = false
			b.Font = Enum.Font.GothamMedium
			b.TextSize = 11
			b.RichText = true
			b.TextColor3 = T.Text
			b.Text = '<font size="18">' .. icon .. "</font>\n" .. label
			b.Parent = grid
			corner(b, 8)
			stroke(b, T.Stroke, 1)
			if id:sub(1, 1) == "@" then
				if id == "@Delete" then b.TextColor3 = T.Danger end
				b.MouseButton1Click:Connect(function()
					if id == "@Clone" then A.clone() else A.delete() end
				end)
			else
				toolButtons[id] = b
				b.MouseButton1Click:Connect(function() BTf.setTool(id) end)
			end
		end

		-- annuler / rétablir
		local undoRow = Instance.new("Frame")
		undoRow.BackgroundTransparency = 1
		undoRow.Position = UDim2.new(0, 12, 0, 264)
		undoRow.Size = UDim2.new(1, -24, 0, 30)
		undoRow.Parent = dock
		local ul = Instance.new("UIListLayout")
		ul.FillDirection = Enum.FillDirection.Horizontal
		ul.Padding = UDim.new(0, 6)
		ul.Parent = undoRow
		local function undoBtn(text, cb)
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(0, 92, 1, 0)
			b.BackgroundColor3 = T.Card
			b.BorderSizePixel = 0
			b.AutoButtonColor = true
			b.Font = Enum.Font.GothamMedium
			b.TextSize = 12
			b.TextColor3 = T.Text
			b.Text = text
			b.Parent = undoRow
			corner(b, 8)
			stroke(b, T.Stroke, 1)
			b.MouseButton1Click:Connect(cb)
		end
		undoBtn("↶  Annuler", function() BTf.undo() end)
		undoBtn("↷  Rétablir", function() BTf.redo() end)
		undoBtn("Tout annuler", function() BTf.undoAll() end)

		-- options de l'outil actif
		opts = Instance.new("ScrollingFrame")
		opts.BackgroundTransparency = 1
		opts.BorderSizePixel = 0
		opts.Position = UDim2.new(0, 0, 0, 302)
		opts.Size = UDim2.new(1, 0, 1, -302)
		opts.CanvasSize = UDim2.new()
		opts.AutomaticCanvasSize = Enum.AutomaticSize.Y
		opts.ScrollBarThickness = 4
		opts.ScrollBarImageColor3 = T.Accent
		opts.Parent = dock
		local pd = Instance.new("UIPadding")
		pd.PaddingLeft = UDim.new(0, 12)
		pd.PaddingRight = UDim.new(0, 14)
		pd.PaddingBottom = UDim.new(0, 12)
		pd.Parent = opts
		local ol = Instance.new("UIListLayout")
		ol.Padding = UDim.new(0, 6)
		ol.SortOrder = Enum.SortOrder.LayoutOrder
		ol.Parent = opts

		table.insert(selListeners, function()
			selChip.Text = #selection .. " sél."
			if infoLabel and infoLabel.Parent then infoLabel.Text = S.summary() end
			W.refresh()
		end)

		local function fitDock()
			local vp = camera.ViewportSize
			dock.Size = UDim2.new(0, DOCK_W, 0, math.clamp(vp.Y - 60, 400, 580))
		end
		fitDock()
		camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitDock)
	end

	BTf.setTool(BT.Tool)
end

----------------------------------------------------------------------
-- BLOC 3 : Raccourcis clavier
----------------------------------------------------------------------
do
	local main = U.main
	local function S_ctrl_pressed() return UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.RightControl) end

	UIS.InputBegan:Connect(function(input, processed)
		if processed then return end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			-- Click TP : maintenir HoldKey + clic gauche
			if Config.TP.ClickTP and UIS:IsKeyDown(Config.TP.HoldKey) then
				local pos = mouseWorldPos()
				if pos then teleportTo(pos) end
				return
			end
			BTf.onPress()
			return
		end

		local k = input.KeyCode
		local keys = Config.Keys

		-- raccourcis BTools (prioritaires quand les BTools sont actifs)
		if Config.BTools.Enabled then
			if S_ctrl_pressed() then
				if k == Enum.KeyCode.Z then
					if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then BTf.redo() else BTf.undo() end
					return
				elseif k == Enum.KeyCode.Y then
					BTf.redo()
					return
				elseif k == Enum.KeyCode.D then
					BTf.clone()
					return
				end
			elseif k == Enum.KeyCode.Backspace then
				BTf.delete()
				return
			end
		end

		if keyIn(keys.Fly, k) then
			setFly(not Config.Fly.Enabled)
		elseif keyIn(keys.Noclip, k) then
			setNoclip(not Config.Noclip.Enabled)
		elseif keyIn(keys.Aimbot, k) then
			setAimbot(not Config.Aimbot.Enabled)
		elseif keyIn(keys.SilentAim, k) then
			setSilent(not Config.SilentAim.Enabled)
		elseif keyIn(keys.ESP, k) then
			setESP(not Config.ESP.Enabled)
		elseif keyIn(keys.WalkFling, k) then
			setWalkFling(not Config.WalkFling.Enabled)
		elseif keyIn(keys.FlingPowerDown, k) then
			addFlingPower(-Config.WalkFling.Step)
		elseif keyIn(keys.FlingPowerUp, k) then
			addFlingPower(Config.WalkFling.Step)
		elseif keyIn(keys.ToggleMenu, k) then
			U.toggleMenu()
		elseif keyIn(keys.ClickTP, k) then
			setClickTP(not Config.TP.ClickTP)
		elseif keyIn(keys.InfJump, k) then
			setInfJump(not Config.InfJump.Enabled)
		elseif keyIn(keys.TPNext, k) then
			tpCycle(1)
		elseif keyIn(keys.TPPrev, k) then
			tpCycle(-1)
		elseif keyIn(keys.SavePos, k) then
			savePosition()
		elseif keyIn(keys.LoadPos, k) then
			loadPosition()
		elseif keyIn(keys.FastMod, k) then
			setFastMod(not Config.FastMod.Enabled)
		elseif keyIn(keys.AutoFire, k) then
			setAutoFire(not Config.FastMod.AutoFire)
		elseif keyIn(keys.JumpPowerDown, k) then
			addJumpPower(-Config.Jump.Step)
		elseif keyIn(keys.JumpPowerUp, k) then
			addJumpPower(Config.Jump.Step)
		elseif keyIn(keys.FlySpeedDown, k) then
			addFlySpeed(-Config.Fly.Step)
		elseif keyIn(keys.FlySpeedUp, k) then
			addFlySpeed(Config.Fly.Step)
		elseif keyIn(keys.WalkSpeedDown, k) then
			addWalkSpeed(-Config.Walk.Step)
		elseif keyIn(keys.WalkSpeedUp, k) then
			addWalkSpeed(Config.Walk.Step)
		elseif keyIn(keys.ViewStop, k) then
			stopView()
			U.notify("View arrêté")
		elseif keyIn(keys.ViewNext, k) then
			local p = viewCycle(1)
			U.notify(p and ("View : " .. p.Name) or "Aucun joueur")
		elseif keyIn(keys.Bring, k) then
			setBring(not Config.Bring.Enabled)
		elseif keyIn(keys.BTools, k) then
			BTf.setEnabled(not Config.BTools.Enabled)
		elseif keyIn(keys.BToolsMode, k) then
			BTf.cycleMode()
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			BTf.onRelease()
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseWheel then
			BTf.onWheel(input.Position.Z)
		end
	end)
end
