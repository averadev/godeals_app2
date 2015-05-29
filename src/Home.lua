---------------------------------------------------------------------------------
-- Godeals App
-- Alfredo Chi
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- OBJETOS Y VARIABLES
---------------------------------------------------------------------------------
-- Includes
require('src.Menu')
require('src.Modal')
require('src.Header')
require('src.BuildRow')
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')

-- Grupos y Contenedores
local scene = storyboard.newScene()
local homeScreen = display.newGroup()
grupoModal = display.newGroup()
groupSearchModal = display.newGroup()
local groupMenu, scrViewMain, scrViewEventos, scrViewDeals,svMenuTxt
local currentSv
local groupEvent
local groupDeals
local groupInicio
local groupNoConection

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
local yMain = 215
local noCallback = 0
local callbackCurrent = 0

---------------------------------------------------------------------------------
-- Setters
---------------------------------------------------------------------------------

function setElements(items)
    elements = items
	for y = 1, #items, 1 do 
        elements[y].callback = Globals.noCallbackGlobal
    end
end

function setFilterEvent(items)
	Globals.filterEvent = items
end

function setFilterDeals(items)
	Globals.filterDeals = items
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
		if elements[obj.posc].callback == Globals.noCallbackGlobal then
			imageItems[obj.posc] = display.newImage( elements[obj.posc].image, system.TemporaryDirectory )
			imageItems[obj.posc].alpha = 0
			if obj.posc < #elements then
				
				obj.posc = obj.posc + 1
				loadImage(obj)
			else
				buildItems(obj.screen)
			end
		end
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImageListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
                event.target.alpha = 0
				
				if elements[obj.posc].callback == Globals.noCallbackGlobal then
				
					imageItems[obj.posc] = event.target
					if obj.posc < #elements then
						obj.posc = obj.posc + 1
						loadImage(obj)
					else
						buildItems(obj.screen)
					end
				end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url..elements[obj.posc].path..elements[obj.posc].image, 
        "GET", loadImageListener, elements[obj.posc].image, system.TemporaryDirectory ) 
    end
end

-- Carga los paneles
function buildItems(screen)    
    
    if screen == "MainScreen" then
	
		yMain = 215
		
        -- Eventos
        local maxShape = display.newRect( intW/2, yMain, intW, 50 )
        maxShape:setFillColor( .87 )
        groupInicio:insert( maxShape )
        
        local separadorEventos = display.newImage( "img/btn/btnArrowGreen.png" )
        separadorEventos:translate( 41, yMain - 2 )
        separadorEventos.isVisible = true
        groupInicio:insert(separadorEventos)
        
        local textSeparadorEventos = display.newText( {
            text = "RECOMENDACIONES DE EVENTOS Y ACTIVIDADES.",     
            x = 300, y = yMain, width = intW, height = 20,
            font = "Lato-Regular", fontSize = 14, align = "left"
        })
        textSeparadorEventos:setFillColor( 0 )
        groupInicio:insert(textSeparadorEventos)
        
        yMain = yMain + 40
        for y = 1, #elements, 1 do 
            -- Create event
            if not (elements[y].rowType == 'deal') then
                local evento = Event:new()
                groupInicio:insert(evento)
                evento:build(false, elements[y], imageItems[y])
                evento.y = yMain
                yMain = yMain + 120
            end
        end
        
        -- Deals
        yMain = yMain + 40
        local maxShape = display.newRect( intW/2, yMain, intW, 50 )
        maxShape:setFillColor( .87 )
        groupInicio:insert( maxShape )
        
        local separadorEventos = display.newImage( "img/btn/btnArrowGreen.png" )
        separadorEventos:translate( 41, yMain - 2 )
        separadorEventos.isVisible = true
        groupInicio:insert(separadorEventos)
        
        local textSeparadorEventos = display.newText( {
            text = "RECOMENDACIONES DE DEALS.",     
            x = 300, y = yMain, width = intW, height = 20,
            font = "Lato-Regular", fontSize = 14, align = "left"
        })
        textSeparadorEventos:setFillColor( 0 )
        groupInicio:insert(textSeparadorEventos)
        
        yMain = yMain + 40
        for y = 1, #elements, 1 do 
            -- Create event
            if elements[y].rowType == 'deal' then
                local deal = Deal:new()
                groupInicio:insert(deal)
                deal:build(false, elements[y], imageItems[y])
                deal.y = yMain
                yMain = yMain + 120
            end
        end
        
		endLoading()
		
        -- Siguiente solicitud
		getLoading(scrViewEventos)
		
		scrViewMain:setScrollHeight(yMain + 20)
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
                    groupEvent:insert(title)
                    title:build(Globals.Months[currentMonth].." del "..k)
                    title.y = lastY
                    lastY = lastY + 70
                end
            end
            
            -- Create noCallback = noCallback + 1
            local evento = Event:new()
            groupEvent:insert(evento)
            evento:build(true, elements[y], imageItems[y])
            evento.y = lastY
            
            lastY = lastY + 120
        end
		
			
		scrViewEventos:setScrollHeight(lastY + 20)
		
        -- Siguiente solicitud
		getLoading(scrViewDeals)
		RestManager.getAllCoupon()
        
    elseif screen == "DealPanel" then
	
		scrViewDeals:scrollTo( "top", { time=400 } )
	
		groupDeals:removeSelf()
		groupDeals = nil
		groupDeals = display.newGroup()
		scrViewDeals:insert(groupDeals)
        
        local lastY = 20
        local currentMonth = 0
        for y = 1, #elements, 1 do 
            
            -- Create container
            local deal = Deal:new()
            groupDeals:insert(deal)
            deal:build(true, elements[y], imageItems[y])
            deal.y = lastY
            
            lastY = lastY + 120
        end
		
		scrViewDeals:setScrollHeight(lastY + 20)
		
		endLoading()
	elseif screen == "FilterEvent" then
	
		scrViewEventos:scrollTo( "top", { time=400 } )
	
		groupEvent:removeSelf()
		groupEvent = nil
		groupEvent = display.newGroup()
		scrViewEventos:insert(groupEvent)
		
		local lastY = 0
        local currentMonth = 0
        for y = 1, #elements, 1 do 
            -- Verify month
            for k, v, u in string.gmatch(elements[y].iniDate, "(%w+)-(%w+)-(%w+)") do
                if not (currentMonth == tonumber(v)) then
                    -- Create title month
                    currentMonth = tonumber(v)
                    local title = MonthTitle:new()
                    groupEvent:insert(title)
                    title:build(Globals.Months[currentMonth].." del "..k)
                    title.y = lastY
                    lastY = lastY + 70
                end
            end
            
            -- Create noCallback = noCallback + 1
            local evento = Event:new()
            groupEvent:insert(evento)
            evento:build(true, elements[y], imageItems[y])
            evento.y = lastY
            
            lastY = lastY + 120
        end
		
	elseif screen == "noFilterEvent" then
	
		groupEvent:removeSelf()
		groupEvent = nil
		groupEvent = display.newGroup()
		scrViewEventos:insert(groupEvent)
		
		local txtNoFilterFound = display.newText( {
			text = "Eventos con el filtro no disponible",     
			x = intW/2, y = intH/2.5,
			width = intW,
			font = "Lato-Regular",  fontSize = 30, align = "center"
		})
		txtNoFilterFound:setFillColor( 0 )
		groupEvent:insert(txtNoFilterFound)
		
	elseif screen == "noFilterCoupon" then
	
		groupDeals:removeSelf()
		groupDeals = nil
		groupDeals = display.newGroup()
		scrViewDeals:insert(groupDeals)
		
		local txtNoFilterFound = display.newText( {
			text = "Deals con el filtro no disponible",     
			x = intW/2, y = intH/2.5,
			width = intW,
			font = "Lato-Regular",  fontSize = 30, align = "center"
		})
		txtNoFilterFound:setFillColor( 0 )
		groupDeals:insert(txtNoFilterFound)
	
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

--obtenemos el homeScreen de la escena
function getScreenH()
	return homeScreen
end

function removeItemsGroupHome()

	getLoading(scrViewMain)
	
	groupInicio:removeSelf()
	groupInicio = display.newGroup()
	scrViewMain:insert(groupInicio)
	
	groupEvent:removeSelf()
	groupEvent = display.newGroup()
	scrViewEventos:insert(groupEvent)
	
	groupDeals:removeSelf()
	groupDeals = display.newGroup()
	scrViewDeals:insert(groupDeals)
	
	RestManager.getRecommended()
end

--comprueba si existe conexion a internet
function networkConnection()
    local netConn = require('socket').connect('www.google.com', 80)
    if netConn == nil then
		notConnection()
        return false
    end
	netConn:close()
    return true
end

function notConnection()

	endLoading()
	
	groupNoConection = display.newGroup()
	scrViewMain:insert( groupNoConection )
	
	local imgDisconnected = display.newImage( "img/btn/errorSad.png" )
	imgDisconnected:translate( intW/2, intH/4)
	groupNoConection:insert( imgDisconnected )

	local txtNoConection = display.newText( {
		text = "¡conexión no disponible, intentelo de nuevo!",     
		x = 240, y = scrViewMain.height/2,
		width = 480,
		font = "Lato-Regular",  fontSize = 22, align = "center"
	})
	txtNoConection:setFillColor( 0 )
	groupNoConection:insert(txtNoConection)
	txtNoConection:addEventListener( 'tap', reloadHome)
	
end

function reloadHome()
	groupNoConection:removeSelf()
	groupNoConection = nil
	getLoading(scrViewMain)
	
	if networkConnection() then
		getFBData()
		RestManager.getBeacons()
		RestManager.getRecommended()
	end
	
end

---------------------------------------------------------------------------------
-- LISTENERS
---------------------------------------------------------------------------------

--- scrollView functions

function ListenerChangeMenuHome( event )


	--[[if event.phase == "began" then --Pressing the button
		print("A");
	elseif event.phase == "canceled" then --sliding your finger off
		print("B");
	elseif event.phase == "ended" then --Releasing the button
		print("C");
	end]]
	
	--[[local phase = event.phase
	
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
		movimiento = "c"
		svMenuTxt:setScrollWidth(  480 )
		diferenciaX = event.x - event.target.x
		posicionMenu = groupMenu.x
		
		event.target:setScrollWidth(480)
		
		--display.getCurrentStage():setFocus( event.target )
		
    elseif event.phase == "moved" then
	
	--	event.target:takeFocus( event )
		
		if  event.direction == "up" then
			--groupMenu.y = 0
		end
	
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
			
			movimiento = "c"
			if(event.direction == "left") then
				movimiento = "i"
			elseif event.direction == "right" then
				movimiento = "d"
			end
			
			
		end
		
		--event.target:takeFocus( event )
		
    elseif event.phase == "ended" or event.phase == "cancelled" then
	
		print("asdfgh")
	
		--display.getCurrentStage():setFocus( nil )
	
		txtMenuInicio:setFillColor( 161/255, 161/255, 161/255 )
		txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
		txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )
	
		if diferenciaX - event.x >= -100 and movimiento == "i"  then
		
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
			
			if currentSv.name == "scrViewEventos" then
				btnModal.name = "EVENTOS"
			elseif currentSv.name == "scrViewDeals" then
				btnModal.name = "DEALS"
			end
			
			showFilter(true)
		elseif diferenciaX - event.x  <= -380 and movimiento == "d"  then
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
			
			if currentSv.name == "scrViewMain" then
				btnModal.name = ""
			elseif currentSv.name == "scrViewEventos" then
				btnModal.name = "EVENTOS"
			end
			
			if currentSv.name == "scrViewMain" then
                showFilter(false)
            end
		else
			transition.to( currentSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = -240, time = 400, transition = easing.outExpo } )
			if movimiento ~= "c" then
				transition.to( groupMenu, { x = posicionMenu, time = 400, transition = easing.outExpo } )
			end
			currentTxt:setFillColor( 0 )
		end
    end
	
	if ( event.limitReached ) then
        if ( event.direction == "up" ) then print( "Reached top limit" )
        elseif ( event.direction == "down" ) then print( "Reached bottom limit" )
        elseif ( event.direction == "left" ) then print( "Reached left limit" )
        elseif ( event.direction == "right" ) then print( "Reached right limit" )
        end
    end
	
	
	if event.phase == "canceled" then --sliding your finger off
		print("hola")
	end--]]
	
	return true
end

--- scrollView functions

function ListenerChangeScrollHome( event )

	scrViewMain:setScrollWidth(480)

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
		xCurrent = 0
		event.target:setScrollWidth(  480 )
		
		diferenciaX = event.x - event.target.x
		xCurrent = event.x
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
		
		if xCurrent == nil then
			xCurrent = 0;
		end
	
		--if event.x <= 100 and movimiento == "i" then
		if xCurrent - event.x >= 160 and movimiento == "i" then
			transition.to( event.target, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = posicionMenu - 166, time = 400, transition = easing.outExpo } )
			if nextSv == nil then
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenu, { x = posicionMenu, time = 400, transition = easing.outExpo } )
				currentTxt:setFillColor( 0 )
			else
				nextTxt:setFillColor( 0 )
				currentSv = nextSv
			end
			
			if event.target.name == "scrViewMain" then
				btnModal.name = "EVENTOS"
			elseif event.target.name == "scrViewEventos" then
				btnModal.name = "DEALS"
			end
			
			
            showFilter(true)
		--elseif event.x  >= 380 and movimiento == "d" then
		elseif xCurrent - event.x <= -160 and movimiento == "d" then
			transition.to( event.target, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( nextSv, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( previousSv, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = posicionMenu + 166, time = 400, transition = easing.outExpo } )
			
			if previousSv == nil then 
				transition.to( event.target, { x = 240, time = 400, transition = easing.outExpo } )
				transition.to( groupMenu, { x = posicionMenu, time = 400, transition = easing.outExpo } )
				currentTxt:setFillColor( 0 )
			else
				previousTxt:setFillColor( 0 )
				currentSv = previousSv
			end
			
			if event.target.name == "scrViewEventos" then
				btnModal.name = ""
			elseif event.target.name == "scrViewDeals" then
				btnModal.name = "EVENTOS"
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
	
	if event.phase == "cancelled" then
	end
	
end

---funcion para cambiar los scroll con un tap
function changeScrollTap( event )

	txtMenuInicio:setFillColor( 161/255, 161/255, 161/255 )
	txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
	txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )

	if event.target.name == "inicio" then
		transition.to( scrViewDeals, { x = 720, time = 400, transition = easing.outExpo } )
		transition.to( scrViewEventos, { x = 720, time = 400, transition = easing.outExpo } )
		transition.to( scrViewMain, { x = 240, time = 400, transition = easing.outExpo } )
		transition.to( groupMenu, { x = 0, time = 400, transition = easing.outExpo } )
		currentSv = scrViewMain
		btnModal.name = ""
		txtMenuInicio:setFillColor( 0 )
		showFilter(false)
	elseif event.target.name == "eventos" then
		transition.to( scrViewMain, { x = -240, time = 400, transition = easing.outExpo } )
		transition.to( scrViewDeals, { x = 720, time = 400, transition = easing.outExpo } )
		transition.to( scrViewEventos, { x = 240, time = 400, transition = easing.outExpo } )
		transition.to( groupMenu, { x = -166, time = 400, transition = easing.outExpo } )
		currentSv = scrViewEventos
		btnModal.name = "EVENTOS"
		txtMenuEventos:setFillColor( 0 )
		showFilter(true)
	elseif event.target.name == "deals" then
		transition.to( scrViewMain, { x = -240, time = 400, transition = easing.outExpo } )
		transition.to( scrViewEventos, { x = -240, time = 400, transition = easing.outExpo } )
		transition.to( scrViewDeals, { x = 240, time = 400, transition = easing.outExpo } )
		transition.to( groupMenu, { x = -332, time = 400, transition = easing.outExpo } )
		currentSv = scrViewDeals
		btnModal.name = "DEALS"
		txtMenuDeals:setFillColor( 0 )
		showFilter(true)
	end
end

---------------------------------------------------
--------- funciones
---------------------------------------------------

-- Ocultamos o Mostramos filtro
function showFilter(boolShow)
    if boolShow and btnModal.alpha == 0 then
        transition.to( btnModal, { alpha = 1, time = 400 } )
    elseif not (boolShow) and btnModal.alpha == 1 then
        transition.to( btnModal, { alpha = 0, time = 400 } )
    end
end

function getFBData()
		local sizeAvatar = 'width=140&height=140'
        
		contenerUser = display.newContainer( display.contentWidth * 2, 350 )
		contenerUser.x = 0
		contenerUser.y = 0
		scrViewMain:insert( contenerUser )
		
		if settings.fbId == "" then
            local mask = graphics.newMask( "img/bgk/maskBig.jpg" )
			local avatar = display.newImage( "img/bgk/user.png" )
            avatar:setMask( mask )
			avatar.x = 110
            avatar.y = 90
            avatar.width = 140
            avatar.height  = 140
			contenerUser:insert(avatar)
		else
			local path = system.pathForFile( "avatarFb"..settings.fbId, system.TemporaryDirectory )
			local fhd = io.open( path )
			if fhd then
				fhd:close()
                local mask = graphics.newMask( "img/bgk/maskBig.jpg" )
				local avatar = display.newImage("avatarFb"..settings.fbId, system.TemporaryDirectory )
                avatar:setMask( mask )
				avatar.x = 110
				avatar.y = 90
                avatar.width = 140
                avatar.height  = 140
				contenerUser:insert(avatar)
			else
				local function networkListenerFB( event )
					-- Verificamos el callback activo
					if ( event.isError ) then
					else
                        local mask = graphics.newMask( "img/bgk/maskBig.jpg" )
						event.target:setMask( mask )
                        event.target.x = 110
                        event.target.y = 90
                        event.target.height = 140
                        event.target.width = 140
						contenerUser:insert( event.target )
					end
				end
				display.loadRemoteImage( "http://graph.facebook.com/".. settings.fbId .."/picture?type=large&"..sizeAvatar, 
					"GET", networkListenerFB, "avatarFb"..settings.fbId, system.TemporaryDirectory )
			end
		end
    
    local textSaludo = display.newText( {
		text = "HOLA!",     
		x = 375, y = 65,
		width = 350, height =20,
		font = "Lato-Regular",  fontSize = 16, align = "left"
	})
	textSaludo:setFillColor( .3 )
	contenerUser:insert(textSaludo)
		
	local textNombre = display.newText( {
		text = settings.name,     
		x = 375, y = 90,
		width = 350, height = 30,
		font = "Lato-Bold",  fontSize = 30, align = "left"
	})
	textNombre:setFillColor( 0 )
	contenerUser:insert(textNombre)
	if settings.fbId == "" then
		textNombre.text = settings.email
	end
		
	local textMsg = display.newText( {
		text = "RECIBE DEALS ÚNICOS, CONSULTA EVENTOS ESPECIALES Y MÁS",     
		x = 375, y = 120,
		width = 350, height =12,
		font = "Lato-Regular",  fontSize = 8, align = "left"
	})
	textMsg:setFillColor( .3 )
	contenerUser:insert(textMsg)
	
end

function openModal( event )
	Modal(btnModal.name)
	return true
end	

function openModalTouch( event )
	return true
end

--obtenemos el grupo homeScreen de la escena actual
function getSceneSearchH( event )
	--modalSeach(txtSearch.text)
	SearchText(homeScreen)
	return true
end

---------------------------------------------------------------------------------
-- DEFAULT METHODS
---------------------------------------------------------------------------------

function scene:createScene( event )
	
	screen = self.view
	
	screen:insert(homeScreen)
	screen:insert(grupoModal)
	screen:insert(groupSearchModal)
	
	local bg = display.newRect( 0, h, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 1 )
	homeScreen:insert(bg)
	
    -- Build Component Header
	local header = Header:new()
    homeScreen:insert(header)
    header.y = h
    header:buildToolbar()
    local hWB = header:buildWifiBle()
        
	svMenuTxt = widget.newScrollView
	{
		x = 240,
		y = h + 92 + hWB,
		width = intW,
		height = 65,
		scrollHeight = 10,
		--listener = ListenerChangeMenuHome,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = true,
		backgroundColor = { .87 }
	}
	homeScreen:insert(svMenuTxt)
	
	local greenLine = display.newImage( "img/btn/greenLine.png" )
	greenLine:translate( display.contentWidth * .5, 123 + h + hWB)
	homeScreen:insert(greenLine)
	
	scrViewMain = widget.newScrollView
	{
		top = h + 125 + hWB,
		--top = 500,
		left = 0,
		width = display.contentWidth,
		height = intH - (h + 125 + hWB),
		listener = ListenerChangeScrollHome,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = false,
		backgroundColor = { .92 }
	}
	homeScreen:insert(scrViewMain)
	scrViewMain.name = "scrViewMain"
	
	scrViewEventos = widget.newScrollView
	{
		top = h + 125 + hWB,
		left = 480,
		width = intW,
		height = intH - (h + 125 + hWB),
		listener = ListenerChangeScrollHome,
		backgroundColor = { .92 }
	}
	homeScreen:insert(scrViewEventos)
	scrViewEventos.name = "scrViewEventos"
    
	scrViewDeals = widget.newScrollView
	{
		top = h + 125 + hWB,
		left = 480,
		width = intW,
		height = intH - (h + 125 + hWB),
		listener = ListenerChangeScrollHome,
		backgroundColor = { .92 }
	}
	homeScreen:insert(scrViewDeals)
	scrViewDeals.name = "scrViewDeals"
	
	groupInicio = display.newGroup()
	scrViewMain:insert(groupInicio)
	groupEvent = display.newGroup()
	scrViewEventos:insert(groupEvent)
	groupDeals = display.newGroup()
	scrViewDeals:insert(groupDeals)
	
	groupMenu = display.newGroup()
	svMenuTxt:insert(groupMenu)
	
	txtMenuInicio = display.newText( {    
        x = display.contentWidth * .5, y = 30,
        text = "INICIO",  font = "Lato-Light", fontSize = 18,
	})
	txtMenuInicio:setFillColor( 0 )
	groupMenu:insert(txtMenuInicio)
	txtMenuInicio.name = "inicio"
	txtMenuInicio:addEventListener("tap", changeScrollTap)
	
	txtMenuEventos = display.newText( {
        x = display.contentWidth * .85, y = 30,
        text = "EVENTOS", font = "Lato-Light", fontSize = 18,
	})
	txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )
	groupMenu:insert(txtMenuEventos)
	txtMenuEventos.name = "eventos"
	txtMenuEventos:addEventListener("tap", changeScrollTap)
	
	txtMenuDeals = display.newText( {
        x = display.contentWidth * 1.2, y = 30,
        text = "DEALS", font = "Lato-Light", fontSize = 18,
	})
	txtMenuDeals:setFillColor( 161/255, 161/255, 161/255 )
	groupMenu:insert(txtMenuDeals)
	txtMenuDeals.name = "deals"
	txtMenuDeals:addEventListener("tap", changeScrollTap)
	
	local grupoSeparadorEventos = display.newGroup()
	scrViewMain:insert(grupoSeparadorEventos)
	
	currentSv = scrViewMain
	
	settings = DBManager.getSettings()
		
	btnModal = display.newImage( "img/btn/btnFilter.png" )
	btnModal:translate( intW - 50, intH - 50)
	btnModal.alpha = 0
	btnModal.name = ""
	homeScreen:insert(btnModal)
	btnModal:addEventListener( "tap", openModal )
	btnModal:addEventListener( "touch", openModalTouch )
	
	btnModal:toFront()
    clearTempDir()
	getLoading(scrViewMain)
	
	if networkConnection() then
		getFBData()
		RestManager.getBeacons()
		RestManager.getRecommended()
	end
	
	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
	
	if settings.tutorial == 1 then
		DBManager.updateTutorial()
		createTutorial(homeScreen)
	end
    
    -- Registramos uso del app
    RestManager.initApp()
    
    -- Para IOS envia actualizaciones de lealtad a comercios
    local platformName = system.getInfo( "platformName" )
    if platformName == "iPhone OS" then
        local lealtad = DBManager.lealtad()
        for y = 1, #lealtad, 1 do 
            RestManager.lealtad(lealtad[y].major, lealtad[y].fecha)
        end
    end
	
end
	
-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scene[1] = storyboard.getCurrentSceneName()
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