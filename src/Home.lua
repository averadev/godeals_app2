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
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local scene = storyboard.newScene()
local homeScreen = display.newGroup()
local grupoModal = display.newGroup()
local groupMenu, scrViewMain, scrViewEventos, scrViewDeals

-- Objetos
local txtMenuInicio, txtMenuEventos, txtMenuDeals
local toolbar, menu, settings, modal, btnModal

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
        separadorEventos:translate( 41, 190)
        separadorEventos:setFillColor( 1 )
        separadorEventos.isVisible = true
        separadorEventos.height = 20
        separadorEventos.width = 20
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
        RestManager.getCoupon()
        
    elseif screen == "MainDeal" then
        
        yMain = yMain + 50
        local separadorEventos = display.newImage( "img/btn/btnArrowBlack.png" )
        separadorEventos:translate( 41, yMain)
        separadorEventos:setFillColor( 1 )
        separadorEventos.isVisible = true
        separadorEventos.height = 20
        separadorEventos.width = 20
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
            for k, v, u in string.gmatch(elements[y].date, "(%w+)-(%w+)-(%w+)") do
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
            -- Verify month
            for k, v, u in string.gmatch(elements[y].iniDate, "(%w+)-(%w+)-(%w+)") do
                if not (currentMonth == tonumber(v)) then
                    -- Create title month
                    currentMonth = tonumber(v)
                    local title = MonthTitle:new()
                    scrViewDeals:insert(title)
                    title:build(Globals.Months[currentMonth].." del "..k)
                    title.y = lastY
                    lastY = lastY + 70
                end
            end
            
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

local function scrollListenerContent1( event )
	if event.phase == "began" then
		
		scrViewMain:setScrollWidth(  480 )
		diferenciaX = event.x - scrViewMain.x
		posicionMenu = groupMenu.x
    elseif event.phase == "moved" then
		if  event.direction == "left"  or event.direction == "right" then
		posicionNueva = event.x-diferenciaX
		scrViewMain.x = posicionNueva
		scrViewEventos.x = 480+posicionNueva
		--groupMenu.x = posicionNueva/3 + posicionMenu
		groupMenu.x = ((posicionNueva - 240) / 3) + posicionMenu
		end
		
		movimiento = "c"
		if(event.direction == "left") then
			movimiento = "i"
		elseif event.direction == "right" then
			movimiento = "d"
		end
		
    elseif event.phase == "ended" or event.phase == "cancelled" then
		if event.x <= 100 and movimiento == "i" then
			transition.to( scrViewMain, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.35, time = 400, transition = easing.outExpo } )
			transition.to( scrViewEventos, { x = 240, time = 400, transition = easing.outExpo } )
			txtMenuInicio:setFillColor( 161/255, 161/255, 161/255 )
			txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
			txtMenuEventos:setFillColor( 0 )
		else
			transition.to( scrViewMain, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = 0, time = 400, transition = easing.outExpo } )
			transition.to( scrViewEventos, { x = 720, time = 400, transition = easing.outExpo } )
		end
    end
end

local function scrollListenerContent2( event )
    local phase = event.phase
    if ( phase == "began" ) then 
		diferenciaX = event.x - scrViewEventos.x
		diferenciaTextX =  groupMenu.x
    elseif ( phase == "moved" ) then
	
		if  event.direction == "left"  or event.direction == "right" then
		
		diferenciaTextX = diferenciaTextX - 1
		posicionNueva = event.x-diferenciaX
		scrViewEventos.x = posicionNueva
		groupMenu.x = (posicionNueva - 740) / 3
		scrViewDeals.x = 480+(posicionNueva)
		scrViewMain.x = -480+posicionNueva
		end
		movimiento = "c"
		if(event.direction == "left") then
			movimiento = "i"
		elseif event.direction == "right" then
			movimiento = "d"
		end
    elseif ( phase == "ended" ) then
		if event.x <= 100 and movimiento == "i" then
			transition.to( scrViewEventos, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.70, time = 400, transition = easing.outExpo } )
			transition.to( scrViewDeals, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( scrViewMain, { x = -240, time = 400, transition = easing.outExpo } )
			txtMenuInicio:setFillColor( 161/255, 161/255, 161/255 )
			txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )
			txtMenuDeals:setFillColor( 0 )
		elseif event.x  >= 380 and movimiento == "d" then
			transition.to( scrViewEventos, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = 0, time = 400, transition = easing.outExpo } )
			transition.to( scrViewDeals, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( scrViewMain, { x = 240, time = 400, transition = easing.outExpo } )
			txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
			txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )
			txtMenuInicio:setFillColor( 0 )
		else
			transition.to( scrViewEventos, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.35, time = 400, transition = easing.outExpo } )
			transition.to( scrViewDeals, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( scrViewMain, { x = -240, time = 400, transition = easing.outExpo } )
		end
			
		
    end
    return true
end

local function scrollListenerContent3( event )
	if event.phase == "began" then
		diferenciaX = event.x - scrViewDeals.x
		posicionMenu = groupMenu.x
    elseif event.phase == "moved" then
		if  event.direction == "left"  or event.direction == "right" then
		posicionNueva = event.x-diferenciaX
		scrViewDeals.x = posicionNueva
		scrViewEventos.x = -480+posicionNueva
		groupMenu.x = ((posicionNueva - 240) / 3) + posicionMenu
		end
		
		movimiento = "c"
		if(event.direction == "left") then
			movimiento = "i"
		elseif event.direction == "right" then
			movimiento = "d"
		end
		
    elseif event.phase == "ended" or event.phase == "cancelled" then
		if event.x  >= 380 and movimiento == "d" then
			transition.to( scrViewDeals, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.35, time = 400, transition = easing.outExpo } )
			transition.to( scrViewEventos, { x = 240, time = 400, transition = easing.outExpo } )
			txtMenuInicio:setFillColor( 161/255, 161/255, 161/255 )
			txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
			txtMenuEventos:setFillColor( 0 )
		else
			transition.to( scrViewDeals, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.70, time = 400, transition = easing.outExpo } )
			transition.to( scrViewEventos, { x = -240, time = 400, transition = easing.outExpo } )
		end
    end
end

local function tapTitulo1(event)
	scrViewMain:setScrollWidth(  480 )
	transition.to( scrViewEventos, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( groupMenu, { x = 0, time = 400, transition = easing.outExpo } )
	transition.to( scrViewDeals, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( scrViewMain, { x = 240, time = 400, transition = easing.outExpo } )
	txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )
	txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
	txtMenuInicio:setFillColor( 0 )
end

local function tapTitulo2(event)
	transition.to( scrViewEventos, { x = 240, time = 400, transition = easing.outExpo } )
	transition.to( groupMenu, { x = display.contentWidth * - 0.35, time = 400, transition = easing.outExpo } )
	transition.to( scrViewDeals, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( scrViewMain, { x = -240, time = 400, transition = easing.outExpo } )
	txtMenuInicio:setFillColor( 161/255, 161/255, 161/255 )
	txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
	txtMenuEventos:setFillColor( 0 )
	
end

local function tapTitulo3(event)
	transition.to( scrViewDeals, { x = 240, time = 400, transition = easing.outExpo } )
	transition.to( groupMenu, { x = display.contentWidth * - 0.70, time = 400, transition = easing.outExpo } )
	transition.to( scrViewEventos, { x = -240, time = 400, transition = easing.outExpo } )
	txtMenuInicio:setFillColor( 161/255, 161/255, 161/255 )
	txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )
	txtMenuDeals:setFillColor( 0 )
end

 function CloseModal( event )
	rect1Modal:removeSelf()
	rect2Modal:removeSelf()
	rect3Modal:removeSelf()
	rect4Modal:removeSelf()
	modal:removeSelf()
	bgModal:removeSelf()
	scrViewMain:setIsLocked( false )
	return true
end

--- Modal Menu

function modalFunction( event )
	return true
end

 function openModal ( event )
 
	bgModal = display.newRect(0,0,intW,intH)
	bgModal.anchorX = 0
	bgModal.anchorY = 0
	bgModal:setFillColor( 187, 219, 255, .1 )
	grupoModal:insert(bgModal)
	bgModal:addEventListener( "tap", CloseModal )
	
	modal = display.newRect(30, display.contentCenterY / 3,intW - 60,(intH / 2) * 1.5)
	modal.anchorX = 0
	modal.anchorY = 0
	modal:setFillColor( 0)
	grupoModal:insert(modal)
	modal:addEventListener( "tap", modalFunction )
	
	rect1Modal = display.newRect(50, display.contentCenterY / 3 + 30,modal.contentWidth /2 - 50,250)
	rect1Modal.anchorX = 0
	rect1Modal.anchorY = 0
	rect1Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect1Modal)
	rect1Modal:addEventListener("tap", rectModal)
	
	rect2Modal = display.newRect(modal.contentWidth /2 + 60, display.contentCenterY / 3 + 30,modal.contentWidth /2 - 50,250)
	rect2Modal.anchorX = 0
	rect2Modal.anchorY = 0
	rect2Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect2Modal)
	rect2Modal:addEventListener("tap", rectModal)
	
	rect3Modal = display.newRect(50, modal.contentHeight / 1.3, modal.contentWidth /2 - 50, 250)
	rect3Modal.anchorX = 0
	rect3Modal.anchorY = 0
	rect3Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect3Modal)
	rect3Modal:addEventListener("tap", rectModal)
	
	rect4Modal = display.newRect(modal.contentWidth /2 + 60, modal.contentHeight / 1.3, modal.contentWidth /2 - 50, 250)
	rect4Modal.anchorX = 0
	rect4Modal.anchorY = 0
	rect4Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect4Modal)
	rect4Modal:addEventListener("tap", rectModal)
	
	local halfW = display.contentWidth * 0.5
	local halfH = display.contentHeight * 0.5
	
	scrViewMain:setIsLocked( true )
	
	return true
end

function rectModal( event )
	return true
end

function showCoupon(event)
    print(event.target.item)
	storyboard.gotoScene( "src.detail", {
		time = 400,
		effect = "crossFade",
		params = { item = event.target.item }
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
		bgFotoFacebook:setFillColor( 1 )	-- red
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
	
	local menu = display.newRect( 0, h + 55, display.contentWidth, 70 )
	menu.anchorX = 0
	menu.anchorY = 0
	menu:setFillColor( 245/255, 245/255, 245/255 )
	homeScreen:insert(menu)
	
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
		listener = scrollListenerContent1,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = false,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(scrViewMain)
	
	scrViewEventos = widget.newScrollView
	{
		top = h + 125,
		left = 480,
		width = display.contentWidth,
		height = display.contentHeight,
		listener = scrollListenerContent2,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(scrViewEventos)
    
	scrViewDeals = widget.newScrollView
	{
		top = h + 125,
		left = 480,
		width = display.contentWidth,
		height = display.contentHeight,
		listener = scrollListenerContent3,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(scrViewDeals)
    
	
	groupMenu = display.newGroup()
	homeScreen:insert(groupMenu)
	
	txtMenuInicio = display.newText( {    
        x = display.contentWidth * .5, y = menu.y + 30,
        text = "Inicio",  font = "Chivo", fontSize = 30,
	})
	txtMenuInicio:setFillColor( 0 )	-- black
	groupMenu:insert(txtMenuInicio)
	txtMenuInicio:addEventListener( "tap", tapTitulo1 )
	
	txtMenuEventos = display.newText( {
        x = display.contentWidth * .85, y = menu.y + 30,
        text = "Eventos", font = "Chivo", fontSize = 30,
	})
	txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )	-- black
	groupMenu:insert(txtMenuEventos)
	txtMenuEventos:addEventListener( "tap", tapTitulo2 )
	
	txtMenuDeals = display.newText( {
        x = display.contentWidth * 1.2, y = menu.y + 30,
        text = "Deals", font = "Chivo", fontSize = 30,
	})
	txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )	-- black
	groupMenu:insert(txtMenuDeals)
	txtMenuDeals:addEventListener( "tap", tapTitulo3 )
	
	local grupoSeparadorEventos = display.newGroup()
	scrViewMain:insert(grupoSeparadorEventos)
	
	
	navGrp = display.newGroup()
    homeScreen:insert(navGrp)
	
	settings = DBManager.getSettings()
	
	getFBData()
	
	btnModal = display.newImage( "img/btn/detailCity.png" )
	btnModal:translate( intW - 62, intH - 62)
	btnModal.isVisible = true
	btnModal.height = 80
	btnModal.width = 80
	homeScreen:insert(btnModal)
	btnModal:addEventListener( "tap", openModal )
	
	btnModal:toFront()
    clearTempDir()
end
	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    storyboard.removeAll()
    RestManager.getEvents()
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