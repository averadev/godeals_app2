---------------------------------------------------------------------------------
-- Godeals App
-- Alfredo Chi
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- REQUIRE & VARIABLES
---------------------------------------------------------------------------------

require('src.Menu')
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

local svAdd, groupAdd, bgAdd, lastY
local h = display.topStatusBarContentHeight
local callbackCurrent = 0
local homeScreen = display.newGroup()

-- funciones
function showPartner( event )
	storyboard.removeScene( "src.Partner" )
	storyboard.gotoScene( "src.Partner", {
		time = 400,
		effect = "crossFade",
		params = { idPartner = event.target.item.partnerId, name = event.target.item.name }
	})
end

------ cargamos logo
function loadLogoAdd(imageName)
     -- Determinamos si la imagen existe
    local path = system.pathForFile( imageName, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		if callbackCurrent == Globals.noCallbackGlobal then
			local imgEvent = display.newImage( imageName, system.TemporaryDirectory )
            imgEvent:translate( 50, 55)
            imgEvent.width = 55
            imgEvent.height = 55
            svAdd:insert( imgEvent )
		end
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImageListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
				if callbackCurrent == Globals.noCallbackGlobal then
                    event.target:translate( 50, 55)
                    event.target.width = 55
                    event.target.height = 55
                    svAdd:insert( event.target )
                else
                    event.target:removeSelf()
                    event.target = nil
				end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url .. "assets/img/app/partner/image/" .. imageName, 
        "GET", loadImageListener, imageName, system.TemporaryDirectory ) 
    end
end

------cargamos las imagen full
function loadImageAdd(imageName)
     -- Determinamos si la imagen existe
    local path = system.pathForFile( imageName, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		if callbackCurrent == Globals.noCallbackGlobal then
			local imgEvent = display.newImage( imageName, system.TemporaryDirectory )
            imgEvent.x = midW
            imgEvent.anchorY = 0
            imgEvent.y = 100
            svAdd:insert( imgEvent )
            groupAdd.y = imgEvent.height
            bgAdd.height = groupAdd.height + groupAdd.y + 110
            svAdd:setScrollHeight(groupAdd.height + groupAdd.y + 150)
		end
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImageListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
				if callbackCurrent == Globals.noCallbackGlobal then
				    event.target.x = midW
                    event.target.anchorY = 0
                    event.target.y = 100
                    svAdd:insert( event.target )
                    groupAdd.y = event.target.height
                    bgAdd.height = groupAdd.height + groupAdd.y + 110
                    svAdd:setScrollHeight(groupAdd.height + groupAdd.y + 150)
                else
                    event.target:removeSelf()
                    event.target = nil
				end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url .. "assets/img/app/message/" .. imageName, 
        "GET", loadImageListener, imageName, system.TemporaryDirectory ) 
    end
end

function showAdd(item)
    lastY = 120
    -- Agregamos textos
    local txtPartner0 = display.newText( {
        text = Globals.language.partnerWTxtPartner0 ..item.name.."!",     
        x = 260, y = 55,
        width = 340,
        font = "Lato-Heavy", fontSize = 16, align = "left"
    })
    txtPartner0:setFillColor( 0 )
    svAdd:insert(txtPartner0)
    
    
	local bgGeneralInformacion = display.newRect( midW, lastY, 440, 150 )
	bgGeneralInformacion:setFillColor( 1 )
	groupAdd:insert(bgGeneralInformacion)
    
    local txtInfo = display.newText({
		text = item.displayInfo,
		x = midW, y = lastY,
		width = 420,
		font = "Lato-Regular", fontSize = 16, align = "left"
	})
	txtInfo:setFillColor( 0 )
    txtInfo.y = (txtInfo.height / 2) + lastY + 10
	groupAdd:insert( txtInfo )
    
    bgGeneralInformacion.height = txtInfo.height + 40
    bgGeneralInformacion.y = (txtInfo.height / 2) + lastY + 10
    lastY = lastY + bgGeneralInformacion.height + 20
	
	-- Link Comercio
    local rctBtnComer = display.newRoundedRect( 330, lastY, 210, 55, 5 )
	rctBtnComer:setFillColor( .4 )
    rctBtnComer.item = item
	rctBtnComer:addEventListener( "tap", showPartner )
	groupAdd:insert(rctBtnComer)
    
    local rctBtnComerB = display.newRoundedRect( 330, lastY + 15, 210, 22, 5 )
    rctBtnComerB:setFillColor( {
        type = 'gradient',
        color1 = { .4 }, 
        color2 = { .3 },
        direction = "bottom"
    } ) 
    groupAdd:insert(rctBtnComerB)

	local txtBtnComer = display.newText( {
		text =  Globals.language.partnerWTxtBtnComer,
		x = 330, y = lastY,
		width = 210, height = 0,
		font = "Lato-Heavy", fontSize = 18, align = "center"
	})
	txtBtnComer:setFillColor( 1 )
	groupAdd:insert( txtBtnComer )
    
    -- Load Image
    bgAdd.height = rctBtnComer.y + 30
    loadLogoAdd(item.image)
    loadImageAdd(item.displayImage)
end

--obtenemos el homeScreen de la escena
function getScreenWP()
	return homeScreen
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
    header:buildNavBar("")
    local hWBAdd = 5 + header:buildWifiBle()
    settings = DBManager.getSettings()
    
    svAdd = widget.newScrollView
	{
		top = h + 125 + hWBAdd,
		left = 0,
		width = intW,
		height = intH - (h + 125 + hWBAdd),
		listener = scrollListenerContent1,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		backgroundColor = { .96 }
	}
	homeScreen:insert(svAdd)
    
    bgAdd = display.newRect( midW, 20, 460, 200 )
    bgAdd.anchorY = 0
	svAdd:insert(bgAdd)
    
    groupAdd = display.newGroup()
    svAdd:insert(groupAdd)
    
    Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
    RestManager.getAdPartner(event.params.idAd)
    
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
