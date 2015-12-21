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
local hWBW = 0

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
			getNoContent(svContent, Globals.language.walletGetNoContent)
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
			text = Globals.language.walletTextSeparadorEventos,     
			x = 300, y = yMain, width = intW, height = 20,
			font = "Lato-Regular", fontSize = 14, align = "left"
		})
		textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
		svContent:insert(textSeparadorEventos)

		yMain = yMain + 50
		for y = 1, #elements, 1 do 
			-- Create container
			local deal = Deal:new()
			svContent:insert(deal)
			deal:build(true, elements[y], imageItems[y])
			deal.y = yMain
			yMain = yMain + 180
		end
		endLoading()
		RestManager.getDealsRedimir()
	elseif screen == "redimir" then
	
		yMain = yMain + 10
	
		local separadorRedimir = display.newImage( "img/btn/btnArrowGreen.png" )
		separadorRedimir:translate( 41, yMain -3)
		separadorRedimir.isVisible = true
		svContent:insert(separadorRedimir)

		local textSeparadorRedimir = display.newText( {
			text = Globals.language.walletTextSeparadorRedimir,     
			x = 300, y = yMain, width = intW, height = 20,
			font = "Lato-Regular", fontSize = 14, align = "left"
		})
		textSeparadorRedimir:setFillColor( 85/255, 85/255, 85/255 )
		svContent:insert(textSeparadorRedimir)
		
		yMain = yMain + 50
		for y = 1, #elements, 1 do 
			-- Create container
			local deal = Deal:new()
			svContent:insert(deal)
			deal:build(true, elements[y], imageItems[y])
			deal.y = yMain
			yMain = yMain + 180
		end
		endLoading()
	end
	
	svContent:setScrollHeight(yMain)
	
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
    header:buildNavBar("Mi Bandeja")
    hWBW = 5 + header:buildWifiBle()
	
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
		top = h + 125 + hWBW,
		left = 0,
		width = intW,
		height = intH - (h + 125 + hWBW),
		horizontalScrollDisabled = true,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(svContent)
	
    Globals.scene[#Globals.scene + 1] = storyboard.getCurrentSceneName()
    
    
    if Globals.isReadOnly then
        local iconReadOnly = display.newImage( "img/btn/lock.png" )
		iconReadOnly:translate( 240, 120)
        iconReadOnly.alpha = .5
		svContent:insert(iconReadOnly)

		local lblReadOnly = display.newText( {
			text = Globals.language.loginFreeDownloads,     
			x = 240, y = 240, width = 400,
			font = "Lato-Regular", fontSize = 16, align = "center"
		})
		lblReadOnly:setFillColor( 85/255, 85/255, 85/255 )
		svContent:insert(lblReadOnly)
        
        local rctFree = display.newRoundedRect( midW, 320, 270, 55, 5 )
        rctFree:setFillColor( .2, .6 ,0 )
		rctFree:addEventListener( "tap", logout )
        svContent:insert(rctFree)
        
        local lblSign = display.newText( {
			text = Globals.language.loginFreeSign,     
			x = 240, y = 320, width = 400,
			font = "Lato-Bold", fontSize = 16, align = "center"
		})
		lblSign:setFillColor( 1 )
		svContent:insert(lblSign)
    else
        getLoading(svContent)
        RestManager.getMyDeals()
    end
    
end

-- Remove Listener
function scene:exitScene( event )
	contDeals = 0
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene