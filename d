--------------------------- CONFIG ---------------------------

local config = {
    enabled = true,

    -- WATCHLISTS
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
        [133321104] = true
    },

    knownWatchList = {
        [9132728378] = true,
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

    beepSoundId = "rbxassetid://97367190838793",
    beepVolume = 3
}

--------------------------- SERVICES ---------------------------

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- YOUR actual webhooks
local webhookURL = "https://discord.com/api/webhooks/1443378847176458270/YVEr9qu3tKp9l0s4g7ePPsrwCS3soL_EJB2NF3CKb1_bCjhomfsDBOX4mtGjqAYQZ6OU"
local knownWebhookURL = "https://discord.com/api/webhooks/1443378854998839356/8-wXLkp3xtJnMS1TST-iZLHYNc9Vcx1OtpSbgE8D9mpq62x86yZkBCHQnu-PDK51JPP1"

local requestFunc = http_request or request or (syn and syn.request) or (http and http.request)

--------------------------- UTILITIES ---------------------------

function playBeepSound()
    local s = Instance.new("Sound")
    s.SoundId = config.beepSoundId
    s.Volume = config.beepVolume
    s.Parent = workspace
    s:Play()
end

function notify(title, text)
    if not config.notify then return end

    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = config.notifyDuration
    })

    playBeepSound()
end

function getAvatar(userId)
    if not requestFunc then return nil end

    local url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
        .. tostring(userId) .. "&size=420x420&format=Png"

    local res = requestFunc({ Url = url, Method = "GET" })
    if not res then return nil end

    local data = HttpService:JSONDecode(res.Body)

    if data and data.data and data.data[1] and data.data[1].imageUrl then
        return data.data[1].imageUrl
    end

    return nil
end

--------------------------- WEBHOOK SYSTEM ---------------------------

function sendWebhook(player, webhookUrl, embedTitle, fieldsTable, thumbnailId)
    if not config.sendWebhook then return end
    if not requestFunc then return end

    local embed = {
        ["username"] = "Roblox Security Logger",
        ["embeds"] = {{
            ["title"] = embedTitle,
            ["color"] = 0x2ECC71,

            ["author"] = {
                ["name"] = "In-Game Player: " .. player.Name,
                ["icon_url"] = getAvatar(player.UserId) or ""
            },

            ["thumbnail"] = {
                ["url"] = getAvatar(thumbnailId or player.UserId) or ""
            },

            ["fields"] = fieldsTable,

            ["footer"] = {
                ["text"] = "Logged at " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    }

    requestFunc({
        Url = webhookUrl,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode(embed)
    })
end

--------------------------- DIRECT DETECTION ---------------------------

function detectDirect(player)
    local userId = player.UserId
    local isMod = config.modWatchList[userId]
    local isKnown = config.knownWatchList[userId]

    if isMod then
        notify("🚨 MOD DETECTED", player.Name .. " is a Moderator!")
        sendWebhook(
            player,
            webhookURL,
            "🚨 MOD DETECTED",
            { { name = "Player", value = player.Name } }
        )
        if config.PrintLogs then warn("MOD detected: " .. player.Name) end
    end

    if isKnown then
        notify("👁️ Known Person", player.Name .. " is a Known Person!")
        sendWebhook(
            player,
            knownWebhookURL,
            "👁️ Known Person Detected",
            { { name = "Player", value = player.Name } }
        )
        if config.PrintLogs then warn("Known detected: " .. player.Name) end
    end
end

--------------------------- FRIEND CONNECTION DETECTION ---------------------------

function detectConnections(player)
    if not config.RBLXConnections then return end
    if not requestFunc then return end

    local res = requestFunc({
        Url = "https://friends.roblox.com/v1/users/" .. player.UserId .. "/friends",
        Method = "GET"
    })

    local data = HttpService:JSONDecode(res.Body)
    if not data or not data.data then return end

    for _, friend in ipairs(data.data) do
        local fid = friend.id
        local status = nil
        local webhook = nil

        if config.modWatchList[fid] then
            status = "Mod"
            webhook = webhookURL
        elseif config.knownWatchList[fid] then
            status = "Known Person"
            webhook = knownWebhookURL
        end

        if status then
            notify(
                "🔗 RBLX Connection!",
                player.Name .. " is friends with " .. status .. ": " .. friend.name
            )

            sendWebhook(
                player,
                webhook,
                "🔗 RBLX Connection Detected!",
                {
                    { name = "🤝 Player", value = player.Name },
                    { name = "🎯 Friend", value = friend.name },
                    { name = "🌟 Status", value = status },
                    { name = "🎮 Current Place", value = MarketplaceService:GetProductInfo(game.PlaceId).Name }
                },
                fid
            )

            if config.PrintLogs then
                warn("Connection: " .. player.Name .. " -> " .. friend.name .. " (" .. status .. ")")
            end
        end
    end
end

--------------------------- MAIN ---------------------------

notify("✅ Mod Detector Active", "Listening for mods, known people, and connections.")

for _, plr in ipairs(Players:GetPlayers()) do
    detectDirect(plr)
    detectConnections(plr)
end

Players.PlayerAdded:Connect(function(plr)
    detectDirect(plr)
    detectConnections(plr)
end)
