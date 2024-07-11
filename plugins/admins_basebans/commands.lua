-- unban
-- unbanip

commands:Register("unban", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "e")

        if not hasAccess then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission")) end
    end

    if argc < 1 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.unban.syntax"), prefix))
    end

    local steamid = args[1]

    PerformUnban(steamid, nil)
    ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.unban"):gsub("{ADMIN}", playerid == -1 and "CONSOLE" or GetPlayer(playerid):CBasePlayerController().PlayerName):gsub("{STEAMID}", args[1]))
end)

commands:Register("unbanip", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "e")

        if not hasAccess then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission")) end
    end

    if argc < 1 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.unbanip.syntax"), prefix))
    end

    local ip = args[1]

    PerformUnban(nil, ip)
    ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.unbanip"):gsub("{ADMIN}", playerid == -1 and "CONSOLE" or GetPlayer(playerid):CBasePlayerController().PlayerName):gsub("{IP}", ip))
end)

commands:Register("ban", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "d")

        if not hasAccess then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission")) end
    end

    if argc < 3 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.ban.syntax"), prefix))
    end

    local target = args[1]
    local time = args[2]
    table.remove(args, 1)
    table.remove(args, 1)
    local reason = table.concat(args, " ")

    local players = FindPlayersByTarget(target, false)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.invalid_player")) -- translation
    end

    time = tonumber(time)
    if time < 0 or time > 525600 then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.invalid_time"):gsub("{MIN}", 1):gsub("{MAX}", 525600)) end

    local admin = nil
    if playerid ~= -1 then
        admin = GetPlayer(playerid)
    end

    for i=1,#players do
        local targetPlayer = players[i]
        PerformBan(tostring(targetPlayer:GetSteamID()), targetPlayer:GetIPAddress(), targetPlayer:CBasePlayerController().PlayerName, admin and tostring(admin:GetSteamID()) or "0", admin and admin:CBasePlayerController().PlayerName or "CONSOLE", time * 60, reason, BanType.SteamID)
        targetPlayer:Drop(DisconnectReason.Kicked)
        ReplyToCommand(playerid, config:Fetch("admins.prefix", FetchTranslation(string.format("admins.ban.message"):gsub("{PLAYER_NAME}", targetPlayer:CBasePlayerController().PlayerName):gsub("{ADMIN_NAME}", admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{TIME}", time):gsub("{REASON}", time))))
    end
end)

commands:Register("banip", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "d")

        if not hasAccess then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission")) end
    end

    if argc < 3 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.banip.syntax"), prefix))
    end

    local target = args[1]
    local time = args[2]
    table.remove(args, 1)
    table.remove(args, 1)
    local reason = table.concat(args, " ")

    local players = FindPlayersByTarget(target, false)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.invalid_player")) -- translation
    end

    time = tonumber(time)
    if time < 0 or time > 525600 then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.invalid_time"):gsub("{MIN}", 1):gsub("{MAX}", 525600)) end

    local admin = nil
    if playerid ~= -1 then
        admin = GetPlayer(playerid)
    end

    for i=1,#players do
        local targetPlayer = players[i]
        PerformBan(tostring(targetPlayer:GetSteamID()), targetPlayer:GetIPAddress(), targetPlayer:CBasePlayerController().PlayerName, admin and tostring(admin:GetSteamID()) or "0", admin and targetPlayer:CBasePlayerController().PlayerName or "CONSOLE", time * 60, reason, BanType.IP)
        targetPlayer:Drop(DisconnectReason.Kicked)
        ReplyToCommand(playerid, config:Fetch("admins.prefix", FetchTranslation(string.format("admins.ban.message"):gsub("{PLAYER_NAME}", targetPlayer:CBasePlayerController().PlayerName):gsub("{ADMIN_NAME}", admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{TIME}", time):gsub("{REASON}", time))))
    end
end)

commands:Register("kick", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "c")

        if not hasAccess then return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.no_permission")) end
    end

    if argc < 2 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), string.format(FetchTranslation("admins.kick.syntax"), prefix))
    end

    local target = args[1]
    local reason = args[2]
    table.remove(args, 1)
    table.remove(args, 1)
    local reason = table.concat(args, " ")

    local players = FindPlayersByTarget(target, true)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.invalid_player"))
    end

    local admin = nil
    if playerid ~= -1 then
        admin = GetPlayer(playerid)
    end

    for i =1, #players do
        local targetPlayer = players[i]
        targetPlayer:Drop(DisconnectReason.Kicked)
       ReplyToCommand(playerid, config:Fetch("admins.prefix", FetchTranslation(string.format("admins.kick.message"):gsub("{ADMIN_NAME}", admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{PLAYER_NAME}", targetPlayer:CBasePlayerController().PlayerName):gsub("{REASON}", reason))))
    end
end)