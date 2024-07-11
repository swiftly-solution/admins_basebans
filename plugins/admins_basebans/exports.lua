export("BanSteamID", function(steamid, name, admin_steamid, admin_name, seconds, reason)
    PerformBan(steamid, nil, name, admin_steamid, admin_name, seconds, reason, BanType.SteamID)
end)

export("BanIP", function(ip, name, admin_steamid, admin_name, seconds, reason)
    PerformBan(nil, ip, name, admin_steamid, admin_name, seconds, reason, BanType.IP)
end)

export("UnbanSteamID", function(steamid)
    PerformUnban(steamid)
end)

export("UnbanIP", function(ip)
    PerformUnban(nil, ip)
end)