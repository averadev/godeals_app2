
require('src.Header')
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local toolbar, menu
local groupMenu, groupPartner, groupMenuPartnerText
local  svCoupon, svMenuTxt
local h = display.topStatusBarContentHeight
local lastY = 200
local lastYImage
local idPartner
local settings
local timeMarker

local info, promotions, gallery, MenuPartnerBar

local callbackCurrent = 0

-- tablas

local srvPartner = {}
local txtMenuPartner = {}
local imagePartnerDeals = {}
local imagePartnerGallery = {}
local itemGallery = {}
local itemPartner = {}

---- grupos ----

local homeScreen = display.newGroup()


--------listener scroll

function ListenerChangeMenuPartner( event )
	
	local positionScroll
	local nextSv
	local previousSv
	
	positionScroll = currentSv.name
	
	if positionScroll ~= nil then
		if positionScroll == 1 then
			nextSv = srvPartner[2]
		elseif positionScroll == #srvPartner then
			previousSv = srvPartner[positionScroll - 1]
		else
			nextSv = srvPartner[positionScroll + 1]
			previousSv = srvPartner[positionScroll - 1]
		end
	end
	
	if event.phase == "began" then
		
		svMenuTxt:setScrollWidth(  480 )
		
		diferenciaX = event.x - event.target.x
		posicionMenu = groupMenuPartnerText.x
		
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
			
			groupMenuPartnerText.x = (( posicionNueva - 240) / 3) + posicionMenu
			
		end
		
    elseif event.phase == "ended" or event.phase == "cancelled" then
		if diferenciaX - event.x >= -100 then
			
			if nextSv == nil then
				transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuPartnerText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			else
			transition.to( currentSv, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuPartnerText, { x = posicionMenu - 166, time = 400, transition = easing.outExpo } )
			currentSv = nextSv
			end
		elseif diferenciaX - event.x  <= -380 then
			
			if previousSv == nil then 
				transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuPartnerText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			else
				transition.to( currentSv, { x = 720, time = 400, transition = easing.outExpo } )
				transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
				transition.to( previousSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuPartnerText, { x = posicionMenu + 166, time = 400, transition = easing.outExpo } )
				currentSv = previousSv
			end
		else
			transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuPartnerText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
		end
		
    end
	
end

function ListenerChangeScrollPartner( event )

	local positionScroll 
	local nextSv
	local previousSv
	
	positionScroll = event.target.name
	
	if positionScroll ~= nil then
			
		if positionScroll == 1 then
			nextSv = srvPartner[2]
		elseif positionScroll == #srvPartner then
			previousSv = srvPartner[positionScroll - 1]
		else
			nextSv = srvPartner[positionScroll + 1]
			previousSv = srvPartner[positionScroll - 1]
		end
		
	end
	
	if event.phase == "began" then
		diferenciaX = event.x - event.target.x
		posicionMenu = groupMenuPartnerText.x
    elseif event.phase == "moved" then
		if  event.direction == "left"  or event.direction == "right" then
			posicionNueva = event.x-diferenciaX
			
			event.target.x = posicionNueva
			
			groupMenuPartnerText.x = (( posicionNueva - 240) / 3) + posicionMenu
			
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
			transition.to( groupMenuPartnerText, { x = posicionMenu - 166, time = 400, transition = easing.outExpo } )
			currentSv = nextSv
			if nextSv == nil then
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuPartnerText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			end
		elseif event.x  >= 380 and movimiento == "d" then
			transition.to( event.target, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuPartnerText, { x = posicionMenu - 160, time = 400, transition = easing.outExpo } )
			
			transition.to( groupMenuPartnerText, { x = posicionMenu + 166, time = 400, transition = easing.outExpo } )
			currentSv = previousSv
			if previousSv == nil then 
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuPartnerText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			end
		else
			transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuPartnerText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			currentSv = event.target
		end
		
    end
	
end

---------------------------------------------------------
---------build Partner
---------------------------------------------------------
function loadPartner(item)
	
	itemPartner = item
	
	groupPartner = display.newGroup()
	homeScreen:insert( groupPartner )
	
	local imgBgPartner = display.newRect( midW, 170, intW, 76 )
	imgBgPartner:setFillColor( 217/255, 217/255, 217/255 )
	groupPartner:insert(imgBgPartner)
	
	svMenuTxt = widget.newScrollView
	{
		x = midW,
		y = 168,
		width = intW,
		height = 73,
		listener = ListenerChangeMenuPartner,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	groupPartner:insert(svMenuTxt)
	
	MenuPartnerBar = display.newRect( midW, 205 , intW /3, 4 )
	MenuPartnerBar:setFillColor( 88/255, 188/255, 36/255 )
	groupPartner:insert(MenuPartnerBar)
	
	groupMenuPartnerText = display.newGroup()
	groupMenuPartnerText.y = 35
	svMenuTxt:insert(groupMenuPartnerText)
	
	createScrollViewPartner("Info")
	
	srvPartner[#srvPartner]:setIsLocked( true, "horizontal" )
	svMenuTxt:setIsLocked( true, "horizontal" )
	
	currentSv = srvPartner[#srvPartner]
	
	if callbackCurrent == Globals.noCallbackGlobal then
		buildPartnerInfo(item)
	end
	
end

function buildPartnerInfo(item)

	lastY = 80

	local bgPartnerInfo = display.newRect( midW, 0, 480, 76 )
	bgPartnerInfo:setFillColor( 1 )
	srvPartner[#srvPartner]:insert(bgPartnerInfo)

	local txtPartner = display.newText({
		text = item.name,
		x = 320,
		y =  lastY,
		font = "Chivo",
		width = 300,
		fontSize = 30,
		align = "left"
	})
	txtPartner:setFillColor( 0 )
	srvPartner[#srvPartner]:insert( txtPartner )
	
	txtPartner.y = txtPartner.y + txtPartner.height/2
	lastY = lastY + txtPartner.height + 10
	
	local txtAddress = display.newText({
		text = item.address,
		x = 320,
		y =  lastY,
		font = "Chivo",
		width = 300,
		fontSize = 18,
		align = "left"
	})
	txtAddress:setFillColor( 0 )
	srvPartner[#srvPartner]:insert( txtAddress )
	
	txtAddress.y = txtAddress.y + txtAddress.height/2
	
	bgPartnerInfo.height = txtPartner.height + txtAddress.height + 40
	
	bgPartnerInfo.y = bgPartnerInfo.height/2 + lastY - txtPartner.height - 20
	
	lastYImage = bgPartnerInfo.y
	
	lastY = lastY + 150
	
	local bgGeneralInformacion = display.newRect( midW, 0, 480, 76 )
	bgGeneralInformacion:setFillColor( 1 )
	srvPartner[#srvPartner]:insert(bgGeneralInformacion)
	
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
	srvPartner[#srvPartner]:insert( txtGeneralInformacion )
	
	local txtInfo = display.newText({
		text = item.info,
		x = 240,
		y = lastY,
		width = 420,
		font = "Chivo",
		fontSize = 18,
		align = "left"
	})
	txtInfo:setFillColor( 0 )
	srvPartner[#srvPartner]:insert( txtInfo )
	
	txtInfo.y = txtInfo.y + txtInfo.height/2
	
	bgGeneralInformacion.height = txtInfo.height + 40
	
	bgGeneralInformacion.y = bgGeneralInformacion.height/2 + lastY - 15
	
	lastY = lastY + bgGeneralInformacion.height + 85
	
	local bgLocation = display.newRect( midW, 0, intW, 76 )
	bgLocation:setFillColor( 1 )
	srvPartner[#srvPartner]:insert(bgLocation)
	
	local txtLocation = display.newText({
		text = "Ubicación",
		x = 240,
		y = lastY - 50,
		width = 420,
		font = "Chivo",
		fontSize = 22,
		align = "left"
	})
	txtLocation:setFillColor( 0 )
	srvPartner[#srvPartner]:insert( txtLocation )
	
	local txtAdressPartner = display.newText({
		text = item.address,
		x = 240,
		y = lastY,
		width = 420,
		font = "Chivo",
		fontSize = 18,
		align = "left"
	})
	txtAdressPartner:setFillColor( 0 )
	srvPartner[#srvPartner]:insert( txtAdressPartner )
	
	txtAdressPartner.y = txtAdressPartner.y + txtAdressPartner.height/2
	
	bgLocation.height = txtAdressPartner.height + 40
	
	bgLocation.y = bgLocation.height/2  + lastY -22
	
	lastY = lastY + bgLocation.height/2  + 10
    
     -- Cocinar el mapa
    local myMap = native.newMapView( midW, lastY + 150, intW, 300 )
    if myMap then
        myMap:setCenter( tonumber(item.latitude), tonumber(item.longitude), 0.02, 0.02 )
        srvPartner[#srvPartner]:insert(myMap)
        
        -- Add Maker
        timeMarker = timer.performWithDelay( 3000, function()
            local options = { 
                title = item.name, 
                subtitle = item.address, 
                listener = markerListener, 
                imageFile = "img/btn/btnIconMap.png"
            }
            
            myMap:addMarker( tonumber(item.latitude), tonumber(item.longitude), options )
        end, 1 )
    else
        local bg = display.newRect( midW, lastY + 150, intW, 300 )
        bg:setFillColor( .7 )
        srvPartner[#srvPartner]:insert(bg)
    end
	
	local spc = display.newRect( 0, lastY + 750, 1, 1 )
    spc:setFillColor( .9 )
    srvPartner[#srvPartner]:insert(spc)
	
	if callbackCurrent == Globals.noCallbackGlobal then
		RestManager.getDealsByPartner(idPartner,"partner")
	end
	
	loadImagePartner()
	
	lastY = lastY + 600
	
	srvPartner[1]:setScrollHeight( lastY )
	
end

--mostramos los deals del comercio
function buildPartnerPromociones(items)

	if #items > 0 then
	
	srvPartner[1]:setIsLocked( false, "horizontal" )
	svMenuTxt:setIsLocked( false, "horizontal" )
	
	createScrollViewPartner("Promociones")
	
		lastY = 25
	
		for y = 1, #items, 1 do 
            -- Create container
			
			imagePartnerDeals[y] = display.newImage( items[y].image, system.TemporaryDirectory )
			imagePartnerDeals[y].alpha = 1
			
            local deal = Deal:new()
            srvPartner[#srvPartner]:insert(deal)
            deal:build(items[y], imagePartnerDeals[y])
            deal.y = lastY
			lastY = lastY + 102
        end
	
	end
	
	--llamamos a la galeria
	RestManager.getGallery(idPartner,1,"partner")
	
end

--mostramos la galeria
function buildPartnerGaleria(items)
	
		lastY = 75
	
		srvPartner[1]:setIsLocked( false, "horizontal" )
		svMenuTxt:setIsLocked( false, "horizontal" )
	
		createScrollViewPartner("Galeria")
	
		for y = 1, #items, 1 do 
            -- Create container
			
			imagePartnerGallery[y] = display.newImage( items[y].image, system.TemporaryDirectory )
			imagePartnerGallery[y].alpha = 1
			
            local gallery = Gallery:new()
            srvPartner[#srvPartner]:insert(gallery)
            gallery:build(items[y], imagePartnerGallery[y])
            gallery.y = lastY
			lastY = lastY + 210
        end
		
		srvPartner[#srvPartner]:setScrollHeight(lastY)

end

--llamas al metodo para cargar las imagenes
function GalleryPartner(items)
	if #items > 0 then
		loadGalleryPartner(items,1)
	end
	
	--cargamos la imagen del partner del encabezado
	--loadImagePartner( 1 )
end

--creamos los crollview dinamicos

function createScrollViewPartner(nameTxt)
	
	local positionCurrent = #srvPartner + 1

	local positionTxtMenu = midW + (#srvPartner * 166)

	txtMenuPartner[positionCurrent] = display.newText({
			text = nameTxt,
			x = positionTxtMenu,
			y =  0,
			font = "Chivo",
			fontSize = 22
	})
	txtMenuPartner[positionCurrent]:setFillColor( 0 )
	groupMenuPartnerText:insert( txtMenuPartner[positionCurrent] )
	txtMenuPartner[positionCurrent].name = positionCurrent
	
	local positionScrollPartner
	if #srvPartner == 0 then
		positionScrollPartner = 0
	else
		positionScrollPartner = intW
	end
	
	srvPartner[positionCurrent] = widget.newScrollView
	{
		top = 210,
		left = positionScrollPartner,
		width = intW,
		height = intH,
		listener = ListenerChangeScrollPartner,
		horizontalScrollDisabled = false,
		verticalScrollDisabled = false,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	groupPartner:insert(srvPartner[positionCurrent])
	srvPartner[positionCurrent].name = positionCurrent
	
end

function loadImagePartner()

	local path
		path = system.pathForFile( itemPartner.image, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		
			--diferenciamos si es el logo o banner del comercio
			if callbackCurrent == Globals.noCallbackGlobal then
					-- creamos la mascara
					local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
					local imgPartner = display.newImage( itemPartner.image, system.TemporaryDirectory )
					--cargando el logo del comercio
					imgPartner.alpha = 1
					imgPartner.x = 90
					imgPartner.y = lastYImage
					imgPartner.width = 120
					imgPartner.height = 120
					imgPartner:setMask( mask )
					srvPartner[1]:insert( imgPartner )
			end
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImagePartnerListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
				event.target.alpha = 0
				
				--diferenciamos si es el logo o banner del comercio
				if callbackCurrent == Globals.noCallbackGlobal then
					-- creamos la mascara
					local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
					local imgPartner = display.newImage( itemPartner.image, system.TemporaryDirectory )
					--cargando el logo del comercio
					imgPartner.alpha = 1
					imgPartner.x = 90
					imgPartner.y = lastYImage
					imgPartner.width = 120
					imgPartner.height = 120
					imgPartner:setMask( mask )
					srvPartner[1]:insert( imgPartner )
				end
            end
        end
		
		local imageUrl
		local imageName
			imageUrl = settings.url.."assets/img/app/partner/image/"..itemPartner.image
			imageName = itemPartner.image
        
        -- Descargamos de la nube
        display.loadRemoteImage( imageUrl, "GET", loadImagePartnerListener, imageName, system.TemporaryDirectory ) 
    end
end

function loadGalleryPartner(items,posc)    
    -- Determinamos si la imagen existe
    local path = system.pathForFile( items[posc].image, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
        --[[imageItems[obj.posc] = display.newImage( elements[obj.posc].image, system.TemporaryDirectory )
        imageItems[obj.posc].alpha = 0]]
		if callbackCurrent == Globals.noCallbackGlobal then
			if posc < #items then
				loadGalleryPartner(items,posc+1)
			else
				buildPartnerGaleria(items)
			end
		end
    else
        -- Listener de la carga de la imagen del servidor
        local function loadGalleryPartnerListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
                event.target.alpha = 0
               -- imageItems[obj.posc] = event.target
				if callbackCurrent == Globals.noCallbackGlobal then
			   
					if posc < #items then
						loadGalleryPartner(items,posc+1)
					else
						buildPartnerGaleria(items)
					end
				end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url.."assets/img/app/partner/gallery/"..items[posc].image, 
        "GET", loadGalleryPartnerListener, items[posc].image, system.TemporaryDirectory ) 
    end
end

function scene:createScene( event )
	screen = self.view
	idPartner = event.params.idPartner
	screen:insert(homeScreen)
	
	homeScreen.y = h
	
	local bg = display.newRect( 0, h, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 245/255, 245/255, 245/255 )
	homeScreen:insert(bg)
	
	-- Build Component Header
	local header = Header:new()
    homeScreen:insert(header)
    header:buildToolbar()
    header:buildNavBar()
	
	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scene[#Globals.scene + 1] = storyboard.getCurrentSceneName()
	settings = DBManager.getSettings()
	RestManager.getPartner(idPartner)
end

-- Remove Listener
function scene:exitScene( event )
    if timeMarker then
        timer.cancel(timeMarker)
        print("cancel Marker")
    end
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene