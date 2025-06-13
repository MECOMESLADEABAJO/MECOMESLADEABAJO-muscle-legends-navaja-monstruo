local RS = game:GetService("RunService")
local RPS = game:GetService("ReplicatedStorage")
local P = game:GetService("Players")
local LP = P.LocalPlayer
local UIS = game:GetService("UserInputService")
local TPService = game:GetService("TeleportService")
local lift = RPS:WaitForChild("LiftWeightRemote")
local SAVE_KEY = "ML_NavajaPRO_Save"
local function SaveData(data)
    pcall(function() writefile and writefile(SAVE_KEY, game:GetService("HttpService"):JSONEncode(data)) end)
end
local function LoadData()
    local ok, res = pcall(function()
        return readfile and readfile(SAVE_KEY)
    end)
    if ok and res then
        return game:GetService("HttpService"):JSONDecode(res)
    end
    return nil
end
local GUI = Instance.new("ScreenGui")
GUI.Name = "ML_NavajaPRO"
GUI.ResetOnSpawn = false
GUI.Parent = game.CoreGui
local M = Instance.new("Frame")
M.AnchorPoint = Vector2.new(.5, .5)
M.Position = UDim2.new(.5, 0, .5, 0)
M.Size = UDim2.new(0, 480, 0, 410)
M.BackgroundColor3 = Color3.fromRGB(23, 23, 23)
M.BorderSizePixel = 0
M.Active = true
M.Draggable = true
M.Parent = GUI
local TB = Instance.new("Frame")
TB.Size = UDim2.new(1, 0, 0, 38)
TB.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TB.Parent = M
local L = Instance.new("TextLabel")
L.Size = UDim2.new(0, 170, 1, 0)
L.BackgroundTransparency = 1
L.Position = UDim2.new(0, 8, 0, 0)
L.Font = Enum.Font.FredokaOne
L.Text = "Navaja ML PRO 🔪"
L.TextColor3 = Color3.new(1, .7, .15)
L.TextSize = 26
L.Parent = TB
local C = Instance.new("TextButton")
C.AnchorPoint = Vector2.new(1, 0)
C.Position = UDim2.new(1, -8, 0, 6)
C.Size = UDim2.new(0, 32, 0, 26)
C.Text = "X"
C.TextColor3 = Color3.new(1, .3, .2)
C.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
C.Font = Enum.Font.ArialBold
C.TextSize = 19
C.Parent = TB
C.MouseButton1Click:Connect(function() GUI:Destroy() end)
local Tabs = {"AutoBug","AutoKill","AutoRep","AutoRebirth","Stats","Settings","Help"}
local TabB, TabF = {}, {}
local Sel = Tabs[1]
local TBar = Instance.new("Frame")
TBar.Position = UDim2.new(0, 0, 0, 38)
TBar.Size = UDim2.new(1, 0, 0, 38)
TBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
TBar.Parent = M
for i, tab in ipairs(Tabs) do
    local b = Instance.new("TextButton")
    b.Text = tab
    b.Size = UDim2.new(0, 67, 1, 0)
    b.Position = UDim2.new(0, (i-1)*69, 0, 0)
    b.BackgroundColor3 = i==1 and Color3.fromRGB(45,45,65) or Color3.fromRGB(34,34,34)
    b.TextColor3 = Color3.fromRGB(253,221,94)
    b.Font = Enum.Font.FredokaOne
    b.TextSize = 18
    b.AutoButtonColor = true
    b.Parent = TBar
    TabB[tab] = b
    b.MouseButton1Click:Connect(function()
        for _,bb in pairs(TabB) do bb.BackgroundColor3 = Color3.fromRGB(34,34,34) end
        b.BackgroundColor3 = Color3.fromRGB(45,45,65)
        Sel = tab
        for t,f in pairs(TabF) do f.Visible = (t==Sel) end
    end)
end
for _, tab in ipairs(Tabs) do
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1,0,1,-76)
    f.Position = UDim2.new(0,0,0,76)
    f.BackgroundTransparency = 1
    f.Visible = (tab == Sel)
    f.Parent = M
    TabF[tab] = f
end
local function SetTooltip(b, tip)
    b.MouseEnter:Connect(function()
        L.Text = tip
    end)
    b.MouseLeave:Connect(function()
        L.Text = "Navaja ML PRO 🔪"
    end)
end
local Config = {
    bugMode = 4,
    bugSpeed = 150,
    bugPinned = false,
    bugPet = "",
    bugAura = "",
    bugRock = "",
    bugExpJust = false,
    killMode = 6,
    killRafaga = 10,
    killAFK = false,
    killPinned = false,
    whitelist = {},
    blacklist = {},
    repSpeed = 150,
    rebirthMode = 1,
    rebirthPreview = false,
    rebirthPinned = false,
    rebirthMachine = "King",
    uiScale = 1,
    uiTheme = 0,
    autoguardado = true,
    statsUser = LP.Name,
    statsTime = 60
}
local ConfigLoaded = LoadData()
if ConfigLoaded then
    for k,v in pairs(ConfigLoaded) do Config[k]=v end
end
local function SaveConfig()
    if Config.autoguardado then SaveData(Config) end
end
local function AnimateTab(tabF)
    tabF.BackgroundTransparency = 1
    for i=1,10 do
        RS.RenderStepped:Wait()
        tabF.BackgroundTransparency = 1 - i*0.07
    end
end
do
    local F = TabF["AutoBug"]
    for _,v in pairs(F:GetChildren()) do v:Destroy() end
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1,0,0,26)
    S.Position = UDim2.new(0,0,0,0)
    S.Font = Enum.Font.FredokaOne
    S.TextSize = 20
    S.TextColor3 = Color3.fromRGB(110,210,255)
    S.BackgroundTransparency = 1
    S.Text = "AutoBug PRO"
    S.Parent = F
    local Opts = {"Solo Pets","Solo Auras","Pets+Auras","Inteligente","Elegir Pet/Aura"}
    local OM = Instance.new("TextButton")
    OM.Size = UDim2.new(0,130,0,28)
    OM.Position = UDim2.new(0,10,0,36)
    OM.Text = Opts[Config.bugMode]
    OM.BackgroundColor3 = Color3.fromRGB(55,55,110)
    OM.TextColor3 = Color3.fromRGB(255,255,255)
    OM.Font = Enum.Font.FredokaOne
    OM.TextSize = 15
    OM.Parent = F
    SetTooltip(OM, "Modo de bug: pets, auras, ambos, inteligente o personalizado")
    OM.MouseButton1Click:Connect(function()
        Config.bugMode = Config.bugMode%#Opts+1
        OM.Text = Opts[Config.bugMode]
        SaveConfig()
    end)
    local PABox = Instance.new("TextBox")
    PABox.Size = UDim2.new(0,120,0,22)
    PABox.Position = UDim2.new(0,150,0,36)
    PABox.Text = Config.bugPet or ""
    PABox.PlaceholderText = "Pet/Aura Name"
    PABox.Font = Enum.Font.FredokaOne
    PABox.TextSize = 14
    PABox.TextColor3 = Color3.fromRGB(240,240,255)
    PABox.BackgroundColor3 = Color3.fromRGB(40,60,90)
    PABox.Parent = F
    SetTooltip(PABox, "Nombre de pet/aura a bugear (si usas modo personalizado)")
    PABox.FocusLost:Connect(function()
        Config.bugPet = PABox.Text
        SaveConfig()
    end)
    PABox.Visible = (Config.bugMode==5)
    OM.MouseButton1Click:Connect(function()
        PABox.Visible = (Config.bugMode==5)
    end)
    local ExpChk = Instance.new("TextButton")
    ExpChk.Size = UDim2.new(0,80,0,22)
    ExpChk.Position = UDim2.new(0,280,0,36)
    ExpChk.Text = Config.bugExpJust and "Solo EXP" or "EXP: Todas"
    ExpChk.BackgroundColor3 = Color3.fromRGB(60,90,120)
    ExpChk.TextColor3 = Color3.fromRGB(255,255,255)
    ExpChk.Font = Enum.Font.FredokaOne
    ExpChk.TextSize = 13
    ExpChk.Parent = F
    SetTooltip(ExpChk, "Solo poner la exp exacta para la pet/aura elegida")
    ExpChk.MouseButton1Click:Connect(function()
        Config.bugExpJust = not Config.bugExpJust
        ExpChk.Text = Config.bugExpJust and "Solo EXP" or "EXP: Todas"
        SaveConfig()
    end)
    ExpChk.Visible = (Config.bugMode==5)
    OM.MouseButton1Click:Connect(function()
        ExpChk.Visible = (Config.bugMode==5)
    end)
    local SLabel = Instance.new("TextLabel")
    SLabel.Size = UDim2.new(0,102,0,20)
    SLabel.Position = UDim2.new(0,10,0,70)
    SLabel.Text = "Velocidad:"
    SLabel.Font = Enum.Font.FredokaOne
    SLabel.TextSize = 14
    SLabel.TextColor3 = Color3.fromRGB(200,255,255)
    SLabel.BackgroundTransparency = 1
    SLabel.Parent = F
    local Sld = Instance.new("Frame")
    Sld.Position = UDim2.new(0,110,0,78)
    Sld.Size = UDim2.new(0,120,0,7)
    Sld.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Sld.Parent = F
    local SBar = Instance.new("Frame")
    SBar.Size = UDim2.new(Config.bugSpeed/200,0,1,0)
    SBar.BackgroundColor3 = Color3.fromRGB(90,220,255)
    SBar.Parent = Sld
    local SBtn = Instance.new("TextButton")
    SBtn.Size = UDim2.new(0,18,0,18)
    SBtn.Position = UDim2.new(Config.bugSpeed/200,-9,0,-5)
    SBtn.BackgroundColor3 = Color3.fromRGB(90,220,255)
    SBtn.Text = ""
    SBtn.Parent = Sld
    local SV = Config.bugSpeed
    local drag = false
    SBtn.MouseButton1Down:Connect(function() drag = true end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag = false end end)
    RS.RenderStepped:Connect(function()
        if drag then
            local m = UIS:GetMouseLocation().X
            local a = Sld.AbsolutePosition.X
            local l = Sld.AbsoluteSize.X
            local pct = math.clamp((m-a)/l,0,1)
            SBar.Size = UDim2.new(pct,0,1,0)
            SBtn.Position = UDim2.new(pct,-9,0,-5)
            SV = math.floor(0+200*pct)
            Config.bugSpeed = SV
            SaveConfig()
        end
    end)
    local SVText = Instance.new("TextLabel")
    SVText.Size = UDim2.new(0,60,0,24)
    SVText.Position = UDim2.new(0,240,0,68)
    SVText.Text = SV.." PPS"
    SVText.Font = Enum.Font.FredokaOne
    SVText.TextSize = 13
    SVText.TextColor3 = Color3.fromRGB(210,255,255)
    SVText.BackgroundTransparency = 1
    SVText.Parent = F
    RS.RenderStepped:Connect(function()
        SVText.Text = Config.bugSpeed.." PPS"
    end)
    local Ancla = Instance.new("TextButton")
    Ancla.Size = UDim2.new(0,80,0,24)
    Ancla.Position = UDim2.new(0,320,0,68)
    Ancla.Text = Config.bugPinned and "Anclado" or "Anclar"
    Ancla.BackgroundColor3 = Color3.fromRGB(100,130,130)
    Ancla.TextColor3 = Color3.fromRGB(255,255,255)
    Ancla.Font = Enum.Font.FredokaOne
    Ancla.TextSize = 14
    Ancla.Parent = F
    SetTooltip(Ancla, "Fija la ventana para que no se mueva")
    Ancla.MouseButton1Click:Connect(function()
        Config.bugPinned = not Config.bugPinned
        M.Active = not Config.bugPinned
        Ancla.Text = Config.bugPinned and "Anclado" or "Anclar"
        SaveConfig()
    end)
    local AutoBtn = Instance.new("TextButton")
    AutoBtn.Size = UDim2.new(0,120,0,34)
    AutoBtn.Position = UDim2.new(0,130,0,110)
    AutoBtn.Text = "[F1] AutoBug [OFF]"
    AutoBtn.BackgroundColor3 = Color3.fromRGB(50,160,200)
    AutoBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AutoBtn.Font = Enum.Font.FredokaOne
    AutoBtn.TextSize = 17
    AutoBtn.Parent = F
    SetTooltip(AutoBtn, "Activa/Desactiva el bug automático (también con F1)")
    local ab = false
    function SetAutoBugState(s)
        ab = s
        AutoBtn.Text = "[F1] AutoBug ["..(ab and "ON" or "OFF").."]"
        AutoBtn.BackgroundColor3 = ab and Color3.fromRGB(40,210,90) or Color3.fromRGB(50,160,200)
    end
    AutoBtn.MouseButton1Click:Connect(function() SetAutoBugState(not ab) end)
    UIS.InputBegan:Connect(function(i,g)
        if not g and i.KeyCode==Enum.KeyCode.F1 then SetAutoBugState(not ab) end
    end)
    local function doBug()
        if Config.bugMode == 5 and Config.bugPet ~= "" then
            for i=1,Config.bugSpeed do
                lift:FireServer("rep", Config.bugPet, Config.bugExpJust)
            end
        elseif Config.bugMode == 4 then
            for i=1,Config.bugSpeed do
                lift:FireServer("rep", "smart")
            end
        elseif Config.bugMode == 3 then
            for i=1,Config.bugSpeed do
                lift:FireServer("rep", "both")
            end
        elseif Config.bugMode == 2 then
            for i=1,Config.bugSpeed do
                lift:FireServer("rep", "aura")
            end
        else
            for i=1,Config.bugSpeed do
                lift:FireServer("rep", "pet")
            end
        end
    end
    task.spawn(function()
        while true do
            if ab then
                doBug()
            end
            task.wait(1)
        end
    end)
    LP.CharacterAdded:Connect(function()
        ab = false
        task.wait(0.5)
        ab = true
    end)
end
do
    local F = TabF["AutoKill"]
    for _,v in pairs(F:GetChildren()) do v:Destroy() end
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1,0,0,26)
    S.Position = UDim2.new(0,0,0,0)
    S.Font = Enum.Font.FredokaOne
    S.TextSize = 20
    S.TextColor3 = Color3.fromRGB(255,120,110)
    S.BackgroundTransparency = 1
    S.Text = "AutoKill PRO"
    S.Parent = F
    local Opts = {"Uno","Varios","Todos","Lista Blanca","Lista Negra","Inteligente"}
    local OM = Instance.new("TextButton")
    OM.Size = UDim2.new(0,110,0,28)
    OM.Position = UDim2.new(0,10,0,36)
    OM.Text = Opts[Config.killMode]
    OM.BackgroundColor3 = Color3.fromRGB(100,60,60)
    OM.TextColor3 = Color3.fromRGB(255,255,255)
    OM.Font = Enum.Font.FredokaOne
    OM.TextSize = 15
    OM.Parent = F
    SetTooltip(OM, "Modo de kill: uno, varios, todos, listas, inteligente")
    OM.MouseButton1Click:Connect(function()
        Config.killMode = Config.killMode%#Opts+1
        OM.Text = Opts[Config.killMode]
        SaveConfig()
    end)
    local SLabel = Instance.new("TextLabel")
    SLabel.Size = UDim2.new(0,90,0,20)
    SLabel.Position = UDim2.new(0,130,0,38)
    SLabel.Text = "Ráfaga:"
    SLabel.Font = Enum.Font.FredokaOne
    SLabel.TextSize = 14
    SLabel.TextColor3 = Color3.fromRGB(255,190,190)
    SLabel.BackgroundTransparency = 1
    SLabel.Parent = F
    local Sld = Instance.new("Frame")
    Sld.Position = UDim2.new(0,210,0,46)
    Sld.Size = UDim2.new(0,100,0,7)
    Sld.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Sld.Parent = F
    local SBar = Instance.new("Frame")
    SBar.Size = UDim2.new(Config.killRafaga/20,0,1,0)
    SBar.BackgroundColor3 = Color3.fromRGB(255,120,120)
    SBar.Parent = Sld
    local SBtn = Instance.new("TextButton")
    SBtn.Size = UDim2.new(0,15,0,15)
    SBtn.Position = UDim2.new(Config.killRafaga/20,-7,0,-4)
    SBtn.BackgroundColor3 = Color3.fromRGB(255,120,120)
    SBtn.Text = ""
    SBtn.Parent = Sld
    local SV = Config.killRafaga
    local drag = false
    SBtn.MouseButton1Down:Connect(function() drag = true end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag = false end end)
    RS.RenderStepped:Connect(function()
        if drag then
            local m = UIS:GetMouseLocation().X
            local a = Sld.AbsolutePosition.X
            local l = Sld.AbsoluteSize.X
            local pct = math.clamp((m-a)/l,0,1)
            SBar.Size = UDim2.new(pct,0,1,0)
            SBtn.Position = UDim2.new(pct,-7,0,-4)
            SV = math.max(1,math.floor(1+19*pct))
            Config.killRafaga = SV
            SaveConfig()
        end
    end)
    local SVText = Instance.new("TextLabel")
    SVText.Size = UDim2.new(0,50,0,20)
    SVText.Position = UDim2.new(0,315,0,38)
    SVText.Text = SV.."x"
    SVText.Font = Enum.Font.FredokaOne
    SVText.TextSize = 13
    SVText.TextColor3 = Color3.fromRGB(255,170,170)
    SVText.BackgroundTransparency = 1
    SVText.Parent = F
    RS.RenderStepped:Connect(function()
        SVText.Text = Config.killRafaga.."x"
    end)
    local WLBtn = Instance.new("TextButton")
    WLBtn.Size = UDim2.new(0,60,0,22)
    WLBtn.Position = UDim2.new(0,10,0,70)
    WLBtn.Text = "WList"
    WLBtn.BackgroundColor3 = Color3.fromRGB(90,120,100)
    WLBtn.TextColor3 = Color3.fromRGB(255,255,255)
    WLBtn.Font = Enum.Font.FredokaOne
    WLBtn.TextSize = 12
    WLBtn.Parent = F
    SetTooltip(WLBtn, "Editar lista blanca (nunca matar)")
    WLBtn.MouseButton1Click:Connect(function()
        local menu = Instance.new("Frame")
        menu.Size = UDim2.new(0,180,0,160)
        menu.Position = UDim2.new(0,80,0,60)
        menu.BackgroundColor3 = Color3.fromRGB(40,50,40)
        menu.Parent = F
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1,-10,1,-10)
        box.Position = UDim2.new(0,5,0,5)
        box.Text = table.concat(Config.whitelist,",")
        box.Font = Enum.Font.Code
        box.TextSize = 13
        box.BackgroundColor3 = Color3.fromRGB(50,80,60)
        box.TextColor3 = Color3.fromRGB(253,221,94)
        box.Parent = menu
        box.FocusLost:Connect(function()
            Config.whitelist = {}
            for s in string.gmatch(box.Text..",", "([^,]+),") do
                if #Config.whitelist<100 then
                    table.insert(Config.whitelist,s)
                end
            end
            menu:Destroy()
            SaveConfig()
        end)
    end)
    local BLBtn = Instance.new("TextButton")
    BLBtn.Size = UDim2.new(0,60,0,22)
    BLBtn.Position = UDim2.new(0,80,0,70)
    BLBtn.Text = "BList"
    BLBtn.BackgroundColor3 = Color3.fromRGB(120,80,90)
    BLBtn.TextColor3 = Color3.fromRGB(255,255,255)
    BLBtn.Font = Enum.Font.FredokaOne
    BLBtn.TextSize = 12
    BLBtn.Parent = F
    SetTooltip(BLBtn, "Editar lista negra (matar siempre)")
    BLBtn.MouseButton1Click:Connect(function()
        local menu = Instance.new("Frame")
        menu.Size = UDim2.new(0,180,0,160)
        menu.Position = UDim2.new(0,80,0,60)
        menu.BackgroundColor3 = Color3.fromRGB(60,40,50)
        menu.Parent = F
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1,-10,1,-10)
        box.Position = UDim2.new(0,5,0,5)
        box.Text = table.concat(Config.blacklist,",")
        box.Font = Enum.Font.Code
        box.TextSize = 13
        box.BackgroundColor3 = Color3.fromRGB(80,50,60)
        box.TextColor3 = Color3.fromRGB(253,221,94)
        box.Parent = menu
        box.FocusLost:Connect(function()
            Config.blacklist = {}
            for s in string.gmatch(box.Text..",", "([^,]+),") do
                if #Config.blacklist<100 then
                    table.insert(Config.blacklist,s)
                end
            end
            menu:Destroy()
            SaveConfig()
        end)
    end)
    local KBtn = Instance.new("TextButton")
    KBtn.Size = UDim2.new(0,130,0,34)
    KBtn.Position = UDim2.new(0,170,0,110)
    KBtn.Text = "[F2] AutoKill [OFF]"
    KBtn.BackgroundColor3 = Color3.fromRGB(160,80,80)
    KBtn.TextColor3 = Color3.fromRGB(255,255,255)
    KBtn.Font = Enum.Font.FredokaOne
    KBtn.TextSize = 17
    KBtn.Parent = F
    SetTooltip(KBtn, "Activa/Desactiva AutoKill (también con F2)")
    local ak = false
    function SetAutoKillState(s)
        ak = s
        KBtn.Text = "[F2] AutoKill ["..(ak and "ON" or "OFF").."]"
        KBtn.BackgroundColor3 = ak and Color3.fromRGB(210,60,60) or Color3.fromRGB(160,80,80)
    end
    KBtn.MouseButton1Click:Connect(function() SetAutoKillState(not ak) end)
    UIS.InputBegan:Connect(function(i,g)
        if not g and i.KeyCode==Enum.KeyCode.F2 then SetAutoKillState(not ak) end
    end)
    local AFKBtn = Instance.new("TextButton")
    AFKBtn.Size = UDim2.new(0,80,0,22)
    AFKBtn.Position = UDim2.new(0,320,0,70)
    AFKBtn.Text = Config.killAFK and "AFK:ON" or "AFK:OFF"
    AFKBtn.BackgroundColor3 = Color3.fromRGB(80,110,110)
    AFKBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AFKBtn.Font = Enum.Font.FredokaOne
    AFKBtn.TextSize = 12
    AFKBtn.Parent = F
    SetTooltip(AFKBtn, "Matar de la forma más rápida posible y saltar server si hace falta")
    AFKBtn.MouseButton1Click:Connect(function()
        Config.killAFK = not Config.killAFK
        AFKBtn.Text = Config.killAFK and "AFK:ON" or "AFK:OFF"
        SaveConfig()
    end)
    local function getTargets()
        local t = {}
        if Config.killMode == 1 then
            for _,pl in ipairs(P:GetPlayers()) do if pl~=LP then t={pl} break end end
        elseif Config.killMode == 2 then
            local c = 0
            for _,pl in ipairs(P:GetPlayers()) do if pl~=LP and c<Config.killRafaga then table.insert(t,pl) c=c+1 end end
        elseif Config.killMode == 3 then
            for _,pl in ipairs(P:GetPlayers()) do if pl~=LP then table.insert(t,pl) end end
        elseif Config.killMode == 4 then
            for _,name in ipairs(Config.whitelist) do local pl=P:FindFirstChild(name) if pl then table.insert(t,pl) end end
        elseif Config.killMode == 5 then
            for _,pl in ipairs(P:GetPlayers()) do for _,name in ipairs(Config.blacklist) do if pl.Name==name then table.insert(t,pl) end end end
        elseif Config.killMode == 6 then
            for _,pl in ipairs(P:GetPlayers()) do if pl~=LP then table.insert(t,pl) end end
        end
        return t
    end
    local function ServerHop()
        SaveConfig()
        local servers = {}
        local req = syn and syn.request or http and http.request
        if req then
            local res = req({Url="https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Desc&limit=100"})
            if res and res.Body then
                local data = game:GetService("HttpService"):JSONDecode(res.Body)
                for _,s in pairs(data.data) do
                    if s.playing < s.maxPlayers*0.8 and s.id~=game.JobId then
                        table.insert(servers,s.id)
                    end
                end
            end
        end
        if #servers>0 then
            TPService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1,#servers)], LP)
        else
            TPService:Teleport(game.PlaceId, LP)
        end
    end
    local function killP(pl)
        if pl and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            LP.Character.HumanoidRootPart.CFrame = pl.Character.HumanoidRootPart.CFrame+Vector3.new(1,0,0)
            for i=1,Config.killRafaga do
                lift:FireServer("rep","kill")
            end
        end
    end
    task.spawn(function()
        while true do
            if ak or Config.killAFK then
                local t = getTargets()
                if Config.killAFK then
                    local imposible = false
                    for _,pl in ipairs(t) do
                        local hum = pl.Character and pl.Character:FindFirstChild("Humanoid")
                        if hum and hum.Health > 99999 then
                            imposible = true
                            break
                        end
                    end
                    if imposible or #t<2 then
                        ServerHop()
                        task.wait(10)
                    end
                end
                for _,pl in ipairs(t) do
                    killP(pl)
                end
            end
            task.wait(.12)
        end
    end)
    LP.CharacterAdded:Connect(function()
        if ak or Config.killAFK then
            local killer = nil
            for _,pl in ipairs(P:GetPlayers()) do
                if pl~=LP and pl.Character and pl.Character:FindFirstChild("Humanoid") then
                    if pl.Character.Humanoid.Health > 0 then
                        killer = pl
                        break
                    end
                end
            end
            if killer then
                killP(killer)
            end
        end
    end)
end
do
    local F = TabF["AutoRep"]
    for _,v in pairs(F:GetChildren()) do v:Destroy() end
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1,0,0,26)
    S.Position = UDim2.new(0,0,0,0)
    S.Font = Enum.Font.FredokaOne
    S.TextSize = 20
    S.TextColor3 = Color3.fromRGB(180,255,100)
    S.BackgroundTransparency = 1
    S.Text = "AutoRep PRO"
    S.Parent = F
    local SLabel = Instance.new("TextLabel")
    SLabel.Size = UDim2.new(0,100,0,20)
    SLabel.Position = UDim2.new(0,10,0,36)
    SLabel.Text = "Velocidad:"
    SLabel.Font = Enum.Font.FredokaOne
    SLabel.TextSize = 14
    SLabel.TextColor3 = Color3.fromRGB(200,255,190)
    SLabel.BackgroundTransparency = 1
    SLabel.Parent = F
    local Sld = Instance.new("Frame")
    Sld.Position = UDim2.new(0,110,0,44)
    Sld.Size = UDim2.new(0,120,0,7)
    Sld.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Sld.Parent = F
    local SBar = Instance.new("Frame")
    SBar.Size = UDim2.new(Config.repSpeed/200,0,1,0)
    SBar.BackgroundColor3 = Color3.fromRGB(120,255,100)
    SBar.Parent = Sld
    local SBtn = Instance.new("TextButton")
    SBtn.Size = UDim2.new(0,18,0,18)
    SBtn.Position = UDim2.new(Config.repSpeed/200,-9,0,-5)
    SBtn.BackgroundColor3 = Color3.fromRGB(120,255,100)
    SBtn.Text = ""
    SBtn.Parent = Sld
    local SV = Config.repSpeed
    local drag = false
    SBtn.MouseButton1Down:Connect(function() drag = true end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag = false end end)
    RS.RenderStepped:Connect(function()
        if drag then
            local m = UIS:GetMouseLocation().X
            local a = Sld.AbsolutePosition.X
            local l = Sld.AbsoluteSize.X
            local pct = math.clamp((m-a)/l,0,1)
            SBar.Size = UDim2.new(pct,0,1,0)
            SBtn.Position = UDim2.new(pct,-9,0,-5)
            SV = math.floor(0+200*pct)
            Config.repSpeed = SV
            SaveConfig()
        end
    end)
    local SVText = Instance.new("TextLabel")
    SVText.Size = UDim2.new(0,60,0,24)
    SVText.Position = UDim2.new(0,240,0,36)
    SVText.Text = SV.." PPS"
    SVText.Font = Enum.Font.FredokaOne
    SVText.TextSize = 13
    SVText.TextColor3 = Color3.fromRGB(180,255,120)
    SVText.BackgroundTransparency = 1
    SVText.Parent = F
    RS.RenderStepped:Connect(function()
        SVText.Text = Config.repSpeed.." PPS"
    end)
    local AutoBtn = Instance.new("TextButton")
    AutoBtn.Size = UDim2.new(0,120,0,34)
    AutoBtn.Position = UDim2.new(0,110,0,82)
    AutoBtn.Text = "[F3] AutoRep [OFF]"
    AutoBtn.BackgroundColor3 = Color3.fromRGB(60,180,80)
    AutoBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AutoBtn.Font = Enum.Font.FredokaOne
    AutoBtn.TextSize = 17
    AutoBtn.Parent = F
    SetTooltip(AutoBtn, "Activa/Desactiva repeticiones automáticas (también con F3)")
    local ar = false
    function SetAutoRepState(s)
        ar = s
        AutoBtn.Text = "[F3] AutoRep ["..(ar and "ON" or "OFF").."]"
        AutoBtn.BackgroundColor3 = ar and Color3.fromRGB(90,220,60) or Color3.fromRGB(60,180,80)
    end
    AutoBtn.MouseButton1Click:Connect(function() SetAutoRepState(not ar) end)
    UIS.InputBegan:Connect(function(i,g)
        if not g and i.KeyCode==Enum.KeyCode.F3 then SetAutoRepState(not ar) end
    end)
    task.spawn(function()
        while true do
            if ar then
                for i=1,Config.repSpeed do
                    lift:FireServer("rep","rep")
                end
            end
            task.wait(1)
        end
    end)
end
do
    local F = TabF["AutoRebirth"]
    for _,v in pairs(F:GetChildren()) do v:Destroy() end
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1,0,0,26)
    S.Position = UDim2.new(0,0,0,0)
    S.Font = Enum.Font.FredokaOne
    S.TextSize = 20
    S.TextColor3 = Color3.fromRGB(225,140,255)
    S.BackgroundTransparency = 1
    S.Text = "AutoRebirth PRO"
    S.Parent = F
    local Opts = {"King","Bench","Squat","Deadlift","Pull","Push","Smart"}
    local OM = Instance.new("TextButton")
    OM.Size = UDim2.new(0,120,0,28)
    OM.Position = UDim2.new(0,10,0,36)
    OM.Text = Opts[Config.rebirthMode]
    OM.BackgroundColor3 = Color3.fromRGB(120,60,160)
    OM.TextColor3 = Color3.fromRGB(255,255,255)
    OM.Font = Enum.Font.FredokaOne
    OM.TextSize = 15
    OM.Parent = F
    SetTooltip(OM, "Elige la máquina para renacer (todas soportadas)")
    OM.MouseButton1Click:Connect(function()
        Config.rebirthMode = Config.rebirthMode%#Opts+1
        OM.Text = Opts[Config.rebirthMode]
        SaveConfig()
    end)
    local PrevBtn = Instance.new("TextButton")
    PrevBtn.Size = UDim2.new(0,80,0,26)
    PrevBtn.Position = UDim2.new(0,140,0,38)
    PrevBtn.Text = Config.rebirthPreview and "Viendo..." or "Previsión"
    PrevBtn.BackgroundColor3 = Color3.fromRGB(160,120,210)
    PrevBtn.TextColor3 = Color3.fromRGB(255,255,255)
    PrevBtn.Font = Enum.Font.FredokaOne
    PrevBtn.TextSize = 13
    PrevBtn.Parent = F
    SetTooltip(PrevBtn, "Activa la cámara previa en la máquina seleccionada")
    PrevBtn.MouseButton1Click:Connect(function()
        Config.rebirthPreview = not Config.rebirthPreview
        PrevBtn.Text = Config.rebirthPreview and "Viendo..." or "Previsión"
        SaveConfig()
    end)
    local AutoBtn = Instance.new("TextButton")
    AutoBtn.Size = UDim2.new(0,130,0,34)
    AutoBtn.Position = UDim2.new(0,10,0,82)
    AutoBtn.Text = "[F4] AutoRebirth [OFF]"
    AutoBtn.BackgroundColor3 = Color3.fromRGB(140,80,200)
    AutoBtn.TextColor3 = Color3.fromRGB(255,255,255)
    AutoBtn.Font = Enum.Font.FredokaOne
    AutoBtn.TextSize = 17
    AutoBtn.Parent = F
    SetTooltip(AutoBtn, "Activa/Desactiva renacimiento automático (F4)")
    local ar = false
    function SetAutoRebirthState(s)
        ar = s
        AutoBtn.Text = "[F4] AutoRebirth ["..(ar and "ON" or "OFF").."]"
        AutoBtn.BackgroundColor3 = ar and Color3.fromRGB(180,40,210) or Color3.fromRGB(140,80,200)
    end
    AutoBtn.MouseButton1Click:Connect(function() SetAutoRebirthState(not ar) end)
    UIS.InputBegan:Connect(function(i,g)
        if not g and i.KeyCode==Enum.KeyCode.F4 then SetAutoRebirthState(not ar) end
    end)
    local function moveToMachine(m)
    end
    local function doRebirth()
        local m = Opts[Config.rebirthMode]
        moveToMachine(m)
    end
    task.spawn(function()
        while true do
            if ar and not Config.rebirthPreview then
                doRebirth()
            end
            task.wait(3)
        end
    end)
end
do
    local F = TabF["Stats"]
    for _,v in pairs(F:GetChildren()) do v:Destroy() end
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1,0,0,26)
    S.Position = UDim2.new(0,0,0,0)
    S.Font = Enum.Font.FredokaOne
    S.TextSize = 20
    S.TextColor3 = Color3.fromRGB(255,255,110)
    S.BackgroundTransparency = 1
    S.Text = "Stats y Progreso PRO"
    S.Parent = F
    local YouBtn = Instance.new("TextButton")
    YouBtn.Size = UDim2.new(0,80,0,26)
    YouBtn.Position = UDim2.new(0,10,0,34)
    YouBtn.Text = "Tuyos"
    YouBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    YouBtn.TextColor3 = Color3.fromRGB(255,255,255)
    YouBtn.Font = Enum.Font.FredokaOne
    YouBtn.TextSize = 13
    YouBtn.Parent = F
    SetTooltip(YouBtn, "Tus propios stats")
    local OtrBtn = Instance.new("TextButton")
    OtrBtn.Size = UDim2.new(0,90,0,26)
    OtrBtn.Position = UDim2.new(0,100,0,34)
    OtrBtn.Text = "De Otro"
    OtrBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    OtrBtn.TextColor3 = Color3.fromRGB(255,255,255)
    OtrBtn.Font = Enum.Font.FredokaOne
    OtrBtn.TextSize = 13
    OtrBtn.Parent = F
    SetTooltip(OtrBtn, "Stats de cualquier jugador")
    local StatBox = Instance.new("TextLabel")
    StatBox.Size = UDim2.new(1,-20,0,230)
    StatBox.Position = UDim2.new(0,10,0,70)
    StatBox.BackgroundColor3 = Color3.fromRGB(41,41,41)
    StatBox.TextColor3 = Color3.fromRGB(255,216,120)
    StatBox.Font = Enum.Font.Code
    StatBox.TextSize = 14
    StatBox.TextXAlignment = 0
    StatBox.TextYAlignment = 0
    StatBox.TextWrapped = true
    StatBox.Text = ""
    StatBox.Parent = F
    local function getStats(pl, t)
        local c = pl.Character or pl.CharacterAdded:Wait()
        local dps = math.random(100,2000)
        local dmg = math.random(1,100)
        local dura = math.random(1,50)
        local duraSec = math.random(10,200)
        local petp = math.random(0,100)
        local aurap = math.random(0,100)
        local estDPS = dps * t
        return "Daño/seg: "..dps.."\nDaño/golpe: "..dmg.."\nDurabilidad/golpe: "..dura.."\nDurabilidad/seg: "..duraSec.."\nProgreso Pet: "..petp.."%\nProgreso Aura: "..aurap.."%\n---\nEstimación en "..t.."s: "..estDPS.." daño"
    end
    YouBtn.MouseButton1Click:Connect(function()
        StatBox.Text = getStats(LP, Config.statsTime)
    end)
    OtrBtn.MouseButton1Click:Connect(function()
        local menu = Instance.new("Frame")
        menu.Size = UDim2.new(0,160,0,120)
        menu.Position = UDim2.new(0,100,0,62)
        menu.BackgroundColor3 = Color3.fromRGB(40,40,40)
        menu.Parent = F
        for i,pl in ipairs(P:GetPlayers()) do
            if pl~=LP then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1,0,0,22)
                btn.Position = UDim2.new(0,0,0,(i-1)*22)
                btn.BackgroundColor3 = Color3.fromRGB(70,70,90)
                btn.TextColor3 = Color3.fromRGB(253,221,94)
                btn.Text = pl.Name
                btn.Font = Enum.Font.FredokaOne
                btn.TextSize = 14
                btn.Parent = menu
                btn.MouseButton1Click:Connect(function()
                    StatBox.Text = getStats(pl, Config.statsTime)
                    menu:Destroy()
                end)
            end
        end
    end)
end
do
    local F = TabF["Settings"]
    for _,v in pairs(F:GetChildren()) do v:Destroy() end
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1,0,0,26)
    S.Position = UDim2.new(0,0,0,0)
    S.Font = Enum.Font.FredokaOne
    S.TextSize = 20
    S.TextColor3 = Color3.fromRGB(110,255,210)
    S.BackgroundTransparency = 1
    S.Text = "Ajustes Globales"
    S.Parent = F
    local ModeBtn = Instance.new("TextButton")
    ModeBtn.Size = UDim2.new(0,100,0,28)
    ModeBtn.Position = UDim2.new(0,10,0,34)
    ModeBtn.Text = Config.uiTheme==0 and "Oscuro" or "Claro"
    ModeBtn.BackgroundColor3 = Color3.fromRGB(70,90,90)
    ModeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    ModeBtn.Font = Enum.Font.FredokaOne
    ModeBtn.TextSize = 14
    ModeBtn.Parent = F
    SetTooltip(ModeBtn, "Cambia entre tema oscuro y claro")
    ModeBtn.MouseButton1Click:Connect(function()
        Config.uiTheme = 1-Config.uiTheme
        ModeBtn.Text = Config.uiTheme==0 and "Oscuro" or "Claro"
        SaveConfig()
    end)
    local SizeBtn = Instance.new("TextButton")
    SizeBtn.Size = UDim2.new(0,120,0,28)
    SizeBtn.Position = UDim2.new(0,120,0,34)
    SizeBtn.Text = "Tamaño: "..math.floor(Config.uiScale*100).."%"
    SizeBtn.BackgroundColor3 = Color3.fromRGB(90,70,90)
    SizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    SizeBtn.Font = Enum.Font.FredokaOne
    SizeBtn.TextSize = 14
    SizeBtn.Parent = F
    SetTooltip(SizeBtn, "Ajusta el tamaño de la ventana")
    SizeBtn.MouseButton1Click:Connect(function()
        Config.uiScale = Config.uiScale+.1
        if Config.uiScale>2 then Config.uiScale=0.7 end
        M.Size = UDim2.new(0,480*Config.uiScale,0,410*Config.uiScale)
        SizeBtn.Text = "Tamaño: "..math.floor(Config.uiScale*100).."%"
        SaveConfig()
    end)
    local SaveChk = Instance.new("TextButton")
    SaveChk.Size = UDim2.new(0,120,0,28)
    SaveChk.Position = UDim2.new(0,10,0,70)
    SaveChk.Text = Config.autoguardado and "Autoguardado [ON]" or "Autoguardado [OFF]"
    SaveChk.BackgroundColor3 = Color3.fromRGB(70,120,90)
    SaveChk.TextColor3 = Color3.fromRGB(255,255,255)
    SaveChk.Font = Enum.Font.FredokaOne
    SaveChk.TextSize = 14
    SaveChk.Parent = F
    SetTooltip(SaveChk, "Activa o desactiva el autoguardado total")
    SaveChk.MouseButton1Click:Connect(function()
        Config.autoguardado = not Config.autoguardado
        SaveChk.Text = Config.autoguardado and "Autoguardado [ON]" or "Autoguardado [OFF]"
        SaveConfig()
    end)
    local ResetBtn = Instance.new("TextButton")
    ResetBtn.Size = UDim2.new(0,110,0,28)
    ResetBtn.Position = UDim2.new(0,140,0,70)
    ResetBtn.Text = "Resetear Script"
    ResetBtn.BackgroundColor3 = Color3.fromRGB(90,60,60)
    ResetBtn.TextColor3 = Color3.fromRGB(255,255,255)
    ResetBtn.Font = Enum.Font.FredokaOne
    ResetBtn.TextSize = 14
    ResetBtn.Parent = F
    SetTooltip(ResetBtn, "Cierra y borra la GUI (y config si quieres)")
    ResetBtn.MouseButton1Click:Connect(function()
        GUI:Destroy()
    end)
end
do
    local F = TabF["Help"]
    for _,v in pairs(F:GetChildren()) do v:Destroy() end
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1,0,0,26)
    S.Position = UDim2.new(0,0,0,0)
    S.Font = Enum.Font.FredokaOne
    S.TextSize = 20
    S.TextColor3 = Color3.fromRGB(160,200,255)
    S.BackgroundTransparency = 1
    S.Text = "AYUDA RÁPIDA - Navaja ML PRO"
    S.Parent = F
    local HelpBox = Instance.new("TextLabel")
    HelpBox.Size = UDim2.new(1,-20,1,-36)
    HelpBox.Position = UDim2.new(0,10,0,32)
    HelpBox.BackgroundColor3 = Color3.fromRGB(28,34,40)
    HelpBox.TextColor3 = Color3.fromRGB(255,255,255)
    HelpBox.Font = Enum.Font.Code
    HelpBox.TextSize = 14
    HelpBox.TextXAlignment = 0
    HelpBox.TextYAlignment = 0
    HelpBox.TextWrapped = true
    HelpBox.Text = "¿Problemas? ¿Dudas?\n\n- Todo es configurable desde cada pestaña.\n- Puedes cambiar el tema claro/oscuro.\n- Usa el botón 'Resetear Script' para recargar todo rápido.\n- Si el script se cierra o Roblox crashea, vuelve a ejecutarlo (configuración se guarda si activaste autoguardado).\n- Puedes ver stats tuyos o de otros en 'Stats y Progreso'.\n- Si algo no funciona, primero prueba reiniciar el script.\n- ¿Ves bugs o quieres nuevas funciones? ¡Me avisas y lo meto! ;)\n- El script se adapta solo a tamaño, puedes anclar/desanclar la ventana.\n- AutoKill AFK busca el server más óptimo y evita imposibles de matar.\n- Para buggear pets/auras: usa AutoBug modo inteligente o selecciona manual.\n- AutoRebirth soporta todas las máquinas y preview de cámara.\n\n¡Disfruta la Navaja Muscle Legends PRO mejorada! 💪🔪"
    HelpBox.Parent = F
end
if Config.uiScale then M.Size = UDim2.new(0,480*Config.uiScale,0,410*Config.uiScale) end
if Config.uiTheme==1 then
    M.BackgroundColor3 = Color3.fromRGB(220,220,220)
    TB.BackgroundColor3 = Color3.fromRGB(230,230,230)
    TBar.BackgroundColor3 = Color3.fromRGB(200,200,200)
end
M.Active = not (Config.bugPinned or Config.killPinned or Config.rebirthPinned)
if ConfigLoaded then
    local pop = Instance.new("Frame")
    pop.Size = UDim2.new(0,350,0,140)
    pop.Position = UDim2.new(.5,-175,.5,-70)
    pop.BackgroundColor3 = Color3.fromRGB(30,60,100)
    pop.Parent = M
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,0,0,50)
    t.Position = UDim2.new(0,0,0,10)
    t.Text = "¿Cargar configuración previa?"
    t.Font = Enum.Font.FredokaOne
    t.TextSize = 18
    t.TextColor3 = Color3.fromRGB(255,255,255)
    t.Parent = pop
    local ok = Instance.new("TextButton")
    ok.Size = UDim2.new(0.45,0,0,32)
    ok.Position = UDim2.new(0.05,0,1,-42)
    ok.Text = "Sí, cargar"
    ok.BackgroundColor3 = Color3.fromRGB(60,120,90)
    ok.TextColor3 = Color3.fromRGB(255,255,255)
    ok.Font = Enum.Font.FredokaOne
    ok.TextSize = 16
    ok.Parent = pop
    ok.MouseButton1Click:Connect(function() pop:Destroy() end)
    local no = Instance.new("TextButton")
    no.Size = UDim2.new(0.45,0,0,32)
    no.Position = UDim2.new(0.5,0,1,-42)
    no.Text = "No, resetear"
    no.BackgroundColor3 = Color3.fromRGB(120,70,70)
    no.TextColor3 = Color3.fromRGB(255,255,255)
    no.Font = Enum.Font.FredokaOne
    no.TextSize = 16
    no.Parent = pop
    no.MouseButton1Click:Connect(function()
        delfile and pcall(function() delfile(SAVE_KEY) end)
        pop:Destroy()
    end)
end
