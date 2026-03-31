--[[




                                                                 
▄▄▄▄▄▄▄▄▄ ▄▄                            ▄▄                       
▀▀▀███▀▀▀ ██                            ██                ▄▄     
   ███    ████▄ ▄███▄ ████▄ ████▄ ▄█▀█▄ ████▄ ▄███▄ ▄███▄ ██ ▄█▀ 
   ███    ██ ██ ██ ██ ██ ▀▀ ██ ██ ██▄█▀ ██ ██ ██ ██ ██ ██ ████   
   ███    ██ ██ ▀███▀ ██    ██ ██ ▀█▄▄▄ ██ ██ ▀███▀ ▀███▀ ██ ▀█▄ 
                                                                 
                                                                 
                 
                                                    
]]


local script = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/Zolura/vaderpaste-mirror/refs/heads/main/thornehook.lua"))()]]
local thread = [[
    for _, func in getgc(false) do
        if type(func) == "function" and islclosure(func) and debug.getinfo(func).name == "require" and string.find(debug.getinfo(func).source, "ClientLoader") then
            ]] .. script .. [[
            break
        end
    end
]]

local executor = string.lower(identifyexecutor and identifyexecutor() or "")
local executors = {
    potassium = { run_on_thread, getactorthreads },
    volt      = { run_on_actor,  getactors },
    cosmic    = { run_on_actor,  getactors },
    sirhurt   = { run_on_actor,  getactors },
    isaeva    = { run_on_actor,  getactors },
    wave      = { run_on_actor,  get_deleted_actors },
}

for name, functions in executors do
    if string.find(executor, name) then
        for _, actor in functions[2]() do
            functions[1](actor, thread)
        end
        return
    end
end

if getfflag and string.lower(tostring(getfflag("DebugRunParallelLuaOnMainThread"))) == "true" then
    loadstring(script)()
elseif setfflag then
    setfflag("DebugRunParallelLuaOnMainThread", "True")
    if queue_on_teleport then
        queue_on_teleport(script)
    end
    game:GetService("TeleportService"):Teleport(game.PlaceId)
end