---------------------------------------------------------------------------------
-- Godeals App
-- Alfredo Chi
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- REQUIRE & VARIABLES
---------------------------------------------------------------------------------

require('src.Menu')
require('src.Header')
require('src.BuildRow')
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local RestManager = require('src.resources.RestManager')
local DBManager = require('src.resources.DBManager')
local widget = require( "widget" )
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local settings
local toolbar, menu
local groupMenu, svContent
local h = display.topStatusBarContentHeight
local lastY = 200;
local itemObj
local contDeals = 0
local yMain = 0

local info, promotions, gallery, MenuEventBar
local homeScreen = display.newGroup()

-- Arreglos
local elements = {}
local imageItems = {}

---------------------------------------------------------------------------------
-- Setters
---------------------------------------------------------------------------------
function setWalletElements(obj)
    elements = obj.items
	
	if #elements > 0 then
			getLoading(svContent)
		loadWalletImage(obj)
	else
		
		contDeals = contDeals + 1
		
		if obj.screen == "noRedimir" then
			RestManager.getDealsRedimir()
		end
		
		if contDeals == 2 then
			endLoading()
			getNoContent(svContent, "En este momento no cuentas con Deals descargados")
		end
		
	end
	
end



--obtenemos el grupo homeScreen de la escena actual
function getSceneSearchW( event )
	--modalSeach(txtSearch.text)
	SearchText(homeScreen)
	return true
end

--obtenemos el homeScreen de la escena
function getScreenW()
	return homeScreen
end

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

-- Carga de la imagen del servidor o de TemporaryDirectory
function loadWalletImage(obj)    
    -- Determinamos si la imagen existe
    local path = system.pathForFile( elements[obj.posc].image, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
        imageItems[obj.posc] = display.newImage( elements[obj.posc].image, system.TemporaryDirectory )
        imageItems[obj.posc].alpha = 0
        if obj.posc < #elements then
            obj.posc = obj.posc + 1
            loadWalletImage(obj)
        else
            buildWalletItems(obj.screen)
        end
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImageListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
                event.target.alpha = 0
                imageItems[obj.posc] = event.target
                if obj.posc < #elements then
                    obj.posc = obj.posc + 1
                    loadWalletImage(obj)
                else
                    buildWalletItems(obj.screen)
                end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url..obj.path..elements[obj.posc].image, 
        "GET", loadImageListener, elements[obj.posc].image, system.TemporaryDirectory ) 
    end
end

function buildWalletItems(screen)

	if screen == "noRedimir" then

		yMain = 50
		endLoading(svContent)
	
		local separadorEventos = display.newImage( "img/btn/btnArrowGreen.png" )
		separadorEventos:translate( 41, yMain -3)
		separadorEventos.isVisible = true
		svContent:insert(separadorEventos)

		local textSeparadorEventos = display.newText( {
			text = "ESTOS SON LOS DEALS DISPONIBLES EN TU CARTERA.",     
			x = 300, y = yMain, width = intW, height = 20,
			font = "Lato-Regular", fontSize = 14, align = "left"
		})
		textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
		svContent:insert(textSeparadorEventos)

		yMain = yMain + 30
		for y = 1, #elements, 1 do 
			-- Create container
			local deal = Deal:new()
			svContent:insert(deal)
			deal:build(true, elements[y], imageItems[y])
			deal.y = yMain
			yMain = yMain + 120
		end
		endLoading()
		RestManager.getDealsRedimir()
	elseif screen == "redimir" then
	
		yMain = yMain + 50
	
		local separadorRedimir = display.newImage( "img/btn/btnArrowGreen.png" )
		separadorRedimir:translate( 41, yMain -3)
		separadorRedimir.isVisible = true
		svContent:insert(separadorRedimir)

		local textSeparadorRedimir = display.newText( {
			text = "ESTOS SON LOS DEALS REDIMIDOS.",     
			x = 300, y = yMain, width = intW, height = 20,
			font = "Lato-Regular", fontSize = 14, align = "left"
		})
		textSeparadorRedimir:setFillColor( 85/255, 85/255, 85/255 )
		svContent:insert(textSeparadorRedimir)
		
		yMain = yMain + 30
		for y = 1, #elements, 1 do 
			-- Create container
			local deal = Deal:new()
			svContent:insert(deal)
			deal:build(true, elements[y], imageItems[y])
			deal.y = yMain
			yMain = yMain + 120
		end
		endLoading()
	end
	
	svContent:setScrollHeight(yMain + 20)
	
end

function scene:createScene( event )

	screen = self.view
	screen:insert(homeScreen)
	
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
    header:buildNavBar("Deals Descargados")
	
	settings = DBManager.getSettings()
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	if svContent then
		svContent:removeSelf()
        svContent = nil
	end
    
    yMain = 0
	svContent = widget.newScrollView
	{
		top = h + 125,
		left = 0,
		width = intW,
		height = intH - (h + 125),
		horizontalScrollDisabled = true,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(svContent)
	getLoading(svContent)
	RestManager.getMyDeals()
    Globals.scene[#Globals.scene + 1] = storyboard.getCurrentSceneName()
end

-- Remove Listener
function scene:exitScene( event )
	contDeals = 0
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene