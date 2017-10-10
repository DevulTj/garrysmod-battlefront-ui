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

function BUTTON:Paint( w, h )
    local color = self.isActive and Color( 230, 230, 230 ) or self:IsDown() and Color( 255, 160, 0 ) or self:IsHovered() and Color( 255, 200, 0 ) or Color( 175, 175, 175 )
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


    //draw.RoundedBox( 8, 0, 0, w, h, color )
    //draw.RoundedBox( 8, 2, 2, w - 4, h - 4, Color( 10, 10, 10, 255 ) )

    draw.SimpleText( self:GetText(), "bfUIMedium-Secondary", w / 2, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    draw.SimpleText( self:GetText(), "bfUIMedium-Secondary-Blurred", w / 2, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "bfUIButton", nil, BUTTON, "DButton" )
