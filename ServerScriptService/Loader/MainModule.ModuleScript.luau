local DataService = require(script.Parent:WaitForChild("Modules"):WaitForChild("DataService"))
local Players = game:GetService("Players")

local MainModule = {}

function MainModule:Init()
    Players.PlayerAdded:Connect(function(player: Player)
        DataService:PlayerAdded(player)
    end)

    for i, v in Players:GetPlayers() do
        DataService:PlayerAdded(v)
    end
end

return MainModule
