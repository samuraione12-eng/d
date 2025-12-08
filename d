--------------------------- CONFIG ---------------------------

local config = {
    enabled = true,
    notify = true,
    bigNotification = false,
    PrintLogs = true,
    sendWebhook = true,
    RBLXConnections = true,
    notifyDuration = 5,
    modWatchList = {
        [9774834404] = true, [3342805365] = true, [180434077] = true, [478848349] = true,
        [7171389384] = true, [164100188] = true, [163180763] = true, [549095619] = true
    },
    knownWatchList = {
        [9132728378] = true, [7171389384] = true, [3410760577] = true, [2722548028] = true
    },
    beepSoundId = "rbxassetid://97367190838793",
    beepVolume = 2
}

--------------------------- SERVICES ---------------------------

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local webhookURL = "https://discord.com/api/webhooks/YOUR_MOD_WEBHOOK"
local knownWebhookURL = "https://discord.com/api/webhooks/YOUR_KNOWN_WEBHOOK"

local requestFunc = http_request or request or (syn and syn.request) or (http and http.request)

--------------------------- NOTIFICATION & SOUND ---------------------------

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
                Duration = config.notifyDuration
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

--------------------------- WEBHOOK ---------------------------

function sendWebhookMessage(player, webhookURL, title, description)
    if not config.sendWebhook then return end

    local userId = player.UserId
    local avatarApiUrl = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. userId .. "&size=420x420&format=Png"
    local avatarImageUrl = nil

    if requestFunc then
        local response = requestFunc({Url = avatarApiUrl, Method = "GET"})
        local data = HttpService:JSONDecode(response.Body)
        if data and data.data and data.data[1] then
            avatarImageUrl = data.data[1].imageUrl
        end
    end

    local message = {
        ["username"] = "Roblox Logger",
        ["embeds"] = {{
            ["title"] = title,
            ["color"] = 0xE74C3C,
            ["thumbnail"] = {["url"] = avatarImageUrl or ""},
            ["description"] = description,
            ["fields"] = {
                {["name"] = "Username", ["value"] = player.Name, ["inline"] = true},
                {["name"] = "UserId", ["value"] = tostring(player.UserId), ["inline"] = true}
            },
            ["footer"] = {["text"] = "Logged at " .. os.date("%Y-%m-%d %H:%M:%S")}
        }}
    }

    requestFunc({
        Url = webhookURL,
        Method = "POST",
        Headers = {["Content-Type"] = "application/json"},
        Body = HttpService:JSONEncode(message)
    })
end

--------------------------- PLAYER DETECTION ---------------------------

function checkPlayer(player)
    if config.modWatchList[player.UserId] then
        local message = "⚠️ Mod Joined!\n" .. player.Name .. " (UserId: " .. player.UserId .. ") is in the game!"
        sendNotification("⚠️ Mod Joined!", message)
        sendWebhookMessage(player, webhookURL, "Mod Detected", message)
        playBeepSound()
        if config.PrintLogs then warn("Mod detected: " .. player.Name) end
    elseif config.knownWatchList[player.UserId] then
        local message = "🔍 Known Person Joined!\n" .. player.Name .. " (UserId: " .. player.UserId .. ") is in the game!"
        sendNotification("🔍 Known Person Joined!", message)
        sendWebhookMessage(player, knownWebhookURL, "Known Person Detected", message)
        playBeepSound()
        if config.PrintLogs then warn("Known person detected: " .. player.Name) end
    end
end

--------------------------- CONNECTION DETECTION ---------------------------

function checkRBLXConnections(player)
    if not config.RBLXConnections then return end
    if not requestFunc then return end

    local response = requestFunc({Url = "https://friends.roblox.com/v1/users/" .. player.UserId .. "/friends", Method = "GET"})
    local data = HttpService:JSONDecode(response.Body)
    if not data or not data.data then return end

    for _, friend in ipairs(data.data) do
        if config.modWatchList[friend.id] or config.knownWatchList[friend.id] then
            local message = "A Player In Your Game Is Connected To A Mod/Known Person.\n" ..
                player.Name .. " (UserId: " .. player.UserId .. ") is friends with " .. friend.name
            sendNotification("RBLX Connection Detected!", message)
            sendWebhookMessage(player, webhookURL, "Connection Detected", message)
            playBeepSound()
            if config.PrintLogs then
                warn("Connection detected: " .. player.Name .. " is friends with " .. friend.name)
            end
        end
    end
end

--------------------------- MAIN ---------------------------

-- Confirmation notification that script executed
sendNotification("✅ Mod Detector Active", "🔍 Monitoring mods, known persons, and connections.")
for _, player in ipairs(Players:GetPlayers()) do
    checkPlayer(player)
    checkRBLXConnections(player)
end

Players.PlayerAdded:Connect(function(player)
    checkPlayer(player)
    checkRBLXConnections(player)
end)
