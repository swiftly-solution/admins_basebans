function PerformBan(player_steamid, player_ip, player_name, admin_steamid, admin_name, seconds, reason, btype)
    if not db:IsConnected() then return end
    player_steamid = tostring(player_steamid)

    db:QueryParams(
        "insert into @tablename (player_name, player_steamid, player_ip, type, expiretime, length, reason, admin_name, admin_steamid) values ('@name', '@steamid', "..(player_ip and "'"..db:EscapeString(player_ip).."'" or "NULL")..", @btype, @seconds, @duration, '@reason', '@admin_name', '@admin_steamid')",
        { tablename = config:Fetch("admins.tablenames.bans"), name = player_name, steamid = player_steamid, btype = btype, seconds = (seconds == 0 and (0) or (os.time() + seconds)), duration = seconds, reason = reason, admin_name = admin_name, admin_steamid = admin_steamid }
    )

    logger:Write(LogType_t.Common, string.format("'%s' (%s) banned '%s' (%s). Time: %s | Reason: %s", admin_name, tostring(admin_steamid), player_name, player_ip or player_steamid, ComputePrettyTime(seconds), reason))
end

function PerformUnban(player_steamid, player_ip)
    if not db:IsConnected() then return end
    player_ip = tostring(player_ip or "")
    player_steamid = tostring(player_steamid or "")

    db:QueryParams(
        "select * from @tablename where (player_steamid = '@steamid' or player_ip = '@ipaddr') and (expiretime = 0 OR expiretime - UNIX_TIMESTAMP() > 0) order by id",
        { tablename = config:Fetch("admins.tablenames.bans"), steamid = player_steamid, ipaddr = player_ip }, function(err, result)
        if #err > 0 then return print("ERROR: "..err) end

        for i=1,#result do
            local banRow = result[i]
            if (banRow.type == BanType.IP and banRow.player_ip == player_ip) or (banRow.type == BanType.SteamID and banRow.player_steamid == player_steamid) then
                db:QueryParams("update @tablename set expiretime = UNIX_TIMESTAMP() where id = '@banid' limit 1", { tablename = config:Fetch("admins.tablenames.bans"), banid = banRow.id })
                logger:Write(LogType_t.Common, string.format("'%s' (%s) unbanned '%s' (%s).", banRow.admin_name, tostring(banRow.admin_steamid), banRow.player_name, banRow.type == BanType.IP and player_ip or player_steamid))
            end
        end
    end)
end