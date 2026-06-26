local CMDFunctions = require(script.Parent:WaitForChild("CmdFunctions"))

return {
    ["!ban"] = "ban",
    ["!kick"] = "kick",
    ["!team"] = "team",
    ["!respawn"] = "respawn",
    ["!health"] = "health",
    ["!serverban"] = "serverban",
    ["!god"] = "god",
    ["!kill"] = "kill",
    ["!damage"] = "damage",
    ["!admin"] = "admin",
    ["!mod"] = "mod",

    functions = {
        ban = CMDFunctions:BanPlayer,
        kick = CMDFunctions:KickPlayer,
        team = CMDFunctions:Team,
        respawn = CMDFunctions:Respawn,
        serverban = CMDFunctions:ServerBan,
        health = CMDFunctions:Health,
        kill = CMDFunctions:Kill,
        damage = CMDFunctions:Damage,
        god = CMDFunctions:God,
        admin = CMDFunctions:Admin,
        mod = CMDFunctions:Mod
    }
}
