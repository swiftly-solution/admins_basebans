AddEventHandler("OnPluginStart", function(event)
	db = Database(tostring(config:Fetch("admins.connection_name")))
	if not db:IsConnected() then return end

    db:QueryParams(
        "CREATE TABLE `@tablename` (`id` INT NOT NULL AUTO_INCREMENT , `player_name` TEXT NOT NULL , `player_steamid` TEXT NOT NULL , `player_ip` TEXT NULL DEFAULT NULL , `type` INT NOT NULL , `expiretime` INT NOT NULL , `length` INT NOT NULL , `reason` TEXT NOT NULL , `admin_name` TEXT NOT NULL , `admin_steamid` TEXT NOT NULL , `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (`id`)) ENGINE = InnoDB;",
        { tablename = config:Fetch("admins.tablenames.bans") }
    )

    GenerateMenu()
	return EventResult.Continue
end)

AddEventHandler("OnAllPluginsLoaded", function(event)
    if GetPluginState("admins") == PluginState_t.Started then
        exports["admins"]:RegisterMenuCategory("admins.adminmenu.bans.title", "admin_bans", "d")
    end

    return EventResult.Continue
end)

AddEventHandler("OnPlayerConnectFull", function(event)
	local playerid = event:GetInt("userid")
	local player = GetPlayer(playerid)
	if not player then return end
    if player:IsFakeClient() then return end

    db:QueryParams(
        "select * from @tablename where (player_steamid = '@steamid' or player_ip = '@ipaddr') and (expiretime = 0 OR expiretime - UNIX_TIMESTAMP() > 0) order by id limit 1",
        { tablename = config:Fetch("admins.tablenames.bans"), steamid = player:GetSteamID(), ipaddr = player:GetIPAddress() }, function(err, result)
        if #err > 0 then return print("ERROR: "..err) end

        if #result > 0 then
            local banRow = result[1]
            if (banRow.type == BanType.IP and banRow.player_ip == player:GetIPAddress()) or (banRow.type == BanType.SteamID and banRow.player_steamid == tostring(player:GetSteamID())) then
                player:SendMsg(MessageType.Console, FetchTranslation("admins.ban.playermessage"):gsub("{PREFIX}", config:Fetch("admins.prefix")):gsub("{TIME}", ComputePrettyTime(banRow.length)):gsub("{TIME_LEFT}", ComputePrettyTime(banRow.expiretime - os.time())):gsub("{REASON}", banRow.reason):gsub("{ADMIN_NAME}", banRow.admin_name or "CONSOLE"):gsub("{ADMIN_STEAMID}", banRow.admin_steamid or "0"))
                SetTimeout(500, function()
                    player:Drop(DisconnectReason.KickBanAdded)
                end)
            end
        end
    end)
end)