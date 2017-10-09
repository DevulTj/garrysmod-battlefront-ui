local PANEL = {}

function PANEL:Init()
    self:Dock( FILL )
end

function PANEL:Paint( w, h ) end

local topRight = Material( "bfui/button/button_topright.png" )
local topRightW, topRightH = 16, 16

function PANEL:createCategoryButton( parent, categoryId, categoryInfo )
    local button = parent:Add( "DButton" )
    button:SetText( "" )
    button:SetSize( 350, 250 )

    button.Paint = function( this, w, h ) 
        local color = this.isActive and Color( 230, 230, 230 ) or this:IsDown() and Color( 255, 160, 0 ) or this:IsHovered() and Color( 255, 200, 0 ) or Color( 175, 175, 175 )
        local colorAlpha = 255

        color = Color( color.r, color.g, color.b, colorAlpha )

        -- Icon image
        surface.SetMaterial( categoryInfo.image )
        surface.SetDrawColor( color )
        surface.DrawTexturedRect( w / 2 - ( 150 / 2 ), h / 1.75 - ( 150 / 2 ), 150, 150 )

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

        draw.SimpleText( categoryInfo.name, "bfUIMediumLarge-Secondary-Blurred", 28, 36, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
        draw.SimpleText( categoryInfo.name, "bfUIMediumLarge-Secondary", 28, 36, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
    end

    button.DoClick = function( this )
        self:viewOptions( categoryId )
    end

    return button
end

function PANEL:addTextEntry( parent, value )
    local textEntry = parent:Add( "DTextEntry" )
    textEntry:Dock( RIGHT )
    textEntry:SetWide( 128 )
    textEntry:SetValue( value )

    textEntry.Paint = function( this, w, h )
        draw.RoundedBox( 16, 0, 4, w, h - 8, Color( 50, 50, 50, 125 ) )

    	this:DrawTextEntryText( color_white, Color( 125, 0, 0, 125 ), Color( 200, 200, 200, 200 ) )
    end
end

function PANEL:addBoolean( parent, value )
    local button = parent:Add( "DButton" )
    button:SetText( "" )
    button:Dock( RIGHT )
    button:SetWide( 186 )

    button.Paint = function( this, w, h )
        local activeColor = Color( 255, 255, 255, 255 )
        local notActiveColor = Color( 0, 0, 0, 255 )

        local desiredBoxColor = value and Color( activeColor.r, activeColor.g, activeColor.b, 200 ) or Color( notActiveColor.r, notActiveColor.g, notActiveColor.b, 100 )
        local desiredBoxColorInverted = not value and Color( activeColor.r, activeColor.g, activeColor.b, 200 ) or Color( notActiveColor.r, notActiveColor.g, notActiveColor.b, 100 )

        -- Yes
        draw.RoundedBox( 4, 8, 4, 64, h - 8, desiredBoxColor )
        draw.SimpleText( "YES", "bfUIMedium-Secondary", 32 + 8, h / 2, not value and activeColor or notActiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        
        -- No
        draw.RoundedBox( 4, 64 + 16, 4, 64, h - 8, desiredBoxColorInverted )
        draw.SimpleText( "NO", "bfUIMedium-Secondary", 32 + 8 + 64 + 8, h / 2, value and activeColor or notActiveColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end

    button.DoClick = function( this )
        local newValue = not value
        bfUI.setClientData( parent.varName, newValue )

        if parent.varInfo.callback then v.callback( value, newValue ) end
        value = newValue
    end
end

function PANEL:addColor( parent, value )

end

function PANEL:fillOptions( categoryId )
    self.elements = {}

    self.optionList = self.panel:Add( "DIconLayout" )
    self.optionList:Dock( LEFT )
    self.optionList:SetWide( self:GetWide() / 2 )

    for varName, varInfo in pairs( bfUI.data.stored ) do
        if varInfo.data and varInfo.data.category ~= categoryId then continue end

        local button = self.optionList:Add( "DButton" )
        button:SetText( "" )
        button:Dock( TOP )
        button:SetTall( 40 )

        button.Paint = function( this, w, h )
            local color = this:IsDown() and Color( 255, 160, 0 ) or this:IsHovered() and Color( 255, 200, 0 ) or Color( 235, 235, 235 )
            local colorAlpha = 255

            color = Color( color.r, color.g, color.b, colorAlpha )

            draw.SimpleText( varName, "bfUIMediumLarge-Secondary-Blurred", 28, h / 2, Color( color.r, color.g, color.b, 150 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
            draw.SimpleText( varName, "bfUIMediumLarge-Secondary", 28, h / 2, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER ) 
        end

        button.varName = varName
        button.varInfo = varInfo

        local _type = type( varInfo.value )

        if _type == "number" or _type == "string" then
            self:addTextEntry( button, varInfo.value )
        elseif _type == "boolean" then
            self:addBoolean( button, varInfo.value )
        elseif _type == "table" then

        end
        
        self.elements[ varName ] = button
    end
end

function PANEL:viewOptions( categoryId )
    local fadeTime = bfUI.getClientData( "fade_time", 0.5 )
    self.panel:AlphaTo( 0, fadeTime, 0, function()
        self.panel:Clear()

        self.footer = self.panel:Add( "Panel" )
        self.footer:Dock( BOTTOM )
        self.footer:SetTall( 40 )

        self.resetBtn = self.footer:Add( "bfUIButton" )
        self.resetBtn:Dock( LEFT )
        self.resetBtn:SetText( "RESET TO DEFAULTS" )
        self.resetBtn:SetWide( 256 )
        self.resetBtn.DoClick = function( pnl )
            bfUI.createDialogue( "RESET", "Reset to defaults settings?", "YES", function( dialogue )
                for a, b in pairs( bfUI.data.stored ) do
                    bfUI.setClientData( a, b.default )
                end

                dialogue:Close()
            end, "NO", function( dialogue ) dialogue:Close() end )
        end

        self.goBack = self.footer:Add( "bfUIButton" )
        self.goBack:Dock( LEFT )
        self.goBack:DockMargin( 8, 0, 0, 0 )
        self.goBack:SetText( "BACK" )
        self.goBack:SetWide( 128 )
        self.goBack.DoClick = function( pnl )
            local fadeTime = bfUI.getClientData( "fade_time", 0.5 )
            self.panel:AlphaTo( 0, fadeTime, 0, function()
                self:setUp()

                self.panel:SetAlpha( 0 )
                self.panel:AlphaTo( 255, fadeTime, 0 )
            end )
        end

        self:fillOptions( categoryId )

        self.panel:AlphaTo( 255, fadeTime, 0 )
    end )
end

function PANEL:setUp()
    self.panel = self:Add( "Panel" )
    self.panel:Dock( FILL )

    self.footer = self.panel:Add( "Panel" )
    self.footer:Dock( BOTTOM )
    self.footer:SetTall( 40 )

    self.resetBtn = self.footer:Add( "bfUIButton" )
    self.resetBtn:Dock( LEFT )
    self.resetBtn:SetText( "RESET TO DEFAULTS" )
    self.resetBtn:SetWide( 256 )
    self.resetBtn.DoClick = function( pnl )
        bfUI.createDialogue( "RESET", "Reset to defaults settings?", "YES", function( dialogue )
            for a, b in pairs( bfUI.data.stored ) do
                bfUI.setClientData( a, b.default )
            end

            dialogue:Close()
        end, "NO", function( dialogue ) dialogue:Close() end )
    end

    self.container = self.panel:Add( "DIconLayout" )
    self.container:Dock( FILL )
    self.container:DockMargin( 0, 0, 0, 16 )
    self.container:SetSpaceX( 8 )

    local varsSaved = {}

    self.categories = {}
    for categoryId, categoryInfo in pairs( bfUI.data.categories ) do
       self.categories[ categoryId ] = self:createCategoryButton( self.container, categoryId, categoryInfo )
    end
end

derma.DefineControl( "bfUISettingsPanel", nil, PANEL, "DPanel" )