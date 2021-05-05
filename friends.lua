
local _, ns = ...
local ycc = ns.ycc

local WHITE = {r = 1, g = 1, b = 1}
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%%d", "%%s")
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%$d", "%$s")

local function friendsFrame()
	local scrollFrame = FriendsListFrameScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local playerArea = GetRealZoneText()
	for i = 1, #buttons do
		local nameText, infoText
		local button = buttons[i]
		local index = offset + i
		if (button:IsShown()) then
			if (button.buttonType == FRIENDS_BUTTON_TYPE_WOW) then
				local info = C_FriendList.GetFriendInfoByIndex(button.id)
				if (info.connected) then
					nameText = ycc.classColor[info.class]..info.name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, ycc.diffColor[info.level]..info.level.."|r", info.class)
					if (info.area == playerArea) then
						infoText = format("|cff00ff00%s|r", info.area)
					end
				end
			elseif (button.buttonType == FRIENDS_BUTTON_TYPE_BNET) then
				local friendAccountInfo = C_BattleNet.GetFriendAccountInfo(button.id)
				local numGameAccounts = C_BattleNet.GetFriendNumGameAccounts(button.id)
				for j = 1, numGameAccounts do
					local gameAccountInfo = C_BattleNet.GetFriendGameAccountInfo(button.id, j)
					if (gameAccountInfo.isOnline and gameAccountInfo.clientProgram == BNET_CLIENT_WOW) then
						local accountInfo = C_BattleNet.GetGameAccountInfoByID(gameAccountInfo.gameAccountID)
						if (friendAccountInfo.accountName and accountInfo.characterName and accountInfo.className) then
							nameText = friendAccountInfo.accountName.." "..FRIENDS_WOW_NAME_COLOR_CODE.."("..ycc.classColor[accountInfo.className]..gameAccountInfo.characterName.." "..accountInfo.characterLevel..FRIENDS_WOW_NAME_COLOR_CODE..")"
							if (accountInfo.areaName == playerArea) then
								infoText = format("|cff00ff00%s|r", accountInfo.areaName)
							end
						end
						break
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

hooksecurefunc(FriendsListFrameScrollFrame, "update", friendsFrame)
hooksecurefunc("FriendsFrame_UpdateFriends", friendsFrame)
