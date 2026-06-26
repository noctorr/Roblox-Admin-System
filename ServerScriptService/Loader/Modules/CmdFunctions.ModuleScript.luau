local Players = game:GetService("Players")
local Teams = game:GetService("Teams")

local DataService = require(script.Parent:WaitForChild("DataService"))

local CmdFunctions = {
    Durations = {
        PERM = math.huge,
        DAY = 60 * 60 * 24,
        WEEK = 60 * 60 * 24 * 7,
        MONTH = 60 * 60 * 24 * 7 * 3,
        YEAR = 60 * 60 * 24 * 7 * 52
    }
}

function CmdFunctions:BanPlayer(plrNameBuffer: buffer, duration: string)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)
    
    if self.Durations[duration] then
        local seconds = self.Durations[duration]

        DataService:AddBan(Player, seconds)        
    end
end

function CmdFunctions:ServerBan(plrNameBuffer: buffer)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)
    DataService:ServerBan(Player)
end

function CmdFunctions:KickPlayer(plrNameBuffer: buffer)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)
    Player:Kick("You have been kicked from the game.")
end

function CmdFunctions:Team(plrNameBuffer: buffer, team: string)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)

    local Team = assert(Teams:FindFirstChild("team"), "Team does not exist.")
    Player.Team = Team
end

function CmdFunctions:Respawn(plrNameBuffer: buffer)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)
    Player:LoadCharacterAsync()
end

function CmdFunctions:Health(plrNameBuffer: buffer, health: string)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)

    local char: Model = assert(Player.Character, "Character does not exist.")
    local hum: Humanoid = assert(char:FindFirstChildOfClass("Humanoid"), "Humanoid does not exist.")
    local newHP = tonumber(health)

    if hum.MaxHealth < newHP then
        hum.MaxHealth = newHP
        hum.Health = newHP
    else
        hum.Health = newHP
    end
end

function CmdFunctions:Kill(plrNameBuffer: buffer)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)

    local char: Model = assert(Player.Character, "Character does not exist.")
    local hum: Humanoid = assert(char:FindFirstChildOfClass("Humanoid"), "Humanoid does not exist.")

    hum:TakeDamage(hum.Health + 1)
end

function CmdFunctions:Damage(plrNameBuffer: buffer, dmg: number)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)

    local char: Model = assert(Player.Character, "Character does not exist.")
    local hum: Humanoid = assert(char:FindFirstChildOfClass("Humanoid"), "Humanoid does not exist.")

    hum:TakeDamage(dmg)
end

function CmdFunctions:God(plrNameBuffer: buffer)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)

    local char: Model = assert(Player.Character, "Character does not exist.")
    local hum: Humanoid = assert(char:FindFirstChildOfClass("Humanoid"), "Humanoid does not exist.")

    hum.MaxHealth = math.huge
    hum.Health = math.huge
end

function CmdFunctions:Mod(plrNameBuffer: buffer)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)

    DataService:ChangeLevel(Player, "MOD")
end

function CmdFunctions:Admin(plrNameBuffer: buffer)
    local Player = assert(Players:FindFirstChild(buffer.tostring(plrNameBuffer)), `Player not found, player name is {buffer.tostring(plrNameBuffer)}`)

    DataService:ChangeLevel(Player, "ADMIN")
end

return CmdFunctions
