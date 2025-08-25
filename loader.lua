local Loader = {}
Loader.baseURL = "https://raw.githubusercontent.com/Ari-apk/aris_scripts/refs/heads/main/scripts/"
Loader.scriptsRegistryURL = "https://raw.githubusercontent.com/Ari-apk/aris_scripts/refs/heads/main/scripts.lua"

-- Fetch and parse scripts registry
local success, registryCode = pcall(function()
    return game:HttpGet(Loader.scriptsRegistryURL)
end)

if success then
    Loader.scripts = loadstring("return "..registryCode)()
else
    warn("Failed to fetch scripts registry: "..registryCode)
    Loader.scripts = {}
end

-- Load a script by its file name
function Loader:loadScript(fileName)
    local url = self.baseURL .. fileName .. ".lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    if success then
        local func, err = loadstring(result)
        if func then
            return func()
        else
            warn("Error loading script '"..fileName.."': "..err)
        end
    else
        warn("Failed to fetch script '"..fileName.."': "..result)
    end
end

-- Optional: List available scripts
function Loader:listScripts()
    for i, s in ipairs(self.scripts) do
        print(i..". "..s.name.." - "..s.description)
    end
end

return Loader
