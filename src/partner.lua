

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
local  svCoupon, svInfo, svPromotions, svGallery
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

function tapMenuEvent( event )

	if event.target.name == "info" then
		transition.to( MenuEventBar, { x = (intW /3)/2, time = 400, transition = easing.outExpo } )
		transition.to( svInfo, { x = 240, time = 400, transition = easing.outExpo } )
		transition.to( svPromotions, { x = 720, time = 400, transition = easing.outExpo } )
		transition.to( svGallery, { x = 720, time = 400, transition = easing.outExpo } )
	elseif event.target.name == "promotions" then
		transition.to( MenuEventBar, { x = midW, time = 400, transition = easing.outExpo } )
		transition.to( svInfo, { x = -240, time = 400, transition = easing.outExpo } )
		transition.to( svPromotions, { x = 240, time = 400, transition = easing.outExpo } )
		transition.to( svGallery, { x = 720, time = 400, transition = easing.outExpo } )
	elseif event.target.name == "gallery" then
		transition.to( MenuEventBar, { x = intW - (intW /3)/2, time = 400, transition = easing.outExpo } )
		transition.to( svGallery, { x = 240, time = 400, transition = easing.outExpo } )
		transition.to( svInfo, { x = -240, time = 400, transition = easing.outExpo } )
		transition.to( svPromotions, { x = -240, time = 400, transition = easing.outExpo } )
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
		
		--scrollViewContent1:setScrollWidth(  480 )
		diferenciaX = event.x - event.target.x
		posicionMenu = MenuEventBar.x
    elseif event.phase == "moved" then
		if  event.direction == "left"  or event.direction == "right" then
			posicionNueva = event.x-diferenciaX
			
			event.target.x = posicionNueva
			
			MenuEventBar.x = (( - posicionNueva + 240) / 3) + posicionMenu
			
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
			transition.to( MenuEventBar, { x = posicionMenu + 160, time = 400, transition = easing.outExpo } )
			if nextSv == nil then
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( MenuEventBar, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			end
		elseif event.x  >= 380 and movimiento == "d" then
			transition.to( event.target, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( MenuEventBar, { x = posicionMenu - 160, time = 400, transition = easing.outExpo } )
			if previousSv == nil then 
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( MenuEventBar, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			end
		else
			transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( MenuEventBar, { x = posicionMenu, time = 400, transition = easing.outExpo } )
		end
		
    end
	
end

---------------------------------------------------------
---------build Partner
---------------------------------------------------------
function loadPartner(item)
	
	groupEvent = display.newGroup()
	homeScreen:insert( groupEvent )
	
	local imgBgEvent = display.newImage( "img/bgk/login.jpg" )
	imgBgEvent.alpha = 1
	imgBgEvent.x = 240
	imgBgEvent.y = 215
	imgBgEvent.width = intW
	imgBgEvent.height = 165
	groupEvent:insert( imgBgEvent )
	
	--[[local imgEvent = display.newImage( "img/btn/tmpComer.jpg" )
	imgEvent.alpha = 1
	imgEvent.x = 110
	imgEvent.y = 215
	imgEvent.width = 86
	imgEvent.height = 86
	groupEvent:insert( imgEvent )]]
	
	--loadImagePartner(item)
	
	local imgEvent = display.newImage( item.logo, system.TemporaryDirectory )
	imgEvent.alpha = 1
	imgEvent.x = 110
	imgEvent.y = 215
	imgEvent.width = 86
	imgEvent.height = 86
	groupEvent:insert( imgEvent )
	
	local txtPartner = display.newText({
		text = item.name,
		x = 320,
		y =  225,
		font = "Chivo",
		height = 100,
		width = 300,
		fontSize = 20,
		align = "left"
	})
	txtPartner:setFillColor( 0 )
	groupEvent:insert( txtPartner )
	
	local txtAddress = display.newText({
		text = item.address,
		x = 320,
		y =  275,
		font = "Chivo",
		height = 100,
		width = 300,
		fontSize = 15,
		align = "left"
	})
	txtAddress:setFillColor( 0 )
	groupEvent:insert( txtAddress )
	
	local BgMenuEvent = display.newRect( midW, 343, intW, 76 )
	BgMenuEvent:setFillColor( 217/255, 217/255, 217/255 )
	groupEvent:insert(BgMenuEvent)
	
	local menuEvent = display.newRect( midW, 341 , intW, 73 )
	menuEvent:setFillColor( 1 )
	groupEvent:insert(menuEvent)
	
	MenuEventBar = display.newRect( (intW /3)/2, 378 , intW /3, 4 )
	MenuEventBar:setFillColor( 88/255, 188/255, 36/255 )
	groupEvent:insert(MenuEventBar)
	
	groupMenuEventText = display.newGroup()
	groupMenuEventText.y = 340
	groupEvent:insert(groupMenuEventText)
	
	txtInfo = display.newText({
		text = "Info",
		x = 70,
		y =  0,
		font = "Chivo",
		fontSize = 22
	})
	txtInfo:setFillColor( 0 )
	groupMenuEventText:insert( txtInfo )
	txtInfo.name = "info"
	txtInfo:addEventListener( "tap", tapMenuEvent )
	
	txtPromotions = display.newText({
		text = "Promociones",
		x = midW,
		y =  0,
		font = "Chivo",
		fontSize = 22
	})
	txtPromotions:setFillColor( 0 )
	txtPromotions.name = "promotions"
	groupMenuEventText:insert( txtPromotions )
	txtPromotions:addEventListener( "tap", tapMenuEvent )
	
	txtGallery = display.newText({
		text = "Galeria",
		x = 400,
		y =  0,
		font = "Chivo",
		fontSize = 22
	})
	txtGallery:setFillColor( 0 )
	txtGallery.name = "gallery"
	groupMenuEventText:insert( txtGallery )
	txtGallery:addEventListener( "tap", tapMenuEvent )
	
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
	
	buildEventInfo(item)
	
end

function loadImagePartner(item)
	local path = system.pathForFile( item.logo, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		
		loadPartner(item)
		
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImageListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
				event.target.alpha = 0
				loadPartner(item)
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url.."assets/img/app/logo/"..item.logo, 
        "GET", loadImageListener, item.logo, system.TemporaryDirectory ) 
    end
	
end

function buildEventInfo(item)

	lastY = 90
	
	local bgGeneralInformacion = display.newRect( midW, 0, 480, 76 )
	bgGeneralInformacion:setFillColor( 1 )
	svInfo:insert(bgGeneralInformacion)
	
	local txtGeneralInformacion = display.newText({
		text = "Informacion general",
		--x = 123,
		x = 240,
		y = lastY - 40,
		--width = 122,
		width = 420,
		font = "Chivo",
		fontSize = 22,
		align = "left"
	})
	txtGeneralInformacion:setFillColor( 0 )
	svInfo:insert( txtGeneralInformacion )
	
	local txtInfo = display.newText({
		text = item.info,
		--x = 123,
		x = 240,
		y = lastY,
		--width = 122,
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
		--x = 123,
		x = 240,
		y = lastY - 50,
		--width = 122,
		width = 420,
		font = "Chivo",
		fontSize = 22,
		align = "left"
	})
	txtLocation:setFillColor( 0 )
	svInfo:insert( txtLocation )
	
	local txtAdressEvent = display.newText({
		text = item.address,
		--x = 123,
		x = 240,
		y = lastY,
		--width = 122,
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
	
	lastY = lastY + bgLocation.height/2  + lastY
	
	svInfo:setScrollHeight(lastY)
	
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
	toolbar:setFillColor( 221/255, 236/255, 241/255 )	-- red
	homeScreen:insert(toolbar)
	
	local grupoToolbar = display.newGroup()
	grupoToolbar.y = 5
	homeScreen:insert(grupoToolbar)
	
	local logo = display.newImage( "img/btn/logo.png" )
	logo:translate( 40, 25 )
	grupoToolbar:insert(logo)
	
	local btnSearch = display.newImage( "img/btn/btnMenuNotification.png" )
	btnSearch:translate( display.contentWidth - 160, 25 )
	grupoToolbar:insert(btnSearch)
	
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
	
	local imgBtnBack = display.newImage( "img/btn/btnUp.png" )
	imgBtnBack.alpha = 1
    imgBtnBack.x= 440
	imgBtnBack.y = 30
    groupMenu:insert( imgBtnBack )
	
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