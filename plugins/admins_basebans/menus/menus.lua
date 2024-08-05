function GenerateMenu()
    menus:Unregister("admin_bans")

    menus:Register("admin_bans", FetchTranslation("admins.adminmenu.bans.title"), tostring(config:Fetch("admins.amenucolor")), {
        { FetchTranslation("admins.bans.addban"),              "sw_addbanmenu" }
    })
end
