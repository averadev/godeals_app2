---------------------------------------------------------------------------------
-- Godeals App
-- Alberto Vera
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- REQUIRE & VARIABLES
---------------------------------------------------------------------------------

require('src.Menu')
require('src.BuildRow')
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local RestManager = require('src.resources.RestManager')
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local h = display.topStatusBarContentHeight
local lastY = 0
local myMap
local homeScreen = display.newGroup()

-- Arreglos
local elements = {}
local imageItems = {}

---------------------------------------------------------------------------------
-- Setters
---------------------------------------------------------------------------------
function setWalletElements(items)
    elements = items
end

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-- obtenemos el grupo homeScreen de la escena actual
function getSceneSearchM( event )
	--modalSeach(txtSearch.text)
	SearchText(homeScreen)
	return true
end

-- obtenemos el homeScreen de la escena
function getScreenM()
	return homeScreen
end

-- obtenemos los comercios
function setComerciosGPS(data)
    if myMap then
        for y = 1, #data, 1 do 
            local options = { 
                title = data[y].name,
                subtitle = data[y].info, 
                listener = markerListener, 
                imageFile = "img/btn/iconGPS.png"
            }
            myMap:addMarker( tonumber(data[y].latitude), tonumber(data[y].longitude), options )
        end
    end
end

function scene:createScene( event )
	screen = self.view
	screen:insert(homeScreen)
	local itemObj = event.params.itemObj
    
	local bg = display.newRect( 0, h, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 245/255, 245/255, 245/255 )
	homeScreen:insert(bg)
	
	-- Build Component Header
	local header = Header:new()
    homeScreen:insert(header)
    header.y = h
    header:buildToolbar()
    header:buildNavBar("Ubicación")
    local hWBMap = 5 + header:buildWifiBle()
    
    lastY = h + 130
    
    -- Cocinar el mapa
    local mh = intH - (lastY + hWBMap)
    myMap = native.newMapView( midW, (lastY + hWBMap) + (mh / 2) - 4, intW, mh )
    if itemObj then
        local mh = intH - lastY
        myMap:setCenter( tonumber(itemObj.latitude), tonumber(itemObj.longitude), 0.02, 0.02 )
        homeScreen:insert(myMap)
        
        -- Add Maker
        timeMarker = timer.performWithDelay( 2000, function()
            if myMap then
                local options = { 
                    title = itemObj.name, 
                    subtitle = itemObj.address, 
                    listener = markerListener, 
                    imageFile = "img/btn/iconGPS.png"
                }
                myMap:addMarker( tonumber(itemObj.latitude), tonumber(itemObj.longitude), options )
            end
        end, 1 )
    else
        homeScreen:insert(myMap)
        timeMarker = timer.performWithDelay( 2000, function()
            if myMap then
                RestManager.getComerciosGPS()
            end
        end, 1 )
    end
    
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scene[#Globals.scene + 1] = storyboard.getCurrentSceneName()
end

-- Remove Listener
function scene:exitScene( event )
    if myMap then
        myMap:removeSelf()
        myMap = nil
    end
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene