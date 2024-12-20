AddEventHandler("OnPluginStart", function(event)
	db = Database(tostring(config:Fetch("admins.connection_name")))
	if not db:IsConnected() then return end

    db:QueryBuilder():Table(tostring(config:Fetch("admins.tablenames.bans"))):Create({
        id = "integer|autoincrement",
        player_name = "string|max:128",
        player_steamid = "string|max:128",
        player_ip = "string|max:128|nullable",
        ["`type`"] = "integer",
        expiretime = "integer",
        length = "integer",
        reason = "string|max:512",
        admin_name = "string|max:128",
        admin_steamid = "string|max:128",
        date = "datetime"
    }):Execute()

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

    db:QueryBuilder():Table(tostring(config:Fetch("admins.tablenames.bans"))):Select({})
        :Where("player_steamid", "=", tostring(player:GetSteamID())):OrWhere("player_ip", "=", player:GetIPAddress()):OrderBy({id = "DESC"}):Limit(1)
        :Execute(function (err, result)
            if #err > 0 then return print("ERROR: "..err) end

            if #result > 0 then
                for i=1,#result do
                    if result[i].expiretime == 0 or result[i].expiretime > os.time() then
                        local banRow = result[i]
                        if (banRow.type == BanType.IP and banRow.player_ip == player:GetIPAddress()) or (banRow.type == BanType.SteamID and banRow.player_steamid == tostring(player:GetSteamID())) then
                            player:SendMsg(MessageType.Console, FetchTranslation("admins.ban.playermessage"):gsub("{PREFIX}", tostring(config:Fetch("admins.prefix"))):gsub("{TIME}", ComputePrettyTime(banRow.length)):gsub("{TIME_LEFT}", ComputePrettyTime(banRow.expiretime - os.time())):gsub("{REASON}", banRow.reason):gsub("{ADMIN_NAME}", banRow.admin_name or "CONSOLE"):gsub("{ADMIN_STEAMID}", banRow.admin_steamid or "0"))
                            SetTimeout(500, function()
                                player:Drop(DisconnectReason.KickBanAdded)
                            end)
                        end
                    end
                end
            end
        end)
end)