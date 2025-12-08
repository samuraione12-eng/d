--------------------------- CONFIG ---------------------------

local config = {
    enabled = true,
    notify = true,
    bigNotification = false,
    PrintLogs = true,
    sendWebhook = true,
    RBLXConnections = true,
    notifyDuration = 5,
    beepSoundId = "rbxassetid://97367190838793",
    beepVolume = 2,

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
    }
}

--------------------------- SERVICES ---------------------------

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local webhookURL = "https://discord.com/api/webhooks/YOUR_MOD_WEBHOOK"
local knownWebhookURL = "https://discord.com/api/webhooks/YOUR_KNOWN_WEBHOOK"

local requestFunc = http_request or request or (syn and syn.request) or (http and http.request)

--------------------------- NOTIFICATIONS & SOUND ---------------------------

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
