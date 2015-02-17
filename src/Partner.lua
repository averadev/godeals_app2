
require('src.Menu')
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


function showMapa( event )
    storyboard.removeScene( "src.Mapa" )
	storyboard.gotoScene( "src.Mapa", {
		time = 400,
		effect = "crossFade",
		params = { itemObj = itemPartner }
	})
end

--obtenemos el grupo homeScreen de la escena actual
function getSceneSearchP( event )
	--modalSeach(txtSearch.text)
	SearchText(homeScreen)
	return true
end

--obtenemos el homeScreen de la escena
function getScreenP()
	return homeScreen
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
		y = 163,
		width = intW,
		height = 73,
		listener = ListenerChangeMenuPartner,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	groupPartner:insert(svMenuTxt)
	
	MenuPartnerBar = display.newRect( midW, 198 , intW /3, 4 )
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

	lastY = 35
	
	lastYImage = 166/2

	local txtPartner = display.newText({
		text = item.name,
		x = 320,
		y =  lastY,
		font = "Lato-Regular",
		width = 300,
		fontSize = 30,
		align = "left"
	})
	txtPartner:setFillColor( 1 )
	srvPartner[#srvPartner]:insert( txtPartner )
	
	txtPartner.y = txtPartner.y + txtPartner.height/2
	lastY = lastY + txtPartner.height + 10
	
	local btnPartner = display.newImage( "img/btn/btnPartner.png" )
	btnPartner.x= 430
	btnPartner.y = lastY
    btnPartner:addEventListener( "tap", showMapa )
    srvPartner[#srvPartner]:insert( btnPartner )
	
	local txtAddress = display.newText({
		text = item.address,
		x = 320,
		y =  lastY,
		font = "Lato-Regular",
		width = 300,
		fontSize = 18,
		align = "left"
	})
	txtAddress:setFillColor( 1 )
	srvPartner[#srvPartner]:insert( txtAddress )
	
	txtAddress.y = txtAddress.y + txtAddress.height/2
	
	lastY = lastY + 150
	
	-- Detail Event
	local bgGeneralInformacion = display.newRect( midW, lastY, 440, 76 )
	bgGeneralInformacion:setFillColor( 1 )
	srvPartner[#srvPartner]:insert(bgGeneralInformacion)
    
    local txtGeneralInformacion = display.newText({
		text = "Informacion Adicional:",
		x = 230, y =  lastY + 5,
		height = 20, width = 400,
		font = "Lato-Bold", fontSize = 16, align = "left"
	})
	txtGeneralInformacion:setFillColor( 0 )
	srvPartner[#srvPartner]:insert(txtGeneralInformacion)
	
	local txtInfo = display.newText({
		text = item.info,
		x = midW, y = lastY,
		width = 420,
		font = "Lato-Regular", fontSize = 16, align = "left"
	})
	txtInfo:setFillColor( 0 )
    txtInfo.y = (txtInfo.height / 2) + lastY + 30
	srvPartner[#srvPartner]:insert( txtInfo )
    
    bgGeneralInformacion.height = txtInfo.height + 70
    bgGeneralInformacion.y = (txtInfo.height / 2) + lastY + 10
    
    lastY = lastY + bgGeneralInformacion.height + 25
	local spc = display.newRect( 0, lastY, 1, 1 )
    spc:setFillColor( 0 )
    srvPartner[#srvPartner]:insert( spc )
	
	if callbackCurrent == Globals.noCallbackGlobal then
		RestManager.getDealsByPartner(idPartner,"partner")
	end
	
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
            deal:build(true, items[y], imagePartnerDeals[y])
            deal.y = lastY
			lastY = lastY + 120
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
	loadImagePartner( 1 )
end

--creamos los crollview dinamicos

function createScrollViewPartner(nameTxt)
	
	local positionCurrent = #srvPartner + 1

	local positionTxtMenu = midW + (#srvPartner * 166)

	txtMenuPartner[positionCurrent] = display.newText({
			text = nameTxt,
			x = positionTxtMenu,
			y =  0,
			font = "Lato-Regular",
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
		top = 200,
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

function loadImagePartner(typeImage)

	local path
	if typeImage == 2 then
		path = system.pathForFile( itemPartner.image, system.TemporaryDirectory )
	else
		path = system.pathForFile( itemPartner.banner, system.TemporaryDirectory )
	end
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		
			--diferenciamos si es el logo o banner del comercio
			if callbackCurrent == Globals.noCallbackGlobal then
				if typeImage == 2 then
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
				else
					--cargando el banner del comercio
					local imgBgPartner = display.newImage( itemPartner.banner, system.TemporaryDirectory )
					imgBgPartner.alpha = 1
					imgBgPartner.x = 240
					imgBgPartner.y = lastYImage
					imgBgPartner.height = 165
					srvPartner[1]:insert( imgBgPartner )
					imgBgPartner:toBack()
					loadImagePartner( 2 )
				end
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
				if typeImage == 2 then
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
				else
					--cargando el banner del comercio
					local imgBgPartner = display.newImage( itemPartner.banner, system.TemporaryDirectory )
					imgBgPartner.alpha = 1
					imgBgPartner.x = 240
					imgBgPartner.y = lastYImage
					imgBgPartner.height = 165
					srvPartner[1]:insert( imgBgPartner )
					imgBgPartner:toBack()
					loadImagePartner( 2 )
				end
			end
            end
        end
		
		local imageUrl
		local imageName
		
		if typeImage == 2 then
			imageUrl = settings.url.."assets/img/app/partner/image/"..itemPartner.image
			imageName = itemPartner.image
		else
			imageUrl = settings.url.."assets/img/app/partner/banner/"..itemPartner.banner
			imageName = itemPartner.banner
		end
        
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
     
    local title = ''
    if event.params.name then title = event.params.name end
	
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
    header:buildNavBar(title)
	
	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
	
    settings = DBManager.getSettings()
	RestManager.getPartner(idPartner)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scene[#Globals.scene + 1] = storyboard.getCurrentSceneName()
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