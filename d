--------------------------- CONFIG ---------------------------

local config = {
    enabled = true,

    -- MOD WATCHLIST
    modWatchList = {
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
        [133321104] = true,
        [10093788601] = true
    },

    -- KNOWN PERSON WATCHLIST
    knownWatchList = {
        [9132728378] = true,
        [7171389384] = true,
        [3410760577] = true,
        [2722548028] = true,
        [3038813476] = true,
        [1676897355] = true,
        -- (your other IDs...) --
        [10093788601] = true
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

local webhookURL = "YOUR_MOD_WEBHOOK"
local knownWebhookURL = "YOUR_KNOWN_WEBHOOK"

local requestFunc =
    http_request or request or (syn and syn.request) or (http and http.request)

--------------------------- SOUND ---------------------------

function playNormalBeep()
    local s = Instance.new("Sound")
    s.SoundId = config.normalBeepId
    s.Volume = config.beepVolume
    s.Parent = workspace
    s:Play()
end

function playSiren()
    local s = Instance.new("Sound")
    s.SoundId = config.sirenSoundId
    s.Volume = config.sirenVolume
    s.Parent = workspace
    s:Play()
end

--------------------------- NOTIFICATION ---------------------------

function notify(title, text, isMod)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = isMod and config.modNotifyDuration or config.notifyDuration
    })
    if isMod then playSiren() else playNormalBeep() end
end

--------------------------- AVATAR ---------------------------

function getAvatar(id)
    if not requestFunc then return nil end
    local url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
        .. id .. "&size=420x420&format=Png"

    local res = requestFunc({ Url = url, Method = "GET" })
    if not res then return nil end

    local data = HttpService:JSONDecode(res.Body)
    if data and data.data and data.data[1] then
        return data.data[1].imageUrl
    end
    return nil
end

--------------------------- WEBHOOK ---------------------------

function sendWebhook(player, webhookUrl, title, fields, thumbId)
    if not config.sendWebhook or not requestFunc then return end

    local avatarPlayer = getAvatar(player.UserId)
    local avatarThumb = getAvatar(thumbId or player.UserId)

    local body = {
        username = "Roblox Security Logger",
        embeds = {{
            title = title,
            color = 0xE74C3C,
            author = {
                name = "🎮 In-Game Player: " .. player.Name,
                icon_url = avatarPlayer or ""
            },
            thumbnail = { url = avatarThumb or "" },
            fields = fields,
            footer = { text = "🕒 Logged at " .. os.date("%Y-%m-%d %H:%M:%S") }
        }}
    }

    requestFunc({
        Url = webhookUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(body)
    })
end

--------------------------- DETECT CONNECTIONS ---------------------------

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

    -- scan all friends
    for _, f in ipairs(data.data) do
        local id = f.id

        -- FIXED NAME HERE 👇
        local name = f.displayName or f.name or ("UserID: " .. id)

        if config.modWatchList[id] then
            table.insert(modFriends, {id = id, name = name})
        elseif config.knownWatchList[id] then
            table.insert(knownFriends, {id = id, name = name})
        end
    end

    -- send mod report
    if #modFriends > 0 then
        local fields = {
            {name = "🧍 Player", value = player.Name},
            {name = "📌 Status", value = "Friends With Moderators"}
        }

        for _, f in ipairs(modFriends) do
            table.insert(fields, {
                name = "👤 Moderator Friend",
                value = f.name .. "\n(ID: " .. f.id .. ")"
            })
        end

        notify("🔗 RBLX Connection", "⚠️ " .. player.Name .. " is friends with "
            .. #modFriends .. " Moderator(s)", false)

        sendWebhook(player, webhookURL, "⚠️ Moderator Connections Detected",
            fields, modFriends[1].id)
    end

    -- send known-person report
    if #knownFriends > 0 then
        local fields = {
            {name = "🧍 Player", value = player.Name},
            {name = "📌 Status", value = "Friends With Known Persons"}
        }

        for _, f in ipairs(knownFriends) do
            table.insert(fields, {
                name = "👤 Known Person Friend",
                value = f.name .. "\n(ID: " .. f.id .. ")"
            })
        end

        notify("🔗 RBLX Connection", "👁️ " .. player.Name .. " is friends with "
            .. #knownFriends .. " Known Person(s)", false)

        sendWebhook(player, knownWebhookURL, "👁️ Known Person Connections Detected",
            fields, knownFriends[1].id)
    end
end

--------------------------- MAIN ---------------------------

notify("✅ Mod Detector Active", "Monitoring connections...", false)

for _, plr in ipairs(Players:GetPlayers()) do
    detectConnections(plr)
end

Players.PlayerAdded:Connect(function(plr)
    detectConnections(plr)
end)
