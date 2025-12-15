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
        [0]=true,[113947873]=true,[133321104]=true,[8304809358]=true
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

--------------------------- SERVICES ---------------------------
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local knownWebhook =
"https://discord.com/api/webhooks/1447387183571800065/noPXyO97Zr4m6a3XbhnxwOAkn0WMOvcG88foOXWNcOrZeCckUMyCyQzIuNNOwm26czn4"

local modWebhook =
"https://discord.com/api/webhooks/1447387193650970747/LGI1sJjS9mggI_dcjaLiC901eoT0kw946GEN93QTIAvCuuJMEPK5Mx9IT1VIVxozD0ek"

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
end

--------------------------- USER INFO ---------------------------
local function getUsername(id)
    if usernameCache[id] then return usernameCache[id] end
    local res = requestFunc({Url="https://users.roblox.com/v1/users/"..id,Method="GET"})
    local d = HttpService:JSONDecode(res.Body)
    usernameCache[id] = d.name or "Unknown"
    return usernameCache[id]
end

--------------------------- AVATARS ---------------------------
local function getHeadshot(id)
    if headshotCache[id] then return headshotCache[id] end
    local res = requestFunc({
        Url=("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=%s&size=420x420&format=Png"):format(id),
        Method="GET"
    })
    local d = HttpService:JSONDecode(res.Body)
    headshotCache[id] = d.data[1].imageUrl
    return headshotCache[id]
end

local function getRender(id)
    if renderCache[id] then return renderCache[id] end
    local res = requestFunc({
        Url=("https://thumbnails.roblox.com/v1/users/avatar?userIds=%s&size=720x720&format=Png&isCircular=false"):format(id),
        Method="GET"
    })
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

--------------------------- FRIEND SCAN ---------------------------
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

--------------------------- FRIEND CHECK ---------------------------
local function scanFriends(player)
    task.spawn(function()
        for _,id in ipairs(getAllFriends(player.UserId)) do
            if config.modWatchList[id] then
                local u=getUsername(id)
                alert("👁️ MOD FRIEND DETECTED",player.Name.." has "..u.." added",false)
                sendWebhook(knownWebhook,"Moderator Friend Detected",
                    {{name="Player",value="`"..player.Name.."`"},{name="Moderator Friend",value="`"..u.."`"}},
                    player.UserId,id)
            elseif config.knownWatchList[id] then
                local u=getUsername(id)
                alert("👁️ KNOWN FRIEND DETECTED",player.Name.." has "..u.." added",false)
                sendWebhook(knownWebhook,"Known Friend Detected",
                    {{name="Player",value="`"..player.Name.."`"},{name="Known Friend",value="`"..u.."`"}},
                    player.UserId,id)
            end
        end
    end)
end

--------------------------- DETECTION ---------------------------
local function detectPlayer(player)
    if not config.enabled then return end

    if config.modWatchList[player.UserId] then
        alert("🚨 MODERATOR JOINED",player.Name.." joined the server!",true)
        task.spawn(function()
            sendWebhook(modWebhook,"Moderator Joined",
                {{name="Moderator",value="`"..player.Name.."`"}},
                player.UserId,player.UserId)
        end)
        return
    end

    if config.knownWatchList[player.UserId] then
        alert("👁️ KNOWN PERSON JOINED",player.Name.." joined the server",false)
        task.spawn(function()
            sendWebhook(knownWebhook,"Known Person Joined",
                {{name="Known User",value="`"..player.Name.."`"}},
                player.UserId,player.UserId)
        end)
    end
end

--------------------------- STARTUP ---------------------------
alert("✅ Detector Active","Startup delay fix enabled",false)

-- Existing players (DELAYED FRIEND SCAN)
for _,p in ipairs(Players:GetPlayers()) do
    detectPlayer(p)
    task.delay(1.5,function()
        scanFriends(p)
    end)
end

-- New joins (INSTANT)
Players.PlayerAdded:Connect(function(player)
    detectPlayer(player)
    scanFriends(player)
end)
