local automationFileName = "automation.lua"
local automationFileUrl = "https://raw.githubusercontent.com/kevink17/aqm2_automation/main/automation.lua"

if(fs.exists(automationFileName)) then
    fs.delete(automationFileName)
end

shell.run("wget", "run", automationFileUrl)