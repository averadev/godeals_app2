---------------------------------------------------------------------------------
-- Godeals App
-- Alfredo Chi
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

---------------------------------------------------------------------------------
-- REQUIRE & VARIABLES
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local Sprites = require('src.resources.Sprites')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager2')
local widget = require( "widget" )
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local toolbar, menu, textTitulo1, textTitulo2, textTitulo3, loading, mask
local groupMenu, grupoScroll1
local scrollViewContent1, scrollViewContent2, scrollViewContent3
local imageBusqueda
local imageItems = {}
local coupons = {}
local content1
local noCallback = 0
local noPackage = 1
local loading, titleLoading
local h = display.topStatusBarContentHeight
local lastY = 120;
local settings
local modal, btnModalC, btnModal

--pantalla

local homeScreen = display.newGroup()

-- funciones

local function tapTitulo1(event)
	scrollViewContent1:setScrollWidth(  480 )
	transition.to( scrollViewContent2, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( groupMenu, { x = 0, time = 400, transition = easing.outExpo } )
	transition.to( scrollViewContent3, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( scrollViewContent1, { x = 240, time = 400, transition = easing.outExpo } )
end

local function tapTitulo2(event)
	transition.to( scrollViewContent2, { x = 240, time = 400, transition = easing.outExpo } )
	transition.to( groupMenu, { x = display.contentWidth * - 0.35, time = 400, transition = easing.outExpo } )
	transition.to( scrollViewContent3, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( scrollViewContent1, { x = -240, time = 400, transition = easing.outExpo } )
end

local function tapTitulo3(event)
	transition.to( scrollViewContent3, { x = 240, time = 400, transition = easing.outExpo } )
	transition.to( groupMenu, { x = display.contentWidth * - 0.70, time = 400, transition = easing.outExpo } )
	transition.to( scrollViewContent2, { x = -240, time = 400, transition = easing.outExpo } )
end

function returnHome( event )
	storyboard.gotoScene( "src.Home", {
        time = 400,
        effect = "crossFade"
    })
end

function scene:createScene( event )
	screen = self.view
	
	screen:insert(homeScreen)
	
	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 1 )	-- white
	homeScreen:insert(bg)
	
	toolbar = display.newRect( 0, h, display.contentWidth, 55 )
	toolbar.anchorX = 0
	toolbar.anchorY = 0
	toolbar:setFillColor( 221/255, 236/255, 241/255 )	-- red
	homeScreen:insert(toolbar)
	
	local grupoToolbar = display.newGroup()
	grupoToolbar.y = h + 5
	homeScreen:insert(grupoToolbar)
	
	local logo = display.newImage( "img/btn/logoGo.png" )
	logo:translate( 80, 25 )
	logo.isVisible = true
	logo.height = 35
	logo.width = 140
	grupoToolbar:insert(logo)
	
	local btnSearch = display.newImage( "img/btn/btnSearch.png" )
	btnSearch:translate( display.contentWidth - 150, 25 )
	btnSearch.isVisible = true
	btnSearch.height = 60
	btnSearch.width = 60
	grupoToolbar:insert(btnSearch)
	
	local btnMensaje = display.newImage( "img/btn/btnMessage.png" )
	btnMensaje:translate( display.contentWidth - 100, 25 )
	btnMensaje.isVisible = true
	btnMensaje.height = 40
	btnMensaje.width = 40
	grupoToolbar:insert(btnMensaje)
	
	local btnHerramienta = display.newImage( "img/btn/tool.png" )
	btnHerramienta:translate( display.contentWidth - 50, 25 )
	btnHerramienta:setFillColor( 1, 1, 1 )
	btnHerramienta.isVisible = true
	btnHerramienta.height = 40
	btnHerramienta.width = 40
	grupoToolbar:insert(btnHerramienta)
	
	local menu = display.newRect( 0, h + 55, display.contentWidth, 70 )
	menu.anchorX = 0
	menu.anchorY = 0
	menu:setFillColor( 189/255, 203/255, 206/255 )
	homeScreen:insert(menu)
	
	--[[local triangle = display.newImage( "img/btn/triangle.png" )
	triangle:translate( display.contentWidth * .5, 112 + h)
	triangle:setFillColor( 1, 1, 1 )
	triangle.isVisible = true
	triangle.height = 15
	triangle.width = 30
	homeScreen:insert(triangle)]]
	
	scrollViewContent1 = widget.newScrollView
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
	homeScreen:insert(scrollViewContent1)
	
	scrollViewContent2 = widget.newScrollView
	{
		top = h + 125,
		left = 480,
		width = display.contentWidth,
		height = display.contentHeight,
		listener = scrollListenerContent2,
		backgroundColor = { 1, 1, 0 }
	}
	homeScreen:insert(scrollViewContent2)
	
	scrollViewContent3 = widget.newScrollView
	{
		top = h + 125,
		left = 480,
		width = display.contentWidth,
		height = display.contentHeight,
		listener = scrollListenerContent3,
		backgroundColor = { 0, 1, 1 }
	}
	homeScreen:insert(scrollViewContent3)
	
	groupMenu = display.newGroup()
	homeScreen:insert(groupMenu)
	
	grupoScroll1 = display.newGroup()
	scrollViewContent1:insert(grupoScroll1)
	
	-- create some text
	--[[textTitulo1 = display.newText( "Eventos", 0, 0, native.systemFont, 20)
	textTitulo1:setFillColor( 0 )	-- black
	textTitulo1.x = display.contentWidth * .5
	textTitulo1.y = menu.y + 30
	groupMenu:insert(textTitulo1)
	textTitulo1:addEventListener( "tap", tapTitulo1 )
	
	textTitulo2 = display.newText( "Entretenimiento", 0, 0, native.systemFont, 20)
	textTitulo2:setFillColor( 0 )	-- black
	textTitulo2.x = display.contentWidth * .85
	textTitulo2.y = menu.y + 30
	groupMenu:insert(textTitulo2)
	textTitulo2:addEventListener( "tap", tapTitulo2 )
	
	textTitulo3 = display.newText( "Sporttv", 0, 0, native.systemFont, 20)
	textTitulo3:setFillColor( 0 )	-- black
	textTitulo3.x = display.contentWidth * 1.2
	textTitulo3.y = menu.y + 30
	groupMenu:insert(textTitulo3)
	textTitulo3:addEventListener( "tap", tapTitulo3 )]]
	
	 -- Loading
     loadingGrp = display.newGroup()
    scrollViewContent1:insert(loadingGrp)
    local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
    loading = display.newSprite(sheet, Sprites.loading.sequences)
    loading.x = midW
    loading.y = midH 
    loadingGrp:insert(loading)
    titleLoading = display.newText( "", midW, midH+50, "Chivo", 20)
    titleLoading:setFillColor( 0 )
    loadingGrp:insert(titleLoading)
	
	navGrp = display.newGroup()
    homeScreen:insert(navGrp)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	
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