local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local BannedDS = DataStoreService:GetDataStore("Bans")
local AdminDS = DataStoreService:GetDataStore("Admins")

local Commands = require(script.Parent:WaitForChild("Commands"))

local function GenerateUID()
    return HttpService:GenerateGUID(false)
end

local Queue: { { self: thread, id: string } } = { }

local function Enqueue(co: thread): string
    local UID = GenerateUID()
    table.insert(Queue, {co, UID})
    return UID
end

local function Dequeue(): ()
    table.remove(Queue, 1)
end

local DataService: {
    ServerBannedPlayers: {number},
    RateLimit: (fn: any) -> ()
} = {
    ServerBannedPlayers = {},

    RateLimit = function(fn: any)
        if rawlen(Queue) > 0 then
            local thread = coroutine.create(function()
                fn()
            end)
            local ID = Enqueue(thread)
            repeat task.wait(1) until (Queue[1])[2] == ID

            coroutine.resume(thread)
            Dequeue()
        else
            local thread = coroutine.create(function()
                fn()
            end)
            local ID = Enqueue(thread)

            coroutine.resume(thread)
            Dequeue()
        end
    end,
}

local function LogData(ID: string, val: { duration: number, startTime: number} | string): any
    local succ, res = pcall(function()
        return BannedDS:SetAsync(tostring(ID), val)
    end)

    if not succ then
        for _, v in Players:GetPlayers() do
            if v.UserId == ID then
                task.defer(function()
                    LogData(ID, val)
                end)
                return
            end
        end        
    end

    return res
end

local function commandCheck(msg: string): ({ Player, string } | { Player, string, string})?
    local newMsg = msg:sub(1, 1):lower():split(" ")
    if Commands[newMsg[1]] then
        local len = newMsg[2]:len() 
        local command = Commands[newMsg[1]]
        if newMsg[3] and command then
            for i,v in Players:GetPlayers() do
                if i:sub(1, len):lower() == newMsg[2] then
                    return { v, command, newMsg[3] }
                end
            end
        elseif command then
            for i,v in Players:GetPlayers() do
                if i:sub(1, len):lower() == newMsg[2] then
                    return { v, command}
                end
            end
        else
            return nil
        end
    else
        return nil
    end
end

function DataService:AddBan(player: Player, dur: number)
    self.RateLimit(function()
        LogData(tostring(player.UserId), { duration = dur, startTime =  os.time()})
    end)

    player:Kick(`You have been banned for: {dur*60*60} hours.`)
end

function DataService:ChangeLevel(player: Player, level: string)
    local succ, res = pcall(function()
        AdminDS:SetAsync(tostring(player.UserId), level)
    end)
end

function DataService:ServerBan(player: Player)
    table.insert(self.ServerBannedPlayers, player.UserId)

    player:Kick("You have been server-banned.")
end

function DataService:PlayerAdded(player: Player)
    local succ, res = pcall(function()
        return BannedDS:GetAsync(tostring(player.UserId))
    end)

    if succ and res then
        if (res.duration - (os.time() - res.startTime)) <= 0 then
        else
            player:Kick(`You are banned for {(os.time() - res.startTime)}`)
        end
    end

    local suc, result = pcall(function()
        return AdminDS:GetAsync(tostring(player.UserId))
    end)

    if suc and result == "ADMIN" or result == "MOD" then
        player.Chatted:Connect(function(msg: string)
            if msg[1] ~= "!" then return end
            local callback = commandCheck(msg)

            if callback and callback[3] then
                Commands.functions[callback[2]](callback[1], buffer.fromstring(callback[3]))
            else if callback then
                Commands.functions[callback[2]](buffer.fromstring(callback[1]))
            end
        end)
    end
end

return DataService

return DataService
