---------------------------------------------------------------------------------
-- Godeals App
-- Alfredo Chi
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- REQUIRE & VARIABLES
---------------------------------------------------------------------------------

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
local groupMenu, groupEvent, groupMenuEventText
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
	storyboard.gotoScene( "src.Mapa", {
		time = 400,
		effect = "crossFade",
		params = { itemObj = itemObj }
	})
end

function ListenerChangeMenuEvent( event )
	
	local positionScroll
	local nextSv
	local previousSv
	
	positionScroll = currentSv.name
	
	if positionScroll ~= nil then
		if positionScroll == 1 then
			nextSv = srvEventos[2]
		elseif positionScroll == #srvEventos then
			previousSv = srvEventos[positionScroll - 1]
		else
			nextSv = srvEventos[positionScroll + 1]
			previousSv = srvEventos[positionScroll - 1]
		end
	end
	
	if event.phase == "began" then
		svMenuTxt:setScrollWidth(  480 )
		diferenciaX = event.x - event.target.x
		posicionMenu = groupMenuEventText.x
		
    elseif event.phase == "moved" then
	
		if  event.direction == "left"  or event.direction == "right" then
			
			posicionNueva = event.x-diferenciaX 
			
			posicionNueva2 = ( (posicionNueva - 240) / .5 )
			
			currentSv.x = ((posicionNueva - 240) / .7 ) + posicionNueva
			
			if nextSv ~= nil then
				nextSv.x = 480 + ((posicionNueva - 240) / .7 ) + posicionNueva
			end
			
			if previousSv ~= nil then
				previousSv.x = -480 + ((posicionNueva - 240) / .7 ) + posicionNueva
			end
			
			groupMenuEventText.x = (( posicionNueva - 240) / 3) + posicionMenu
			
		end
		
    elseif event.phase == "ended" or event.phase == "cancelled" then
		if diferenciaX - event.x >= -100 then
			if nextSv == nil then
				transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuEventText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			else
			transition.to( currentSv, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuEventText, { x = posicionMenu - 168, time = 400, transition = easing.outExpo } )
			currentSv = nextSv
			end
		elseif diferenciaX - event.x  <= -380 then
			
			if previousSv == nil then 
				transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuEventText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			else
				transition.to( currentSv, { x = 720, time = 400, transition = easing.outExpo } )
				transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
				transition.to( previousSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuEventText, { x = posicionMenu + 168, time = 400, transition = easing.outExpo } )
				currentSv = previousSv
			end
		else
			transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuEventText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
		end
		
    end
	
end

function ListenerChangeScrollEvent( event )

	local positionScroll 
	local nextSv
	local previousSv
	
	positionScroll = event.target.name
	
		if positionScroll ~= nil then
		
			--[[nextSv = srvEventos[positionScroll + 1]
			previousSv = srvEventos[positionScroll - 1]]
			
			if positionScroll == 1 then
				nextSv = srvEventos[2]
			elseif positionScroll == #srvEventos then
				previousSv = srvEventos[positionScroll - 1]
			else
				nextSv = srvEventos[positionScroll + 1]
				previousSv = srvEventos[positionScroll - 1]
			end
		end
	
	if event.phase == "began" then
		
		diferenciaX = event.x - event.target.x
		posicionMenu = groupMenuEventText.x
		
    elseif event.phase == "moved" then
		if  event.direction == "left"  or event.direction == "right" then
			posicionNueva = event.x-diferenciaX
			
			event.target.x = posicionNueva
			
			groupMenuEventText.x = (( posicionNueva - 240) / 3) + posicionMenu
			
			if nextSv ~= nil then
				nextSv.x = 480+posicionNueva
			end
			
			if previousSv ~= nil then
				previousSv.x = -480+posicionNueva
			end
			
		end
		
		movimiento = "c"
		if(event.direction == "left") then
			movimiento = "i"
		elseif event.direction == "right" then
			movimiento = "d"
		end
		
    elseif event.phase == "ended" or event.phase == "cancelled" then
		if event.x <= 100 and movimiento == "i" then
			transition.to( event.target, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuEventText, { x = posicionMenu - 168, time = 400, transition = easing.outExpo } )
			currentSv = nextSv
			if nextSv == nil then
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuEventText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
				currentSv = event.target
			end
		elseif event.x  >= 380 and movimiento == "d" then
			transition.to( event.target, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuEventText, { x = posicionMenu - 160, time = 400, transition = easing.outExpo } )
			
			transition.to( groupMenuEventText, { x = posicionMenu + 168, time = 400, transition = easing.outExpo } )
			currentSv = previousSv
			if previousSv == nil then 
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuEventText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
				currentSv = event.target
			end
		else
			transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuEventText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			currentSv = event.target
		end
		
    end
	
	
end

--creamos el evento
function buildEvent(item)

	groupEvent = display.newGroup()
	groupEvent.y = h
	homeScreen:insert( groupEvent )
	
	local BgMenuEvent = display.newRect( midW, 170, intW, 76 )
	BgMenuEvent:setFillColor( 217/255, 217/255, 217/255 )
	groupEvent:insert(BgMenuEvent)
	
	svMenuTxt = widget.newScrollView
	{
		x = midW,
		y = 168,
		width = intW,
		height = 73,
		listener = ListenerChangeMenuEvent,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	groupEvent:insert(svMenuTxt)
	
	MenuEventBar = display.newRect( midW, 205 , intW /3, 4 )
	MenuEventBar:setFillColor( 88/255, 188/255, 36/255 )
	groupEvent:insert(MenuEventBar)
	
	groupMenuEventText = display.newGroup()
	groupMenuEventText.y = 35
	svMenuTxt:insert(groupMenuEventText)
		
	createScrollViewEvent("Info")
	
	srvEventos[#srvEventos]:setIsLocked( true, "horizontal" )
	svMenuTxt:setIsLocked( true, "horizontal" )
	
	currentSv = srvEventos[1]
	
	if callbackCurrent == Globals.noCallbackGlobal then
		buildEventInfo(item)
	end
	
end

--creamos la primera seccion del evento
function buildEventInfo(item)

	lastY = 40
	
	local imgEvent = display.newImage(  "img/tmp/" .. itemObj.imageFull )
	imgEvent.x = midW
	srvEventos[1]:insert( imgEvent )
    
    imgEvent.y = lastY + (imgEvent.height / 2)
    
	lastY = lastY + imgEvent.height + 75
	
	local bgPartnerInfo = display.newRect( midW, 0, 480, 76 )
	bgPartnerInfo:setFillColor( 1 )
	srvEventos[1]:insert(bgPartnerInfo)
	
	local txtPartner = display.newText({
		text = itemObj.place,
		x = 320,
		y =  lastY,
		font = "Chivo",
		width = 300,
		fontSize = 30,
		align = "left"
	})
	txtPartner:setFillColor( 0 )
	srvEventos[1]:insert( txtPartner )
	
	txtPartner.y = txtPartner.y + txtPartner.height/2
	
	lastY = lastY + txtPartner.height + 10
	
	local txtAddress = display.newText({
		text =itemObj.address,
		x = 320,
		y =  lastY,
		font = "Chivo",
		width = 300,
		fontSize = 18,
		align = "left"
	})
	txtAddress:setFillColor( 0 )
	srvEventos[1]:insert( txtAddress )
	
	txtAddress.y = txtAddress.y + txtAddress.height/2
	
	bgPartnerInfo.height = txtPartner.height + txtAddress.height + 40
	
	bgPartnerInfo.y = bgPartnerInfo.height/2 + lastY - txtPartner.height - 20
	
	lastYImage = bgPartnerInfo.y
	
	lastY = lastY + 150
	
	local bgGeneralInformacion = display.newRect( midW, 0, 480, 76 )
	bgGeneralInformacion:setFillColor( 1 )
	srvEventos[1]:insert(bgGeneralInformacion)
	
	local txtGeneralInformacion = display.newText({
		text = "Informacion general",
		x = 240,
		y = lastY - 40,
		width = 420,
		font = "Chivo",
		fontSize = 22,
		align = "left"
	})
	txtGeneralInformacion:setFillColor( 0 )
	srvEventos[1]:insert( txtGeneralInformacion )
	
	local txtInfo = display.newText({
		text = itemObj.detail,
		x = 240,
		y = lastY,
		width = 420,
		font = "Chivo",
		fontSize = 18,
		align = "left"
	})
	txtInfo:setFillColor( 0 )
	srvEventos[1]:insert( txtInfo )
	
	txtInfo.y = txtInfo.y + txtInfo.height/2
	
	bgGeneralInformacion.height = txtInfo.height + 40
	
	bgGeneralInformacion.y = bgGeneralInformacion.height/2 + lastY - 15
	
	lastY = lastY + bgGeneralInformacion.height + 30
	
	local txtAdditionalInformation = display.newText({
		text = "Consultar ubicación del evento",
		x = 230, y = lastY,
		height = 40, width = 400,
		font = "Chivo", fontSize = 22, align = "center"
	})
    txtAdditionalInformation.itemObj = itemObj
	txtAdditionalInformation:setFillColor( 0 )
	srvEventos[1]:insert( txtAdditionalInformation )
	txtAdditionalInformation:addEventListener( "tap", showMapa )
    
    local lineLink = display.newRect( 50, lastY + 15, 360, 1 )
	lineLink.anchorX = 0
	lineLink.anchorY = 0
	lineLink:setFillColor( .2 )
	srvEventos[1]:insert( lineLink )
    
    local spc = display.newRect( 0, lastY + 500, 1, 1 )
    spc:setFillColor( .9 )
    srvEventos[1]:insert(spc)
	
	lastY = lastY + 280
	
	--decidimos si el evento es por un comercio o por un lugar
	if callbackCurrent == Globals.noCallbackGlobal then
		if itemObj.type == "partner" then
			RestManager.getDealsByPartner(itemObj.typeId,"event")
		else
			RestManager.getGallery(itemObj.typeId,2,"event")
		end
	end
	
	loadImageOfPartner()
	
	--lastY = lastY + 300
	
	srvEventos[#srvEventos]:setScrollHeight(lastY)
	
end

--mostramos los deals del comercio
function buildEventPromociones(items)

	if #items > 0 then
	
	srvEventos[1]:setIsLocked( false, "horizontal" )
	svMenuTxt:setIsLocked( false, "horizontal" )
	
	createScrollViewEvent("promociones")
	
		lastY = 25
	
		for y = 1, #items, 1 do 
            -- Create container
			
			imageEventDeals[y] = display.newImage( items[y].image, system.TemporaryDirectory )
			imageEventDeals[y].alpha = 1
			
            local deal = Deal:new()
            srvEventos[#srvEventos]:insert(deal)
            deal:build(items[y], imageEventDeals[y])
            deal.y = lastY
			lastY = lastY + 102
        end
	
	end
	
	--llamamos a la galeria
	RestManager.getGallery(itemObj.typeId,1,"event")
	
end

--mostramos la galeria
function buildEventGaleria(items)
	
		lastY = 75
	
		srvEventos[1]:setIsLocked( false, "horizontal" )
		svMenuTxt:setIsLocked( false, "horizontal" )
	
		createScrollViewEvent("Galeria")
	
		for y = 1, #items, 1 do 
            -- Create container
			
			imageEventGallery[y] = display.newImage( items[y].image, system.TemporaryDirectory )
			imageEventGallery[y].alpha = 1
			
            local gallery = Gallery:new()
            srvEventos[#srvEventos]:insert(gallery)
            gallery:build(items[y], imageEventGallery[y])
            gallery.y = lastY
			lastY = lastY + 210
        end
		
		srvEventos[#srvEventos]:setScrollHeight(lastY)

end

--llamas al metodo para cargar las imagenes
function GalleryEvent(items)
	if #items > 0 then
		loadGalleryEvent(items,1)
	end
	
	--cargamos la imagen del partner del encabezado
	--loadImageOfPartner(1)
end

--creamos los crollview dinamicos

function createScrollViewEvent(nameTxt)
	
	local positionCurrent = #srvEventos + 1

    local positionTxtMenu = midW + (#srvEventos * 166)

	txtMenuEvent[positionCurrent] = display.newText({
			text = nameTxt,
			x = positionTxtMenu,
			y =  0,
			font = "Chivo",
			fontSize = 22
	})
	txtMenuEvent[positionCurrent]:setFillColor( 0 )
	groupMenuEventText:insert( txtMenuEvent[positionCurrent] )
	txtMenuEvent[positionCurrent].name = positionCurrent
	
	local positionScrollEvent
	if #srvEventos == 0 then
		positionScrollEvent = 0
	else
		positionScrollEvent = intW
	end
	
	srvEventos[positionCurrent] = widget.newScrollView
	{
		top = 210,
		left = positionScrollEvent,
		width = intW,
		height = intH,
		listener = ListenerChangeScrollEvent,
		horizontalScrollDisabled = false,
		verticalScrollDisabled = false,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	groupEvent:insert(srvEventos[positionCurrent])
	srvEventos[positionCurrent].name = positionCurrent
	
end

------cargamos las imagenes del partner

function loadImageOfPartner(typeImage)

	local path
		path = system.pathForFile( itemObj.placeImage, system.TemporaryDirectory )
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
				srvEventos[1]:insert( imgEvent )
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
				srvEventos[1]:insert( imgEvent )
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

function loadGalleryEvent(items,posc)    
    -- Determinamos si la imagen existe
    local path = system.pathForFile( items[posc].image, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
        --[[imageItems[obj.posc] = display.newImage( elements[obj.posc].image, system.TemporaryDirectory )
        imageItems[obj.posc].alpha = 0]]
		if callbackCurrent == Globals.noCallbackGlobal then
			if posc < #items then
				loadGalleryEvent(items,posc+1)
			else
				buildEventGaleria(items)
			end
		end
    else
        -- Listener de la carga de la imagen del servidor
        local function loadGalleryEventListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
                event.target.alpha = 0
				if callbackCurrent == Globals.noCallbackGlobal then
					-- imageItems[obj.posc] = event.target
					if posc < #items then
						loadGalleryEvent(items,posc+1)
					else
						buildEventGaleria(items)
					end
				end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url.."assets/img/app/partner/gallery/"..items[posc].image, 
        "GET", loadGalleryEventListener, items[posc].image, system.TemporaryDirectory ) 
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
    header:buildNavBar(itemObj.name, itemObj.id)
	
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