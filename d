--------------------------- CONFIG ---------------------------

local config = {
    enabled = true,

    modWatchList = {
        [9774834404] = true, [3342805365] = true, [180434077] = true, [478848349] = true,
        [7171389384] = true, [164100188] = true, [163180763] = true, [549095619] = true,
        [224264658] = true, [99268362] = true, [131577796] = true, [3161872154] = true,
        [1602256048] = true, [1302259915] = true, [219021541] = true, [39560492] = true,
        [475975042] = true, [877654864] = true, [754154414] = true, [31598456] = true,
        [1399517213] = true, [113947873] = true, [133321104] = true, [10093788601] = true
    },

    knownWatchList = {
        [9132728378] = true, [7171389384] = true, [3410760577] = true, [2722548028] = true,
        [3038813476] = true, [1676897355] = true, [1212564846] = true, [1170157879] = true,
        [817372683] = true, [976048069] = true, [20576250] = true, [324386852] = true,
        [1699080206] = true, [4761042954] = true, [716661842] = true, [1952198604] = true,
        [3960908652] = true, [5041464410] = true, [719253194] = true, [72777686] = true,
        [93396927] = true, [1570344799] = true, [2715139893] = true, [2592044281] = true,
        [7509170326] = true, [3168035361] = true, [299656551] = true, [7114434816] = true,
        [2398965451] = true, [8876776576] = true, [8854090897] = true, [2589526320] = true,
        [904064295] = true, [1347365278] = true, [1197113640] = true, [711164374] = true,
        [167011353] = true, [4045652628] = true, [835918816] = true, [1634295899] = true,
        [484209710] = true, [1046882754] = true, [301707243] = true, [4814045937] = true,
        [192648256] = true, [4979329484] = true, [18394211] = true, [2627770086] = true,
        [1283600369] = true, [988801608] = true, [5499975764] = true, [7519940219] = true,
        [5441022436] = true, [33916776] = true, [590056862] = true, [3410760577] = true,
        [1596012708] = true, [1503659477] = true, [160222694] = true, [72777686] = true,
        [538421707] = true, [174371231] = true, [158782923] = true, [1366392507] = true,
        [4701284318] = true, [570996811] = true, [508441337] = true, [423324971] = true,
        [4681641674] = true, [10093788601] = true
    },

    notify = true,
    RBLXConnections = true,
    PrintLogs = true,
    notifyDuration = 5,
    modNotifyDuration = 10,
    sendWebhook = true,

    normalBeepId = "rbxassetid://97367190838793",
    sirenSoundId = "rbxassetid://101333891213137",
    beepVolume = 2,
    sirenVolume = 10
}

--------------------------- SERVICES ---------------------------

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local webhookURL =
    "https://discord.com/api/webhooks/1447387183571800065/noPXyO97Zr4m6a3XbhnxwOAkn0WMOvcG88foOXWNcOrZeCckUMyCyQzIuNNOwm26czn4"
local knownWebhookURL =
    "https://discord.com/api/webhooks/1447387193650970747/LGI1sJjS9mggI_dcjaLiC901eoT0kw946GEN93QTIAvCuuJMEPK5Mx9IT1VIVxozD0ek"

local requestFunc =
    http_request or request or (syn and syn.request) or (http and http.request)

--------------------------- NOTIFY ---------------------------

function notify(title, text, isMod)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = isMod and config.modNotifyDuration or config.notifyDuration
    })
end

--------------------------- AVATAR ---------------------------

function getAvatar(id)
    if not requestFunc then return nil end
    local url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. id .. "&size=420x420&format=Png"
    local res = requestFunc({Url = url, Method = "GET"})
    if not res then return nil end
    local data = HttpService:JSONDecode(res.Body)
    if data and data.data and data.data[1] then
        return data.data[1].imageUrl
    end
end

--------------------------- WEBHOOK ---------------------------

function sendWebhook(player, webhookUrl, title, fields, thumbUserId)
    if not config.sendWebhook or not requestFunc then return end

    local body = {
        username = "Roblox Security Logger",
        embeds = {{
            title = title,
            color = 0xE74C3C,
            author = {
                name = player.Name,
                icon_url = getAvatar(player.UserId) or ""
            },
            thumbnail = {
                url = getAvatar(thumbUserId or player.UserId) or ""
            },
            fields = fields,
            footer = {text = "Logged at " .. os.date("%Y-%m-%d %H:%M:%S")}
        }}
    }

    requestFunc({
        Url = webhookUrl,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(body)
    })
end

--------------------------- DIRECT DETECTION ---------------------------

function detectDirect(player)
    local uid = player.UserId
    if config.knownWatchList[uid] then
        notify("Known User", player.Name .. " is a Known Person!", false)
        sendWebhook(player, knownWebhookURL, "Known User Detected", {
            {name = "Player", value = player.Name}
        })
    end

    if config.modWatchList[uid] then
        notify("MOD DETECTED", player.Name .. " is a Moderator!", true)
        sendWebhook(player, webhookURL, "Moderator Detected", {
            {name = "Player", value = player.Name},
            {name = "Status", value = "Moderator"}
        })
    end
end

--------------------------- CONNECTION DETECTION ---------------------------
-- **THIS IS THE PART YOU WANTED FIXED**
-- Now uses the FRIEND'S NAME, not the user ID

function detectConnections(player)
    if not requestFunc then return end

    local r = requestFunc({
        Url = "https://friends.roblox.com/v1/users/" .. player.UserId .. "/friends",
        Method = "GET"
    })

    local data = HttpService:JSONDecode(r.Body)
    if not data or not data.data then return end

    local modFriends = {}
    local knownFriends = {}

    for _, f in ipairs(data.data) do
        local name = f.displayName or f.name or "Unknown"
        local id = f.id

        if config.modWatchList[id] then
            table.insert(modFriends, {name = name, id = id})
        elseif config.knownWatchList[id] then
            table.insert(knownFriends, {name = name, id = id})
        end
    end

    -- MOD FRIENDS FOUND
    if #modFriends > 0 then
        notify("Mod Friend Detected",
            player.Name .. " is friends with " .. modFriends[1].name .. " (MOD)", false)

        local fields = {
            {name = "Player", value = player.Name},
            {name = "Status", value = "Friends with Moderator(s)"}
        }

        for _, f in ipairs(modFriends) do
            table.insert(fields, {
                name = "Moderator Friend",
                value = f.name .. " (ID: " .. f.id .. ")"
            })
        end

        sendWebhook(player, webhookURL, "Moderator Friend Detected", fields, modFriends[1].id)
    end

    -- KNOWN FRIENDS FOUND
    if #knownFriends > 0 then
        notify("Known Friend Detected",
            player.Name .. " is friends with " .. knownFriends[1].name, false)

        local fields = {
            {name = "Player", value = player.Name},
            {name = "Status", value = "Friends with Known Person(s)"}
        }

        for _, f in ipairs(knownFriends) do
            table.insert(fields, {
                name = "Known Person Friend",
                value = f.name .. " (ID: " .. f.id .. ")"
            })
        end

        sendWebhook(player, knownWebhookURL, "Known Friend Detected", fields, knownFriends[1].id)
    end
end

--------------------------- MAIN ---------------------------

for _, plr in ipairs(Players:GetPlayers()) do
    detectDirect(plr)
    detectConnections(plr)
end

Players.PlayerAdded:Connect(function(plr)
    detectDirect(plr)
    detectConnections(plr)
end)
