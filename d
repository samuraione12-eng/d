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
        local id = f.id

        -- FIX: Always get correct friend name
        local name = f.displayName or f.name or ("UserID: " .. id)

        if config.modWatchList[id] then
            table.insert(modFriends, {id = id, name = name})
        elseif config.knownWatchList[id] then
            table.insert(knownFriends, {id = id, name = name})
        end
    end

    -- SEND MOD WEBHOOK
    if #modFriends > 0 then
        local fields = {
            {name = "🧍 Player", value = player.Name},
            {name = "📌 Status", value = "Friends With Moderator(s)"}
        }

        for _, f in ipairs(modFriends) do
            table.insert(fields, {
                name = "👤 Moderator Friend",
                value = f.name .. " (ID: " .. f.id .. ")"
            })
        end

        notify(
            "🔗 RBLX Connection",
            "⚠️ " .. player.Name .. " is friends with " .. #modFriends .. " Moderator(s)",
            false
        )

        sendWebhook(
            player,
            webhookURL,
            "⚠️ Moderator Connections Detected",
            fields,
            modFriends[1].id
        )
    end

    -- SEND KNOWN PERSON WEBHOOK
    if #knownFriends > 0 then
        local fields = {
            {name = "🧍 Player", value = player.Name},
            {name = "📌 Status", value = "Friends With Known Person(s)"}
        }

        for _, f in ipairs(knownFriends) do
            table.insert(fields, {
                name = "👤 Known Person Friend",
                value = f.name .. " (ID: " .. f.id .. ")"
            })
        end

        notify(
            "🔗 RBLX Connection",
            "👁️ " .. player.Name .. " is friends with " .. #knownFriends .. " Known Person(s)",
            false
        )

        sendWebhook(
            player,
            knownWebhookURL,
            "👁️ Known Person Connections Detected",
            fields,
            knownFriends[1].id
        )
    end
end
