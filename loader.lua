-- loader.lua
local Loader = {}
Loader.baseURL = "https://raw.githubusercontent.com/Ari-apk/aris_scripts/main/scripts/"
Loader.scriptsRegistryURL = "https://raw.githubusercontent.com/Ari-apk/aris_scripts/main/scripts.lua"

-- Fetch scripts registry safely
local function fetchRegistry()
    local success, registryCode = pcall(function()
        return game:HttpGet(Loader.scriptsRegistryURL)
    end)

    if not success or not registryCode or registryCode == "" then
        warn("Failed to fetch scripts registry: "..tostring(registryCode))
        return {}
    end

    local ok, result = pcall(function()
        return loadstring("return "..registryCode)()
    end)

    if ok and type(result) == "table" then
        return result
    else
        warn("Failed to parse scripts registry: "..tostring(result))
        return {}
    end
end

Loader.scripts = fetchRegistry()

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

    if not success or not result or result == "" then
        warn("Failed to fetch script '"..fileName.."': "..tostring(result))
        return
    end

    local func, err = loadstring(result)
    if not func then
        warn("Error compiling script '"..fileName.."': "..tostring(err))
        return
    end

    local ok, res = pcall(func)
    if not ok then
        warn("Error running script '"..fileName.."': "..tostring(res))
    end
    return res
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

-- Safety check: always return Loader
return Loader
