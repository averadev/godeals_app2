---------------------------------------------------------------------------------
-- Godeals App
-- Alfredo Chi
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.BuildRow')
require('src.Modal')
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local scene = storyboard.newScene()
local homeScreen = display.newGroup()
grupoModal = display.newGroup()
local groupMenu, scrViewMain, scrViewEventos, scrViewDeals,svMenuTxt
local currentSv

-- Objetos
local txtMenuInicio, txtMenuEventos, txtMenuDeals
local toolbar, menu, settings, btnModal

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local h = display.topStatusBarContentHeight

-- Arreglos
local elements = {}
local imageItems = {}

-- Contadores
local yMain = 220
local noCallback = 0

---------------------------------------------------------------------------------
-- Setters
---------------------------------------------------------------------------------
function setElements(items)
    elements = items
end

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------
-- Limpiamos imagenes con 15 dias de descarga
local function clearTempDir()
    local lfs = require "lfs"
    local doc_path = system.pathForFile( "", system.TemporaryDirectory )
    local destDir = system.TemporaryDirectory  -- where the file is stored
    local lastTwoWeeks = os.time() - 1209600

    for file in lfs.dir(doc_path) do
        -- file is the current file or directory name
        local file_attr = lfs.attributes( system.pathForFile( file, destDir  ) )
        -- Elimina despues de 2 semanas
        if file_attr.modification < lastTwoWeeks then
           os.remove( system.pathForFile( file, destDir  ) ) 
        end
    end
end

-- Carga de la imagen del servidor o de TemporaryDirectory
function loadImage(obj)    
    -- Determinamos si la imagen existe
    local path = system.pathForFile( elements[obj.posc].image, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
        imageItems[obj.posc] = display.newImage( elements[obj.posc].image, system.TemporaryDirectory )
        imageItems[obj.posc].alpha = 0
        if obj.posc < #elements then
            obj.posc = obj.posc + 1
            loadImage(obj)
        else
            buildItems(obj.screen)
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
                    loadImage(obj)
                else
                    buildItems(obj.screen)
                end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url..obj.path..elements[obj.posc].image, 
        "GET", loadImageListener, elements[obj.posc].image, system.TemporaryDirectory ) 
    end
end

-- Carga los paneles
function buildItems(screen)    
    
    if screen == "MainEvent" then
        
        local separadorEventos = display.newImage( "img/btn/btnArrowBlack.png" )
        separadorEventos:translate( 41, 190 -3)
        separadorEventos.isVisible = true
        scrViewMain:insert(separadorEventos)

        local textSeparadorEventos = display.newText( {
            text = "Recomendaciones de eventos y actividades.",     
            x = 300, y = 217, width = intW, height = 80,
            font = "Chivo", fontSize = 19, align = "left"
        })
        textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
        scrViewMain:insert(textSeparadorEventos)
        
        for y = 1, #elements, 1 do 
            -- Create container
            local evento = Event:new()
            scrViewMain:insert(evento)
            evento:build(elements[y], imageItems[y])
            evento.y = yMain
            yMain = yMain + 102 
        end
        -- Siguiente solicitud
        RestManager.getTodayDeal()
        
    elseif screen == "MainDeal" then
        
        yMain = yMain + 50
        local separadorEventos = display.newImage( "img/btn/btnArrowBlack.png" )
        separadorEventos:translate( 41, yMain -3)
        separadorEventos.isVisible = true
        scrViewMain:insert(separadorEventos)

        local textSeparadorEventos = display.newText( {
            text = "Recomendaciones de promociones para ti.",     
            x = 300, y = yMain + 27, width = intW, height = 80,
            font = "Chivo", fontSize = 19, align = "left"
        })
        textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
        scrViewMain:insert(textSeparadorEventos)
        
        yMain = yMain + 30
        for y = 1, #elements, 1 do 
            -- Create container
            local deal = Deal:new()
            scrViewMain:insert(deal)
            deal:build(elements[y], imageItems[y])
            deal.y = yMain
            yMain = yMain + 102
        end
        -- Siguiente solicitud
        RestManager.getAllEvent()
        
    elseif screen == "EventPanel" then
        
        local lastY = 0
        local currentMonth = 0
        for y = 1, #elements, 1 do 
            -- Verify month
            for k, v, u in string.gmatch(elements[y].iniDate, "(%w+)-(%w+)-(%w+)") do
                if not (currentMonth == tonumber(v)) then
                    -- Create title month
                    currentMonth = tonumber(v)
                    local title = MonthTitle:new()
                    scrViewEventos:insert(title)
                    title:build(Globals.Months[currentMonth].." del "..k)
                    title.y = lastY
                    lastY = lastY + 70
                end
            end
            
            -- Create container
            local evento = Event:new()
            scrViewEventos:insert(evento)
            evento:build(elements[y], imageItems[y])
            evento.y = lastY
            
            lastY = lastY + 102
        end
        -- Siguiente solicitud
        RestManager.getAllCoupon()
        
    elseif screen == "DealPanel" then
        
        local lastY = 0
        local currentMonth = 0
        for y = 1, #elements, 1 do 
            
            -- Create container
            local deal = Deal:new()
            scrViewDeals:insert(deal)
            deal:build(elements[y], imageItems[y])
            deal.y = lastY
            
            lastY = lastY + 102
        end
    end
end

-- Genera la fecha en formato
function getDate(strDate)
    local fecha
    for k, v, u in string.gmatch(strDate, "(%w+)-(%w+)-(%w+)") do
        fecha = u .. " de "..Globals.Months[tonumber(v)].." de " .. k  
    end
    return fecha
end

---------------------------------------------------------------------------------
-- LISTENERS
---------------------------------------------------------------------------------

--- scrollView functions

function ListenerChangeMenu( event )
	
	local nextSv
	local previousSv
	local currentTxt, nextTxt, previousTxt
	
	if currentSv.name == "scrViewMain" then
		nextSv = scrViewEventos
		currentTxt = txtMenuInicio
		nextTxt = txtMenuEventos
	elseif currentSv.name == "scrViewEventos" then
		nextSv = scrViewDeals
		previousSv = scrViewMain
		currentTxt = txtMenuEventos
		nextTxt = txtMenuDeals
		previousTxt = txtMenuInicio
	elseif currentSv.name == "scrViewDeals" then
		previousSv = scrViewEventos
		currentTxt = txtMenuDeals
		previousTxt = txtMenuEventos
	end
	
	if event.phase == "began" then
		svMenuTxt:setScrollWidth(  480 )
		diferenciaX = event.x - event.target.x
		posicionMenu = groupMenu.x
		
		event.target:setScrollWidth(480)
		
    elseif event.phase == "moved" then
		if  event.direction == "left"  or event.direction == "right" then
			
			posicionNueva = event.x-diferenciaX 
			
			currentSv.x = ((posicionNueva - 240) / .7 ) + posicionNueva
			
			if nextSv ~= nil then
				nextSv.x = 480 + ((posicionNueva - 240) / .7 ) + posicionNueva
			end
			
			if previousSv ~= nil then
				previousSv.x = -480 + ((posicionNueva - 240) / .7 ) + posicionNueva
			end
			
			groupMenu.x = (( posicionNueva - 240) / 3) + posicionMenu
			
		end
		
    elseif event.phase == "ended" or event.phase == "cancelled" then
	
		txtMenuInicio:setFillColor( 161/255, 161/255, 161/255 )
		txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
		txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )
	
		if diferenciaX - event.x >= -100 then
			if nextSv == nil then
				transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenu, { x = posicionMenu, time = 400, transition = easing.outExpo } )
				currentTxt:setFillColor( 0 )
			else
				transition.to( currentSv, { x = -240, time = 400, transition = easing.outExpo } )
				transition.to( nextSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenu, { x = posicionMenu - 166, time = 400, transition = easing.outExpo } )
				currentSv = nextSv
				nextTxt:setFillColor( 0 )
			end
		elseif diferenciaX - event.x  <= -380 then
			
			if previousSv == nil then 
				transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenu, { x = posicionMenu, time = 400, transition = easing.outExpo } )
				currentTxt:setFillColor( 0 )
			else
				transition.to( currentSv, { x = 720, time = 400, transition = easing.outExpo } )
				transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
				transition.to( previousSv, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenu, { x = posicionMenu + 166, time = 400, transition = easing.outExpo } )
				currentSv = previousSv
				previousTxt:setFillColor( 0 )
			end
		else
			transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			currentTxt:setFillColor( 0 )
		end
    end
	
end

--- scrollView functions

function ListenerChangeScroll( event )

	local nextSv
	local previousSv
	local posicionMenuGroup
	local currentTxt, nextTxt, previousTxt
	
	if event.target.name == "scrViewMain" then
		nextSv = scrViewEventos
		currentTxt = txtMenuInicio
		nextTxt = txtMenuEventos
	elseif event.target.name == "scrViewEventos" then
		nextSv = scrViewDeals
		previousSv = scrViewMain
		currentTxt = txtMenuEventos
		nextTxt = txtMenuDeals
		previousTxt = txtMenuInicio
	elseif event.target.name == "scrViewDeals" then
		previousSv = scrViewEventos
		currentTxt = txtMenuDeals
		previousTxt = txtMenuEventos
	end
	
	if event.phase == "began" then
		event.target:setScrollWidth(  480 )
		diferenciaX = event.x - event.target.x
		posicionMenu = groupMenu.x
    elseif event.phase == "moved" then
		if  event.direction == "left"  or event.direction == "right" then
			posicionNueva = event.x-diferenciaX
			
			event.target.x = posicionNueva
			
			groupMenu.x = (( posicionNueva - 240) / 3) + posicionMenu
			
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
	
		txtMenuInicio:setFillColor( 161/255, 161/255, 161/255 )
		txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
		txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )
	
		if event.x <= 100 and movimiento == "i" then
			transition.to( event.target, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = posicionMenu - 166, time = 400, transition = easing.outExpo } )
			currentSv = nextSv
			if nextSv == nil then
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenu, { x = posicionMenu, time = 400, transition = easing.outExpo } )
				currentTxt:setFillColor( 0 )
			else
				nextTxt:setFillColor( 0 )
			end
            showFilter(true)
		elseif event.x  >= 380 and movimiento == "d" then
			transition.to( event.target, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = posicionMenu + 166, time = 400, transition = easing.outExpo } )
			currentSv = previousSv
			if previousSv == nil then 
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenu, { x = posicionMenu, time = 400, transition = easing.outExpo } )
				currentTxt:setFillColor( 0 )
			else
				previousTxt:setFillColor( 0 )
			end
            if event.target.name == "scrViewEventos" then
                showFilter(false)
            end
		else
			transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			currentTxt:setFillColor( 0 )
			currentSv = event.target
		end
		
    end
	
end

-- Ocultamos o Mostramos filtro
function showFilter(boolShow)
    if boolShow and btnModal.alpha == 0 then
        transition.to( btnModal, { alpha = 1, time = 400 } )
    elseif not (boolShow) and btnModal.alpha == 1 then
        transition.to( btnModal, { alpha = 0, time = 400 } )
    end
end

--- Modal Menu

function showCoupon(event)
    print(event.target.item)
	storyboard.gotoScene( "src.Detail", {
		time = 400,
		effect = "crossFade",
		params = { item = event.target.item }
	})
end

function showWallet(event)
    print(event.target.item)
	storyboard.gotoScene( "src.Wallet", {
		time = 400,
		effect = "crossFade"
	})
end

function getFBData()
		local sizeAvatar = 'width=100&height=100'
        
		contenerUser = display.newContainer( display.contentWidth * 2, 350 )
		contenerUser.x = 0
		contenerUser.y = 0
		scrViewMain:insert( contenerUser )
		
		local bgFotoFacebook = display.newRect( 0, 0, display.contentWidth, 90 )
		bgFotoFacebook.anchorX = 0
		bgFotoFacebook.anchorY = 0
		bgFotoFacebook:setFillColor( 1 )
		contenerUser:insert(bgFotoFacebook)
		
        local path = system.pathForFile( "avatarFb"..settings.fbId, system.TemporaryDirectory )
        local fhd = io.open( path )
        if fhd then
            fhd:close()
			
            local avatar = display.newImage("avatarFb"..settings.fbId, system.TemporaryDirectory )
            avatar.x = 55
            avatar.y = 90
			avatar.height = 100
			avatar.width = 100
            contenerUser:insert(avatar)
        else
            local function networkListenerFB( event )
                -- Verificamos el callback activo
                if ( event.isError ) then
                else
                    event.target.x = 55
                    event.target.y = 90
                    contenerUser:insert( event.target )
                end
            end
            display.loadRemoteImage( "http://graph.facebook.com/".. settings.fbId .."/picture?type=large&"..sizeAvatar, 
                "GET", networkListenerFB, "avatarFb"..settings.fbId, system.TemporaryDirectory )
				 
        end
		
	local textNombre = display.newText( {
		text = settings.name,     
		x = 245, y = 25,
		width = intW, height = 30,
		font = "Chivo-Black",  fontSize = 26, align = "left"
	})
	textNombre:setFillColor( 0 )
	contenerUser:insert(textNombre)
		
	local textSaludo = display.newText( {
		text = "Actualmente esta viendo eventos y cupones de Cancún",     
		x = 310, y = 80,
		width = 400, height =20,
		font = "Chivo",  fontSize = 14, align = "left"
	})
	textSaludo:setFillColor( 176/255, 176/255, 176/255 )
	contenerUser:insert(textSaludo)
	
end


---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:createScene( event )
	screen = self.view
	
	screen:insert(homeScreen)
	screen:insert(grupoModal)
	
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 1 )
	homeScreen:insert(bg)
	
	toolbar = display.newRect( 0, h, display.contentWidth, 55 )
	toolbar.anchorX = 0
	toolbar.anchorY = 0
	toolbar:setFillColor( 221/255, 236/255, 241/255 )
	homeScreen:insert(toolbar)
	
	local grupoToolbar = display.newGroup()
	grupoToolbar.y = h + 5
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
	btnWallet:addEventListener( "tap", showWallet )
	grupoToolbar:insert(btnWallet)
	
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
	btnMensaje:translate( display.contentWidth - 90, 25 )
	grupoToolbar:insert(btnMensaje)
	
	local btnHerramienta = display.newImage( "img/btn/btnMenuUser.png" )
	btnHerramienta:translate( display.contentWidth - 35, 25 )
	grupoToolbar:insert(btnHerramienta)
	btnHerramienta:addEventListener( "tap", saveBeacon )
    
	svMenuTxt = widget.newScrollView
	{
		x = 240,
		y = h + 89,
		width = intW,
		height = 70,
		listener = ListenerChangeMenu,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = true,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(svMenuTxt)
	
	local triangle = display.newImage( "img/btn/triangle.png" )
	triangle:translate( display.contentWidth * .5, 123 + h)
	triangle:setFillColor( 1 )
	triangle.isVisible = true
	triangle.height = 15
	triangle.width = 24
	homeScreen:insert(triangle)
	
	scrViewMain = widget.newScrollView
	{
		top = h + 125,
		left = 0,
		width = intW,
		height = intH,
		listener = ListenerChangeScroll,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = false,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(scrViewMain)
	scrViewMain.name = "scrViewMain"
	
	scrViewEventos = widget.newScrollView
	{
		top = h + 125,
		left = 480,
		width = display.contentWidth,
		height = display.contentHeight,
		listener = ListenerChangeScroll,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(scrViewEventos)
	scrViewEventos.name = "scrViewEventos"
    
	scrViewDeals = widget.newScrollView
	{
		top = h + 125,
		left = 480,
		width = display.contentWidth,
		height = display.contentHeight,
		listener = ListenerChangeScroll,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(scrViewDeals)
	scrViewDeals.name = "scrViewDeals"
	
	groupMenu = display.newGroup()
	svMenuTxt:insert(groupMenu)
	
	txtMenuInicio = display.newText( {    
        x = display.contentWidth * .5, y = 30,
        text = "Inicio",  font = "Chivo", fontSize = 30,
	})
	txtMenuInicio:setFillColor( 0 )
	groupMenu:insert(txtMenuInicio)
	txtMenuInicio.name = "inicio"
	
	txtMenuEventos = display.newText( {
        x = display.contentWidth * .85, y = 30,
        text = "Eventos", font = "Chivo", fontSize = 30,
	})
	txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )
	groupMenu:insert(txtMenuEventos)
	txtMenuEventos.name = "eventos"
	
	txtMenuDeals = display.newText( {
        x = display.contentWidth * 1.2, y = 30,
        text = "Deals", font = "Chivo", fontSize = 30,
	})
	txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
	groupMenu:insert(txtMenuDeals)
	txtMenuDeals.name = "deals"
	
	local grupoSeparadorEventos = display.newGroup()
	scrViewMain:insert(grupoSeparadorEventos)
	
	currentSv = scrViewMain
	
	settings = DBManager.getSettings()
	
	getFBData()
	
	btnModal = display.newImage( "img/btn/btnFilter.png" )
	btnModal:translate( intW - 50, intH - 50)
	btnModal.alpha = 0
	homeScreen:insert(btnModal)
	btnModal:addEventListener( "tap", openModal )
	
	btnModal:toFront()
    clearTempDir()
    --RestManager.getAds()
    RestManager.getTodayEvent()
end

-- Temporal
function saveBeacon( event )
    -- Move
    transition.to( event.target, { alpha = 0, time = 400, transition = easing.outExpo } )
    transition.to( event.target, { alpha = 1, time = 400, delay = 500, transition = easing.outExpo } )
    
    local dataTmp = {
        {id = '1', message = 'Hola, veo que estas cerca, recuerda visitarnos.', uuid = '1a4f5be7-6683-44a6-b559-b8bf6efd9ad7', 
            latitude = '0', longitude = '0', distanceMin = '.6', distanceMax = '.3', partnerId = '2'},
        {id = '2', message = 'Hola, veo que estas cerca, recuerda visitarnos.', uuid = 'f7826da6-4fa2-4e98-8024-bc5b71e0893e', 
            latitude = '0', longitude = '0', distanceMin = '.6', distanceMax = '.3', partnerId = '2'},
        {id = '3', message = 'Hola, veo que estas cerca, recuerda visitarnos.', uuid = 'a1ea8136-0e1b-d4a1-b840-63f88c8da1ea', 
            latitude = '0', longitude = '0', distanceMin = '.6', distanceMax = '.3', partnerId = '2'},
    
        {id = '4', message = 'Bienvenido, hoy tenemos una oferta para ti.', uuid = '1a4f5be7-6683-44a6-b559-b8bf6efd9ad7', 
            latitude = '0', longitude = '0', distanceMin = '.3', distanceMax = '0', partnerId = '2'},
        {id = '5', message = 'Bienvenido, hoy tenemos una oferta para ti.', uuid = 'f7826da6-4fa2-4e98-8024-bc5b71e0893e', 
            latitude = '0', longitude = '0', distanceMin = '.3', distanceMax = '0', partnerId = '2'},
        {id = '6', message = 'Bienvenido, hoy tenemos una oferta para ti.', uuid = 'a1ea8136-0e1b-d4a1-b840-63f88c8da1ea', 
            latitude = '0', longitude = '0', distanceMin = '.3', distanceMax = '0', partnerId = '2'}
    }
    DBManager.saveAds(dataTmp)
end

function openModal( event )
	Modal(scrViewMain)
	return true
end	
	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    storyboard.removeAll()
end

-- Remove Listener
function scene:exitScene( event )
    if storeBar then
        storeBar:removeSelf()
        storeBar = nil
    end
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene