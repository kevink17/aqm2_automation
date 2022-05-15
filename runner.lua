local automationFileName = "automation.lua"
local automationFileUrl = "https://raw.githubusercontent.com/kevink17/aqm2_automation/main/automation.lua"
local monitorFileUrl = "https://raw.githubusercontent.com/kevink17/aqm2_automation/main/monitor.lua"
local settingsUrl = "https://raw.githubusercontent.com/kevink17/aqm2_automation/main/.settings_"
local settingsFileName = ".settings"

function isMonitor()
    local computerLabel = os.getComputerLabel()
    if computerLabel == "monitor" then
        return true
    end
    return false
end

function getSettingsUrl()
    local computerId = os.getComputerID()
 
    if isMonitor() then
        return settingsUrl.."monitor"
    end
    return settingsUrl..computerId
end

function getScriptFile()
    if isMonitor() then
        return monitorFileUrl
    end
    return automationFileUrl
end

function deleteFileIfExists(file)
    if(fs.exists(file)) then
        fs.delete(file)
    end
end

deleteFileIfExists(automationFileName)
deleteFileIfExists(settingsFileName)

shell.run("wget", getSettingsUrl(), settingsFileName)
shell.run("wget", "run", getScriptFile())