local was_banned_over_here = {}

function PerformBan(player_steamid, player_ip, player_name, admin_steamid, admin_name, seconds, reason, btype, callback)
    if not db:IsConnected() then return end
    player_steamid = tostring(player_steamid)

    db:QueryBuilder():Table(tostring(config:Fetch("admins.tablenames.bans"))):Select({}):OrderBy({id = "ASC"})
        :Where(btype == BanType.IP and "player_ip" or "player_steamid", "=", btype == BanType.IP and player_ip or player_steamid)
        :Execute(function(err, result)
            if #err > 0 then return print("ERROR: "..err) end

            for i=1,#result do
                if result[i].expiretime == 0 or result[i].expiretime > os.time() then
                    return
                end
            end

            if was_banned_over_here[player_steamid] == true then return end
            if was_banned_over_here[player_ip] == true then return end

            was_banned_over_here[player_steamid] = true
            was_banned_over_here[player_ip] = true

            db:QueryBuilder():Table(tostring(config:Fetch("admins.tablenames.bans"))):Insert({
                player_name = player_name,
                player_steamid = player_steamid,
                player_ip = player_ip or "nil",
                ["`type`"] = btype,
                expiretime = (seconds == 0 and (0) or (os.time() + seconds)),
                length = seconds,
                reason = reason,
                admin_name = admin_name,
                admin_steamid = admin_steamid,
            }):Execute(function (err, result)
                if #err > 0 then
                    print("Err: " .. err)
                end

                was_banned_over_here[player_steamid] = false
                was_banned_over_here[player_ip] = false
            end)

            logger:Write(LogType_t.Common, string.format("'%s' (%s) banned '%s' (%s). Time: %s | Reason: %s", admin_name, tostring(admin_steamid), player_name, player_ip or player_steamid, ComputePrettyTime(seconds), reason))
        end)
end

function PerformUnban(player_steamid, player_ip)
    if not db:IsConnected() then return end
    player_ip = tostring(player_ip or "")
    player_steamid = tostring(player_steamid or "")

    db:QueryBuilder():Table(tostring(config:Fetch("admins.tablenames.bans"))):Select({})
        :Where("player_steamid", "=", player_steamid):OrWhere("player_ip", "=", player_ip):OrderBy({ id = "ASC" })
        :Execute(function(err, result)
        if #err > 0 then return print("ERROR: "..err) end

        for i=1,#result do
            local banRow = result[i]
            if banRow.expiretime == 0 or banRow.expiretime > os.time() then
                if (banRow.type == BanType.IP and banRow.player_ip == player_ip) or (banRow.type == BanType.SteamID and banRow.player_steamid == player_steamid) then
                    db:QueryBuilder():Table(tostring(config:Fetch("admins.tablenames.bans"))):Update({ expiretime = os.time() }):Where("id", "=", banRow.id):Limit(1):Execute()
                    logger:Write(LogType_t.Common, string.format("'%s' (%s) unbanned '%s' (%s).", banRow.admin_name, tostring(banRow.admin_steamid), banRow.player_name, banRow.type == BanType.IP and player_ip or player_steamid))
                end
            end
        end
    end)
end
