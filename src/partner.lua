

local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local widget = require( "widget" )
local RestManager = require('src.resources.RestManager')
local DBManager = require('src.resources.DBManager')
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local toolbar, menu
local groupMenu, groupEvent, groupMenuEventText
local  svCoupon, svInfo, svPromotions, svGallery, svMenuTxt
local h = display.topStatusBarContentHeight
local lastY = 200;
local idPartner
local settings

local info, promotions, gallery, MenuEventBar

---- grupos ----

local homeScreen = display.newGroup()

-------------------------------------------
----funciones
-------------------------------------------

function ListenerChangeMenu( event )
	
	local nextSv
	local previousSv
	
	if currentSv.name == "svInfo" then
		nextSv = svPromotions
	elseif currentSv.name == "svPromotions" then
		nextSv = svGallery
		previousSv = svInfo
	elseif currentSv.name == "svGallery" then
		previousSv = svPromotions
	end
	
	if event.phase == "began" then
		
		svMenuTxt:setScrollWidth(  480 )
		
		diferenciaX = event.x - event.target.x
		posicionMenu = groupMenuEventText.x
		a = event.x
		
    elseif event.phase == "moved" then
		if  event.direction == "left"  or event.direction == "right" then
		
		
			print(diferenciaX - event.x)
			
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
			print("hola")
			if nextSv == nil then
				transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuEventText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			else
			transition.to( currentSv, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuEventText, { x = posicionMenu - 166, time = 400, transition = easing.outExpo } )
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
				transition.to( groupMenuEventText, { x = posicionMenu + 166, time = 400, transition = easing.outExpo } )
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

function ListenerChangeScroll( event )

	local nextSv
	local previousSv
	
	if event.target.name == "svInfo" then
		nextSv = svPromotions
	elseif event.target.name == "svPromotions" then
		nextSv = svGallery
		previousSv = svInfo
	elseif event.target.name == "svGallery" then
		previousSv = svPromotions
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
			transition.to( groupMenuEventText, { x = posicionMenu - 166, time = 400, transition = easing.outExpo } )
			currentSv = nextSv
			if nextSv == nil then
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuEventText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			end
		elseif event.x  >= 380 and movimiento == "d" then
			transition.to( event.target, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenuEventText, { x = posicionMenu - 160, time = 400, transition = easing.outExpo } )
			
			transition.to( groupMenuEventText, { x = posicionMenu + 166, time = 400, transition = easing.outExpo } )
			currentSv = previousSv
			if previousSv == nil then 
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenuEventText, { x = posicionMenu, time = 400, transition = easing.outExpo } )
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

---------------------------------------------------------
---------build Partner
---------------------------------------------------------
function loadPartner(item)
	
	groupEvent = display.newGroup()
	homeScreen:insert( groupEvent )
	
	local imgBgEvent = display.newImage( "img/tmp/" .. item.banner )
	imgBgEvent.alpha = 1
	imgBgEvent.x = 240
	imgBgEvent.y = 215
	groupEvent:insert( imgBgEvent )
	
    local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
	local imgEvent = display.newImage( "img/tmp/" .. item.image )
	imgEvent.alpha = 1
	imgEvent.x = 90
	imgEvent.y = 215
	imgEvent.width = 120
	imgEvent.height = 120
    imgEvent:setMask( mask )
	groupEvent:insert( imgEvent )
	
	local txtPartner = display.newText({
		text = item.name,
		x = 320,
		y =  225,
		font = "Chivo",
		height = 100,
		width = 300,
		fontSize = 30,
		align = "left"
	})
	txtPartner:setFillColor( 1 )
	groupEvent:insert( txtPartner )
	
	local txtAddress = display.newText({
		text = item.address,
		x = 320,
		y =  265,
		font = "Chivo",
		height = 100,
		width = 300,
		fontSize = 18,
		align = "left"
	})
	txtAddress:setFillColor( 1 )
	groupEvent:insert( txtAddress )
	
	local BgMenuEvent = display.newRect( midW, 343, intW, 76 )
	BgMenuEvent:setFillColor( 217/255, 217/255, 217/255 )
	groupEvent:insert(BgMenuEvent)
	
	svMenuTxt = widget.newScrollView
	{
		x = midW,
		y = 341,
		width = intW,
		height = 73,
		listener = ListenerChangeMenu,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = true,
		backgroundColor = { 1 }
	}
	groupEvent:insert(svMenuTxt)
	
	MenuEventBar = display.newRect( midW, 378 , intW /3, 4 )
	MenuEventBar:setFillColor( 88/255, 188/255, 36/255 )
	groupEvent:insert(MenuEventBar)
	
	groupMenuEventText = display.newGroup()
	groupMenuEventText.y = 35
	svMenuTxt:insert(groupMenuEventText)
	
	txtInfo = display.newText({
		text = "Info",
		x = intW * .5,
		y =  0,
		font = "Chivo",
		fontSize = 22
	})
	txtInfo:setFillColor( 0 )
	groupMenuEventText:insert( txtInfo )
	txtInfo.name = "info"
	
	txtPromotions = display.newText({
		text = "Promociones",
		x = intW * .85,
		y =  0,
		font = "Chivo",
		fontSize = 22
	})
	txtPromotions:setFillColor( 0 )
	txtPromotions.name = "promotions"
	groupMenuEventText:insert( txtPromotions )
	
	txtGallery = display.newText({
		text = "Galeria",
		x = intW * 1.2,
		y =  0,
		font = "Chivo",
		fontSize = 22
	})
	txtGallery:setFillColor( 0 )
	txtGallery.name = "gallery"
	groupMenuEventText:insert( txtGallery )
	
	svInfo = widget.newScrollView
	{
		top = 383,
		left = 0,
		width = intW,
		height = intH,
		listener = ListenerChangeScroll,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = false,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	groupEvent:insert(svInfo)
	svInfo.name = "svInfo"
	
	svPromotions = widget.newScrollView
	{
		top = 383,
		left = intW,
		width = intW,
		height = intH,
		listener = ListenerChangeScroll,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = false,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	groupEvent:insert(svPromotions)
	svPromotions.name = "svPromotions"
	
	svGallery = widget.newScrollView
	{
		top = 383,
		left = intW,
		width = intW,
		height = intH,
		listener = ListenerChangeScroll,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = false,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	
	groupEvent:insert(svGallery)
	svGallery.name = "svGallery"
	
	currentSv = svInfo
	
	buildEventInfo(item)
	
end

function buildEventInfo(item)

	lastY = 90
	
	local bgGeneralInformacion = display.newRect( midW, 0, 480, 76 )
	bgGeneralInformacion:setFillColor( 1 )
	svInfo:insert(bgGeneralInformacion)
	
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
	svInfo:insert( txtGeneralInformacion )
	
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
	svInfo:insert( txtInfo )
	
	txtInfo.y = txtInfo.y + txtInfo.height/2
	
	bgGeneralInformacion.height = txtInfo.height + 40
	
	bgGeneralInformacion.y = bgGeneralInformacion.height/2 + 70
	
	lastY = lastY + bgGeneralInformacion.height + 85
	
	local bgLocation = display.newRect( midW, 0, intW, 76 )
	bgLocation:setFillColor( 1 )
	svInfo:insert(bgLocation)
	
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
	svInfo:insert( txtLocation )
	
	local txtAdressEvent = display.newText({
		text = item.address,
		x = 240,
		y = lastY,
		width = 420,
		font = "Chivo",
		fontSize = 18,
		align = "left"
	})
	txtAdressEvent:setFillColor( 0 )
	svInfo:insert( txtAdressEvent )
	
	txtAdressEvent.y = txtAdressEvent.y + txtAdressEvent.height/2
	
	bgLocation.height = txtAdressEvent.height + 40
	
	bgLocation.y = bgLocation.height/2  + lastY -22
	
	lastY = lastY + bgLocation.height/2  + 10
    
     -- Cocinar el mapa
    local myMap = native.newMapView( midW, lastY + 150, intW, 300 )
    if myMap then
        myMap:setCenter( tonumber(item.latitude), tonumber(item.longitude), 0.02, 0.02 )
        svInfo:insert(myMap)
        
        -- Add Maker
        timer.performWithDelay( 3000, function()
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
        svInfo:insert(bg)
    end
	
	local spc = display.newRect( 0, lastY + 750, 1, 1 )
    spc:setFillColor( .9 )
    svInfo:insert(spc)
	
	loadImagePartner(item,1)
	
end

function loadImagePartner(item,typeImage)

	local path
	if typeImage == 2 then
		path = system.pathForFile( item.image, system.TemporaryDirectory )
	else
		path = system.pathForFile( item.banner, system.TemporaryDirectory )
	end
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		
			
			--diferenciamos si es el logo o banner del comercio
			if typeImage == 2 then
				-- creamos la mascara
				local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
				local imgEvent = display.newImage( item.image, system.TemporaryDirectory )
				--cargando el logo del comercio
				imgEvent.alpha = 1
				imgEvent.x = 90
				imgEvent.y = 215
				imgEvent.width = 120
				imgEvent.height = 120
				imgEvent:setMask( mask )
				groupEvent:insert( imgEvent )
			else
				--cargando el banner del comercio
				local imgBgEvent = display.newImage( item.banner, system.TemporaryDirectory )
				imgBgEvent.alpha = 1
				imgBgEvent.x = 240
				imgBgEvent.y = 215
				groupEvent:insert( imgBgEvent )
				imgBgEvent:toBack()
				loadImagePartner(item, 2)
			end
		
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImageListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
				event.target.alpha = 0
				
				--diferenciamos si es el logo o banner del comercio
			if typeImage == 2 then
				-- creamos la mascara
				local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
				local imgEvent = display.newImage( item.image, system.TemporaryDirectory )
				--cargando el logo del comercio
				imgEvent.alpha = 1
				imgEvent.x = 90
				imgEvent.y = 215
				imgEvent.width = 120
				imgEvent.height = 120
				imgEvent:setMask( mask )
				groupEvent:insert( imgEvent )
			else
				--cargando el banner del comercio
				local imgBgEvent = display.newImage( item.banner, system.TemporaryDirectory )
				imgBgEvent.alpha = 1
				imgBgEvent.x = 240
				imgBgEvent.y = 215
				groupEvent:insert( imgBgEvent )
				imgBgEvent:toBack()
				loadImagePartner(item, 2)
			end
				
            end
        end
		
		local imageUrl
		local imageName
		
		if typeImage == 2 then
			imageUrl = settings.url.."assets/img/app/partner/image/"..item.image
			imageName = item.image
		else
			imageUrl = settings.url.."assets/img/app/partner/banner/"..item.banner
			imageName = item.banner
		end
        
        -- Descargamos de la nube
        display.loadRemoteImage( imageUrl, "GET", loadImageListener, imageName, system.TemporaryDirectory ) 
    end
end

function scene:createScene( event )
	screen = self.view
	idPartner = event.params.idPartner
	screen:insert(homeScreen)
	
	homeScreen.y = h
	
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 245/255, 245/255, 245/255 )
	homeScreen:insert(bg)
	
	toolbar = display.newRect( 0, 0, display.contentWidth, 135 )
	toolbar.anchorX = 0
	toolbar.anchorY = 0
	toolbar:setFillColor( 221/255, 236/255, 241/255 )
	homeScreen:insert(toolbar)
	
	local grupoToolbar = display.newGroup()
	grupoToolbar.y = 5
	homeScreen:insert(grupoToolbar)
	
	local logo = display.newImage( "img/btn/logo.png" )
	logo:translate( 45, 23 )
	grupoToolbar:insert(logo)
    
    local txtCancun = display.newText( {
        x = 130, y = 23,
        text = "Cancun", font = "Chivo", fontSize = 25,
	})
	txtCancun:setFillColor( .1 )
	grupoToolbar:insert(txtCancun)
	
	local btnWallet = display.newImage( "img/btn/btnMenuWallet.png" )
	btnWallet:translate( display.contentWidth - 212, 23 )
	grupoToolbar:insert(btnWallet)
	btnWallet:addEventListener( "tap", showWallet )
	
	local btnSearch = display.newImage( "img/btn/btnMenuNotification.png" )
	btnSearch:translate( display.contentWidth - 150, 25 )
	grupoToolbar:insert(btnSearch)
    -- Temporal bubble
    local notBubble = display.newCircle( display.contentWidth - 132, 10, 10 )
    notBubble:setFillColor(128,128,128)
    notBubble.strokeWidth = 2
    notBubble:setStrokeColor(.8)
	grupoToolbar:insert(notBubble)
    local txtBubble = display.newText( {
        x = display.contentWidth - 131, y = 10,
        text = "3", font = "Chivo", fontSize = 12,
	})
	txtBubble:setFillColor( .1 )
	grupoToolbar:insert(txtBubble)
	
	local btnMensaje = display.newImage( "img/btn/btnMenuSearch.png" )
	btnMensaje:translate( display.contentWidth - 95, 25 )
	grupoToolbar:insert(btnMensaje)
	
	local btnHerramienta = display.newImage( "img/btn/btnMenuUser.png" )
	btnHerramienta:translate( display.contentWidth - 35, 25 )
	grupoToolbar:insert(btnHerramienta)
	
	local menu = display.newRect( 0, 55, display.contentWidth, 75 )
	menu.anchorX = 0
	menu.anchorY = 0
	menu:setFillColor( 189/255, 203/255, 206/255 )
	homeScreen:insert(menu)
	
	groupMenu = display.newGroup()
	groupMenu.y =  60
	homeScreen:insert(groupMenu)
	
	local imgBtnBack = display.newImage( "img/btn/btnBackward.png" )
	imgBtnBack.alpha = 1
    imgBtnBack.x= 30
	imgBtnBack.y = 30
    imgBtnBack.width = 30
    imgBtnBack.height  = 50
    groupMenu:insert( imgBtnBack )
	imgBtnBack:addEventListener( "tap", returnHome )
	
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	settings = DBManager.getSettings()
	RestManager.getPartner(idPartner)
end

-- Remove Listener
function scene:exitScene( event )
	
   --[[ if storeBar then
        storeBar:removeSelf()
        storeBar = nil
    end]]
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene