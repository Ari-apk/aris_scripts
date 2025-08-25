local Loader = {}
Loader.baseURL = "https://raw.githubusercontent.com/Ari-apk/aris_scripts/main/scripts/"
Loader.scriptsRegistryURL = "https://raw.githubusercontent.com/Ari-apk/aris_scripts/main/scripts.lua"

-- Fetch scripts registry safely
local success, registryCode = pcall(function()
    return game:HttpGet(Loader.scriptsRegistryURL)
end)

if success and registryCode and registryCode ~= "" then
    local ok, result = pcall(function()
        return loadstring("return "..registryCode)()
    end)
    if ok and result then
        Loader.scripts = result
    else
        warn("Failed to parse scripts registry: "..tostring(result))
        Loader.scripts = {}
    end
else
    warn("Failed to fetch scripts registry: "..tostring(registryCode))
    Loader.scripts = {}
end

-- Load a script by file name
function Loader:loadScript(fileName)
    if not fileName or fileName == "" then
        warn("No script file name provided")
        return
    end

    local url = self.baseURL .. fileName .. ".lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if success and result and result ~= "" then
        local func, err = loadstring(result)
        if func then
            return func()
        else
            warn("Error compiling script '"..fileName.."': "..tostring(err))
        end
    else
        warn("Failed to fetch script '"..fileName.."': "..tostring(result))
    end
end

-- List available scripts
function Loader:listScripts()
    if not self.scripts or #self.scripts == 0 then
        warn("No scripts available")
        return
    end

    for i, s in ipairs(self.scripts) do
        print(i..". "..s.name.." - "..s.description)
    end
end

return Loader
