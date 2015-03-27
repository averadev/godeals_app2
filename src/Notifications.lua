---------------------------------------------------------------------------------
-- Godeals App
-- Alfredo Chi
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- REQUIRE & VARIABLES
---------------------------------------------------------------------------------

require('src.Menu')
require('src.BuildRow')
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local RestManager = require('src.resources.RestManager')
local widget = require( "widget" )
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local toolbar, menu
local groupMenu, svContent
local h = display.topStatusBarContentHeight
local lastY = 200;
local itemObj

local info, promotions, gallery, MenuEventBar
local homeScreen = display.newGroup()

-- Arreglos
local elements = {}
local imageItems = {}
local noLeido = {}

---------------------------------------------------------------------------------
-- Setters
---------------------------------------------------------------------------------
function setNotificationsElements(items)
    elements = items
	if #elements > 0 then
		loadNotificationsImage({posc = 1})
	else
		endLoading(svContent)
		getNoContent(svContent, "En este momento no cuentas con notificaciones")
	end
end

---------------------------------------------------------------------------------
-- FUNCIONES
---------------------------------------------------------------------------------

--obtenemos el grupo homeScreen de la escena actual
function getSceneSearchN( event )
	SearchText(homeScreen)
	return true
end

--obtenemos el homeScreen de la escena
function getScreenN()
	return homeScreen
end

------marca como leido la notificaciones

function markRead( event )


	if elements[event.target.posci].leido == "1" then
	
		elements[event.target.posci].leido = 0
	
		for y = 1, #Globals.txtBubble, 1 do
		
			if Globals.txtBubble[y].text ~= nill then
				if Globals.txtBubble[y].text == "1" then
					Globals.txtBubble[y]:removeSelf()
					Globals.notBubble[y]:removeSelf()
				else
					Globals.txtBubble[y].text = Globals.txtBubble[y].text - 1
				end
			end
		end
		noLeido[event.target.posci]:removeSelf()
		RestManager.notificationRead( elements[event.target.posci].idNotification )
	end

end

---------------------------------------------
-----mostrar las notificaciones
---------------------------------------------

-- Carga de la imagen del servidor o de TemporaryDirectory
function loadNotificationsImage(obj)

    -- Determinamos si la imagen existe
    local path = system.pathForFile( elements[obj.posc].image, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
        imageItems[obj.posc] = display.newImage( elements[obj.posc].image, system.TemporaryDirectory )
        imageItems[obj.posc].alpha = 0
        if obj.posc < #elements then
            obj.posc = obj.posc + 1
            loadNotificationsImage(obj)
        else
            buildNotificationsItems(obj.screen)
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
                    loadNotificationsImage(obj)
                else
                    buildNotificationsItems(obj.screen)
                end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url..elements[obj.posc].path..elements[obj.posc].image, 
        "GET", loadImageListener, elements[obj.posc].image, system.TemporaryDirectory ) 
    end
end

function buildNotificationsItems(objScreen)

    yMain = 50
	endLoading(svContent)
	
    local separadorEventos = display.newImage( "img/btn/btnArrowGreen.png" )
    separadorEventos:translate( 41, yMain -3)
    separadorEventos.isVisible = true
    svContent:insert(separadorEventos)

    local textSeparadorEventos = display.newText( {
        text = "ESTAS SON TUS NOTIFICACIONES.",     
        x = 300, y = yMain, width = intW, height = 20,
        font = "Lato-Regular", fontSize = 14, align = "left"
    })
    textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
    svContent:insert(textSeparadorEventos)
	
    yMain = yMain + 30
    for y = 1, #elements, 1 do
	
        -- Create container
		if elements[y].tipo == "1" then
		
			local evento = Event:new()
            svContent:insert(evento)
            evento:build(true, elements[y], imageItems[y])
            evento.y = yMain
			evento.id = elements[y].idRelacional
			evento.posci = y
			evento:addEventListener('tap', markRead)
			yMain = yMain + 120
		
		elseif elements[y].tipo == "2" then
		
			local deal = Deal:new()
			svContent:insert(deal)
			deal:build(true, elements[y], imageItems[y])
			deal.y = yMain
			deal.id = elements[y].idRelacional
			deal.posci = y
			deal:addEventListener('tap', markRead)
			yMain = yMain + 120
		
		end
		
		if elements[y].leido == "1" then
            noLeido[y] = display.newRect( 0, h, 2, 110 )
            noLeido[y].x = 10
            noLeido[y].y = yMain - 60
            noLeido[y]:setFillColor( .18, .59, 0 )
            svContent:insert(noLeido[y])
		end
		
    end
	
	svContent:setScrollHeight(yMain + 20)
	
end

function scene:createScene( event )
	screen = self.view
	screen:insert(homeScreen)
	
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
    header:buildNavBar("Notificaciones")
	
    svContent = widget.newScrollView
	{
		top = h + 125,
		left = 0,
		width = intW,
		height = intH - (h + 125),
		horizontalScrollDisabled = true,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(svContent)
	getLoading(svContent)
	RestManager.getNotifications()
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scene[#Globals.scene + 1] = storyboard.getCurrentSceneName()
end

-- Remove Listener
function scene:exitScene( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene