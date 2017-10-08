--[[
  Battlefront UI
  Created by http://steamcommunity.com/id/Devul/
  Do not redistribute this software without permission from authors

  Developer information: {{ user_id }} : {{ script_id }} : {{ script_version_id }}
]]--

bfUI.data = bfUI.data or {}

bfUI.data.playerData = bfUI.data.playerData or {}
bfUI.data.stored = bfUI.data.stored or {}

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

function bfUI.registerUneditableConfig( var, val )
    bfUI.data.unEditableConfig[ var ] = val
end

function bfUI.getUnEditableData( var, fallbackVal )
    return bfUI.data.unEditableConfig[ var ] or fallbackVal
end

function bfUI.getClientData( var, fallbackVal )
    return bfUI.data.playerData[ var ] or fallbackVal
end

function bfUI.setClientData( var, val )
    bfUI.data.playerData[ var ] = val

    saveData()
end

bfUI.data.playerData = getAllData()

--[[----------------------------------------
    ELEMENTS SETUP
------------------------------------------]]

bfUI.config = bfUI.config or {}
bfUI.config.ELEMENTS = {}

bfUI.registerElement = function( name, data )
    data = data or {}
    data.name = name

    return table.insert( bfUI.config.ELEMENTS, data )
end
