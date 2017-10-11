--[[
    Battlefront UI
    Created by http://steamcommunity.com/id/Devul/
    Do not redistribute this software without permission from authors

    Developer information: {{ user_id }} : {{ script_id }} : {{ script_version_id }}
]]--

local BUTTON = {}

function BUTTON:Init()
    self:SetFont( "bfUIMedium-Secondary" )
    self:SetTextColor( Color( 0, 0, 0, 0 ) )
end

local topRight = Material( "bfui/button/button_topright.png" )
local topRightW, topRightH = 16, 16

function math.clampColor( val )
    return math.Clamp( val, 0, 255 )
end

function BUTTON:Paint( w, h )
    local pCol = bfUI.getClientData( "main_color", color_white )
    local sCol = bfUI.getClientData( "secondary_color", Color( 255, 200, 0 ) )
    local color = self.isActive and Color( pCol.r, pCol.g, pCol.b ) 
        or self:IsDown() and Color( math.clampColor( sCol.r - 35 ), math.clampColor( sCol.g - 35 ), math.clampColor( sCol.b - 35 ) ) 
            or self:IsHovered() and sCol or Color( math.clampColor( pCol.r - 55 ), math.clampColor( pCol.g - 55 ), math.clampColor( pCol.b - 55 ) )
    local colorAlpha = 255

    color = Color( color.r, color.g, color.b, colorAlpha )

    surface.SetMaterial( topRight )
    surface.SetDrawColor( color )
    surface.DrawTexturedRect( w - topRightW, 0, topRightW, topRightH )

    -- Bottom bar
    surface.DrawRect( 0, h - 2, w, 2 )

    -- Top bar
    surface.DrawRect( 0, 0, w - topRightW, 2 )

    -- Left bar
    surface.DrawRect( 0, 0, 2, h )

    -- Right bar
    surface.DrawRect( w - 2, topRightH, 2, h - topRightH )

    draw.SimpleText( self:GetText(), "bfUIMedium-Secondary", w / 2, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( self:GetText(), "bfUIMedium-Secondary-Blurred", w / 2, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end

derma.DefineControl( "bfUIButton", nil, BUTTON, "DButton" )
