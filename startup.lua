local automationFileName = "automation.lua"
local automationFileUrl = "https://raw.githubusercontent.com/kevink17/aqm2_automation/main/automation.lua"
local settingsUrl = "https://raw.githubusercontent.com/kevink17/aqm2_automation/main/.settings_"
local settingsFileName = ".settings"

function getSettingsUrl()
    local computerId = os.getComputerID()
    return settingsUrl..computerId
end

function deleteFileIfExists(file)
    if(fs.exists(file)) then
        fs.delete(file)
    end
end

deleteFileIfExists(automationFileName)
deleteFileIfExists(settingsFileName)

shell.run("wget", getSettingsUrl(), settingsFileName)
shell.run("wget", "run", automationFileUrl)