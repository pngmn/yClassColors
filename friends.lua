
local _, ns = ...
local ycc = ns.ycc

local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%%d", "%%s")
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%$d", "%$s")
local scrollFrame = ycc.Retail and FriendsListFrameScrollFrame or FriendsFrameFriendsScrollFrame

local function friendsFrame()
	local buttons = scrollFrame.buttons
	local playerArea = GetRealZoneText()
	for i = 1, #buttons do
		local nameText, infoText
		local button = buttons[i]
		if (button:IsShown()) then
			if (button.buttonType == FRIENDS_BUTTON_TYPE_WOW) then
				local name, level, class, area, connected
				if ycc.Retail then
					local info = C_FriendList.GetFriendInfoByIndex(button.id)
					name, level, class, area, connected = info.name, info.level, info.class, info.area, info.connected
				else
					name, level, class, area, connected = GetFriendInfo(button.id)
				end
				if (connected) then
					nameText = ycc.classColor[class]..name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, ycc.diffColor[level]..level.."|r", class)
					if (area == playerArea) then
						infoText = format("|cff00ff00%s|r", area)
					end
				end
			elseif (button.buttonType == FRIENDS_BUTTON_TYPE_BNET) then
				local _, presenceName, name, toonID, client, isOnline, class, area, level
				if ycc.Retail then
					local friendAccountInfo = C_BattleNet.GetFriendAccountInfo(button.id)
					presenceName = friendAccountInfo.accountName
					for i = 1, C_BattleNet.GetFriendNumGameAccounts(button.id) do
						local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(button.id, i)
						if (gameAccountInfo.isOnline and gameAccountInfo.clientProgram == BNET_CLIENT_WOW) then
							local accountInfo = C_BattleNet.GetGameAccountInfoByID(gameAccountInfo.gameAccountID)
							name, class, area, level = accountInfo.characterName, accountInfo.className, accountInfo.areaName, accountInfo.characterLevel
							break
						end
					end
				else
					_, presenceName, _, _, _, toonID, client, isOnline = BNGetFriendInfo(button.id)
					if (isOnline and client == BNET_CLIENT_WOW) then
						_, name, _, _, _, _, _, class, _, area, level = BNGetGameAccountInfo(toonID)
					end
				end
				if (presenceName and name and class) then
					nameText = presenceName.." "..FRIENDS_WOW_NAME_COLOR_CODE.."("..ycc.classColor[class]..name.." "..level..FRIENDS_WOW_NAME_COLOR_CODE..")"
					if (area == playerArea) then
						infoText = format("|cff00ff00%s|r", area)
					end
				end
			end
		end
		if (nameText) then
			button.name:SetText(nameText)
		end
		if (infoText) then
			button.info:SetText(infoText)
		end
	end
end

hooksecurefunc(scrollFrame, "update", friendsFrame)
hooksecurefunc("FriendsFrame_UpdateFriends", friendsFrame)