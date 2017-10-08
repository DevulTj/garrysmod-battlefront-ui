--[[
    Battlefront UI
    Created by http://steamcommunity.com/id/Devul/
    Do not redistribute this software without permission from authors

    Developer information: {{ user_id }} : {{ script_id }} : {{ script_version_id }}
]]--

local BUTTON = {}

function BUTTON:Init()
    self:SetFont( "bfUIMedium-Secondary" )
end

function BUTTON:Paint( w, h )
    local color = self.isActive and Color( 230, 230, 230 ) or self:IsDown() and Color( 255, 160, 0 ) or self:IsHovered() and Color( 255, 200, 0 ) or Color( 175, 175, 175 )
    local colorAlpha = 255

    color = Color( color.r, color.g, color.b, colorAlpha )

    draw.RoundedBox( 8, 0, 0, w, h, color )
    draw.RoundedBox( 8, 2, 2, w - 4, h - 4, Color( 10, 10, 10, 255 ) )

    draw.SimpleText( self:GetText(), "bfUIMedium-Secondary-Blurred", w / 2 - 1, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    self:SetTextColor( color )
end

derma.DefineControl( "bfUIButton", nil, BUTTON, "DButton" )
