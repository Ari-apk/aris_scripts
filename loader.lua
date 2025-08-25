-- loader.lua
local loader = {}
loader.baseURL = "https://raw.githubusercontent.com/Ari-apk/aris_scripts/main/scripts/"
loader.registryURL = "https://raw.githubusercontent.com/Ari-apk/aris_scripts/main/scripts.lua"

-- Fetch and parse scripts registry safely
local function fetchRegistry()
    local success, registryCode = pcall(function()
        return game:HttpGet(loader.registryURL)
    end)

    if not success or not registryCode or registryCode == "" then
        warn("Failed to fetch scripts registry: " .. tostring(registryCode))
        return {}
    end

    local ok, result = pcall(function()
        return loadstring(registryCode)()
    end)

    if ok and type(result) == "table" then
        return result
    else
        warn("Failed to parse scripts registry: " .. tostring(result))
        return {}
    end
end

loader.scripts = fetchRegistry()

-- Load a script by file name
function loader.loadscript(fileName)
    if not fileName or fileName == "" then
        warn("No script file name provided")
        return
    end

    local url = loader.baseURL .. fileName .. ".lua"
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not success or not result or result == "" then
        warn("Failed to fetch script '" .. fileName .. "': " .. tostring(result))
        return
    end

    local func, err = loadstring(result)
    if not func then
        warn("Error compiling script '" .. fileName .. "': " .. tostring(err))
        return
    end

    local ok, res = pcall(func)
    if not ok then
        warn("Error running script '" .. fileName .. "': " .. tostring(res))
    end
    return res
end

-- List available scripts
function loader.listscripts()
    if not loader.scripts or #loader.scripts == 0 then
        warn("No scripts available")
        return
    end

    for i, s in ipairs(loader.scripts) do
        local name = tostring(s.name or "Unnamed")
        local desc = tostring(s.description or "No description")
        print(i .. ". " .. name .. " - " .. desc)
    end
end

return loader
