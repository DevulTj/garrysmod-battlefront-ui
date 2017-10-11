--[[
    Battlefront UI
    Created by http://steamcommunity.com/id/Devul/
    Do not redistribute this software without permission from authors

    Developer information: {{ user_id }} : {{ script_id }} : {{ script_version_id }}
]]--

hook.Add( "PlayerButtonUp", "bfUI_keybinds", function( player, buttonId )
	if not IsFirstTimePredicted() then return end
	if player ~= LocalPlayer() then return end
	if gui.IsGameUIVisible() then return end
	if player:IsTyping() then return end

    local chosenKey = bfUI.getUnEditableData( "menu_key", KEY_F6 )
    if buttonId ~= chosenKey then return end

    bfUI.toggleMenu()
end )

concommand.Add( "bfui_toggle", bfUI.toggleMenu )

if bfUI.getClientData( "auto_open_on_join", true ) then
    hook.Add( "InitPostEntity", "bfUI", bfUI.toggleMenu )
end
