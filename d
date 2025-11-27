local config = {
    enabled = true,
    modWatchList = {
        [9774834404] = true, --// test id
        [3342805365] = true,--// Test Id ( RBLX CONNECTIONS )
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
        [9132728378] = false, --// test id
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

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Updated Webhook URLs
local webhookURL = "https://discord.com/api/webhooks/1443378847176458270/YVEr9qu3tKp9l0s4g7ePPsrwCS3soL_EJB2NF3CKb1_bCjhomfsDBOX4mtGjqAYQZ6OU"
local knownWebhookURL = "https://discord.com/api/webhooks/1443378854998839356/8-wXLkp3xtJnMS1TST-iZLHYNc9Vcx1OtpSbgE8D9mpq62x86yZkBCHQnu-PDK51JPP1"

-- Utility function to get avatar URL 
function getAvatarUrl(userId)
    local avatarApiUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=420x420&format=Png"
    local requestFunc = http_request or request or (syn and syn.request) or (http and http.request)
    
    if requestFunc then
        local thumbnailResponse = requestFunc({
            Url = avatarApiUrl,
            Method = "GET"
        })

        local data = HttpService:JSONDecode(thumbnailResponse.Body)
        if data and data.data and data.data[1] and data.data[1].imageUrl then
            return data.data[1].imageUrl
        end
    end
    return nil
end

function sendNotification(title, text)
    if config.notify then
        if config.bigNotification then
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "CustomNotification"
            screenGui.Parent = game:GetService("CoreGui")

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(0, 400, 0, 200)
            frame.Position = UDim2.new(0.5, -200, 0.5, -100)
            frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            frame.BorderSizePixel = 2
            frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            frame.Parent = screenGui

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, 0, 0, 50)
            titleLabel.Position = UDim2.new(0, 0, 0, 0)
            titleLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.Text = title
            titleLabel.TextSize = 24
            titleLabel.Font = Enum.Font.SourceSansBold
            titleLabel.Parent = frame

            local textLabel = Instance.new("TextLabel")
            textLabel.Size = UDim2.new(1, 0, 0, 100)
            textLabel.Position = UDim2.new(0, 0, 0, 50)
            textLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
            textLabel.Text = text
            textLabel.TextSize = 18
            textLabel.Font = Enum.Font.SourceSans
            textLabel.Parent = frame

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 50)
            button.Position = UDim2.new(0, 0, 1, -50)
            button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            button.TextColor3 = Color3.fromRGB(255, 255, 255)
            button.Text = "I understand"
            button.TextSize = 24
            button.Font = Enum.Font.SourceSansBold
            button.Parent = frame

            button.MouseButton1Click:Connect(function()
                screenGui:Destroy()
            end)
        else
            StarterGui:SetCore("SendNotification", {
                Title = title,
                Text = text,
                Duration = config.notifyDuration,
                Button1 = "OK",
                Callback = function() end,
                TextSize = 24,
                Position = UDim2.new(0.5, -200, 0.5, -100),
                Size = UDim2.new(0, 250, 0, 50)
            })
        end
    end
end

function playBeepSound()
    local beepSound = Instance.new("Sound")
    beepSound.SoundId = config.beepSoundId
    beepSound.Volume = config.beepVolume
    beepSound.Parent = workspace
    beepSound:Play()
end

function sendWebhookMessage(player, webhookURL, isKnown, isConnection, friendName, friendStatus, targetId)
    if not config.sendWebhook then return end

    local userId = player.UserId
    local requestFunc = http_request or request or (syn and syn.request) or (http and http.request)

    local playerAvatarImageUrl = getAvatarUrl(userId)
    local targetAvatarImageUrl = nil
    
    -- Determine the target ID for the thumbnail: friend's ID for connection, or player's ID for direct detection.
    local thumbnailId = targetId or userId
    targetAvatarImageUrl = getAvatarUrl(thumbnailId)

    local success, gameInfo = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)

    local gameName = success and gameInfo.Name or "Unknown"
    local title, description, color = "", "", 0

    if isConnection then
        title = "🔗👤 RBLX Connection Detected! ⚠️"
        description = string.format(
            "An in-game player is linked to a target user! \n\n🤝 Player: **%s** \n🎯 Friend: **%s** \n🌟 Status: **%s**",
            player.Name,
            friendName,
            friendStatus
        )
        color = 0x2ECC71
    elseif isKnown then
        title = "👁️ Known Person Detected! 🚨"
        description = "⚠️ A **KNOWN PERSON** is guaranteed to have **MOD CONNECTIONS**! 🕵️‍♂️"
        color = 0xF1C40F
    else
        title = "🚨 MOD DETECTED! 🛡️"
        description = "🔥🔥🔥 A **MODERATOR** is in the game. Proceed with **MAXIMUM CAUTION**! 🔥🔥🔥"
        color = 0xE74C3C
    end

    local message = {
        ["username"] = "Roblox Security Logger 🛡️",
        ["embeds"] = {{
            ["title"] = title,
            ["color"] = color,
            
            -- NEW: Player's avatar in the server is now the AUTHOR ICON
            ["author"] = {
                ["name"] = "In-Game Player: " .. player.Name,
                ["icon_url"] = playerAvatarImageUrl or ""
            },
            
            -- Target's avatar (Mod/Known Person) remains the EMBED THUMBNAIL
            ["thumbnail"] = {
                ["url"] = targetAvatarImageUrl or ""
            },
            
            ["description"] = description,
            ["fields"] = {
                {
                    ["name"] = "🎮 Player Username",
                    ["value"] = player.Name,
                    ["inline"] = true
                },
                {
                    ["name"] = "🗺️ Current Place",
                    ["value"] = gameName,
                    ["inline"] = true
                },
                {
                    ["name"] = "🔗 Game ID",
                    ["value"] = tostring(game.GameId),
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "⏱️ Logged at " .. os.date("%Y-%m-%d %H:%M:%S")
            }
        }}
    }

    if requestFunc then
        local jsonData = HttpService:JSONEncode(message)
        requestFunc({
            Url = webhookURL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = jsonData
        })
    end
end

function checkPlayer(player)
    local title, message, webhookUrl, isKnown, isConnection = "", "", "", false, false
    local friendName, friendStatus, targetId = nil, nil, nil

    if config.modWatchList[player.UserId] then
        title = "🚨 MOD ALERT!"
        message = "🚨 WARNING! A MOD JUST JOINED THE SERVER!\nPlayer: **" .. player.Name .. "**"
        webhookUrl = webhookURL
    elseif config.knownWatchList[player.UserId] then
        title = "👁️ Known Person Joined!"
        message = "👁️ Known Person Joined!\nPlayer: **" .. player.Name .. "**"
        webhookUrl = knownWebhookURL
        isKnown = true
    end

    if title ~= "" then
        sendNotification(title, message)
        -- targetId is nil for direct match, defaulting to player's avatar as thumbnail
        sendWebhookMessage(player, webhookUrl, isKnown, isConnection, friendName, friendStatus, targetId)
        playBeepSound()
        if config.PrintLogs then
            warn(title .. ": " .. player.Name .. " (" .. player.UserId .. ")")
        end
        return true
    end
    return false
end

function checkRBLXConnections(player)
    if not config.RBLXConnections then return end

    local requestFunc = http_request or request or (syn and syn.request) or (http and http.request)
    if not requestFunc then
        warn("HTTP request function not available.")
        return
    end

    local friendsResponse = requestFunc({
        Url = "https://friends.roblox.com/v1/users/" .. player.UserId .. "/friends",
        Method = "GET"
    })

    local friendsData = HttpService:JSONDecode(friendsResponse.Body)
    if not friendsData then
        warn("Failed to decode friends data.")
        return
    end

    local friends = friendsData.data
    for _, friend in ipairs(friends) do
        local friendStatus = nil
        local webhookToSend = nil
        local friendId = friend.id 

        if config.modWatchList[friendId] then
            friendStatus = "Mod"
            webhookToSend = webhookURL
        elseif config.knownWatchList[friendId] then
            friendStatus = "Known Person"
            webhookToSend = knownWebhookURL
        end

        if friendStatus then
            local title = "🔗 RBLX Connection Detected!"
            local message = string.format(
                "Player **%s** is friends with a **%s** named **%s**.",
                player.Name,
                friendStatus,
                friend.name
            )

            sendNotification(title, message)
            -- Pass the friend's ID as targetId
            sendWebhookMessage(player, webhookToSend, false, true, friend.name, friendStatus, friendId)
            playBeepSound()
            
            if config.PrintLogs then
                warn(string.format(
                    "🔗 RBLX Connection detected: %s (ID: %d) is friends with %s (ID: %d), a %s.", 
                    player.Name, 
                    player.UserId, 
                    friend.name, 
                    friendId, 
                    friendStatus
                ))
            end
            return
        end
    end
end

-- Notify that the script is running
sendNotification("✅ Mod Detector Active", "Listening for mods and known persons. Script fully executed.")
playBeepSound() -- Play a sound for confirmation

-- Initial check for players already in the game when the script executes
for _, player in ipairs(Players:GetPlayers()) do
    if not checkPlayer(player) then
        checkRBLXConnections(player)
    end
end

-- Continuous check for players joining the game
Players.PlayerAdded:Connect(function(player)
    if not checkPlayer(player) then
        checkRBLXConnections(player)
    end
end)
