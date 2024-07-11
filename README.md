<p align="center">
  <a href="https://github.com/swiftly-solution/admins">
    <img src="https://cdn.swiftlycs2.net/swiftly-logo.png" alt="SwiftlyLogo" width="80" height="80">
  </a>

  <h3 align="center">[Swiftly] Admin System - Base Bans</h3>

  <p align="center">
    A simple plugin for Swiftly that implements a ban system.
    <br/>
  </p>
</p>

<p align="center">
  <img src="https://img.shields.io/github/downloads/swiftly-solution/admins/total" alt="Downloads"> 
  <img src="https://img.shields.io/github/contributors/swiftly-solution/admins?color=dark-green" alt="Contributors">
  <img src="https://img.shields.io/github/issues/swiftly-solution/admins" alt="Issues">
  <img src="https://img.shields.io/github/license/swiftly-solution/admins" alt="License">
</p>

---

### Installation 👀

1. Download the newest [release](https://github.com/swiftly-solution/admins/releases) of Admins - Core.
2. Download the newest [release](https://github.com/swiftly-solution/admins_basebans/releases) of Admins - Base Bans.
3. Everything is drag & drop, so I think you can do it!
4. Setup database connection in `addons/swiftly/configs/databases.json` with the key `swiftly_admins` like in the following example:
```json
{
    "swiftly_admins": {
        "hostname": "...",
        "username": "...",
        "password": "...",
        "database": "...",
        "port": 3306
    }
}
```
> [!WARNING]
> Don't forget to replace the `...` with the actual values !!

### Configuring the plugin 🧐

* After installing the plugin, you need to change the prefix from `addons/swiftly/configs/plugins` (optional) and if you want, you can change the messages from `addons/swiftly/translations`.

### Exports 🛠️

The following exports are available:

|     Name    |    Arguments    |                            Description                            |
|:-----------:|:---------------:|:-----------------------------------------------------------------:|
|   BanSteamID  | steamid, name, admin_steamid, admin_name, seconds, reason | Bans a player on SteamID64  |
| BanIP |     ip, name, admin_steamid, admin_name, seconds, reason    |                 Bans a player on IP                |
| UnbanSteamID | steamid | Unbans a player on SteamID64 |
| UnbanIP |     ip    |                 Unbans a player on IP                |

### Commands 💬

* Base commands provided by this plugin:

|      Command     |        Flag       |               Description              |
|:----------------:|:-----------------:|:--------------------------------------:|
|       !ban       |    ADMFLAG_BAN    | Bans a player from joining the server. |
|      !unban      |   ADMFLAG_UNBAN   |            Unbans a player.            |
|       !banip       |    ADMFLAG_BAN    | Bans a player from joining the server on ip. |
|      !unbanip      |   ADMFLAG_UNBAN   |            Unbans a player on ip.            |
|       !kick      |    ADMFLAG_KICK   |     Kicks a player from the server.    |

### Creating A Pull Request 😃

1. Fork the Project
2. Create your Feature Branch
3. Commit your Changes
4. Push to the Branch
5. Open a Pull Request

### Have ideas/Found bugs? 💡
Join [Swiftly Discord Server](https://swiftlycs2.net/discord) and send a message in the topic from `📕╎plugins-sharing` of this plugin!

---
