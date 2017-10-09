--[[
Battlefront UI
Created by http://steamcommunity.com/id/Devul/
Do not redistribute this software without permission from authors

Developer information: {{ user_id }} : {{ script_id }} : {{ script_version_id }}
]]--

--[[
	If you bind the menu_key to F1, make sure you've disabled the default DarkRP f1 help menu:

	1. open `darkrpmodification/lua/darkrp_config/disabled_defaults.lua`
	2. find the `DarkRP.disabledDefaults["modules"]` table
	3. disable the f1menu module by setting the config to `true`
]]

bfUI.registerCategory( "general configuration", "GENERAL", Material( "bfui/cogwheel.png", "mips smooth" ) )
bfUI.registerCategory( "appearance", "APPEARANCE", Material( "bfui/avatar.png", "mips smooth" )  )

bfUI.registerUneditableConfig( "menu_key", KEY_F6 ) -- Available keys: KEY enumeration (https://wiki.garrysmod.com/page/Enums/KEY)
bfUI.registerUneditableConfig( "background_material_disabled", false ) -- Disables material background image and uses main_color client configuration
bfUI.registerClientConfig( "background_material", { "bfui/bfui_background.jpg" }, "The background of Battlefront UI", nil, { category = "appearance" } ) -- Material background path, make sure you FastDL/Workshop it
bfUI.registerUneditableConfig( "element_title_force_uppercase", true ) -- Forces element button titles to be in UPPERCASE or not
bfUI.registerUneditableConfig( "can_edit_clientside_settings", true ) -- Enforces the ability to set clientside customization
bfUI.registerUneditableConfig( "show_avatar", true ) -- Show avatar button

bfUI.registerClientConfig( "theme_elements_color", Color( 255, 255, 255 ), "The theme's element's colour", nil, { category = "appearance" } )
bfUI.registerClientConfig( "theme_elements_widget_color", Color( 255, 255, 255 ), "The theme's element's theme widget colour", nil, { category = "appearance" } )
bfUI.registerClientConfig( "main_color", Color( 26, 28, 89 ), "The theme's main colour", nil, { category = "appearance" } )
bfUI.registerClientConfig( "gradient_color", Color( 25, 25, 25 ), "The theme's gradient main colour", nil, { category = "appearance" } )
bfUI.registerClientConfig( "fade_time", 0.5, "Fade time for animations within the theme", nil, { category = "appearance" } )
bfUI.registerClientConfig( "element_pressed_fade_time", 0.5, "Fade time for when you press an element button", nil, { category = "appearance" } )

bfUI.registerClientConfig( "font", "Futura ICG", "The theme's font", function( _, newFont )
	hook.Call( "loadFonts" )
end, { category = "appearance" } )

bfUI.registerClientConfig( "font_secondary", "Roboto Condensed", "The theme's secondary font", function( _, newFont )
	hook.Call( "loadFonts" )
end, { category = "appearance" } )

bfUI.registerClientConfig( "element_button_color", Color( 255, 255, 255 ), "Button colour within the theme", nil, { category = "element button appearance" } )
bfUI.registerClientConfig( "element_button_disabled_color", Color( 125, 125, 125 ), "Disabled button colour within the theme", nil, { category = "element button appearance" } )
bfUI.registerClientConfig( "element_button_hover_color", Color( 235, 235, 235 ), "Hovered button colour within the theme", nil, { category = "element button appearance" } )
bfUI.registerClientConfig( "element_button_down_color", Color( 215, 215, 215 ), "Pressed down button colour within the theme", nil, { category = "element button appearance" } )

bfUI.registerClientConfig( "button_text_color", Color( 255, 255, 255 ), "Text colour within the theme", nil, { category = "button appearance" } )
bfUI.registerClientConfig( "button_text_color_inverted", Color( 0, 0, 0 ), "Inverted text color within the theme", nil, { category = "button appearance" } )
bfUI.registerClientConfig( "button_bg_color", Color( 255, 255, 255 ), "Button background color within the theme", nil, { category = "button appearance" } )

bfUI.registerClientConfig( "ask_on_close", true, "Whether to ask to close the frame when you press the close button", nil, { category = "general configuration" } )

bfUI.registerClientConfig( "auto_open_on_join", true, "Whether Central Menu should auto-open on join", nil, { category = "general configuration" } )

bfUI.registerElement( "HOME", {
	greeting = "WELCOME TO BATTLEFRONT UI, YOU CAN SPECIFY YOUR TEXT HERE.",
	blocks = {
		[ 1 ] = {
			text = "FULLY IN-GAME CONFIGURATION",
			sub = "FEATURING",
			image = Material( "bfui/block_2.png" )
		},
		[ 2 ] = {
			text = "BY DEVULTJ",
			sub = "A QUALITY, OPTIMIZED SCRIPT",
			image = Material( "bfui/block_3.png" )
		},
		[ 3 ] = {
			text = "PURCHASE BATTLEFRONT UI          FOR $3.99",
			sub = "LAST CHANCE",
			image = Material( "bfui/block_4.png" )
		}
	},

	-- Currency is global, you only have to define it once.
	currency = {
		{
			image = Material( "bfui/money.png" ),
			callback = function( player ) return player.getDarkRPVar and player:getDarkRPVar( "money", 0 ) or 0 end
		}
	}
})

bfUI.registerElement( "FORUMS", {
	showURL = "https://facepunch.com/"
})

bfUI.registerElement( "STAFF", {
	--customCheck = function( client, panel ) return client:IsAdmin() or client:IsSuperAdmin() end,

	headerMessage = "This list shows the current online Staff members, contact them if you have any issues.",
	staff = {
		[ "admin" ] = {
			name = "Administrator",
			color = Color( 255, 255, 255 ),
		},
		[ "superadmin" ] = {
			name = "Senior Administrator",
			color = Color( 51, 125, 255 ),
		},
		[ "founder" ] = {
			name = "Founder",
			color = Color( 235, 51, 51 ),
		}
	}
})

bfUI.registerElement( "SERVERS", {
	servers = {
		[ "DARKRP" ] = {
			icon = Material( "bfuiserver_icon.png" ),
			ip = "89.34.97.159",
			desc = "One of our servers.",

			joinText = "JOIN"
		},
		[ "TTT" ] = {
			icon = Material( "bfuiserver_icon_2.png" ),
			ip = "89.34.97.159",
			desc = "Another one of our servers.",

			joinText = "JOIN"
		}
	}
})

bfUI.registerElement( "RULES", {
	showURL = "https://google.co.uk"
})

bfUI.registerElement( "OPTIONS", {
	greeting = "ALL OPTIONS WITHIN BATTLEFRONT UI. THEY ARE FULLY CUSTOMIZABLE IN-GAME.",
	options = true,
} )
