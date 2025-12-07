--====================================================
--   MOD + KNOWN PERSON + RBLX CONNECTION DETECTOR
--     ★ Fully Fixed Version (Discord-Safe Embeds)
--====================================================

local config = {
    enabled = true,

    modWatchList = {
        [2201888694] = true,
        [9774834404] = true,
        [3342805365] = true,
        [180434077] = true,
        [478848349] = true,
        [7171389384] = true,
        [164100188] = true,
        [163180763] = true,
        [549095619] = true,
        [224264658] = true,
        [99268362] = true,
        [131577796] = true,
        [3161872154] = true,
        [1602256048] = true,
        [1302259915] = true,
        [219021541] = true,
        [39560492] = true,
        [475975042] = true,
        [877654864] = true,
        [754154414] = true,
        [31598456] = true,
        [1399517213] = true,
        [113947873] = true,
        [133321104] = true
    },

    knownWatchList = {
        [2201888694] = true,
        [9132728378] = false,
        [7171389384] = true,
        [3410760577] = true,
        [2722548028] = true,
        [3038813476] = true,
        [1676897355] = true,
        [1212564846] = true,
        [1170157879] = true,
        [817372683] = true,
        [976048069] = true,
        [20576250] = true,
        [324386852] = true,
        [1699080206] = true,
        [4761042954] = true,
        [716661842] = true,
        [1952198604] = true,
        [3960908652] = true,
        [5041464410] = true,
        [719253194] = true,
        [72777686] = true,
        [93396927] = true,
        [1570344799] = true,
        [2715139893] = true,
        [2592044281] = true,
        [7509170326] = true,
        [3168035361] = true,
        [299656551] = true,
        [7114434816] = true,
        [2398965451] = true,
        [8876776576] = true,
        [8854090897] = true,
        [2589526320] = true,
        [904064295] = true,
        [1347365278] = true,
        [1197113640] = true,
        [711164374] = true,
        [167011353] = true,
        [4045652628] = true,
        [835918816] = true,
        [1634295899] = true,
        [484209710] = true,
        [1046882754] = true,
        [301707243] = true,
        [4814045937] = true,
        [192648256] = true,
        [4979329484] = true,
        [18394211] = true,
        [2627770086] = true,
        [1283600369] = true,
        [988801608] = true,
        [5499975764] = true,
        [7519940219] = true,
        [5441022436] = true,
        [33916776] = true,
        [590056862] = true,
        [3410760577] = true,
        [1596012708] = true,
        [1503659477] = true,
        [160222694] = true,
        [72777686] = true,
        [538421707] = true,
        [174371231] = true,
        [158782923] = true,
        [1366392507] = true,
        [4701284318] = true,
        [570996811] = true,
        [508441337] = true,
        [423324971] = true,
        [4681641674] = true
    },

    notify = true,
    RBLXConnections = true,
    PrintLogs = true,
    notifyDuration = 5,
    sendWebhook = true,
    beepSoundId = "RBLXassetid://97367190838793",
    beepVolume = 3,
    bigNotification = false,
}

------------------------------------------------------------

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local webhookURL = "https://discord.com/api/webhooks/1443378847176458270/YVEr9qu3tKp9l0s4g7ePPsrwCS3soL_EJB2NF3CKb1_bCjhomfsDBOX4mtGjqAYQZ6OU"
local knownWebhookURL = "https://discord.com/api/webhooks/1443378854998839356/8-wXLkp3xtJnMS1TST-iZLHYNc9Vcx1OtpSbgE8D9mpq62x86yZkBCHQnu-PDK51JPP1"

------------------------------------------------------------
-- SAFE VALUE FUNCTION (prevents Discord embed breaking)
------------------------------------------------------------

local function safe(v)
    if v == nil or v == "" or v == "null" then
        return "N/A"
    end
    return tostring(v)
end

------------------------------------------------------------
-- GET PLAYER AVATAR IMAGE (safe)
------------------------------------------------------------

function getAvatarUrl(userId)
    local requestFunc = http_request or request or (syn and syn.request) or (http and http.request)
    if not requestFunc then return nil end

    local url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=".. userId .."&size=420x420&format=Png"

    local response = requestFunc({ Url = url, Method = "GET" })
    if not response or not response.Body then return nil end

    local decoded = HttpService:JSONDecode(response.Body)
    if decoded and decoded.data and decoded.data[1] then
        return decoded.data[1].imageUrl or nil
    end

    return nil
end

------------------------------------------------------------
-- SEND WEBHOOK MESSAGE (Fully patched + safe)
------------------------------------------------------------

function sendWebhookMessage(player, webhookURL, isKnown, isConnection, friendName, friendStatus, targetId)
    if not config.sendWebhook then return end

    local requestFunc = http_request or request or (syn and syn.request) or (http and http.request)
    if not requestFunc then return end

    local playerAvatar = getAvatarUrl(player.UserId)
    local targetAvatar = getAvatarUrl(targetId or player.UserId)

    local success, gameInfo = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    local gameName = success and gameInfo.Name or "Unknown"

    local title, description, color

    if isConnection then
        title = "🔗👤 RBLX Connection Detected!"
        description = string.format(
            "🤝 Player: **%s**\n🎯 Friend: **%s**\n⭐ Status: **%s**",
            player.Name, safe(friendName), safe(friendStatus)
        )
        color = 0x27AE60

    elseif isKnown then
        title = "👁️ Known Person Detected!"
        description = "A **known person** with mod connections just joined!"
        color = 0xF1C40F

    else
        title = "🚨 MOD DETECTED!"
        description = "A **MODERATOR** is in the server!"
        color = 0xE74C3C
    end

    local message = {
        username = "Roblox Security Logger 🛡️",
        embeds = {{
            title = title,
            description = description,
            color = color,

            author = {
                name = "In-Game Player: " .. player.Name,
                icon_url = playerAvatar
            },

            thumbnail = {
                url = targetAvatar
            },

            fields = {
                { name = "🎮 Username", value = safe(player.Name), inline = true },
                { name = "🗺️ Current Place", value = safe(gameName), inline = true },
                { name = "🔗 Game ID", value = safe(game.GameId), inline = true }
            },

            footer = {
                text = "⏱️ Logged at " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    }

    requestFunc({
        Url = webhookURL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(message)
    })
end

------------------------------------------------------------
-- NOTIFICATIONS + SOUNDS
------------------------------------------------------------

function sendNotification(title, text)
    if config.notify then
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = config.notifyDuration
        })
    end
end

function playBeepSound()
    local s = Instance.new("Sound")
    s.SoundId = config.beepSoundId
    s.Volume = config.beepVolume
    s.Parent = workspace
    s:Play()
end

------------------------------------------------------------
-- MOD / KNOWN CHECK
------------------------------------------------------------

function checkPlayer(player)
    if config.modWatchList[player.UserId] then
        sendNotification("🚨 MOD JOINED!", player.Name.." is a MOD.")
        sendWebhookMessage(player, webhookURL, false, false)
        playBeepSound()
        return true
    end

    if config.knownWatchList[player.UserId] then
        sendNotification("👁️ Known Person", player.Name.." is known.")
        sendWebhookMessage(player, knownWebhookURL, true, false)
        playBeepSound()
        return true
    end

    return false
end

------------------------------------------------------------
-- FRIEND CONNECTION CHECK (RBLX Connections)
------------------------------------------------------------

function checkRBLXConnections(player)
    if not config.RBLXConnections then return end

    local requestFunc = http_request or request or (syn and syn.request) or (http and http.request)
    if not requestFunc then return end

    local resp = requestFunc({
        Url = "https://friends.roblox.com/v1/users/"..player.UserId.."/friends",
        Method = "GET"
    })

    local data = HttpService:JSONDecode(resp.Body)
    if not data or not data.data then return end

    for _, friend in ipairs(data.data) do
        local fId = friend.id
        local fName = friend.name

        if config.modWatchList[fId] then
            sendNotification("🔗 Mod Connection",
                player.Name.." is friends with MOD "..fName)
            sendWebhookMessage(player, webhookURL, false, true, fName, "Mod", fId)
            playBeepSound()
            return
        end

        if config.knownWatchList[fId] then
            sendNotification("🔗 Known Connection",
                player.Name.." is friends with known person "..fName)
            sendWebhookMessage(player, knownWebhookURL, false, true, fName, "Known Person", fId)
            playBeepSound()
            return
        end
    end
end

------------------------------------------------------------
-- INITIALIZATION
------------------------------------------------------------

sendNotification("✅ Mod Detector Active", "System ready.")
playBeepSound()

-- Check players already in-game
for _, p in ipairs(Players:GetPlayers()) do
    if not checkPlayer(p) then
        checkRBLXConnections(p)
    end
end

-- Listen for new players joining
Players.PlayerAdded:Connect(function(player)
    if not checkPlayer(player) then
        checkRBLXConnections(player)
    end
end)
