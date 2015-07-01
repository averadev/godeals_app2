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
local widget = require( "widget" )
local scene = storyboard.newScene()
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local toolbar, menu
local groupMenu, groupInfo, groupEvent, groupMenuEventText
local svCoupon, svInfo, svPromotions, svGallery
local h = display.topStatusBarContentHeight
local lastY = 200;
local lastYImage = lastY;
local itemObj
local currentSv
local settings
local dealsPartner = {}
local timeMarker
local callbackCurrent = 0
local hWBE = 0

local info, promotions, gallery, MenuEventBar
--pantalla

local homeScreen = display.newGroup()

-- tablas

local srvEventos = {}
local txtMenuEvent = {}
local imageEventDeals = {}
local imageEventGallery = {}

-- funciones

function showMapa( event )
    storyboard.removeScene( "src.Mapa" )
	storyboard.gotoScene( "src.Mapa", {
		time = 400,
		effect = "crossFade",
		params = { itemObj = itemObj }
	})
end

--obtenemos el grupo homeScreen de la escena actual
function getSceneSearchE( event )
	--modalSeach(txtSearch.text)
	SearchText(homeScreen)
	return true
end

--obtenemos el homeScreen de la escena
function getScreenE()
	return homeScreen
end

--creamos el evento
function buildEvent(item, hWB)
	
	srvEventos[1] = widget.newScrollView
	{
		top = h + 125 + hWBE,
		left = positionScrollEvent,
		width = intW,
		height = intH - (h + 125 + hWBE),
		listener = ListenerChangeScrollEvent,
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
    homeScreen:insert( srvEventos[1] )
	
	if callbackCurrent == Globals.noCallbackGlobal then
		buildEventInfo(item)
	end
	
end

--creamos la primera seccion del evento
function buildEventInfo(item)

	lastY = 70
	groupInfo = display.newGroup()
    srvEventos[1]:insert(groupInfo)
	loadImageFull(itemObj.imageFull)
    
	local bgPartnerInfo = display.newRect( midW, 0, 460, 76 )
	bgPartnerInfo:setFillColor( .87 )
	groupInfo:insert(bgPartnerInfo)
	
	local txtPartner = display.newText({
		text = itemObj.place,
		x = 320,
		y =  lastY,
		font = "Lato-Regular",
		width = 300,
		fontSize = 30,
		align = "left"
	})
	txtPartner:setFillColor( 0 )
	groupInfo:insert( txtPartner )
	txtPartner.y = txtPartner.y + txtPartner.height/2
	lastY = lastY + txtPartner.height + 10
	
	local txtDate = display.newText( {
            text = getDate(itemObj.iniDate),     
            x = 320, y = lastY,
            width = 300,
            font = "Lato-Regular", fontSize = 18, align = "left"
    })
    txtDate:setFillColor( .2 )
    groupInfo:insert(txtDate)
	
	txtDate.y = txtDate.y + txtDate.height/2
	
	local txtAddress = display.newText({
		text =itemObj.address,
		x = 320,
		y =  lastY + 35,
		font = "Lato-Regular",
		width = 300,
		fontSize = 18,
		align = "left"
	})
	txtAddress:setFillColor( 0 )
	groupInfo:insert( txtAddress )
    
	txtAddress.y = txtAddress.y + txtAddress.height/2
	
	lastY = lastY + txtAddress.height
	
	bgPartnerInfo.height = txtPartner.height + txtAddress.height + txtDate.height + 60
	bgPartnerInfo.y = bgPartnerInfo.height/2 + lastY - txtPartner.height - txtDate.height - 20
	lastYImage = bgPartnerInfo.y
	lastY = lastY + 120
    
    -- Detail Event
	local bgGeneralInformacion = display.newRect( midW, lastY, 440, 76 )
	bgGeneralInformacion:setFillColor( 1 )
	groupInfo:insert(bgGeneralInformacion)
    
    local txtGeneralInformacion = display.newText({
		text = "Información Adicional:",
		x = 230, y =  lastY + 5,
		height = 20, width = 400,
		font = "Lato-Bold", fontSize = 16, align = "left"
	})
	txtGeneralInformacion:setFillColor( 0 )
	groupInfo:insert(txtGeneralInformacion)
	
	local txtInfo = display.newText({
		text = itemObj.detail,
		x = midW, y = lastY,
		width = 420,
		font = "Lato-Regular", fontSize = 16, align = "left"
	})
	txtInfo:setFillColor( 0 )
    txtInfo.y = (txtInfo.height / 2) + lastY + 30
	groupInfo:insert( txtInfo )
    
	txtInfo.height = txtInfo.height + 10
	
    bgGeneralInformacion.height = txtInfo.height + 70
    bgGeneralInformacion.y = (txtInfo.height / 2) + lastY + 10
    
    lastY = lastY + bgGeneralInformacion.height + 25
	
	local txtAdditionalInformation = display.newText({
		text = "Consultar ubicación en el mapa",
		x = 230, y = lastY,
		height = 40, width = 400,
		font = "Chivo", fontSize = 22, align = "center"
	})
    txtAdditionalInformation.itemObj = itemObj
	txtAdditionalInformation:setFillColor( .27, .5, .7 )
	txtAdditionalInformation:addEventListener( "tap", showMapa )
	groupInfo:insert( txtAdditionalInformation )
    
    local lineLink = display.newRect( 72, lastY + 15, 320, 1 )
	lineLink.anchorX = 0
	lineLink.anchorY = 0
	lineLink:setFillColor( .27, .5, .7 )
	groupInfo:insert( lineLink )
	
	local spc = display.newRect( 0, lastY + 30, 1, 1 )
    spc:setFillColor( 0 )
    groupInfo:insert( spc )
	
	srvEventos[#srvEventos]:setScrollHeight(groupInfo.height + 670)
	loadImageOfPartner()
end

------cargamos las imagen full
function loadImageFull(imageName)
     -- Determinamos si la imagen existe
    local path = system.pathForFile( imageName, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		if callbackCurrent == Globals.noCallbackGlobal then
			local imgEvent = display.newImage( imageName, system.TemporaryDirectory )
            imgEvent.x = midW
            imgEvent.y = (imgEvent.height / 2)
            srvEventos[1]:insert( imgEvent )
            groupInfo.y = imgEvent.height
		end
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImageListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
				if callbackCurrent == Globals.noCallbackGlobal then
				    event.target.x = midW
                    event.target.y = (event.target.height / 2)
                    srvEventos[1]:insert( event.target )
                    groupInfo.y = event.target.height
                else
                    event.target:removeSelf()
                    event.target = nil
				end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url.."assets/img/app/event/full/"..imageName, 
        "GET", loadImageListener, imageName, system.TemporaryDirectory ) 
    end
end

------cargamos las imagenes del partner
function loadImageOfPartner(typeImage)
	local path = system.pathForFile( itemObj.placeImage, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
			if callbackCurrent == Globals.noCallbackGlobal then
			--diferenciamos si es el logo o banner del comercio
				-- creamos la mascara
				local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
				local imgEvent = display.newImage( itemObj.placeImage, system.TemporaryDirectory )
				--cargando el logo del comercio
				imgEvent.alpha = 1
				imgEvent.x = 90
				imgEvent.y = lastYImage
				imgEvent.width = 120
				imgEvent.height = 120
				imgEvent:setMask( mask )
				groupInfo:insert( imgEvent )
			end
		
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImageOfPartnerListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
				event.target.alpha = 0
			if callbackCurrent == Globals.noCallbackGlobal then
				--diferenciamos si es el logo o banner del comercio
				-- creamos la mascara
				local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
				local imgEvent = display.newImage( itemObj.placeImage, system.TemporaryDirectory )
				--cargando el logo del comercio
				imgEvent.alpha = 1
				imgEvent.x = 90
				imgEvent.y = lastYImage
				imgEvent.width = 120
				imgEvent.height = 120
				imgEvent:setMask( mask )
				groupInfo:insert( imgEvent )
			end
            end
        end
		
		local imageUrl
		local imageName
		
			if itemObj.type == "partner" then
				imageUrl = settings.url.."assets/img/app/partner/image/"
			else
				imageUrl = settings.url.."assets/img/app/place/image/"
			end
			imageUrl = imageUrl..itemObj.placeImage
			imageName = itemObj.placeImage
        
        -- Descargamos de la nube
        display.loadRemoteImage( imageUrl, "GET", loadImageOfPartnerListener, imageName, system.TemporaryDirectory ) 
    end
end

function scene:createScene( event )
	screen = self.view
	screen:insert(homeScreen)
	
	itemObj = event.params.item
	
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
    header:buildNavBar(itemObj.name)
    hWBE = 5 + header:buildWifiBle()
	
	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
	
    settings = DBManager.getSettings()
	buildEvent(itemObj)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scene[#Globals.scene + 1] = storyboard.getCurrentSceneName()
end

-- Remove Listener
function scene:exitScene( event )
    if timeMarker then
        timer.cancel(timeMarker)
    end
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene