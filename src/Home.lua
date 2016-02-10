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


local settings = DBManager.getSettings()

lengHome = settings.language

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
local imageLogos = {}
local isSvLoaded = {false, false}

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

--funcion que entra cuando no se encuentran deals cupones
function getNoItemsHome(src)

	local imgNoItemsHome = display.newImage( "img/btn/noData.png" )
	imgNoItemsHome.x = display.contentWidth / 2
	imgNoItemsHome.y = intH/3.7
		
	local txtNoItemsHome = display.newText( {
		--text = Globals.language.homeNoFilterEvent, 
		text = "No items",		
		x = intW/2, y = intH/2.5,
		width = intW,
		font = "Lato-Regular",  fontSize = 16, align = "center"
	})
	txtNoItemsHome:setFillColor( 0 )
	
	if src == "home" then
		groupInicio:insert(txtNoItemsHome)
		groupInicio:insert(imgNoItemsHome) 
		txtNoItemsHome.text = Globals.language.homeNoItemsHome
	elseif src == "deals" then
		groupDeals:insert(txtNoItemsHome)
		groupDeals:insert(imgNoItemsHome) 
		txtNoItemsHome.text = Globals.language.homeNoItemsDeals
	elseif src == "events" then
		groupEvent:insert(txtNoItemsHome)
		groupEvent:insert(imgNoItemsHome) 
		txtNoItemsHome.text = Globals.language.homeNoItemsEvents
	end
	
	
	endLoading()
	
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
function loadImageLogos(obj)
    -- Determinamos si la imagen existe
    if elements[obj.posc].rowType == 'deal' then
        local path = system.pathForFile( elements[obj.posc].partnerImage, system.TemporaryDirectory )
        local fhd = io.open( path )
        if fhd then
            fhd:close()
            if elements[obj.posc].callback == Globals.noCallbackGlobal then
                imageLogos[obj.posc] = display.newImage( elements[obj.posc].partnerImage, system.TemporaryDirectory )
                imageLogos[obj.posc].alpha = 0
                if obj.posc < #elements then
                    obj.posc = obj.posc + 1
                    loadImageLogos(obj)
                else
                    loadImage({posc = 1, screen = 'MainScreen'})
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
                        imageLogos[obj.posc] = event.target
                        if obj.posc < #elements then
                            obj.posc = obj.posc + 1
                            loadImageLogos(obj)
                        else
                            loadImage({posc = 1, screen = 'MainScreen'})
                        end
                    end
                end
            end
            -- Descargamos de la nube
            display.loadRemoteImage( settings.url..elements[obj.posc].partnerPath..elements[obj.posc].partnerImage, 
            "GET", loadImageListener, elements[obj.posc].partnerImage, system.TemporaryDirectory ) 
        end
    else
        if obj.posc < #elements then
            obj.posc = obj.posc + 1
            loadImageLogos(obj)
        else
            loadImage({posc = 1, screen = 'MainScreen'})
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
	   
        yMain = 60
        for y = 1, #elements, 1 do 
            -- Create event
            if elements[y].rowType == 'deal' then
                local deal = DealMain:new()
                groupInicio:insert(deal)
                deal:build(false, elements[y], imageItems[y], imageLogos[y])
                deal.y = yMain
                yMain = yMain + 220
            end
        end
        
        local btnNexTab = display.newImage( "img/btn/btnNexTab.png" )
        btnNexTab:translate( intW/2, yMain + 10)
        btnNexTab.name = 'deals'
        btnNexTab:addEventListener("tap", changeScrollTap)
        groupInicio:insert( btnNexTab )
        
        local txtNoFilterFound = display.newText( {
			text = Globals.language.homeMoreItems,     
			x = 235, y = yMain + 8,
			width = 400,
			font = "Lato-Regular",  fontSize = 24, align = "left"
		})
		txtNoFilterFound:setFillColor( 1 )
		groupInicio:insert(txtNoFilterFound)
        
		endLoading()
		scrViewMain:setScrollHeight(yMain + 70)
        
    elseif screen == "DealPanel" then
	
		scrViewDeals:scrollTo( "top", { time=400 } )
	
		groupDeals:removeSelf()
		groupDeals = nil
		groupDeals = display.newGroup()
		scrViewDeals:insert(groupDeals)
        
        local lastY = 40
        local currentMonth = 0
        for y = 1, #elements, 1 do 
            
            -- Create container
            local deal = Deal:new()
            groupDeals:insert(deal)
            deal:build(true, elements[y], imageItems[y])
            deal.y = lastY
            
            lastY = lastY + 180
        end
        
		isSvLoaded[1] = true
        endLoading()
		scrViewDeals:setScrollHeight(lastY)
        
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
					if lengHome == "es" then
						title:build(Globals.Months[currentMonth].." del "..k)
					else
						title:build(Globals.Months_en[currentMonth].." of "..k)
					end
                    title.y = lastY
                    lastY = lastY + 100
                end
            end
            
            -- Create noCallback = noCallback + 1
            local evento = Event:new()
            groupEvent:insert(evento)
            evento:build(true, elements[y], imageItems[y])
            evento.y = lastY
            
            lastY = lastY + 180
        end
		
        isSvLoaded[2] = true
        endLoading()
		scrViewEventos:setScrollHeight(lastY)
        
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
					if lengHome == "es" then
						title:build(Globals.Months[currentMonth].." del "..k)
					else
						title:build(Globals.Months_en[currentMonth].." of "..k)
					end
                   -- title:build(Globals.Months[currentMonth].." del "..k)
                    title.y = lastY
                    lastY = lastY + 100
                end
            end
            
            -- Create noCallback = noCallback + 1
            local evento = Event:new()
            groupEvent:insert(evento)
            evento:build(true, elements[y], imageItems[y])
            evento.y = lastY
            
            lastY = lastY + 180
        end
		
	elseif screen == "noFilterEvent" then
	
		groupEvent:removeSelf()
		groupEvent = nil
		groupEvent = display.newGroup()
		scrViewEventos:insert(groupEvent)
		
		local txtNoFilterFound = display.newText( {
			text = Globals.language.homeNoFilterEvent,     
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
			text = Globals.language.homeNoFilterDeals,     
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
		if lengHome == "es" then
			--title:build(Globals.Months[currentMonth].." del "..k)
			fecha = u .. " de "..Globals.Months[tonumber(v)].." de " .. k
		else
			--title:build(Globals.Months_en[currentMonth].." of "..k)
			fecha = u .. " "..Globals.Months_en[tonumber(v)]..", " .. k
		end
    end
    return fecha
end

--obtenemos el homeScreen de la escena
function getScreenH()
	return homeScreen
end

function svLoaded(no)
    if not (isSvLoaded[no]) then
        if no == 1 then
            getLoading(scrViewDeals)
            RestManager.getAllCoupon()
        else
            getLoading(scrViewEventos)
            RestManager.getAllEvent()
        end
    end
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
	
	isSvLoaded[1] = false
	isSvLoaded[2] = false
	
	--[[scrViewMain, scrViewEventos, scrViewDeals]]
	
	returnHome()
	
	transition.to( scrViewDeals, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( scrViewMain, { x = 240, time = 400, transition = easing.outExpo } )
	transition.to( scrViewEventos, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( groupMenu, { x = 0, time = 400, transition = easing.outExpo } )
	
	showFilter(false)
	
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
		text = Globals.language.homeNoConection,     
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
		RestManager.getBeacons()
		RestManager.getRecommended()
	end
	
end

---------------------------------------------------------------------------------
-- LISTENERS
---------------------------------------------------------------------------------


--- scrollView functions

function ListenerChangeScrollHome( event )

	scrViewMain:setScrollWidth(480)

	local nextSv
	local previousSv
	local posicionMenuGroup
	local currentTxt, nextTxt, previousTxt
	
	if event.target.name == "scrViewMain" then
		nextSv = scrViewDeals
		currentTxt = txtMenuInicio
		nextTxt = txtMenuDeals
	elseif event.target.name == "scrViewDeals" then
		nextSv = scrViewEventos
		previousSv = scrViewMain
		currentTxt = txtMenuDeals
		nextTxt = txtMenuEventos
		previousTxt = txtMenuInicio
	elseif event.target.name == "scrViewEventos" then
		previousSv = scrViewDeals
		currentTxt = txtMenuEventos
		previousTxt = txtMenuDeals
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
				btnModal.name = "DEALS"
                svLoaded(1)
			elseif event.target.name == "scrViewDeals" then
				btnModal.name = "EVENTOS"
                svLoaded(2)
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
				btnModal.name = "DEALS"
			elseif event.target.name == "scrViewDeals" then
				btnModal.name = ""
			end
			
            if event.target.name == "scrViewDeals" then
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
	elseif event.target.name == "deals" then
		transition.to( scrViewMain, { x = -240, time = 400, transition = easing.outExpo } )
		transition.to( scrViewDeals, { x = 240, time = 400, transition = easing.outExpo } )
		transition.to( scrViewEventos, { x = 720, time = 400, transition = easing.outExpo } )
		transition.to( groupMenu, { x = -166, time = 400, transition = easing.outExpo } )
		currentSv = scrViewDeals
		btnModal.name = "DEALS"
		txtMenuDeals:setFillColor( 0 )
        svLoaded(1)
		showFilter(true)
	elseif event.target.name == "eventos" then
		transition.to( scrViewMain, { x = -240, time = 400, transition = easing.outExpo } )
		transition.to( scrViewEventos, { x = 240, time = 400, transition = easing.outExpo } )
		transition.to( scrViewDeals, { x = -240, time = 400, transition = easing.outExpo } )
		transition.to( groupMenu, { x = -332, time = 400, transition = easing.outExpo } )
		currentSv = scrViewEventos
		btnModal.name = "EVENTOS"
		txtMenuEventos:setFillColor( 0 )
        svLoaded(2)
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

function openModal( event )
	modalActive = 'Filter'
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
    local hWB = 20 + header:buildWifiBle()
        
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
    
    local toolbarMenu = display.newRect( 240, 33, 150, 63 )
    toolbarMenu:setFillColor( 1 )
    svMenuTxt:insert(toolbarMenu)
    
    local greenLine = display.newRect( 240, 64, 150, 2 )
    greenLine.alpha = 1
    greenLine:setFillColor( 50/255, 150/255, 0 )
    svMenuTxt:insert(greenLine)
	
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
	
	endLoading()
	
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
        text = Globals.language.homeInicio,  font = "Lato-Heavy", fontSize = 22,
	})
	txtMenuInicio:setFillColor( 0 )
	groupMenu:insert(txtMenuInicio)
	txtMenuInicio.name = "inicio"
	txtMenuInicio:addEventListener("tap", changeScrollTap)
	
	txtMenuEventos = display.newText( {
        x = display.contentWidth * 1.2, y = 30,
        text = Globals.language.homeEvent, font = "Lato-Heavy", fontSize = 22,
	})
	txtMenuEventos:setFillColor( 161/255, 161/255, 161/255 )
	groupMenu:insert(txtMenuEventos)
	txtMenuEventos.name = "eventos"
	txtMenuEventos:addEventListener("tap", changeScrollTap)
	
	txtMenuDeals = display.newText( {
        x = display.contentWidth * .85, y = 30,
        text = Globals.language.homeDeals, font = "Lato-Heavy", fontSize = 22,
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