commands:Register("unban", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "d")

        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
        end
    end

    if argc < 1 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            string.format(FetchTranslation("admins.unban.syntax"), prefix))
    end

    local steamid = args[1]

    PerformUnban(steamid, nil)
    ReplyToCommand(playerid, config:Fetch("admins.prefix"),
        FetchTranslation("admins.unban.message"):gsub("{ADMIN_NAME}",
            playerid == -1 and "CONSOLE" or GetPlayer(playerid):CBasePlayerController().PlayerName):gsub("{STEAMID}",
            steamid))
end)

commands:Register("unbanip", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "d")

        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
        end
    end

    if argc < 1 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            string.format(FetchTranslation("admins.unbanip.syntax"), prefix))
    end

    local ip = args[1]

    PerformUnban(nil, ip)
    ReplyToCommand(playerid, config:Fetch("admins.prefix"),
        FetchTranslation("admins.unban.message"):gsub("{ADMIN_NAME}",
            playerid == -1 and "CONSOLE" or GetPlayer(playerid):CBasePlayerController().PlayerName):gsub("{IP}",
            ip))
end)

commands:Register("ban", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "d")

        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
        end
    end

    if argc < 3 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            string.format(FetchTranslation("admins.ban.syntax"), prefix))
    end

    local target = args[1]
    local time = args[2]
    table.remove(args, 1)
    table.remove(args, 1)
    local reason = table.concat(args, " ")

    local players = FindPlayersByTarget(target, false)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.invalid_player"))
    end

    time = tonumber(time)
    if time < 0 or time > 525600 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.invalid_time"):gsub("{MIN}", 1):gsub("{MAX}", 525600))
    end

    local admin = nil
    if playerid ~= -1 then
        admin = GetPlayer(playerid)
    end

    for i = 1, #players do
        local targetPlayer = players[i]
        if not targetPlayer:CBasePlayerController():IsValid() then return end
        PerformBan(tostring(targetPlayer:GetSteamID()), targetPlayer:GetIPAddress(),
            targetPlayer:CBasePlayerController().PlayerName, admin and tostring(admin:GetSteamID()) or "0",
            admin and admin:CBasePlayerController().PlayerName or "CONSOLE", time * 60, reason, BanType.SteamID)

        ReplyToCommand(playerid,
            config:Fetch("admins.prefix"),
            FetchTranslation("admins.ban.message"):gsub("{PLAYER_NAME}",
                targetPlayer:CBasePlayerController().PlayerName):gsub("{ADMIN_NAME}",
                admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{TIME}", ComputePrettyTime(time * 60))
            :gsub("{REASON}", reason))

        targetPlayer:SendMsg(MessageType.Console, FetchTranslation("admins.ban.playermessage"):gsub("{PREFIX}", config:Fetch("admins.prefix")):gsub("{TIME}", ComputePrettyTime(time * 60)):gsub("{TIME_LEFT}", ComputePrettyTime(time * 60)):gsub("{REASON}", reason):gsub("{ADMIN_NAME}", admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{ADMIN_STEAMID}", admin and tostring(admin:GetSteamID()) or "0"))
        SetTimeout(500, function()
            targetPlayer:Drop(DisconnectReason.Kicked)
        end)
    end
end)

commands:Register("bano", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "d")

        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
        end
    end

    if argc < 3 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            string.format(FetchTranslation("admins.bano.syntax"), prefix))
    end

    local steamid = args[1]
    local name = args[2]
    local time = args[3]
    table.remove(args, 1)
    table.remove(args, 1)
    table.remove(args, 1)
    local reason = table.concat(args, " ")

    time = tonumber(time)
    if time < 0 or time > 525600 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.invalid_time"):gsub("{MIN}", 1):gsub("{MAX}", 525600))
    end

    local admin = nil
    if playerid ~= -1 then
        admin = GetPlayer(playerid)
    end

   PerformBan(tostring(steamid), "127.0.0.1",
       name, admin and tostring(admin:GetSteamID()) or "0",
       admin and admin:CBasePlayerController().PlayerName or "CONSOLE", time * 60, reason, BanType.SteamID)

   ReplyToCommand(playerid,
       config:Fetch("admins.prefix"),
       FetchTranslation("admins.ban.message"):gsub("{PLAYER_NAME}",
           name):gsub("{ADMIN_NAME}",
           admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{TIME}", ComputePrettyTime(time * 60))
       :gsub("{REASON}", reason))
end)

commands:Register("banip", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "d")

        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
        end
    end

    if argc < 3 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            string.format(FetchTranslation("admins.banip.syntax"), prefix))
    end

    local target = args[1]
    local time = args[2]
    table.remove(args, 1)
    table.remove(args, 1)
    local reason = table.concat(args, " ")

    local players = FindPlayersByTarget(target, false)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.invalid_player"))
    end

    time = tonumber(time)
    if time < 0 or time > 525600 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.invalid_time"):gsub("{MIN}", 1):gsub("{MAX}", 525600))
    end

    local admin = nil
    if playerid ~= -1 then
        admin = GetPlayer(playerid)
    end

    for i = 1, #players do
        local targetPlayer = players[i]
        if not targetPlayer:CBasePlayerController():IsValid() then return end
        PerformBan(tostring(targetPlayer:GetSteamID()), targetPlayer:GetIPAddress(),
            targetPlayer:CBasePlayerController().PlayerName, admin and tostring(admin:GetSteamID()) or "0",
            admin and admin:CBasePlayerController().PlayerName or "CONSOLE", time * 60, reason, BanType.IP)

        ReplyToCommand(playerid,
            config:Fetch("admins.prefix"),
            FetchTranslation("admins.ban.message"):gsub("{PLAYER_NAME}",
                targetPlayer:CBasePlayerController().PlayerName):gsub("{ADMIN_NAME}",
                admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{TIME}", ComputePrettyTime(time * 60))
            :gsub("{REASON}", reason))

        targetPlayer:SendMsg(MessageType.Console, FetchTranslation("admins.ban.playermessage"):gsub("{PREFIX}", config:Fetch("admins.prefix")):gsub("{TIME}", ComputePrettyTime(time * 60)):gsub("{TIME_LEFT}", ComputePrettyTime(time * 60)):gsub("{REASON}", reason):gsub("{ADMIN_NAME}", admin and admin:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{ADMIN_STEAMID}", admin and tostring(admin:GetSteamID()) or "0"))
        SetTimeout(500, function()
            targetPlayer:Drop(DisconnectReason.Kicked)
        end)
    end
end)

commands:Register("kick", function(playerid, args, argc, silent, prefix)
    if playerid ~= -1 then
        local player = GetPlayer(playerid)
        if not player then return end

        local hasAccess = exports["admins"]:HasFlags(playerid, "c")

        if not hasAccess then
            return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
                FetchTranslation("admins.no_permission"))
        end
    end

    if argc < 2 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            string.format(FetchTranslation("admins.kick.syntax"), prefix))
    end

    local target = args[1]
    table.remove(args, 1)
    local reason = table.concat(args, " ")

    local players = FindPlayersByTarget(target, true)
    if #players == 0 then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.invalid_player"))
    end

    local admin = "CONSOLE"
    if playerid ~= -1 then
        admin = GetPlayer(playerid):CBasePlayerController().PlayerName
    end

    for i = 1, #players do
        local targetPlayer = players[i]
        if not targetPlayer:CBasePlayerController():IsValid() then return end
        ReplyToCommand(playerid,
            config:Fetch("admins.prefix"),
            FetchTranslation("admins.kick.message"):gsub("{ADMIN_NAME}", admin):gsub("{PLAYER_NAME}",
                targetPlayer:CBasePlayerController().PlayerName):gsub("{REASON}", reason))

        targetPlayer:Drop(DisconnectReason.Kicked)
    end
end)

local AddBanMenuSelectedPlayer = {}
local AddBanMenuSelectedReason = {}
local AddBanMenuSelectedTime = {}

commands:Register("addbanmenu", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, "d") then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.no_permission"))
    end

    AddBanMenuSelectedPlayer[playerid] = nil
    AddBanMenuSelectedReason[playerid] = nil
    AddBanMenuSelectedTime[playerid] = nil

    local players = {}

    for i = 0, playermanager:GetPlayerCap() - 1, 1 do
        local pl = GetPlayer(i)
        if pl then
            if not pl:IsFakeClient() then
                if pl:CBasePlayerController():IsValid() then
                    table.insert(players, { pl:CBasePlayerController().PlayerName, "sw_addbanmenu_selectplayer " .. i })
                end
            end
        end
    end

    if #players == 0 then
        table.insert(players, { FetchTranslation("admins.no_players"), "" })
    end

    menus:RegisterTemporary("addbanmenuadmintempplayer_" .. playerid, FetchTranslation("admins.bans.addban"),
        config:Fetch("admins.amenucolor"), players)

    player:HideMenu()
    player:ShowMenu("addbanmenuadmintempplayer_" .. playerid)
end)

commands:Register("addbanmenu_selectplayer", function(playerid, args, argc, silent)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, "d") then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.no_permission"))
    end

    if argc == 0 then return end

    local pid = tonumber(args[1])
    if pid == nil then return end
    local pl = GetPlayer(pid)
    if not pl then return end

    AddBanMenuSelectedPlayer[playerid] = pid

    local options = {}

    for i = 0, config:FetchArraySize("admin_bans.reasons") - 1, 1 do
        table.insert(options,
            { config:Fetch("admin_bans.reasons[" .. i .. "]"), "sw_addbanmenu_selectreason \"" ..
            config:Fetch("admin_bans.reasons[" .. i .. "]") .. "\"" })
    end

    menus:RegisterTemporary("addbanmenuadmintempplayerreason_" .. playerid, FetchTranslation("admins.bans.select_reason"),
        config:Fetch("admins.amenucolor"), options)
    player:HideMenu()
    player:ShowMenu("addbanmenuadmintempplayerreason_" .. playerid)
end)

commands:Register("addbanmenu_selectreason", function(playerid, args, argc, silent)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, "d") then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.no_permission"))
    end

    if argc == 0 then return end
    if not AddBanMenuSelectedPlayer[playerid] then return player:HideMenu() end

    local reason = args[1]
    AddBanMenuSelectedReason[playerid] = reason

    local options = {}

    for i = 0, config:FetchArraySize("admin_bans.times") - 1, 1 do
        table.insert(options,
            { math.floor(tonumber(config:Fetch("admin_bans.times[" .. i .. "]"))) == 0 and "Forever" or
            ComputePrettyTime(tonumber(config:Fetch("admin_bans.times[" .. i .. "]"))), "sw_addbanmenu_selecttime " .. i })
    end

    menus:RegisterTemporary("addbanmenuadmintempplayertime_" .. playerid,
        string.format("%s - %s", FetchTranslation("admins.bans.addban"), FetchTranslation("admins.time")),
        config:Fetch("admins.amenucolor"), options)

    player:HideMenu()
    player:ShowMenu("addbanmenuadmintempplayertime_" .. playerid)
    print(AddBanMenuSelectedReason[playerid])
end)

commands:Register("addbanmenu_selecttime", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, "d") then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.no_permission"))
    end

    if argc == 0 then return end
    if not AddBanMenuSelectedPlayer[playerid] then return player:HideMenu() end
    if not AddBanMenuSelectedReason[playerid] then return player:HideMenu() end

    local timeidx = tonumber(args[1])
    if not config:Exists("admin_bans.times[" .. timeidx .. "]") then return end
    AddBanMenuSelectedTime[playerid] = timeidx

    local pid = AddBanMenuSelectedPlayer[playerid]
    local pl = GetPlayer(pid)
    if not pl then
        player:HideMenu()
        ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.not_connected"))
        return
    end

    local options = {
        { FetchTranslation("admins.addban_confirm"):gsub("{COLOR}", config:Fetch("admins.amenucolor")):gsub("{PLAYER_NAME}", pl:CBasePlayerController().PlayerName):gsub("{TIME}", ComputePrettyTime(tonumber(config:Fetch("admin_bans.times[" .. timeidx .. "]")))), "" },
        { FetchTranslation("admins.yes"),                                                                                                                                                                                                                             "sw_addbanmenu_confirmbox yes" },
        { FetchTranslation("admins.no"),                                                                                                                                                                                                                              "sw_addbanmenu_confirmbox no" }
    }


    menus:RegisterTemporary("addbanmenuadmintempplayerconfirm_" .. playerid,
        string.format("%s - %s", FetchTranslation("admins.bans.addban"), FetchTranslation("admins.confirm")),
        config:Fetch("admins.amenucolor"), options)

    player:HideMenu()
    player:ShowMenu("addbanmenuadmintempplayerconfirm_" .. playerid)
end)

commands:Register("addbanmenu_confirmbox", function(playerid, args, argc, silent, prefix)
    if playerid == -1 then return end
    local player = GetPlayer(playerid)
    if not player then return end
    if player:IsFakeClient() then return end
    if not exports["admins"]:HasFlags(playerid, "d") then
        return ReplyToCommand(playerid, config:Fetch("admins.prefix"),
            FetchTranslation("admins.no_permission"))
    end

    if argc == 0 then return end
    if not AddBanMenuSelectedPlayer[playerid] then return player:HideMenu() end
    if not AddBanMenuSelectedReason[playerid] then return player:HideMenu() end
    if not AddBanMenuSelectedTime[playerid] then return player:HideMenu() end

    local response = args[1]

    if response == "yes" then
        local pid = AddBanMenuSelectedPlayer[playerid]
        local pl = GetPlayer(pid)
        if not pl then
            AddBanMenuSelectedPlayer[playerid] = nil
            AddBanMenuSelectedReason[playerid] = nil
            AddBanMenuSelectedTime[playerid] = nil
            player:HideMenu()
            ReplyToCommand(playerid, config:Fetch("admins.prefix"), FetchTranslation("admins.not_connected"))
            return
        end

        if not pl:CBasePlayerController():IsValid() then return end
        if not player:CBasePlayerController():IsValid() then return end
        PerformBan(pl:GetSteamID(), pl:GetIPAddress(), pl:CBasePlayerController().PlayerName, player:GetSteamID(),
            player:CBasePlayerController().PlayerName,
            config:Fetch("admin_bans.times[" .. AddBanMenuSelectedTime[playerid] .. "]"),
            AddBanMenuSelectedReason[playerid], BanType.SteamID)

        ReplyToCommand(playerid,
            config:Fetch("admins.prefix"),
            FetchTranslation("admins.ban.message"):gsub("{PLAYER_NAME}",
                pl:CBasePlayerController().PlayerName):gsub("{ADMIN_NAME}",
                player and player:CBasePlayerController().PlayerName or "CONSOLE"):gsub("{TIME}", ComputePrettyTime(config:Fetch("admin_bans.times[" .. AddBanMenuSelectedTime[playerid] .. "]")))
            :gsub(
                "{REASON}", AddBanMenuSelectedReason[playerid]))

        player:HideMenu()

        pl:SendMsg(MessageType.Console, FetchTranslation("admins.ban.playermessage"):gsub("{PREFIX}", config:Fetch("admins.prefix")):gsub("{TIME}", ComputePrettyTime(config:Fetch("admin_bans.times[" .. AddBanMenuSelectedTime[playerid] .. "]"))):gsub("{TIME_LEFT}", ComputePrettyTime(config:Fetch("admin_bans.times[" .. AddBanMenuSelectedTime[playerid] .. "]"))):gsub("{REASON}", AddBanMenuSelectedReason[playerid]):gsub("{ADMIN_NAME}", player:CBasePlayerController().PlayerName):gsub("{ADMIN_STEAMID}", tostring(player:GetSteamID())))
        SetTimeout(500, function()
            pl:Drop(DisconnectReason.Kicked)
        end)
    end
end)
