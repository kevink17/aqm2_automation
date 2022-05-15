rednet.open("right")

settings.load()
local computers = settings.get("computers")
local monitor = peripheral.wrap("back")
monitor.setTextScale(0.5)

function getComputer( id )
    for k, v in pairs(computers) do
        if(v.id == id) then
            return v
        end
    end
end


while true do
    local computerId, msg = rednet.receive("reporting")
    local computer = getComputer(computerId)
    local displayMsg = computer.name..": "..msg
    print(displayMsg)
    print("Drawing on line "..computer.line)
    monitor.setCursorPos(1, computer.line)
    monitor.clearLine()
    monitor.write(computer.name..": "..msg)
end