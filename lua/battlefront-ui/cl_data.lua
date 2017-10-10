--[[
  Battlefront UI
  Created by http://steamcommunity.com/id/Devul/
  Do not redistribute this software without permission from authors

  Developer information: {{ user_id }} : {{ script_id }} : {{ script_version_id }}
]]--

bfUI.data = bfUI.data or {}

bfUI.data.playerData = bfUI.data.playerData or {}
bfUI.data.stored = bfUI.data.stored or {}
bfUI.data.categories = bfUI.data.categories or {}

bfUI.data.unEditableConfig = bfUI.data.unEditableConfig or {}

bfUI.data.folderName = "bfUI"
bfUI.data.fileName = "configuration.txt"

local function saveData()
    file.Write( bfUI.data.folderName .. "/" .. bfUI.data.fileName, util.TableToJSON( bfUI.data.playerData ) )
end

local function getAllData()
    return util.JSONToTable( file.Read( bfUI.data.folderName .. "/" .. bfUI.data.fileName, "DATA" ) or "[]" ) or {}
end

function bfUI.registerClientConfig( var, val, description, callback, data )
    local oldCfg = bfUI.data.stored[ var ]

    bfUI.data.stored[ var ] = {
        data = data,
        value = oldCfg and oldCfg.value or val,
        default = val,
        description = description,
        callback = callback
    }
end

function bfUI.registerCategory( id, name, image )
    bfUI.data.categories[ id ] = { id = id, name = name, image = image }
end

function bfUI.registerUneditableConfig( var, val )
    bfUI.data.unEditableConfig[ var ] = val
end

function bfUI.getUnEditableData( var, fallbackVal )
    return bfUI.data.unEditableConfig[ var ] or fallbackVal
end

function bfUI.getClientData( var, fallbackVal )
    local curVal = bfUI.data.playerData[ var ]
    return curVal or curVal == false and curVal or fallbackVal
end

function bfUI.setClientData( var, val )
    local oldVal = bfUI.data.playerData[ var ]
    bfUI.data.playerData[ var ] = val

    saveData()

    if bfUI.data.stored[ var ] and bfUI.data.stored[ var ].callback then
        bfUI.data.stored[ var ].callback( oldVal, val )
    end
end

bfUI.data.playerData = getAllData()

--[[----------------------------------------
    ELEMENTS SETUP
------------------------------------------]]

bfUI.config = bfUI.config or {}
bfUI.config.ELEMENTS = {}
bfUI.config.ELEMENTS_TO_ID = {}

bfUI.registerElement = function( name, data )
    data = data or {}
    data.name = name

    if bfUI.config.ELEMENTS_TO_ID[ name ] then
        local id = bfUI.config.ELEMENTS_TO_ID[ name ]

        bfUI.config.ELEMENTS[ id ] = data
    else
        local id = table.insert( bfUI.config.ELEMENTS, data )

        bfUI.config.ELEMENTS_TO_ID[ name ] = id
    end
end
