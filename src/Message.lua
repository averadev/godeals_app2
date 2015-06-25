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

local toolbar, menu, bgMessage, groupInfo, svMessage
local h = display.topStatusBarContentHeight
local lastY = 200;
local lastYImage = lastY;
local itemObj
local settings
local timeMarker
local callbackCurrent = 0
local hWBE = 0
local homeScreen = display.newGroup()

-- funciones
function showPartner( event )
	storyboard.removeScene( "src.Partner" )
	storyboard.gotoScene( "src.Partner", {
		time = 400,
		effect = "crossFade",
		params = { idPartner = itemObj.partnerId, name = itemObj.partner }
	})
end

------cargamos las imagen full
function loadImageMessage(itemObj)
     -- Determinamos si la imagen existe
    local imageName = itemObj.imageFull
    local path = system.pathForFile( imageName, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		if callbackCurrent == Globals.noCallbackGlobal then
			local imgEvent = display.newImage( imageName, system.TemporaryDirectory )
            imgEvent.x = midW
            imgEvent.anchorY = 0
            imgEvent.y = 100
            svMessage:insert( imgEvent )
            groupInfo.y = imgEvent.height
            bgMessage.height = groupInfo.height + groupInfo.y + 110
            svMessage:setScrollHeight(groupInfo.height + groupInfo.y + 150)
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
                    svMessage:insert( event.target )
                    groupInfo.y = event.target.height
                    bgMessage.height = groupInfo.height + groupInfo.y + 110
                    svMessage:setScrollHeight(groupInfo.height + groupInfo.y + 150)
                else
                    event.target:removeSelf()
                    event.target = nil
				end
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url .. itemObj.path .. imageName, 
        "GET", loadImageListener, imageName, system.TemporaryDirectory ) 
    end
end


function scene:createScene( event )
	screen = self.view
	screen:insert(homeScreen)
	
	itemObj = event.params.item
	
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
    header:buildNavBar(itemObj.name)
    hWBE = 5 + header:buildWifiBle()
    settings = DBManager.getSettings()
    
    svMessage = widget.newScrollView
	{
		top = h + 125 + hWBE,
		left = 0,
		width = intW,
		height = intH - (h + 125 + hWBE),
		listener = scrollListenerContent1,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		backgroundColor = { .96 }
	}
	homeScreen:insert(svMessage)
    
    bgMessage = display.newRect( midW, 20, 460, 200 )
    bgMessage.anchorY = 0
	svMessage:insert(bgMessage)
    
    -- Agregamos imagen
    local iconMessage = display.newImage( itemObj.image, system.TemporaryDirectory )
    iconMessage:translate( 50, 55)
    svMessage:insert( iconMessage )

    -- Agregamos textos
    local txtPartner0 = display.newText( {
        text = "De:",     
        x = 260, y = 40,
        width = 340,
        font = "Lato-Bold", fontSize = 16, align = "left"
    })
    txtPartner0:setFillColor( 0 )
    svMessage:insert(txtPartner0)

    local txtPartner = display.newText( {
        text = itemObj.partner,     
        x = 270, y = 40,
        width = 300,
        font = "Lato-Bold", fontSize = 18, align = "left"
    })
    txtPartner:setFillColor( 0 )
    svMessage:insert(txtPartner)

    local txtFecha = display.newText( {
        text = itemObj.fechaFormat,     
        x = 440, y = 35,
        width = 100,
        font = "Lato-Bold", fontSize = 12, align = "left"
    })
    txtFecha:setFillColor( 0 )
    svMessage:insert(txtFecha)

    local txtTitle0 = display.newText( {
        text = "Asunto: ",
        x = 260, y = 70,
        width = 340, height = 0,
        font = "Lato-Bold", fontSize = 16, align = "left"
    })
    txtTitle0:setFillColor( 0 )
    svMessage:insert(txtTitle0)

    local txtTitle = display.newText( {
        text = itemObj.name,
        x = 290, y = 70,
        width = 280, height = 0,
        font = "Lato-Bold", fontSize = 18, align = "left"
    })
    txtTitle:setFillColor( 0 )
    svMessage:insert(txtTitle)
    
	groupInfo = display.newGroup()
    svMessage:insert(groupInfo)
    lastY = 120
    
	local bgGeneralInformacion = display.newRect( midW, lastY, 440, 76 )
	bgGeneralInformacion:setFillColor( 1 )
	groupInfo:insert(bgGeneralInformacion)
    
    local txtInfo = display.newText({
		text = itemObj.detail,
		x = midW, y = lastY,
		width = 420,
		font = "Lato-Regular", fontSize = 16, align = "left"
	})
	txtInfo:setFillColor( 0 )
    txtInfo.y = (txtInfo.height / 2) + lastY + 10
	groupInfo:insert( txtInfo )
    
    bgGeneralInformacion.height = txtInfo.height + 40
    bgGeneralInformacion.y = (txtInfo.height / 2) + lastY + 10
    lastY = lastY + bgGeneralInformacion.height + 20
	
	-- Link Comercio
    local rctBtnComer = display.newRoundedRect( 330, lastY, 210, 55, 5 )
	rctBtnComer:setFillColor( .4 )
	rctBtnComer:addEventListener( "tap", showPartner )
	groupInfo:insert(rctBtnComer)
    
    local rctBtnComerB = display.newRoundedRect( 330, lastY + 15, 210, 22, 5 )
    rctBtnComerB:setFillColor( {
        type = 'gradient',
        color1 = { .4 }, 
        color2 = { .3 },
        direction = "bottom"
    } ) 
    groupInfo:insert(rctBtnComerB)

	local txtBtnComer = display.newText( {
		text =  "IR A COMERCIO",
		x = 330, y = lastY,
		width = 210, height = 0,
		font = "Lato-Bold", fontSize = 18, align = "center"
	})
	txtBtnComer:setFillColor( 1 )
	groupInfo:insert( txtBtnComer )
    
    -- Load Image
    bgMessage.height = rctBtnComer.y + 30
    Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
    loadImageMessage(itemObj)
    
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