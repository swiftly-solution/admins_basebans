function PerformBan(player_steamid, player_ip, player_name, admin_steamid, admin_name, seconds, reason, btype)
    if not db:IsConnected() then return end
    player_steamid = tostring(player_steamid)

    db:Query(
        string.format(
            "insert into %s (player_name, player_steamid, player_ip, type, expiretime, length, reason, admin_name, admin_steamid, serverid) values ('%s', '%s', %s, %d, %d, %d, '%s', '%s', '%s', %d)",
            config:Fetch("admins.tablenames.bans"), db:EscapeString(player_name), db:EscapeString(player_steamid), player_ip and "'"..player_ip.."'" or "NULL", btype, seconds == 0 and (0) or math.floor(GetTime() / 1000) + seconds, 
            seconds, reason, db:EscapeString(admin_name), admin_steamid, config:Fetch("admins.serverid")
        )
    )

    logger:Write(LogType_t.Common, string.format("'%s' (%s) banned '%s' (%s). Time: %s | Reason: %s", admin_name, tostring(admin_steamid), player_name, player_ip or player_steamid, ComputePrettyTime(seconds), reason))
end

function PerformUnban(player_steamid, player_ip)
    if not db:IsConnected() then return end
    player_ip = tostring(player_ip or "")
    player_steamid = tostring(player_steamid or "")

    db:Query("select * from "..config:Fetch("admins.tablenames.bans").." where (player_steamid = '"..db:EscapeString(player_steamid).."' or player_ip = '"..player_ip.."') and serverid = "..config:Fetch("admins.serverid").." and (expiretime = 0 OR expiretime - UNIX_TIMESTAMP() > 0) order by id", function(err, result)
        if #err > 0 then return print("ERROR: "..err) end

        for i=1,#result do
            local banRow = result[i]
            if (banRow.type == BanType.IP and banRow.player_ip == player_ip) or (banRow.type == BanType.SteamID and banRow.player_steamid == player_steamid) then
                db:Query("update "..config:Fetch("admins.tablenames.bans").." set expiretime = UNIX_TIMESTAMP() where id = '"..banRow.id.."' limit 1")
                logger:Write(LogType_t.Common, string.format("'%s' (%s) unbanned '%s' (%s).", banRow.admin_name, tostring(banRow.admin_steamid), player_name, banRow.type == BanType.IP and player_ip or player_steamid))
            end
        end
    end)
end