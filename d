-------------------------------------------------
-- ANTI-DOUBLE EXECUTION
-------------------------------------------------
if _G.DetectorRunning then 
    warn("Script is already running!") 
    return 
end
_G.DetectorRunning = true

-------------------------------------------------
-- PERMANENT KEY SYSTEM + USER ID CHECK
-------------------------------------------------
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- 🔑 KEYS
local PRIMARY_KEY = "New_Jmaster_is_king"
local SECRET_BYPASS_KEY = "no one knows this so fuck you"

-- 👤 ALLOWED USER IDS (Only required for PRIMARY_KEY)
local AllowedUsers = {
    --[14768594] = true,
   -- [14768594] = true,
    --[14768594] = true,
    [930418048] = true,
    [4778259229] = true,
    [14768594] = true,
}

local KEY_FILE = "mod_notifier"
local accessGranted = false

-- 🔊 UI SOUND HANDLER
local function playUISound(id, vol)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = vol or 1
    s.Parent = game:GetService("SoundService")
    s:Play()
    task.delay(3, function() s:Destroy() end)
end

-- 🔒 PERMANENT CHECK
if isfile and isfile(KEY_FILE) then
    accessGranted = true
end

-------------------------------------------------
-- KEY SYSTEM UI
-------------------------------------------------
if not accessGranted then
    playUISound("rbxassetid://170765130", 0.8)

    local gui = Instance.new("ScreenGui")
    gui.Name = "KeySystemUI_Unique"
    gui.ResetOnSpawn = false
    gui.Parent = game:GetService("CoreGui")

    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.fromScale(0.28, 0.22)
    frame.Position = UDim2.fromScale(0.36, 0.35)
    frame.BackgroundColor3 = Color3.fromRGB(18,18,18)
    frame.Active = true
    frame.Draggable = true
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,14)

    -- 🏷️ LARGE TEXT TITLE
    local mainTitle = Instance.new("TextLabel", frame)
    mainTitle.Size = UDim2.new(1, 0, 0, 40)
    mainTitle.Position = UDim2.new(0, 0, 0, -45)
    mainTitle.BackgroundTransparency = 1
    mainTitle.Text = "JMASTERS MOD NOTIFIER"
    mainTitle.Font = Enum.Font.GothamBlack
    mainTitle.TextSize = 35
    mainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainTitle.TextStrokeTransparency = 0

    -- ❌ RESTORED CLOSE BUTTON
    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -35, 0, 5)
    close.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
    close.Text = "X"
    close.Font = Enum.Font.GothamBold
    close.TextColor3 = Color3.new(1,1,1)
    close.TextSize = 16
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

    close.MouseButton1Click:Connect(function()
        playUISound("rbxassetid://12222152", 0.8)
        _G.DetectorRunning = nil
        gui:Destroy()
    end)

    local subTitle = Instance.new("TextLabel", frame)
    subTitle.Size = UDim2.fromScale(1, 0.2)
    subTitle.Position = UDim2.fromScale(0, 0.05)
    subTitle.BackgroundTransparency = 1
    subTitle.Text = "🔐 KEY REQUIRED YOU RETARD"
    subTitle.Font = Enum.Font.GothamBold
    subTitle.TextSize = 18
    subTitle.TextColor3 = Color3.fromRGB(200, 200, 200)

    local lastPos = frame.Position
    frame:GetPropertyChangedSignal("Position"):Connect(function()
        local currentPos = frame.Position
        if (currentPos.X.Offset - lastPos.X.Offset)^2 + (currentPos.Y.Offset - lastPos.Y.Offset)^2 > 100 then
            playUISound("rbxassetid://12222152", 0.2)
            lastPos = currentPos
        end
    end)

    local box = Instance.new("TextBox", frame)
    box.PlaceholderText = "input key here"
    box.Size = UDim2.fromScale(0.85, 0.25)
    box.Position = UDim2.fromScale(0.075, 0.38)
    box.BackgroundColor3 = Color3.fromRGB(30,30,30)
    box.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,10)

    local btn = Instance.new("TextButton", frame)
    btn.Text = "CONTINUE"
    btn.Size = UDim2.fromScale(0.6, 0.22)
    btn.Position = UDim2.fromScale(0.2, 0.7)
    btn.BackgroundColor3 = Color3.fromRGB(70,180,110)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

    btn.MouseButton1Click:Connect(function()
        local input = box.Text
        local isBypass = (input == SECRET_BYPASS_KEY)
        local isPrimaryValid = (input == PRIMARY_KEY and AllowedUsers[LocalPlayer.UserId])

        if isBypass or isPrimaryValid then
            if writefile then writefile(KEY_FILE, "true") end
            playUISound("rbxassetid://170765130", 1)
            accessGranted = true
            gui:Destroy()
        else
            playUISound("rbxassetid://131147505", 1)
            StarterGui:SetCore("SendNotification", {Title = "❌ Access Denied", Text = "Unauthorized ID or Invalid Key", Duration = 4})
        end
    end)

    repeat task.wait() until accessGranted
end

-------------------------------------------------
-- WRONG GAME CHECK
-------------------------------------------------
local RIVALS_GAME_ID = 6035872082
if game.GameId ~= RIVALS_GAME_ID then
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "❌ Wrong Game",
            Text = "ITS THE WRONG FUCKING GAME YOU FAT FUCK",
            Duration = 6
        })
    end)

    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://119554021427991"
    s.Volume = 5
    s.Parent = workspace
    s:Play()

    task.wait(7)
    s:Destroy()
    _G.DetectorRunning = nil
    return
end

--------------------------- CONFIG ---------------------------
local config = {
    enabled = true,

    modWatchList = {
        [9774834404]=true,[3342805365]=true,[180434077]=true,[478848349]=true,
        [7171389384]=true,[164100188]=true,[163180763]=true,[549095619]=true,
        [224264658]=true,[99268362]=true,[131577796]=true,[3161872154]=true,
        [1602256048]=true,[1302259915]=true,[219021541]=true,[39560492]=true,
        [475975042]=true,[877654864]=true,[754154414]=true,[31598456]=true,
        [1399517213]=true,[8034104]=true,[20349956]=true,[15941965]=true,
        [158374605]=true,[113947873]=true,[133321104]=true,[0]=true
    },

    knownWatchList = {
        [9132728378]=true,[7171389384]=true,[3410760577]=true,[2722548028]=true,
        [3038813476]=true,[1676897355]=true,[1212564846]=true,[1170157879]=true,
        [817372683]=true,[976048069]=true,[20576250]=true,[324386852]=true,
        [1699080206]=true,[4761042954]=true,[716661842]=true,[1952198604]=true,
        [3960908652]=true,[5041464410]=true,[719253194]=true,[72777686]=true,
        [93396927]=true,[1570344799]=true,[2715139893]=true,[2592044281]=true,
        [7509170326]=true,[3168035361]=true,[299656551]=true,[7114434816]=true,
        [2398965451]=true,[8876776576]=true,[8854090897]=true,[2589526320]=true,
        [904064295]=true,[1347365278]=true,[1197113640]=true,[711164374]=true,
        [167011353]=true,[4045652628]=true,[835918816]=true,[1634295899]=true,
        [484209710]=true,[1046882754]=true,[301707243]=true,[4814045937]=true,
        [192648256]=true,[4979329484]=true,[18394211]=true,[2627770086]=true,
        [1283600369]=true,[988801608]=true,[5499975764]=true,[7519940219]=true,
        [5441022436]=true,[33916776]=true,[590056862]=true,[1596012708]=true,
        [1503659477]=true,[160222694]=true,[538421707]=true,[174371231]=true,
        [158782923]=true,[1366392507]=true,[4701284318]=true,[622420080]=true,
        [907880682]=true,[7360779969]=true,[477778892]=true,[1010680683]=true,
        [761517915]=true,[3805605247]=true,[129345706]=true,[289034063]=true,
        [570996811]=true,[508441337]=true,[423324971]=true,[4681641674]=true,
        [1796383039]=true,[68729698]=true,[00]=true
    },

    notifyDuration = 6,
    modNotifyDuration = 10,
    normalBeepId = "rbxassetid://97367190838793",
    sirenSoundId = "rbxassetid://101333891213137",
    beepVolume = 2,
    sirenVolume = 6
}

local knownWebhook = "https://discord.com/api/webhooks/1447387183571800065/noPXyO97Zr4m6a3XbhnxwOAkn0WMOvcG88foOXWNcOrZeCckUMyCyQzIuNNOwm26czn4"
local modWebhook = "https://discord.com/api/webhooks/1447387193650970747/LGI1sJjS9mggI_dcjaLiC901eoT0kw946GEN93QTIAvCuuJMEPK5Mx9IT1VIVxozD0ek"
local requestFunc = http_request or request or (syn and syn.request)

--------------------------- CACHES ---------------------------
local usernameCache, headshotCache, renderCache = {}, {}, {}

--------------------------- NOTIFY ---------------------------
local function alert(title, text, isMod)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = isMod and config.modNotifyDuration or config.notifyDuration
    })
    local s = Instance.new("Sound", workspace)
    s.SoundId = isMod and config.sirenSoundId or config.normalBeepId
    s.Volume = isMod and config.sirenVolume or config.beepVolume
    s:Play()
    task.delay(5, function() s:Destroy() end)
end

--------------------------- USER INFO ---------------------------
local function getUsername(id)
    if usernameCache[id] then return usernameCache[id] end
    local res = requestFunc({Url="https://users.roblox.com/v1/users/"..id,Method="GET"})
    local d = HttpService:JSONDecode(res.Body)
    usernameCache[id] = d.name or "Unknown"
    return usernameCache[id]
end

local function getHeadshot(id)
    if headshotCache[id] then return headshotCache[id] end
    local res = requestFunc({Url=("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%s&size=420x420&format=Png"):format(id),Method="GET"})
    local d = HttpService:JSONDecode(res.Body)
    headshotCache[id] = d.data[1].imageUrl
    return headshotCache[id]
end

local function getRender(id)
    if renderCache[id] then return renderCache[id] end
    local res = requestFunc({Url=("https://thumbnails.roblox.com/v1/users/avatar?userIds=%s&size=720x720&format=Png&isCircular=false"):format(id),Method="GET"})
    local d = HttpService:JSONDecode(res.Body)
    renderCache[id] = d.data[1].imageUrl
    return renderCache[id]
end

--------------------------- WEBHOOK ---------------------------
local function sendWebhook(url, title, fields, joinerId, targetId)
    requestFunc({
        Url = url,
        Method = "POST",
        Headers = {["Content-Type"]="application/json"},
        Body = HttpService:JSONEncode({
            username="Roblox Security Logger",
            embeds={{
                title="⚠️ "..title,
                color=0xFF8800,
                author={name="Player: "..getUsername(joinerId),icon_url=getHeadshot(joinerId)},
                thumbnail={url=getHeadshot(joinerId)},
                image={url=getRender(targetId)},
                fields=fields,
                footer={text=os.date("%Y-%m-%d %H:%M:%S")}
            }}
        })
    })
end

--------------------------- SCANNING ---------------------------
local function getAllFriends(userId)
    local ids, cursor = {}, nil
    repeat
        local url="https://friends.roblox.com/v1/users/"..userId.."/friends?limit=100"
        if cursor then url..="&cursor="..cursor end
        local res=requestFunc({Url=url,Method="GET"})
        local d=HttpService:JSONDecode(res.Body)
        for _,f in ipairs(d.data or {}) do table.insert(ids,f.id) end
        cursor=d.nextPageCursor
    until not cursor
    return ids
end

local function scanFriends(player)
    task.spawn(function()
        for _,id in ipairs(getAllFriends(player.UserId)) do
            if config.modWatchList[id] then
                local u=getUsername(id)
                alert("👁️ MOD FRIEND DETECTED",player.Name.." has "..u.." added",false)
                sendWebhook(knownWebhook,"Moderator Friend Detected", {{name="Player",value="`"..player.Name.."`"},{name="Moderator Friend",value="`"..u.."`"}}, player.UserId,id)
            elseif config.knownWatchList[id] then
                local u=getUsername(id)
                alert("👁️ KNOWN FRIEND DETECTED",player.Name.." has "..u.." added",false)
                sendWebhook(knownWebhook,"Known Friend Detected", {{name="Player",value="`"..player.Name.."`"},{name="Known Friend",value="`"..u.."`"}}, player.UserId,id)
            end
        end
    end)
end

local function detectPlayer(player)
    if not config.enabled then return end
    if config.modWatchList[player.UserId] then
        alert("🚨 MODERATOR JOINED",player.Name.." joined the server!",true)
        sendWebhook(modWebhook,"Moderator Joined", {{name="Moderator",value="`"..player.Name.."`"}}, player.UserId,player.UserId)
    elseif config.knownWatchList[player.UserId] then
        alert("👁️ KNOWN PERSON JOINED",player.Name.." joined the server",false)
        sendWebhook(knownWebhook,"Known Person Joined", {{name="Known User",value="`"..player.Name.."`"}}, player.UserId,player.UserId)
    end
end

--------------------------- STARTUP ---------------------------
alert("✅ Detector Active","Startup delay fix enabled",false)

for _,p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        detectPlayer(p)
        task.delay(1.5,function() scanFriends(p) end)
    end
end

Players.PlayerAdded:Connect(function(p)
    detectPlayer(p)
    scanFriends(p)
end)
