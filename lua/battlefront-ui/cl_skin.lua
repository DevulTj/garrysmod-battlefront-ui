--[[
  Battlefront UI
  Created by http://steamcommunity.com/id/Devul/
  Do not redistribute this software without permission from authors

  Developer information: {{ user_id }} : {{ script_id }} : {{ script_version_id }}
]]--

hook.Add( "loadFonts" , "fonts", function()
	local fontFace = bfUI.getClientData( "font", "FuturaBT-Book" )
	local secondaryFontFace = bfUI.getClientData( "font_secondary", "Roboto Condensed" )

	surface.CreateFont( "bfUIHuge-Secondary", {
		font = secondaryFontFace,
		size = 48,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "bfUILarge", {
		font = fontFace,
		size = 32,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "bfUILargeThin", {
		font = fontFace,
		size = 30,
		weight = 0,
		antialias = true
	} )

	surface.CreateFont( "bfUIMedium", {
		font = fontFace,
		size = 24,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "bfUIMedium-Secondary", {
		font = secondaryFontFace,
		size = 24,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "bfUIMedium-Blurred", {
		font = fontFace,
		size = 24,
		weight = 500,
		antialias = true,
		blursize = 2
	} )

	surface.CreateFont( "bfUIMedium-Secondary-Blurred", {
		font = secondaryFontFace,
		size = 24,
		weight = 500,
		antialias = true,
		blursize = 2
	} )

	surface.CreateFont( "bfUISmall", {
		font = fontFace,
		size = 16,
		weight = 500,
		antialias = true
	} )

	surface.CreateFont( "bfUISmall-Secondary", {
		font = secondaryFontFace,
		size = 18,
		weight = 500,
		antialias = true
	} )
end )

hook.Call( "loadFonts" )

local blur = Material( "pp/blurscreen" )
function bfUI.drawBlurAt( x, y, w, h, amount, passes )
	amount = amount or 4

	surface.SetMaterial( blur )
	surface.SetDrawColor( color_white )

	local scrW, scrH = ScrW(), ScrH()
	local _x, _y = x / scrW, y / scrH
	local _w, _h = ( x + w ) / scrW, ( y + h ) / scrH

	for i = - passes or 0.15, 1, 0.15 do
		blur:SetFloat( "$blur", i * amount )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRectUV( x, y, w, h, _x, _y, _w, _h )
	end
end
