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
--require('src.BuildRow')
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local RestManager = require('src.resources.RestManager')
local DBManager = require('src.resources.DBManager')
local Sprites = require('src.resources.Sprites')
local widget = require( "widget" )
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local h = display.topStatusBarContentHeight
local lastY = 200

--[[local toolbar, menu
local groupMenu, groupEvent, groupMenuEventText, grpRedem
local svCoupon, svInfo, svPromotions, svGallery, sprCheck
local h = display.topStatusBarContentHeight

local lastYCoupon = 0
local itemObj
local currentSv
local settings
local rctBtn, rctBtnB
local FlagCoupon = 0
local imgBtnShare, imgBtnShareB
local hWCup = 0]]

--[[local txtInfo, txtBtn, txtTitleInfo, loadingRed, rctRed, txtRed
local info, promotions, gallery, MenuEventBar, txtInfoRedimir2
local btnDownloadCoupon]]

--pantalla

local codeScreen = display.newGroup()
local txtFieldReedirCode, rctBtnRC, rctBtnBRC, txtBtnRC

----------------------------------------------------------
-- Funciones
----------------------------------------------------------

--obtenemos el homeScreen de la escena
function getScreenRC()
	return codeScreen
end

--redime el codigo
function changeCodeC( event )
	--RestManager.redeemCodePromoter(txtFieldReedirCode.text)
	if txtFieldReedirCode.text ~= '' or txtFieldReedirCode.text ~= " " then
		RestManager.redeemCodePromoter(txtFieldReedirCode.text)
		txtFieldReedirCode.text = ''
	else
		native.showAlert( "Go Deals", 'Campo vacio. Ingrese un codigo de deals', { "OK" })
	end
	native.setKeyboardFocus(nil)
end
	
-- Descargar Deal
function showDealsRedeem()
        
	-- Play Sound
	timer.performWithDelay(500, function() 
		audio.play( fx )
	end, 1)
        
	-- Creamos anuncio
	local midW = display.contentWidth / 2
	local midH = display.contentHeight / 2
	groupDownloadCode = display.newGroup()
        
	local bgShade = display.newRect( midW, midH, display.contentWidth, display.contentHeight )
	bgShade:setFillColor( 0, 0, 0, .3 )
	groupDownloadCode:insert(bgShade)
        
	local bg = display.newRoundedRect( midW, midH, 280, 300, 10 )
	bg:setFillColor( .3, .3, .3 )
	groupDownloadCode:insert(bg)
        
	-- Sprite and text
	local sheet = graphics.newImageSheet(Sprites.down.source, Sprites.down.frames)
	local sprite = display.newSprite(sheet, Sprites.down.sequences)
	sprite.x = midW
	sprite.y = midH - 40
	groupDownloadCode:insert(sprite)
        
	local txt1 = display.newText( {
		text = "DEAL Descargado",
		x = midW, y = midH + 60,
		align = "center", width = 200,
		font = "Lato-Bold", fontSize = 24
	})
	groupDownloadCode:insert(txt1)
        
	local txt2 = display.newText( {
		text = "Consulta tus descargas",
		x = midW, y = midH + 95,
		align = "center", width = 200,
		font = "Lato-Bold", fontSize = 16
	})
	groupDownloadCode:insert(txt2)
        
	sprite:setSequence("play")
	sprite:play()
        
	transition.to( groupDownloadCode, { alpha = 0, time = 400, delay = 2000, transition = easing.outExpo } )
        
	return true
end

function onTxtFocusCode(event)
    if ( "submitted" == event.phase ) then
		changeCodeC()
    end
end

----------------------------------------------------------
-- Funciones Default
----------------------------------------------------------

function scene:createScene( event )

	screen = self.view
	screen:insert(codeScreen)
	
	local bg = display.newRect( 0, h, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 245/255, 245/255, 245/255 )
	codeScreen:insert(bg)
	
	-- Build Component Header
	local header = Header:new()
    codeScreen:insert(header)
    header.y = h
    header:buildToolbar()
    header:buildNavBar("Codigo")
    hWPL = 5 + header:buildWifiBle()
	
	local txtReedirCode = display.newText({
		text = "Codigo a redimir",
		x = 230, y = 600,
		x = midW, y = lastY + 15,
		width = 400,
		font = "Lato-Regular", fontSize = 24, align = "center"
	})
	txtReedirCode:setFillColor( 0 )
	codeScreen:insert(txtReedirCode)
	
	local bgReedirCode = display.newImage("img/btn/txtEmail.png", true) 
    bgReedirCode.x = midW
    bgReedirCode.y = midH - 100
    codeScreen:insert(bgReedirCode)
	
	txtFieldReedirCode = native.newTextField( midW, midH - 100, 380, 60 )
    txtFieldReedirCode.method = "code"
    txtFieldReedirCode.inputType = "text"
    txtFieldReedirCode.hasBackground = false
    txtFieldReedirCode:addEventListener( "userInput", onTxtFocusCode )
	txtFieldReedirCode:setReturnKey(  "send"  )
	codeScreen:insert(txtFieldReedirCode)
	
	rctBtnRC = display.newRoundedRect( 240, lastY + 250, 210, 55, 5 )
	--rctBtn.idCoipon = itemObj.id
	rctBtnRC:setFillColor( .2, .6, 0 )
	codeScreen:insert(rctBtnRC)
	rctBtnRC:addEventListener( 'tap', changeCodeC )
	
	rctBtnBRC = display.newRoundedRect( 240, lastY + 268, 210, 22, 5 )
    rctBtnBRC:setFillColor( {
        type = 'gradient',
        color1 = { .2, .6, 0 }, 
        color2 = { .1, .5, 0 },
        direction = "bottom"
    } ) 
    codeScreen:insert(rctBtnBRC)

	txtBtnRC = display.newText( {
		text =  "Redimir codigo",
		x = 240, y = lastY + 250,
		width = 210, height = 0,
		font = "Lato-Bold", fontSize = 18, align = "center"
	})
	txtBtnRC:setFillColor( 1 )
	codeScreen:insert(txtBtnRC)
	
    
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scene[#Globals.scene + 1] = storyboard.getCurrentSceneName()
	settings = DBManager.getSettings()
end

-- Remove Listener
function scene:exitScene( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene