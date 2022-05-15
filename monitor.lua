rednet.open("right")

settings.load()
local computers = settings.get("computers")
local monitor = peripheral.wrap("back")
monitor.setTextScale(0.5)
while true do
    local computerId, msg = rednet.receive("reporting")
    local computer = computers[computerId]
    monitor.setCursorPos(1, computer.line)
    monitor.clearLine()
    monitor.write(computer.name..": "..msg)
end