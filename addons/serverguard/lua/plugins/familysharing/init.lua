--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]
local plugin = plugin
plugin:IncludeFile("shared.lua", SERVERGUARD.STATE.SHARED)

plugin:Hook("CheckPassword", "serverguard.familysharing.CheckFamilySharing", function(communityID, ip, serverPassword, enteredPassword, name)
    if (SERVERGUARD.STEAM_APIKEY) then
        local steamID = util.SteamIDFrom64(communityID)
        local url = Format("https://api.steampowered.com/IPlayerService/IsPlayingSharedGame/v0001/?key=%s&format=json&steamid=%s&appid_playing=4000", SERVERGUARD.STEAM_APIKEY, communityID)

        http.Fetch(url, function(body)
            if (not body) then return end
            local response = util.JSONToTable(body)

            if (not response or not response.lender_steamid) then
                serverguard.PrintConsole("[familysharing] Failed to check for player '" .. name .. "' [" .. steamID .. "], JSON response not valid.\n")

                return
            end

            if (response.lender_steamid ~= "0") then
                local lenderSteamID = util.SteamIDFrom64(response.lender_steamid)
                local lenderData = serverguard.banTable[lenderSteamID]

                if (lenderData) then
                    local endTime = tonumber(lenderData.endTime)

                    if (endTime == 0 or endTime >= os.time()) then
                        serverguard.PrintConsole("[familysharing] Player '" .. name .. "' [" .. steamID .. "] had family sharing set up with banned player '" .. tostring(lenderData.player) .. "' [" .. lenderSteamID .. "] and has been banned.\n")
                        serverguard:BanPlayer(nil, steamID, endTime == 0 and 0 or (endTime - os.time()), lenderData.reason)
                    end
                end
            end
        end, function(error)
            serverguard.PrintConsole("[familysharing] Failed to check for player '" .. name .. "' [" .. steamID .. "], HTTP Error: " .. tostring(err) .. "\n")
        end)
    end
end)