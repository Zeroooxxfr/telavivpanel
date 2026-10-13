--=====================================================================
-- LocalScript (StarterPlayer > StarterPlayerScripts)
-- Menu : ScreenGui "telavivmenu"
-- Version 5 : panel dashboard (cartes, flou, animations) + Camlock + Rapid Fire + BTools F3X + Walk Fling + Fling All (1 fichier .luau)
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
		SilentAim     = { Enum.KeyCode.I },
		Camlock       = { Enum.KeyCode.C },
		RapidFire     = { Enum.KeyCode.U },
		ESP           = { Enum.KeyCode.H },
		FlySpeedDown  = { Enum.KeyCode.LeftBracket },
		FlySpeedUp    = { Enum.KeyCode.RightBracket },
		WalkSpeedDown = { Enum.KeyCode.Minus },
		WalkSpeedUp   = { Enum.KeyCode.Equals },
		WalkFling     = { Enum.KeyCode.T },
		FlingAll      = { Enum.KeyCode.F },
		FlingPowerDown = { Enum.KeyCode.Comma },
		FlingPowerUp   = { Enum.KeyCode.Period },
		JumpPowerDown  = { Enum.KeyCode.Semicolon },
		JumpPowerUp    = { Enum.KeyCode.Quote },
		ToggleMenu     = { Enum.KeyCode.K, Enum.KeyCode.RightControl }, -- K = cacher / afficher le panel
		FastMod        = { Enum.KeyCode.J },
		AutoFire       = { Enum.KeyCode.O },
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
		HoldToAim = false,       -- true = ne vise que clic droit maintenu
	},

	Camlock = {
		Enabled = false,
		TargetPart = "Head",
		Smoothness = 1,          -- 1 = verrouillage total, plus bas = plus doux
		Prediction = true,
		PredictionFactor = 0.12,
		WallCheck = false,
		TeamCheck = true,
		Sticky = true,           -- garde la même cible jusqu'à sa mort (sinon : la plus proche du centre)
		FOV = 100000,            -- distance max à l'écran (pixels) pour choisir la cible
		MaxDistance = math.huge,
	},

	RapidFire = {
		Enabled = false,
		Rate = 30,               -- tirs par seconde (aucune limite)
		Step = 10,
		HoldOnly = true,         -- ne tire que quand tu maintiens le clic gauche
		ForceEnabled = true,     -- remet Tool.Enabled = true (cooldowns faits avec Enabled = false)
		Deactivate = true,       -- Activate() puis Deactivate() à chaque tir
		MaxPerFrame = 60,
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
		Accent = Color3.fromRGB(36, 140, 255),
		Blur = true,           -- flou d'arrière-plan quand le panel est ouvert
		BlurSize = 20,
		Dim = 0.3,             -- assombrissement derrière le panel (0 à 1)
		Animations = true,
		AnimBorder = true,     -- bordure animée
		Width = 1080,
		Height = 680,
		DefaultWidth = 1080,
		DefaultHeight = 680,
		StartPosition = UDim2.new(0.5, 0, 0.5, 0),
	},}

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
	if not (fm.Enabled and fm.AutoFire) or Config.RapidFire.Enabled then autoTimer = 0; return end
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
-- Ciblage, FOV, Aimbot & Silent Aim
----------------------------------------------------------------------
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

-- la souris est-elle au-dessus du panel ? (on ne tire / ne vise pas quand on clique dans le menu)
local function mouseOverMenu()
	if not (menuFrameRef and menuFrameRef.Visible) then return false end
	local m = UIS:GetMouseLocation()
	local p, sz = menuFrameRef.AbsolutePosition, menuFrameRef.AbsoluteSize
	return m.X >= p.X and m.X <= p.X + sz.X and m.Y >= p.Y and m.Y <= p.Y + sz.Y
end

-- visible = aucun mur solide entre la caméra et la cible (ignore les parts invisibles / non solides)
local function isVisible(part)
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

-- centre du FOV : centre de l'écran, ou la souris quand le curseur est libre (useMouse)
local function aimCenter(useMouse)
	if useMouse and UIS.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
		return UIS:GetMouseLocation()
	end
	return camera.ViewportSize / 2
end

-- R6 et R15 : "Torso" = UpperTorso (R15) ou Torso (R6) ; "HumanoidRootPart" = centre du perso
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

-- Renvoie (position écran, position monde, part, joueur) de la cible la plus proche du centre du FOV
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
		-- on teste le FOV AVANT le raycast (beaucoup plus léger)
		if d < bestDist and (not s.WallCheck or isVisible(part)) then
			bestScreen, bestWorld, bestPart, bestPlr, bestDist = v, pos3D, part, other, d
		end
	end
	return bestScreen, bestWorld, bestPart, bestPlr
end

----------------------------------------------------------------------
-- Cercle FOV (suit le FOV de l'Aimbot, ou du Silent Aim si l'Aimbot est coupé)
----------------------------------------------------------------------
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "telavivfov"
fovGui.ResetOnSpawn = false
fovGui.IgnoreGuiInset = true
fovGui.DisplayOrder = 49 -- sous le menu (50)
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
	fovGui.Parent = player:WaitForChild("PlayerGui")
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

----------------------------------------------------------------------
-- Silent Aim
-- La cible est recalculée à chaque image (cache), puis servie :
--   1) via l'API _G.DevTools (à appeler depuis le script d'arme du jeu) :
--        local pos = _G.DevTools.GetAimPosition(mouse.Hit.Position)
--        local part = _G.DevTools.GetAimTarget()            -- Part visée (ou nil)
--        local dir = _G.DevTools.GetAimDirection(origin, defaultDir)
--   2) automatiquement sur mouse.Hit / mouse.Target si l'environnement
--      fournit hookmetamethod + checkcaller (executor) ; sinon ignoré sans erreur.
----------------------------------------------------------------------
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
-- Smoothness indépendante des FPS ; option "maintenir clic droit" ; pas d'aim pendant la saisie / dans le menu
RunService:BindToRenderStep("TelAvivAimbot", Enum.RenderPriority.Camera.Value + 1, function(dt)
	local a = Config.Aimbot
	if not a.Enabled then return end
	if UIS:GetFocusedTextBox() then return end
	if a.HoldToAim and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then return end
	if mouseOverMenu() then return end
	local _, world = getClosestTarget(a, a.TargetPart, false)
	if world then
		local camPos = camera.CFrame.Position
		local s = math.clamp(a.Smoothness, 0.01, 1)
		local alpha = s >= 1 and 1 or 1 - (1 - s) ^ (math.min(dt, 0.1) * 60)
		camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camPos, world), alpha)
	end
end)

----------------------------------------------------------------------
-- Camlock : verrouille la caméra sur un joueur
----------------------------------------------------------------------
local camTarget = nil
local camState = {}

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

function camState.lockNearest()
	camTarget = camPick(Config.Camlock)
	return camTarget
end

RunService:BindToRenderStep("TelAvivCamlock", Enum.RenderPriority.Camera.Value + 2, function()
	local c = Config.Camlock
	if not c.Enabled then camTarget = nil return end
	if not (c.Sticky and camTarget and camValid(camTarget, c)) then
		camTarget = camPick(c)
	end
	if not camTarget then return end
	local part, char = camValid(camTarget, c)
	if not part then return end
	local pos = part.Position
	if c.Prediction then
		local root = char:FindFirstChild("HumanoidRootPart")
		if root then pos += root.AssemblyLinearVelocity * c.PredictionFactor end
	end
	local camPos = camera.CFrame.Position
	camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camPos, pos), math.clamp(c.Smoothness, 0.01, 1))
end)

----------------------------------------------------------------------
-- Rapid Fire : tirs répétés très rapides avec l'arme en main
----------------------------------------------------------------------
do
	local acc = 0
	RunService.Heartbeat:Connect(function(dt)
		local r = Config.RapidFire
		if not r.Enabled then acc = 0 return end
		if r.HoldOnly and not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) then acc = 0 return end
		if UIS:GetFocusedTextBox() then return end
		if mouseOverMenu() then return end
		local char = player.Character
		local tool = char and char:FindFirstChildOfClass("Tool")
		if not tool then acc = 0 return end
		acc += dt * math.max(r.Rate, 0)
		local n = math.min(math.floor(acc), r.MaxPerFrame) -- max par image (évite de figer le client)
		acc -= math.floor(acc)
		for _ = 1, n do
			-- les armes qui font Tool.Enabled = false pour leur cooldown bloqueraient Activate()
			if r.ForceEnabled and not tool.Enabled then tool.Enabled = true end
			tool:Activate()
			-- Deactivate : sans lui, les armes à boucle "tant que activée" empilent des boucles
			if r.Deactivate then tool:Deactivate() end
		end
	end)
end

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
local function setCamlock(v) Config.Camlock.Enabled = v; if v then camState.lockNearest() end; refreshUI() end
local function setRapidFire(v) Config.RapidFire.Enabled = v; refreshUI() end
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
-- Fling All (boucle sur tous les joueurs)
----------------------------------------------------------------------
Config.FlingAll = {
	Enabled = false,
	VelocityPower = 9e7,
	RotVelocityPower = 9e8,
	TimeToWait = 2,
	DelayBetweenTargets = 0.3,
	MinVelocitySuccess = 500,
	LoopDelay = 1,
	Whitelist = {}, -- noms à ne pas fling
}

local flingAllRunning = false
local flingAllOldPos = nil
local flingAllFPDH = workspace.FallenPartsDestroyHeight

local function flingAllWhitelisted(plr)
	local n = plr.Name:lower()
	for _, w in ipairs(Config.FlingAll.Whitelist) do
		if w:lower() == n then return true end
	end
	return false
end

local function flingAllSeated(plr)
	local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
	return hum ~= nil and hum.Sit
end

local function flingAllWaitRespawn()
	local waited = false
	while Config.FlingAll.Enabled do
		local char = player.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if char and char.Parent and hum and hum.Health > 0 and hum.RootPart then
			if waited then task.wait(1) end
			return true
		end
		waited = true
		task.wait(0.5)
	end
	return false
end

local function flingAllOne(target)
	local F = Config.FlingAll
	if not target.Parent or flingAllSeated(target) then return false end

	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = hum and hum.RootPart
	local tchar = target.Character
	local thum = tchar and tchar:FindFirstChildOfClass("Humanoid")
	local troot = thum and thum.RootPart
	local thead = tchar and tchar:FindFirstChild("Head")
	local acc = tchar and tchar:FindFirstChildOfClass("Accessory")
	local handle = acc and acc:FindFirstChild("Handle")
	if not (char and hum and root and tchar and thum) then return false end
	if not tchar:FindFirstChildWhichIsA("BasePart") then return false end

	if root.AssemblyLinearVelocity.Magnitude < 50 then
		flingAllOldPos = root.CFrame
	end

	-- la caméra suit la cible
	if thead then camera.CameraSubject = thead
	elseif handle then camera.CameraSubject = handle
	elseif troot then camera.CameraSubject = thum end

	local function fpos(base, pos, ang)
		if not base.Parent or not root.Parent or not char.Parent then return end
		char:PivotTo(CFrame.new(base.Position) * pos * ang)
		root.AssemblyLinearVelocity = Vector3.new(F.VelocityPower, F.VelocityPower * 10, F.VelocityPower)
		root.AssemblyAngularVelocity = Vector3.new(F.RotVelocityPower, F.RotVelocityPower, F.RotVelocityPower)
	end

	local function sfbase(base)
		local t0 = tick()
		local angle = 0
		repeat
			if not (root.Parent and thum.Parent) then break end
			local md = thum.MoveDirection
			local bv = base.AssemblyLinearVelocity.Magnitude
			if bv < 50 then
				angle += 100
				local a = CFrame.Angles(math.rad(angle), 0, 0)
				fpos(base, CFrame.new(0, 1.5, 0) + md * bv / 1.25, a); task.wait()
				fpos(base, CFrame.new(0, -1.5, 0) + md * bv / 1.25, a); task.wait()
				fpos(base, CFrame.new(2.25, 1.5, -2.25) + md * bv / 1.25, a); task.wait()
				fpos(base, CFrame.new(-2.25, -1.5, 2.25) + md * bv / 1.25, a); task.wait()
				fpos(base, CFrame.new(0, 1.5, 0) + md, a); task.wait()
				fpos(base, CFrame.new(0, -1.5, 0) + md, a); task.wait()
			else
				local tv = troot and troot.AssemblyLinearVelocity.Magnitude / 1.25 or 0
				fpos(base, CFrame.new(0, 1.5, thum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
				fpos(base, CFrame.new(0, -1.5, -thum.WalkSpeed), CFrame.Angles(0, 0, 0)); task.wait()
				fpos(base, CFrame.new(0, 1.5, thum.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
				fpos(base, CFrame.new(0, 1.5, tv), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
				fpos(base, CFrame.new(0, -1.5, -tv), CFrame.Angles(0, 0, 0)); task.wait()
				fpos(base, CFrame.new(0, 1.5, tv), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
				fpos(base, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
				fpos(base, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0)); task.wait()
				fpos(base, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0)); task.wait()
				fpos(base, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0)); task.wait()
			end
		until not F.Enabled
			or base.AssemblyLinearVelocity.Magnitude > F.MinVelocitySuccess
			or base.Parent ~= target.Character
			or target.Parent ~= Players
			or thum.Sit
			or hum.Health <= 0
			or tick() > t0 + F.TimeToWait
	end

	workspace.FallenPartsDestroyHeight = 0 / 0
	hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

	if troot and thead then
		if (troot.Position - thead.Position).Magnitude > 5 then sfbase(thead) else sfbase(troot) end
	elseif troot then sfbase(troot)
	elseif thead then sfbase(thead)
	elseif acc and handle then sfbase(handle)
	else return false end

	-- retour à la position de départ
	local t0 = tick()
	repeat
		if not root.Parent or not char.Parent or not flingAllOldPos then break end
		char:PivotTo(flingAllOldPos * CFrame.new(0, 0.5, 0))
		hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		for _, x in ipairs(char:GetChildren()) do
			if x:IsA("BasePart") then
				x.AssemblyLinearVelocity = Vector3.zero
				x.AssemblyAngularVelocity = Vector3.zero
			end
		end
		task.wait()
	until (root.Position - flingAllOldPos.Position).Magnitude < 25 or tick() > t0 + 3
	return true
end

-- exécute un fling puis remet tout en ordre, même en cas d'erreur
local function flingAllSafe(target)
	pcall(flingAllOne, target)
	workspace.FallenPartsDestroyHeight = flingAllFPDH
	local _, hum = getChar()
	if hum then
		hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		camera.CameraSubject = hum
	end
end

local function startFlingAll()
	if flingAllRunning then return end
	flingAllRunning = true
	task.spawn(function()
		while Config.FlingAll.Enabled do
			local F = Config.FlingAll
			local targets = {}
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and not flingAllWhitelisted(p) then table.insert(targets, p) end
			end
			for _, t in ipairs(targets) do
				if not F.Enabled then break end
				if t.Parent and not flingAllWhitelisted(t) and flingAllWaitRespawn() then
					if flingAllSeated(t) then
						task.wait(0.2)
					else
						flingAllSafe(t)
						task.wait(F.DelayBetweenTargets)
					end
				end
			end
			task.wait(F.LoopDelay)
		end
		flingAllRunning = false
	end)
end

local function setFlingAll(v)
	Config.FlingAll.Enabled = v
	if v then
		if Config.WalkFling.Enabled then setWalkFling(false) end -- évite le conflit de vélocité
		if Config.Fly.Enabled then setFly(false) end
		startFlingAll()
	end
	refreshUI()
end

----------------------------------------------------------------------
-- GUI "telavivmenu" v3 : interface à onglets + BTools
----------------------------------------------------------------------
local U = {}     -- partage entre les blocs GUI
local BTf = {}   -- fonctions BTools (remplies plus bas)

----------------------------------------------------------------------
-- BLOC 1 : interface v6 (panel dashboard : cartes, flou, animations, recherche globale)
----------------------------------------------------------------------
do
	local M = Config.Menu
	local Lighting = game:GetService("Lighting")
	local TextService = game:GetService("TextService")

	local T = {
		Bg        = Color3.fromRGB(6, 11, 26),
		Panel     = Color3.fromRGB(9, 18, 42),
		Card      = Color3.fromRGB(12, 25, 58),
		CardHover = Color3.fromRGB(21, 44, 96),
		Stroke    = Color3.fromRGB(30, 72, 150),
		Off       = Color3.fromRGB(54, 66, 100),
		Accent    = M.Accent,
		Text      = Color3.fromRGB(232, 240, 255),
		SubText   = Color3.fromRGB(140, 162, 205),
		On        = Color3.fromRGB(52, 199, 120),
		Danger    = Color3.fromRGB(240, 82, 82),
		Dark      = Color3.fromRGB(5, 9, 20),
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
	local N = { navs = {}, navOrder = {}, cards = {}, nav = "Home", y = 14, open = true, minimized = false, compact = false }
	local V = {}
	local HEAD_H = 64
	local SIDE_W = 200
	local FULL = UDim2.new(0, M.Width, 0, M.Height)

	local main = Instance.new("Frame")
	main.Name = "Main"
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.Position = M.StartPosition
	main.Size = FULL
	main.BackgroundColor3 = Color3.new(1, 1, 1)
	main.BackgroundTransparency = 0.04
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
		bg.Color = ColorSequence.new(Color3.fromRGB(13, 26, 62), Color3.fromRGB(5, 9, 22))
		bg.Rotation = 125
		bg.Parent = main

		-- bordure animée
		local ms = Instance.new("UIStroke")
		ms.Color = Color3.new(1, 1, 1)
		ms.Thickness = 2
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

		local tw1 = TextService:GetTextSize("Tel Aviv", 20, Enum.Font.GothamBlack, Vector2.new(400, 30)).X
		local title = newLabel(header, "Tel Aviv", 20, T.Text, Enum.Font.GothamBlack)
		title.Position = UDim2.new(0, 64, 0.5, -20)
		title.Size = UDim2.new(0, tw1, 0, 24)
		title.ZIndex = 6
		local title2 = newLabel(header, "Menu", 20, T.Accent, Enum.Font.GothamBlack)
		title2.Position = UDim2.new(0, 64 + tw1 + 6, 0.5, -20)
		title2.Size = UDim2.new(0, 60, 0, 24)
		title2.ZIndex = 6
		local ver = Instance.new("TextLabel")
		ver.Position = UDim2.new(0, 64 + tw1 + 6 + 58, 0.5, -17)
		ver.Size = UDim2.new(0, 28, 0, 18)
		ver.BackgroundColor3 = T.Accent
		ver.BackgroundTransparency = 0.7
		ver.BorderSizePixel = 0
		ver.Font = Enum.Font.GothamBold
		ver.TextSize = 11
		ver.TextColor3 = T.Text
		ver.Text = "v5"
		ver.ZIndex = 6
		ver.Parent = header
		corner(ver, 9)
		local sub = newLabel(header, "More Power. No Limits.", 11, T.SubText, Enum.Font.Gotham)
		sub.Position = UDim2.new(0, 64, 0.5, 6)
		sub.Size = UDim2.new(0, 190, 0, 14)
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
		chips.Position = UDim2.new(1, -100, 0.5, 0)
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
	-- Corps : barre latérale + zone des cartes
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
	sidebar.BackgroundTransparency = 0.3
	sidebar.BorderSizePixel = 0
	sidebar.ZIndex = 2
	sidebar.Parent = body
	V.sidebar = sidebar

	local NAV = {
		{ "Home", "🏠" }, { "Movement", "🏃" }, { "Combat", "🎯" }, { "Troll", "😈" }, { "Visuals", "👁" }, { "Teleport", "📍" },
		{ "Player", "🧍" }, { "BTools", "🔨" }, { "Misc", "🧰" }, { "Settings", "⚙" },
	}

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

		-- pastille pleine qui glisse sous l'onglet actif
		local pill = Instance.new("Frame")
		pill.Name = "Pill"
		pill.Position = UDim2.new(0, 10, 0, 14)
		pill.Size = UDim2.new(1, -20, 0, 40)
		pill.BackgroundColor3 = Color3.new(1, 1, 1)
		pill.BorderSizePixel = 0
		pill.ZIndex = 3
		pill.Parent = nav
		corner(pill, 10)
		accentGradient(pill, 0)
		local pst = stroke(pill, T.Accent, 1)
		pst.Transparency = 0.2
		V.pill = pill

		for i, e in ipairs(NAV) do
			local name, icon = e[1], e[2]
			local item = Instance.new("TextButton")
			item.Name = "Nav_" .. name
			item.Position = UDim2.new(0, 10, 0, 14 + (i - 1) * 44)
			item.Size = UDim2.new(1, -20, 0, 40)
			item.BackgroundTransparency = 1
			item.AutoButtonColor = false
			item.Text = ""
			item.ZIndex = 5
			item.Parent = nav
			local ic = Instance.new("TextLabel")
			ic.BackgroundTransparency = 1
			ic.Size = UDim2.new(0, 44, 1, 0)
			ic.Font = Enum.Font.GothamMedium
			ic.TextSize = 18
			ic.TextColor3 = T.Text
			ic.Text = icon
			ic.ZIndex = 6
			ic.Parent = item
			local tx = newLabel(item, name, 14, T.SubText, Enum.Font.GothamMedium)
			tx.Position = UDim2.new(0, 44, 0, 0)
			tx.Size = UDim2.new(1, -48, 1, 0)
			tx.ZIndex = 6
			item.MouseEnter:Connect(function()
				if N.nav ~= name then
					tw(tx, { TextColor3 = T.Text }, 0.12)
					tw(ic, { Position = UDim2.new(0, 4, 0, 0) }, 0.15)
				end
			end)
			item.MouseLeave:Connect(function()
				if N.nav ~= name then
					tw(tx, { TextColor3 = T.SubText }, 0.12)
				end
				tw(ic, { Position = UDim2.new(0, 0, 0, 0) }, 0.15)
			end)
			item.MouseButton1Click:Connect(function() N.selectPage(name) end)
			N.navs[name] = { item = item, txt = tx, icon = ic, y = 14 + (i - 1) * 44 }
			table.insert(N.navOrder, name)
		end

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

	-- zone de contenu (CanvasGroup : fondu + glissement à chaque changement d'onglet)
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.BackgroundTransparency = 1
	content.Position = UDim2.new(0, SIDE_W, 0, 0)
	content.Size = UDim2.new(1, -SIDE_W, 1, 0)
	content.ClipsDescendants = true
	content.ZIndex = 2
	content.Parent = body
	V.content = content

	local area = Instance.new("CanvasGroup")
	area.Name = "Area"
	area.BackgroundTransparency = 1
	area.BorderSizePixel = 0
	area.ZIndex = 2
	area.Parent = content
	local AREA_POS = UDim2.new(0, 14, 0, 12)
	area.Position = AREA_POS
	area.Size = UDim2.new(1, -28, 1, -24)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "Scroll"
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.CanvasSize = UDim2.new()
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = T.Accent
	scroll.ZIndex = 2
	scroll.Parent = area
	do
		local pd = Instance.new("UIPadding", scroll)
		pd.PaddingBottom = UDim.new(0, 16)
		pd.PaddingRight = UDim.new(0, 8)
		pd.PaddingTop = UDim.new(0, 2)
	end
	V.scroll = scroll

	local grid = Instance.new("Frame")
	grid.Name = "Grid"
	grid.BackgroundTransparency = 1
	grid.Size = UDim2.new(1, 0, 0, 0)
	grid.AutomaticSize = Enum.AutomaticSize.Y
	grid.Parent = scroll

	local pool = Instance.new("Frame") -- cartes non affichées
	pool.Name = "Pool"
	pool.Visible = false
	pool.BackgroundTransparency = 1
	pool.Parent = gui

	local registry = {} -- { text, card, row }
	N.cols = {}

	-- répartit les cartes de l'onglet courant en 1 à 3 colonnes (la plus courte d'abord)
	function N.layout()
		local sbw = N.compact and 68 or SIDE_W
		local w = FULL.X.Offset - sbw - 28 - 12
		local ncols = (w >= 740 and 3) or (w >= 480 and 2) or 1
		local gap = 12
		for _, ci in ipairs(N.cards) do ci.frame.Parent = pool end
		for _, c in ipairs(N.cols) do c:Destroy() end
		N.cols = {}
		local hs = {}
		for i = 1, ncols do
			local c = Instance.new("Frame")
			c.Name = "Col" .. i
			c.BackgroundTransparency = 1
			c.Size = UDim2.new(1 / ncols, -gap * (ncols - 1) / ncols, 0, 0)
			c.Position = UDim2.new((i - 1) / ncols, (i - 1) * gap / ncols, 0, 0)
			c.AutomaticSize = Enum.AutomaticSize.Y
			c.Parent = grid
			local l = Instance.new("UIListLayout", c)
			l.Padding = UDim.new(0, gap)
			l.SortOrder = Enum.SortOrder.LayoutOrder
			N.cols[i] = c
			hs[i] = 0
		end
		local seq = 0
		for _, ci in ipairs(N.cards) do
			if N.nav == "Home" or table.find(ci.cats, N.nav) then
				local best = 1
				for i = 2, ncols do
					if hs[i] < hs[best] - 1 then best = i end
				end
				seq += 1
				ci.frame.LayoutOrder = seq
				ci.frame.Parent = N.cols[best]
				hs[best] += ci.h + gap
			end
		end
	end

	local function animateIn()
		if not M.Animations then area.GroupTransparency = 0 area.Position = AREA_POS return end
		area.GroupTransparency = 1
		area.Position = AREA_POS + UDim2.fromOffset(0, 18)
		tw(area, { GroupTransparency = 0, Position = AREA_POS }, 0.4)
	end

	function N.selectPage(name)
		local nv = N.navs[name]
		if not nv then return end
		N.nav = name
		for n, e in pairs(N.navs) do
			local on = (n == name)
			tw(e.txt, { TextColor3 = on and Color3.new(1, 1, 1) or T.SubText }, 0.15)
		end
		tw(V.pill, { Position = UDim2.new(0, 10, 0, nv.y) }, 0.4, Enum.EasingStyle.Back)
		scroll.CanvasPosition = Vector2.new(0, 0)
		N.layout()
		animateIn()
	end


	do
		local sbox = Instance.new("Frame")
		sbox.Name = "SearchBox"
		sbox.AnchorPoint = Vector2.new(0, 0.5)
		sbox.Position = UDim2.new(0, 330, 0.5, 0)
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
		drop.Position = UDim2.new(0, 330, 0.5, 26)
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
			tw(row, { BackgroundTransparency = 0.55 }, 0.2)
			task.delay(dur(1.2), function()
				if row.Parent then tw(row, { BackgroundTransparency = 1 }, 0.6) end
			end)
		end

		local function jump(e)
			box.Text = ""
			box:ReleaseFocus()
			N.selectPage(e.card.cats[2] or "Home")
			task.delay(dur(0.2), function()
				if e.row and e.row.Parent and e.row.Parent.Parent then
					local y = e.row.AbsolutePosition.Y - V.scroll.AbsolutePosition.Y + V.scroll.CanvasPosition.Y
					V.scroll.CanvasPosition = Vector2.new(0, math.max(0, (y - 20) / scale.Scale))
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
					if not table.find(results, e) and e.card.title:lower():find(q, 1, true) then
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
				local t2 = newLabel(b, e.card.title, 11, T.SubText, Enum.Font.Gotham)
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
	-- Cartes + widgets compacts
	----------------------------------------------------------------
	local function makeCard(title, icon, cats)
		local card = Instance.new("Frame")
		card.Name = "Card_" .. title
		card.Size = UDim2.new(1, 0, 0, 0)
		card.AutomaticSize = Enum.AutomaticSize.Y
		card.BackgroundColor3 = T.Card
		card.BackgroundTransparency = 0.1
		card.BorderSizePixel = 0
		card.Parent = pool
		corner(card, 12)
		local st = stroke(card, T.Stroke, 1.2)
		local gr = Instance.new("UIGradient")
		gr.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 200, 225))
		gr.Rotation = 90
		gr.Parent = card
		local ll = Instance.new("UIListLayout", card)
		ll.Padding = UDim.new(0, 3)
		ll.SortOrder = Enum.SortOrder.LayoutOrder
		local pd = Instance.new("UIPadding", card)
		pd.PaddingTop = UDim.new(0, 10)
		pd.PaddingBottom = UDim.new(0, 12)
		pd.PaddingLeft = UDim.new(0, 12)
		pd.PaddingRight = UDim.new(0, 12)

		local hd = Instance.new("Frame")
		hd.LayoutOrder = 0
		hd.Size = UDim2.new(1, 0, 0, 30)
		hd.BackgroundTransparency = 1
		hd.Parent = card
		local ic = Instance.new("TextLabel")
		ic.BackgroundTransparency = 1
		ic.Size = UDim2.new(0, 24, 0, 24)
		ic.Font = Enum.Font.GothamBold
		ic.TextSize = 17
		ic.TextColor3 = T.Accent
		ic.Text = icon
		ic.Parent = hd
		local tl = newLabel(hd, title, 15, T.Text, Enum.Font.GothamBold)
		tl.Position = UDim2.new(0, 30, 0, 0)
		tl.Size = UDim2.new(1, -30, 0, 24)
		local ln = Instance.new("Frame")
		ln.Position = UDim2.new(0, 0, 1, -2)
		ln.Size = UDim2.new(1, 0, 0, 1)
		ln.BackgroundColor3 = T.Stroke
		ln.BorderSizePixel = 0
		ln.Parent = hd

		local c = { frame = card, h = 66, cats = cats, title = title, n = 0, stroke = st }
		table.insert(N.cards, c)
		N.cur = c
		card.MouseEnter:Connect(function() tw(st, { Color = T.Accent }, 0.2) end)
		card.MouseLeave:Connect(function() tw(st, { Color = T.Stroke }, 0.25) end)
		return c
	end

	local function addRow(h)
		local c = N.cur
		c.n += 1
		c.h += h + 3
		local r = Instance.new("Frame")
		r.LayoutOrder = c.n
		r.Size = UDim2.new(1, 0, 0, h)
		r.BackgroundColor3 = T.Accent
		r.BackgroundTransparency = 1
		r.BorderSizePixel = 0
		r.ClipsDescendants = true
		r.Parent = c.frame
		corner(r, 7)
		return r
	end

	local function register(row, text)
		table.insert(registry, { text = text, card = N.cur, row = row })
	end

	local function hoverRow(row, hit)
		hit.MouseEnter:Connect(function() tw(row, { BackgroundTransparency = 0.88 }, 0.12) end)
		hit.MouseLeave:Connect(function() tw(row, { BackgroundTransparency = 1 }, 0.18) end)
	end

	local function hitButton(row)
		local hit = Instance.new("TextButton")
		hit.BackgroundTransparency = 1
		hit.Size = UDim2.new(1, 0, 1, 0)
		hit.Text = ""
		hit.ZIndex = 5
		hit.Parent = row
		return hit
	end

	local function rowLabel(row, text, w)
		local l = newLabel(row, text, 13, T.Text, Enum.Font.GothamMedium)
		l.Position = UDim2.new(0, 4, 0, 0)
		l.Size = w or UDim2.new(1, -60, 1, 0)
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.ZIndex = 3
		return l
	end

	local function makeSub(text)
		local r = addRow(26)
		r.ClipsDescendants = false
		local l = newLabel(r, text, 13, T.Text, Enum.Font.GothamBold)
		l.Position = UDim2.new(0, 2, 0, 6)
		l.Size = UDim2.new(1, 0, 0, 18)
		local ln = Instance.new("Frame")
		ln.Position = UDim2.new(0, 0, 0, 3)
		ln.Size = UDim2.new(1, 0, 0, 1)
		ln.BackgroundColor3 = T.Stroke
		ln.BorderSizePixel = 0
		ln.Parent = r
	end

	local function makeNote(text)
		local h = TextService:GetTextSize(text, 11, Enum.Font.Gotham, Vector2.new(240, 2000)).Y + 6
		local r = addRow(h)
		local l = newLabel(r, text, 11, T.SubText, Enum.Font.Gotham)
		l.Position = UDim2.new(0, 4, 0, 2)
		l.Size = UDim2.new(1, -8, 1, -2)
		l.TextWrapped = true
		l.TextYAlignment = Enum.TextYAlignment.Top
	end

	local function makeToggle(text, getter, setter, keyText)
		local row = addRow(28)
		rowLabel(row, text, UDim2.new(1, keyText and -112 or -56, 1, 0))

		local track = Instance.new("Frame")
		track.AnchorPoint = Vector2.new(1, 0.5)
		track.Position = UDim2.new(1, -4, 0.5, 0)
		track.Size = UDim2.new(0, 38, 0, 20)
		track.BackgroundColor3 = T.Off
		track.BorderSizePixel = 0
		track.ZIndex = 3
		track.Parent = row
		corner(track, 10)
		local knob = Instance.new("Frame")
		knob.AnchorPoint = Vector2.new(0, 0.5)
		knob.Position = UDim2.new(0, 3, 0.5, 0)
		knob.Size = UDim2.new(0, 14, 0, 14)
		knob.BackgroundColor3 = Color3.new(1, 1, 1)
		knob.BorderSizePixel = 0
		knob.ZIndex = 4
		knob.Parent = track
		knob:SetAttribute("keep", true)
		corner(knob, 7)

		if keyText then
			local badge = Instance.new("TextLabel")
			badge.AnchorPoint = Vector2.new(1, 0.5)
			badge.Position = UDim2.new(1, -50, 0.5, 0)
			badge.Size = UDim2.new(0, 0, 0, 20)
			badge.AutomaticSize = Enum.AutomaticSize.X
			badge.BackgroundColor3 = T.Bg
			badge.BorderSizePixel = 0
			badge.Font = Enum.Font.GothamBold
			badge.TextSize = 10
			badge.TextColor3 = T.SubText
			badge.Text = keyText
			badge.ZIndex = 3
			badge.Parent = row
			corner(badge, 5)
			stroke(badge, T.Stroke, 1)
			local bp = Instance.new("UIPadding", badge)
			bp.PaddingLeft = UDim.new(0, 7)
			bp.PaddingRight = UDim.new(0, 7)
		end

		local hit = hitButton(row)
		hoverRow(row, hit)
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
			tw(knob, { Position = on and UDim2.new(0, 21, 0.5, 0) or UDim2.new(0, 3, 0.5, 0) }, 0.28, Enum.EasingStyle.Back)
		end)
		register(row, text)
	end

	local function smallBtn(parent, text, xOff)
		local b = Instance.new("TextButton")
		b.AnchorPoint = Vector2.new(1, 0.5)
		b.Position = UDim2.new(1, xOff, 0.5, 0)
		b.Size = UDim2.new(0, 20, 0, 22)
		b.BackgroundColor3 = T.Bg
		b.BorderSizePixel = 0
		b.AutoButtonColor = false
		b.Font = Enum.Font.GothamBold
		b.TextSize = 13
		b.TextColor3 = T.Text
		b.Text = text
		b.ZIndex = 4
		b.Parent = parent
		corner(b, 6)
		local s = stroke(b, T.Stroke, 1)
		b.MouseEnter:Connect(function() tw(s, { Color = T.Accent }, 0.12) end)
		b.MouseLeave:Connect(function() tw(s, { Color = T.Stroke }, 0.15) end)
		return b
	end

	local function makeBox(parent, w, h, size)
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(0, w, 0, h)
		box.BackgroundColor3 = T.Bg
		box.BorderSizePixel = 0
		box.Font = Enum.Font.GothamBold
		box.TextSize = size or 12
		box.TextColor3 = T.Text
		box.ClearTextOnFocus = false
		box.ZIndex = 4
		box.Parent = parent
		corner(box, 6)
		local st = stroke(box, T.Stroke, 1)
		box.Focused:Connect(function() tw(st, { Color = T.Accent }, 0.15) end)
		box.FocusLost:Connect(function() tw(st, { Color = T.Stroke }, 0.2) end)
		return box
	end

	-- valeur modifiable : [-] [valeur] [+] (+ curseur si smin/smax) ; la case et les boutons n'ont aucune limite
	local function makeStepper(text, getter, setter, step, smin, smax)
		local hasSlider = smin ~= nil
		local row = addRow(30)
		local lbl = rowLabel(row, text, hasSlider and UDim2.new(0, 80, 1, 0) or UDim2.new(1, -112, 1, 0))

		local plus = smallBtn(row, "+", -2)
		local minus = smallBtn(row, "−", -26)
		local box = makeBox(row, 44, 22, 11)
		box.AnchorPoint = Vector2.new(1, 0.5)
		box.Position = UDim2.new(1, -50, 0.5, 0)

		local function hold(btn, dir)
			btn.MouseButton1Down:Connect(function()
				ripple(row)
				local token = {}
				btn:SetAttribute("tok", tostring(token))
				local my = tostring(token)
				setter(getter() + dir * step)
				task.delay(0.4, function()
					while btn:GetAttribute("tok") == my do
						setter(getter() + dir * step)
						task.wait(0.06)
					end
				end)
			end)
			local function stop() btn:SetAttribute("tok", "") end
			btn.MouseButton1Up:Connect(stop)
			btn.MouseLeave:Connect(stop)
		end
		hold(plus, 1)
		hold(minus, -1)

		local fill
		if hasSlider then
			local hit = Instance.new("Frame")
			hit.BackgroundTransparency = 1
			hit.Position = UDim2.new(0, 84, 0, 0)
			hit.Size = UDim2.new(1, -(84 + 104), 1, 0)
			hit.Active = true
			hit.ZIndex = 4
			hit.Parent = row
			local track = Instance.new("Frame")
			track.Position = UDim2.new(0, 0, 0.5, -2)
			track.Size = UDim2.new(1, 0, 0, 4)
			track.BackgroundColor3 = T.Off
			track.BorderSizePixel = 0
			track.ZIndex = 4
			track.Parent = hit
			corner(track, 2)
			fill = Instance.new("Frame")
			fill.Size = UDim2.new(0, 0, 1, 0)
			fill.BackgroundColor3 = Color3.new(1, 1, 1)
			fill.BorderSizePixel = 0
			fill.ZIndex = 5
			fill.Parent = track
			corner(fill, 2)
			accentGradient(fill, 0)
			local knob = Instance.new("Frame")
			knob.AnchorPoint = Vector2.new(0.5, 0.5)
			knob.Position = UDim2.new(1, 0, 0.5, 0)
			knob.Size = UDim2.new(0, 10, 0, 10)
			knob.BackgroundColor3 = Color3.new(1, 1, 1)
			knob.BorderSizePixel = 0
			knob.ZIndex = 6
			knob.Parent = fill
			knob:SetAttribute("keep", true)
			corner(knob, 5)

			local dragging = false
			local function setFromX(x)
				local rel = math.clamp((x - hit.AbsolutePosition.X) / math.max(hit.AbsoluteSize.X, 1), 0, 1)
				local v = smin + (smax - smin) * rel
				if step < 1 then v = math.floor(v / step + 0.5) * step else v = math.floor(v + 0.5) end
				setter(v)
			end
			hit.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					dragging = true
					tw(knob, { Size = UDim2.new(0, 15, 0, 15) }, 0.15, Enum.EasingStyle.Back)
					setFromX(input.Position.X)
				end
			end)
			UIS.InputChanged:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
					setFromX(input.Position.X)
				end
			end)
			UIS.InputEnded:Connect(function(input)
				if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
					dragging = false
					tw(knob, { Size = UDim2.new(0, 10, 0, 10) }, 0.2)
				end
			end)
		end

		box.FocusLost:Connect(function()
			local v = tonumber(box.Text)
			if v then setter(v) else refreshUI() end
		end)
		table.insert(refreshers, function()
			local v = getter()
			box.Text = fmt(v)
			if fill then
				tw(fill, { Size = UDim2.new(math.clamp((v - smin) / (smax - smin), 0, 1), 0, 1, 0) }, 0.12)
			end
		end)
		register(row, text)
	end

	local function makeButton(text, callback, danger)
		local row = addRow(28)
		row.BackgroundColor3 = T.CardHover
		row.BackgroundTransparency = 0.45
		local l = rowLabel(row, text, UDim2.new(1, -8, 1, 0))
		l.TextXAlignment = Enum.TextXAlignment.Center
		if danger then l.TextColor3 = T.Danger end
		local hit = hitButton(row)
		hit.MouseEnter:Connect(function() tw(row, { BackgroundTransparency = 0.15 }, 0.12) end)
		hit.MouseLeave:Connect(function() tw(row, { BackgroundTransparency = 0.45 }, 0.18) end)
		hit.MouseButton1Click:Connect(function()
			ripple(row)
			callback()
		end)
		register(row, (text:gsub("%s+%[.-%]", "")))
	end

	local function makeTextAction(text, placeholder, buttonText, callback)
		local row = addRow(30)
		local box = makeBox(row, 0, 24, 11)
		box.Font = Enum.Font.GothamMedium
		box.AnchorPoint = Vector2.new(0, 0.5)
		box.Size = UDim2.new(1, -64, 0, 24)
		box.Position = UDim2.new(0, 0, 0.5, 0)
		box.PlaceholderText = text .. " (" .. placeholder .. ")"
		box.PlaceholderColor3 = T.SubText
		box.Text = ""
		local btn = Instance.new("TextButton")
		btn.AnchorPoint = Vector2.new(1, 0.5)
		btn.Position = UDim2.new(1, 0, 0.5, 0)
		btn.Size = UDim2.new(0, 58, 0, 24)
		btn.BackgroundColor3 = T.Accent
		btn.BorderSizePixel = 0
		btn.AutoButtonColor = true
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 12
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.Text = buttonText
		btn.ZIndex = 4
		btn.Parent = row
		corner(btn, 6)
		btn.MouseButton1Click:Connect(function()
			ripple(row)
			callback(box.Text)
		end)
		box.FocusLost:Connect(function(enter) if enter then callback(box.Text) end end)
		register(row, text)
	end

	local function makeSegment(text, options, getter, setter)
		local row = addRow(50)
		local l = newLabel(row, text, 11, T.SubText, Enum.Font.GothamMedium)
		l.Position = UDim2.new(0, 4, 0, 0)
		l.Size = UDim2.new(1, -8, 0, 18)
		local holder = Instance.new("Frame")
		holder.BackgroundTransparency = 1
		holder.Position = UDim2.new(0, 0, 0, 20)
		holder.Size = UDim2.new(1, 0, 0, 26)
		holder.ZIndex = 3
		holder.Parent = row
		local hl = Instance.new("UIListLayout", holder)
		hl.FillDirection = Enum.FillDirection.Horizontal
		hl.Padding = UDim.new(0, 4)
		local n = #options
		local btns = {}
		for _, opt in ipairs(options) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1 / n, -4 * (n - 1) / n, 1, 0)
			b.BorderSizePixel = 0
			b.AutoButtonColor = false
			b.Font = Enum.Font.GothamMedium
			b.TextSize = 12
			b.Text = opt[1]
			b.ZIndex = 4
			b.Parent = holder
			corner(b, 7)
			b.MouseButton1Click:Connect(function() ripple(row); setter(opt[2]) end)
			btns[opt[2]] = b
		end
		table.insert(refreshers, function()
			local cur = getter()
			for val, b in pairs(btns) do
				local on = (val == cur)
				tw(b, { BackgroundColor3 = on and T.Accent or T.Bg, TextColor3 = on and Color3.new(1, 1, 1) or T.SubText }, 0.2)
			end
		end)
		register(row, text)
	end

	local function makeSwatches(text, colors, onPick)
		local row = addRow(50)
		local l = newLabel(row, text, 11, T.SubText, Enum.Font.GothamMedium)
		l.Position = UDim2.new(0, 4, 0, 0)
		l.Size = UDim2.new(1, -8, 0, 18)
		local holder = Instance.new("Frame")
		holder.BackgroundTransparency = 1
		holder.Position = UDim2.new(0, 2, 0, 22)
		holder.Size = UDim2.new(1, -4, 0, 24)
		holder.ZIndex = 3
		holder.Parent = row
		local ll = Instance.new("UIListLayout", holder)
		ll.FillDirection = Enum.FillDirection.Horizontal
		ll.Padding = UDim.new(0, 6)
		for _, c in ipairs(colors) do
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(0, 24, 0, 24)
			b.BackgroundColor3 = c
			b.BorderSizePixel = 0
			b.Text = ""
			b.AutoButtonColor = false
			b.ZIndex = 4
			b:SetAttribute("keep", true)
			b.Parent = holder
			corner(b, 12)
			local bs = stroke(b, Color3.new(1, 1, 1), 0)
			bs.Transparency = 0.2
			b.MouseEnter:Connect(function() tw(bs, { Thickness = 2 }, 0.12) end)
			b.MouseLeave:Connect(function() tw(bs, { Thickness = 0 }, 0.12) end)
			b.MouseButton1Click:Connect(function() onPick(c) end)
		end
		register(row, text)
	end

	local function keyLabel(keys) return keys[1].Name end

	-- raccourcis pour les valeurs de Config
	local function cfgToggle(text, tbl, key, keyText, after)
		makeToggle(text, function() return tbl[key] end,
			function(v) tbl[key] = v; if after then after(v) end; refreshUI() end, keyText)
	end
	local function cfgStep(text, tbl, key, step, smin, smax, after)
		makeStepper(text, function() return tbl[key] end,
			function(v) tbl[key] = v; if after then after(v) end; refreshUI() end, step, smin, smax)
	end
	local function both(key, v) Config.Aimbot[key] = v; Config.SilentAim[key] = v end
	local function espAfter() if Config.ESP.Enabled then refreshESP() end end
	local PARTS = { { "Tête", "Head" }, { "Torse", "Torso" }, { "Centre", "HumanoidRootPart" } }

	----------------------------------------------------------------
	-- Contenu : toutes les cartes
	----------------------------------------------------------------
	makeCard("Général", "★", { "Home", "Movement" })
	makeToggle("Noclip", function() return Config.Noclip.Enabled end, setNoclip, keyLabel(Config.Keys.Noclip))
	makeToggle("Saut infini", function() return Config.InfJump.Enabled end, setInfJump, keyLabel(Config.Keys.InfJump))
	makeToggle("Walk Speed perso", function() return Config.Walk.Enabled end, setWalkEnabled)
	makeStepper("Walk Speed", function() return Config.Walk.Speed end, setWalkSpeed, Config.Walk.Step, 0, 200)
	makeToggle("Jump Power perso", function() return Config.Jump.Enabled end, setJumpEnabled)
	makeStepper("Jump Power", function() return Config.Jump.Power end, setJumpPower, Config.Jump.Step, Config.Jump.Min, Config.Jump.Max)
	makeToggle("Fly", function() return Config.Fly.Enabled end, setFly, "Alt")
	makeStepper("Fly Speed", function() return Config.Fly.Speed end, setFlySpeed, Config.Fly.Step, 0, 300)
	cfgToggle("Fly Noclip", Config.Fly, "Noclip")
	cfgToggle("Fly Invisible", Config.Fly, "Invisible")
	makeToggle("Vehicle Mode", function() return Config.Fly.VehicleMode end, setFlyVehicle)

	makeCard("Nage", "≈", { "Home", "Movement" })
	makeToggle("Vitesse de nage perso", function() return Config.Swim.Enabled end, setSwimEnabled)
	makeStepper("Swim Speed", function() return Config.Swim.Speed end, setSwimSpeed, Config.Swim.Step, 0, 300)
	makeNote("Détection d'eau + vélocité : marche même avec les ragdolls du jeu.")

	makeCard("Combat", "◎", { "Home", "Combat" })
	makeToggle("Aimbot", function() return Config.Aimbot.Enabled end, setAimbot, keyLabel(Config.Keys.Aimbot))
	makeToggle("Silent Aim", function() return Config.SilentAim.Enabled end, setSilent, keyLabel(Config.Keys.SilentAim))
	makeToggle("Auto Fire", function() return Config.FastMod.AutoFire end, setAutoFire, keyLabel(Config.Keys.AutoFire))
	makeSub("Aimbot Settings")
	makeStepper("FOV", function() return Config.Aimbot.FOV end, function(v) both("FOV", v); refreshUI() end, 10, 0, 1000)
	makeStepper("Smoothness", function() return Config.Aimbot.Smoothness end,
		function(v) Config.Aimbot.Smoothness = v; refreshUI() end, 0.05, 0.01, 1)
	makeSegment("Target Part", PARTS, function() return Config.Aimbot.TargetPart end,
		function(v) both("TargetPart", v); refreshUI() end)
	makeToggle("Team Check", function() return Config.Aimbot.TeamCheck end, function(v) both("TeamCheck", v); refreshUI() end)
	makeToggle("Wall Check", function() return Config.Aimbot.WallCheck end, function(v) both("WallCheck", v); refreshUI() end)
	makeToggle("Prediction", function() return Config.Aimbot.Prediction end, function(v) both("Prediction", v); refreshUI() end)
	cfgToggle("Aimbot : maintenir clic droit", Config.Aimbot, "HoldToAim")
	cfgStep("Silent Aim : Hit Chance (%)", Config.SilentAim, "HitChance", 5, 1, 100)
	makeNote("Le cercle FOV s'affiche si \"FOV Circle\" est activé (onglet Visuals). Silent Aim : le jeu doit appeler _G.DevTools.GetAimPosition(...), ou un executor avec hookmetamethod le branche tout seul sur mouse.Hit.")

	makeCard("Camlock", "⌖", { "Home", "Combat" })
	makeToggle("Camlock", function() return Config.Camlock.Enabled end, setCamlock, keyLabel(Config.Keys.Camlock))
	makeButton("Verrouiller le joueur le plus proche", function()
		local p = camState.lockNearest()
		Config.Camlock.Enabled = true
		refreshUI()
		U.notify(p and ("Camlock : " .. p.Name) or "Aucune cible")
	end)
	makeSub("Camlock Settings")
	cfgStep("Smoothness", Config.Camlock, "Smoothness", 0.05, 0.01, 1)
	makeSegment("Target Part", PARTS, function() return Config.Camlock.TargetPart end,
		function(v) Config.Camlock.TargetPart = v; refreshUI() end)
	cfgToggle("Garder la cible (Sticky)", Config.Camlock, "Sticky")
	cfgToggle("Prediction", Config.Camlock, "Prediction")
	cfgToggle("Wall Check", Config.Camlock, "WallCheck")
	cfgToggle("Team Check", Config.Camlock, "TeamCheck")
	cfgStep("Portée écran (px)", Config.Camlock, "FOV", 100, 0, 2000)
	makeNote("Appuie sur C : la caméra se verrouille sur le joueur le plus proche du centre. Smoothness 1 = verrouillage total.")

	makeCard("Rapid Fire", "ϟ", { "Home", "Combat" })
	makeToggle("Rapid Fire", function() return Config.RapidFire.Enabled end, setRapidFire, keyLabel(Config.Keys.RapidFire))
	makeStepper("Tirs / seconde", function() return Config.RapidFire.Rate end,
		function(v) Config.RapidFire.Rate = math.max(v, 0); refreshUI() end, Config.RapidFire.Step, 1, 200)
	cfgToggle("Maintenir le clic", Config.RapidFire, "HoldOnly")
	cfgToggle("Forcer Tool.Enabled", Config.RapidFire, "ForceEnabled")
	cfgToggle("Deactivate après chaque tir", Config.RapidFire, "Deactivate")
	makeNote("Arme en main + clic gauche maintenu. La valeur n'a pas de limite (60 tirs max par image pour ne pas figer le jeu).")

	makeCard("ESP & Visuals", "👁", { "Home", "Visuals" })
	makeToggle("ESP", function() return Config.ESP.Enabled end, setESP, keyLabel(Config.Keys.ESP))
	cfgToggle("FOV Circle", Config.FOVCircle, "Show")
	makeSub("ESP Settings")
	makeSwatches("Fill Color", {
		Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 150, 50), Color3.fromRGB(255, 220, 60), Color3.fromRGB(70, 220, 110),
		Color3.fromRGB(60, 200, 255), Color3.fromRGB(80, 120, 255), Color3.fromRGB(190, 90, 255), Color3.fromRGB(255, 255, 255),
	}, function(c) Config.ESP.FillColor = c; espAfter() end)
	makeSwatches("Outline Color", {
		Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 220, 60), Color3.fromRGB(70, 220, 110),
		Color3.fromRGB(60, 200, 255), Color3.fromRGB(80, 120, 255), Color3.fromRGB(190, 90, 255), Color3.fromRGB(20, 20, 20),
	}, function(c) Config.ESP.OutlineColor = c; espAfter() end)
	cfgStep("Fill Transp.", Config.ESP, "FillTransparency", 0.1, 0, 1, espAfter)
	cfgStep("Outline Transp.", Config.ESP, "OutlineTransparency", 0.1, 0, 1, espAfter)
	cfgToggle("Show Names", Config.ESP, "ShowNames", nil, espAfter)
	cfgToggle("Show Distance", Config.ESP, "ShowDistance", nil, espAfter)
	cfgToggle("Team Check", Config.ESP, "TeamCheck", nil, espAfter)

	makeCard("Client Bring", "⇲", { "Home", "Player" })
	makeToggle("Bring", function() return Config.Bring.Enabled end, setBring, keyLabel(Config.Keys.Bring))
	makeSegment("Cible", { { "Un joueur", "Player" }, { "Tous", "All" } }, function() return Config.Bring.Mode end, setBringMode)
	makeTextAction("Bring un joueur", "nom", "Bring", function(t)
		local p = bringPlayer(t)
		U.notify(p and ("Bring : " .. p.Name) or "Joueur introuvable")
	end)
	makeSegment("Formation", { { "Ligne", "Line" }, { "Cercle", "Circle" }, { "Derrière", "Behind" }, { "Pile", "Stack" } },
		function() return Config.Bring.Formation end, setBringFormation)
	cfgStep("Distance", Config.Bring, "Distance", 2)
	cfgStep("Hauteur", Config.Bring, "Height", 1)
	cfgStep("Écart", Config.Bring, "Spacing", 1)
	cfgToggle("Déplacement fluide", Config.Bring, "Smooth")
	cfgStep("Vitesse fluide", Config.Bring, "SmoothSpeed", 0.05, 0.01, 1)
	cfgToggle("Ils me regardent", Config.Bring, "FaceMe")
	cfgToggle("Ignorer les assis", Config.Bring, "SkipSeated")
	cfgToggle("Ignorer mon équipe", Config.Bring, "TeamCheck")
	makeNote("Visuel côté client : les autres joueurs ne les voient pas bouger.")

	makeCard("View Player", "◉", { "Home", "Player" })
	makeTextAction("View un joueur", "nom", "View", function(t)
		local p = findPlayerByName(t)
		if p and viewPlayer(p) then U.notify("View : " .. p.Name) else U.notify("Joueur introuvable") end
	end)
	makeButton("View suivant   [End]", function()
		local p = viewCycle(1)
		U.notify(p and ("View : " .. p.Name) or "Aucun joueur")
	end)
	makeButton("View précédent", function()
		local p = viewCycle(-1)
		U.notify(p and ("View : " .. p.Name) or "Aucun joueur")
	end)
	makeButton("Arrêter le view   [Home]", function() stopView(); U.notify("View arrêté") end)

	makeCard("Téléportation", "📍", { "Home", "Teleport" })
	makeToggle("Click TP (Shift + clic)", function() return Config.TP.ClickTP end, setClickTP, keyLabel(Config.Keys.ClickTP))
	makeTextAction("TP à un joueur", "nom", "TP", tpByName)
	makeButton("Joueur suivant   [PgDn]", function() tpCycle(1) end)
	makeButton("Joueur précédent   [PgUp]", function() tpCycle(-1) end)
	makeSub("Positions")
	makeButton("Sauvegarder la position   [Insert]", function() savePosition(); U.notify("Position sauvegardée") end)
	makeButton("Retourner à la position   [Delete]", function() loadPosition(); U.notify("Retour à la position") end)
	makeButton("TP au spawn", tpSpawn)

	makeCard("Fast Mod", "⚡", { "Home", "Combat" })
	makeToggle("Enable Fast Mod", function() return Config.FastMod.Enabled end, setFastMod, keyLabel(Config.Keys.FastMod))
	cfgToggle("Anim Boost", Config.FastMod, "AnimBoost")
	makeSub("General Settings")
	makeStepper("Delay (ms)", function() return math.floor(Config.FastMod.Delay * 1000 + 0.5) end, setFastDelayMs, 1, 0, 500)
	cfgStep("Rate Value", Config.FastMod, "RateValue", 10, 0, 500)
	cfgStep("Anim Speed (x)", Config.FastMod, "AnimSpeed", 0.5)
	cfgToggle("Patch Backpack", Config.FastMod, "PatchBackpack")
	cfgToggle("Patch Modules", Config.FastMod, "PatchModules")
	cfgToggle("Watch Changes", Config.FastMod, "Watch")
	makeTextAction("Mot-clé délai", "ex: cooldown", "Add", function(t)
		U.notify(addFastKeyword(Config.FastMod.DelayKeywords, t) and "Mot-clé ajouté" or "Déjà présent ou vide")
	end)
	makeTextAction("Mot-clé cadence", "ex: rpm", "Add", function(t)
		U.notify(addFastKeyword(Config.FastMod.RateKeywords, t) and "Mot-clé ajouté" or "Déjà présent ou vide")
	end)
	makeButton("Réappliquer maintenant", function()
		if Config.FastMod.Enabled then fastPatchAll(); U.notify("Fast Mod réappliqué") else U.notify("Active d'abord le Fast Mod") end
	end)

	makeCard("Walk Fling", "✦", { "Home", "Combat", "Troll" })
	makeToggle("Walk Fling", function() return Config.WalkFling.Enabled end, setWalkFling, keyLabel(Config.Keys.WalkFling))
	makeStepper("Power", function() return Config.WalkFling.Power end, setFlingPower, Config.WalkFling.Step,
		Config.WalkFling.Min, Config.WalkFling.Max)
	cfgToggle("Only Near Players", Config.WalkFling, "OnlyNearPlayers")
	cfgStep("Trigger Range", Config.WalkFling, "TriggerRange", 1, 1, 50)
	makeToggle("Safe Return", function() return Config.WalkFling.SafeReturn end,
		function(v) Config.WalkFling.SafeReturn = v; if not v then lastSafeCF = nil end; refreshUI() end)
	cfgStep("Safe Return Dist.", Config.WalkFling, "SafeReturnDistance", 50, 50, 1000)
	cfgToggle("Notifier mes kills", Config.Kills, "Enabled")
	cfgStep("Délai contact → mort (s)", Config.Kills, "Window", 1)
	makeNote("Touches , et . : puissance −/+. Fling uniquement au contact.")

	makeCard("Fling All", "☄", { "Home", "Troll" })
	makeToggle("Fling All (boucle)", function() return Config.FlingAll.Enabled end, setFlingAll, keyLabel(Config.Keys.FlingAll))
	cfgStep("Temps max / joueur (s)", Config.FlingAll, "TimeToWait", 0.5, 0.5, 10)
	cfgStep("Pause entre cibles (s)", Config.FlingAll, "DelayBetweenTargets", 0.1, 0, 5)
	cfgStep("Pause entre boucles (s)", Config.FlingAll, "LoopDelay", 0.5, 0, 10)
	makeTextAction("Whitelist", "nom exact", "Add", function(t)
		t = (t or ""):gsub("^%s+", ""):gsub("%s+$", "")
		if t == "" then U.notify("Nom vide") return end
		table.insert(Config.FlingAll.Whitelist, t)
		U.notify("Whitelist : " .. t)
	end)
	makeButton("Vider la whitelist", function()
		table.clear(Config.FlingAll.Whitelist)
		U.notify("Whitelist vidée")
	end, true)
	makeNote("Boucle sur tous les joueurs (sauf whitelist et assis). Touche F. Coupe Walk Fling et Fly à l'activation.")

	makeCard("BTools", "🔨", { "Home", "BTools" })
	makeToggle("BTools (ouvre le panneau)", function() return Config.BTools.Enabled end, function(v) BTf.setEnabled(v) end, keyLabel(Config.Keys.BTools))
	cfgToggle("Ignorer joueurs et PNJ", Config.BTools, "IgnorePlayers")
	cfgToggle("Surbrillance au survol", Config.BTools, "ShowHover")
	cfgToggle("Glisser directement", Config.BTools, "FreeDrag")
	cfgStep("Pas de déplacement", Config.BTools, "MoveStep", 1, nil, nil, function() Config.BTools.MoveStep = math.max(Config.BTools.MoveStep, 0) end)
	cfgStep("Pas de taille", Config.BTools, "ResizeStep", 1, nil, nil, function() Config.BTools.ResizeStep = math.max(Config.BTools.ResizeStep, 0) end)
	cfgStep("Pas de rotation (°)", Config.BTools, "RotateStep", 5, nil, nil, function() Config.BTools.RotateStep = math.max(Config.BTools.RotateStep, 0) end)
	makeSub("Historique")
	makeButton("Annuler   [Ctrl+Z]", function() BTf.undo() end)
	makeButton("Rétablir   [Ctrl+Y]", function() BTf.redo() end)
	makeButton("Tout annuler", function() BTf.undoAll() end, true)
	makeNote("V = outil suivant • Ctrl+D = cloner • Retour arrière = supprimer • Ctrl+clic = multi-sélection • Shift+clic = modèle entier. Tout est client-side.")

	makeCard("Nextbot Spam", "☠", { "Home", "Misc", "Troll" })
	makeButton("Spawn Nextbot (x1)", function() spawnLocalNextbot() end)
	cfgStep("Speed", Config.NextbotSpam, "Speed", 5, 0, 200)

	makeCard("Interface", "🎨", { "Home", "Settings" })
	makeSwatches("Couleur d'accent", {
		Color3.fromRGB(36, 140, 255), Color3.fromRGB(124, 108, 255), Color3.fromRGB(50, 210, 220), Color3.fromRGB(60, 200, 120),
		Color3.fromRGB(255, 190, 60), Color3.fromRGB(255, 120, 70), Color3.fromRGB(240, 80, 80), Color3.fromRGB(255, 95, 160),
	}, function(c) U.setAccent(c) end)
	makeToggle("Blur Background", function() return M.Blur end, function(v) M.Blur = v; U.updateFx(); refreshUI() end)
	makeStepper("Blur", function() return M.BlurSize end, function(v) M.BlurSize = math.max(math.floor(v), 0); U.updateFx(); refreshUI() end, 2, 0, 40)
	makeStepper("Dim", function() return M.Dim end, function(v) M.Dim = math.clamp(v, 0, 1); U.updateFx(); refreshUI() end, 0.05, 0, 1)
	makeToggle("Animations", function() return M.Animations end, function(v) M.Animations = v; refreshUI() end)
	makeToggle("Animated Border", function() return M.AnimBorder end, function(v) M.AnimBorder = v; U.setShimmer(v); refreshUI() end)
	cfgToggle("Show Notifications", Config.Notify, "Toggles")
	makeButton("Réinitialiser taille et position", function() U.resetWindow() end)
	makeNote("K ou Ctrl droit : cacher / afficher le panel.")


	----------------------------------------------------------------
	-- Ouverture / fermeture / réduction / flou
	----------------------------------------------------------------
	function U.updateFx()
		local showFx = N.open and not N.minimized
		tw(blur, { Size = (showFx and M.Blur) and M.BlurSize or 0 }, 0.4)
		tw(dim, { BackgroundTransparency = showFx and (1 - math.clamp(M.Dim, 0, 1)) or 1 }, 0.4)
	end

	local function mainPos() return M.StartPosition end
	local homePos = nil

	function U.setOpen(v)
		if v == N.open then return end
		N.open = v
		if v then
			main.Visible = true
			local base = homePos or main.Position
			homePos = nil
			scale.Scale = 0.9
			main.Position = base + UDim2.fromOffset(0, 26)
			tw(scale, { Scale = 1 }, 0.45, Enum.EasingStyle.Back)
			tw(main, { Position = base }, 0.45, Enum.EasingStyle.Quint)
			animateIn()
		else
			homePos = main.Position
			tw(scale, { Scale = 0.92 }, 0.22)
			tw(main, { Position = main.Position + UDim2.fromOffset(0, 22) }, 0.22)
			task.delay(dur(0.23), function()
				if not N.open then
					main.Visible = false
					if homePos then main.Position = homePos end
				end
			end)
		end
		U.updateFx()
	end

	function U.toggleMenu() U.setOpen(not N.open) end

	function U.setMinimized(v)
		N.minimized = v
		if v then
			tw(main, { Size = UDim2.new(0, math.min(FULL.X.Offset, 620), 0, HEAD_H) }, 0.35, Enum.EasingStyle.Quint)
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
		U.notify("Panel masqué : appuie sur K pour le rouvrir")
	end)

	local function applyLayout()
		local vp = camera.ViewportSize
		local w = math.min(M.Width, vp.X - 20)
		local h = math.min(M.Height, vp.Y - 40)
		FULL = UDim2.new(0, w, 0, h)
		N.compact = w < 800
		local sbw = N.compact and 68 or SIDE_W
		V.sidebar.Size = UDim2.new(0, sbw, 1, 0)
		V.content.Position = UDim2.new(0, sbw, 0, 0)
		V.content.Size = UDim2.new(1, -sbw, 1, 0)
		for _, e in pairs(N.navs) do e.txt.Visible = not N.compact end
		V.userNm.Visible = not N.compact
		V.userSt.Visible = not N.compact
		V.chips.Visible = not N.compact
		V.sub.Visible = not N.compact
		V.sbox.Visible = not N.minimized
		if not N.minimized then main.Size = FULL end
		N.layout()
	end

	function U.resetWindow()
		M.Width, M.Height = M.DefaultWidth, M.DefaultHeight
		main.Position = M.StartPosition
		homePos = nil
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
				M.Width = math.clamp(gW + d.X * 2, 640, 1300) -- fenêtre centrée : ×2 pour suivre le curseur
				M.Height = math.clamp(gH + d.Y * 2, 420, 800)
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
	N.selectPage("Home")
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
		elseif keyIn(keys.Camlock, k) then
			setCamlock(not Config.Camlock.Enabled)
		elseif keyIn(keys.RapidFire, k) then
			setRapidFire(not Config.RapidFire.Enabled)
		elseif keyIn(keys.SilentAim, k) then
			setSilent(not Config.SilentAim.Enabled)
		elseif keyIn(keys.ESP, k) then
			setESP(not Config.ESP.Enabled)
		elseif keyIn(keys.WalkFling, k) then
			setWalkFling(not Config.WalkFling.Enabled)
		elseif keyIn(keys.FlingAll, k) then
			setFlingAll(not Config.FlingAll.Enabled)
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
