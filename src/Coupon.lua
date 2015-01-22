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
local widget = require( "widget" )
local scene = storyboard.newScene()
local DBManager = require('src.resources.DBManager')

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local toolbar, menu
local groupMenu, groupEvent, groupMenuEventText
local svCoupon, svInfo, svPromotions, svGallery
local h = display.topStatusBarContentHeight
local lastY = 200;
local itemObj
local currentSv
local settings

local info, promotions, gallery, MenuEventBar
--pantalla

local homeScreen = display.newGroup()

-- funciones

function returnHome( event )
	storyboard.gotoScene( "src.Home", {
        time = 400,
        effect = "crossFade"
    })
end

function showPartner( event )

	storyboard.gotoScene( "src.Partner", {
		time = 400,
		effect = "crossFade",
		params = { idPartner = itemObj.partnerId }
	})
end

function buildCoupon()

	svCoupon = widget.newScrollView
	{
		top = h + 134,
		left = 0,
		width = intW,
		height = intH,
		listener = scrollListenerContent1,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = false,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(svCoupon)
	
	grupoSvCoupon = display.newGroup()
	svCoupon:insert(grupoSvCoupon)

	local imgShape = display.newRoundedRect( midW, 20, 444, 455,12 )
	imgShape:setFillColor( 1 )
	svCoupon:insert(imgShape)
	
	local imgBgCoupon = display.newImage( "img/bgk/bgCoupon.fw.png" )
	imgBgCoupon.alpha = 1
    imgBgCoupon.x= 240
	imgBgCoupon.y = 0
    imgBgCoupon.width = 410
    imgBgCoupon.height  = 410
    svCoupon:insert( imgBgCoupon )
	
	local imgCoupon = display.newImage( itemObj.image, system.TemporaryDirectory )
	imgCoupon.alpha = 1
    imgCoupon.x= 121
	imgCoupon.y = 124
    imgCoupon.width = 128
    imgCoupon.height  = 128
    svCoupon:insert( imgCoupon )
	
	local txtPartner = display.newText( {
        text = itemObj.partner,    
        x = 320,
        y = 80,
        width = 240,
        height =0,
        font = "Chivo",   
        fontSize = 30,
        align = "left"
    })
    txtPartner:setFillColor( 0 )
    svCoupon:insert( txtPartner )
    
	local txtAddressPartner = display.newText( {
        text = itemObj.address,
        x = 320,
        y = 110,
        width = 240,
        height =25,
        font = "Chivo",   
        fontSize = 17,
        align = "left"
    })
    txtAddressPartner:setFillColor( 0 )
    svCoupon:insert( txtAddressPartner )
    
    -- Reasigna posicion en textos grandes
    if txtPartner.contentHeight > 50 then
        txtAddressPartner.y = 130
    end
	
	local txtSchedulePartner = display.newText( {
        text = "Abierto de Lunes a Domingo de 11:00 am a 9:00 pm.",
        x = 320,
        y = 170,
        width = 240,
        height =60,
        font = "Chivo",   
        fontSize = 17,
        align = "left"
    })
    txtSchedulePartner:setFillColor( 0 )
    svCoupon:insert( txtSchedulePartner )
	
	local txtDescription = display.newText({
		text = itemObj.detail,
		x = 240,
		y = lastY,
		width = 370,
		font = "Chivo",
		fontSize = 24,
		align = "left"
	})
	txtDescription:setFillColor( 0 )
	svCoupon:insert( txtDescription )
	
	lastY = lastY + txtDescription.height + 25
	
	txtDescription.y = txtDescription.height/2 + txtDescription.y
	
	local grupoCouponsReleased = display.newGroup()
	svCoupon:insert( grupoCouponsReleased )
	
	local CouponsReleased = 100
	
	local remainingCoupons = CouponsReleased - 47
	
	local txtCouponsReleased = display.newText({
		text = "Limitado a " .. itemObj.total .. " Cupones",
		x = 240,
		y = lastY,
		height = 40,
		width = 370,
		font = "Chivo",
		fontSize = 19,
		align = "left"
	})
	txtCouponsReleased:setFillColor( 0 )
	svCoupon:insert( txtCouponsReleased )
	
	lastY = lastY + 25
	
	local CouponsReleasedSize  = string.len( CouponsReleased ) * 13
	local withCouponsReleased =  (string.len( CouponsReleased ) * 8.3) / string.len( CouponsReleased ) -1
	
	local txtRemainingCoupons = display.newText({
		text = itemObj.stock .. " cupones disponibles.",
		x = 240,
		y = lastY,
		height = 40,
		width = 370,
		font = "Chivo",
		fontSize = 19,
		align = "left"
	})
	txtRemainingCoupons:setFillColor( 0 )
	svCoupon:insert( txtRemainingCoupons )
	
	lastY = lastY + 25
	
	local txtRequirements = display.newText({
		text = "Requisitos para el canje del cupon:",
		x = 240,
		y = lastY,
		height = 40,
		width = 370,
		font = "Chivo",
		fontSize = 19,
		align = "left"
	})
	txtRequirements:setFillColor( 0 )
	svCoupon:insert( txtRequirements )
	
	lastY = lastY + 10
	
	local txtDetail = display.newText({
		text = itemObj.detail,
		x = 240,
		y = lastY,
		width = 370,
		font = "Chivo",
		fontSize = 18,
		align = "left"
	})
	txtDetail:setFillColor( 0 )
	svCoupon:insert( txtDetail )
	
	txtDetail.y = txtDetail.height/2 + txtDetail.y
	
	lastY = lastY + txtDetail.height + 50
	
    if itemObj.stock == '0' then
            local agotado = display.newImage( "img/btn/agotadoMax.png" )
            agotado.x= 240
            agotado.y = lastY - 5
            agotado.alpha = .8
            svCoupon:insert(agotado)
    elseif itemObj.assigned == 1 or itemObj.assigned == '1' then 
        local btnCanjearCoupon = display.newImage( "img/btn/btnCanjearCoupon.png" )
        btnCanjearCoupon.alpha = 1
        btnCanjearCoupon.x= 240
        btnCanjearCoupon.y = lastY
        btnCanjearCoupon.width = 376
        btnCanjearCoupon.height  = 58
        svCoupon:insert( btnCanjearCoupon )
    else
        local btnDownloadCoupon = display.newImage( "img/btn/btnDownloadCoupon.png" )
        btnDownloadCoupon.alpha = 1
        btnDownloadCoupon.x= 240
        btnDownloadCoupon.y = lastY
        btnDownloadCoupon.width = 376
        btnDownloadCoupon.height  = 58
        svCoupon:insert( btnDownloadCoupon )
    end
	
	imgBgCoupon.height = lastY + 10
	
	imgBgCoupon.y = imgBgCoupon.height/2 + 35
	
	imgShape.height = lastY + 40
	
	imgShape.y = imgShape.height/2 + 20
	
	lastY = lastY + 75 + 50
	
	local txtAdditionalInformation = display.newText({
		text = "Informacion Adicional",
		x = 230,
		y =  lastY,
		height = 40,
		width = 400,
		font = "Chivo",
		fontSize = 22,
		align = "left"
	})
	txtAdditionalInformation:setFillColor( 0 )
	svCoupon:insert(txtAdditionalInformation)
	
	lastY = lastY + 40
	
	local imgBgDetail = display.newRect( midW, lastY, intW, 156 )
	imgBgDetail:setFillColor( 1 )
	svCoupon:insert(imgBgDetail)
	
	local txtClauses = display.newText({
		text = itemObj.clauses,
		x = midW,
		y = lastY,
		width = 420,
		font = "Chivo",
		fontSize = 18,
		align = "left"
	})
	txtClauses:setFillColor( 0 )
	svCoupon:insert( txtClauses )
	
	txtClauses.y = txtClauses.height/2 + lastY
	
	imgBgDetail.height = txtClauses.height + 50
	
	imgBgDetail.y = txtClauses.height / 2 + lastY
	
	lastY = lastY + txtClauses.height + 70
	
	local txtAdditionalInformation = display.newText({
		text = "Consultar informacion del comercio",
		x = 230, y = lastY,
		height = 40, width = 400,
		font = "Chivo", fontSize = 22, align = "center"
	})
	txtAdditionalInformation:setFillColor( 0 )
	svCoupon:insert( txtAdditionalInformation )
	txtAdditionalInformation:addEventListener( "tap", showPartner )
    
    local lineLink = display.newRect( 50, lastY + 15, 360, 1 )
	lineLink.anchorX = 0
	lineLink.anchorY = 0
	lineLink:setFillColor( .2 )
	svCoupon:insert( lineLink )
	
	svCoupon:setScrollHeight(lastY + 200)
	
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
	
	toolbar = display.newRect( 0, h, display.contentWidth, 135 )
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
	grupoToolbar:insert(btnWallet)
	btnWallet:addEventListener( "tap", showWallet )
	
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
	btnMensaje:translate( display.contentWidth - 95, 25 )
	grupoToolbar:insert(btnMensaje)
	
	local btnHerramienta = display.newImage( "img/btn/btnMenuUser.png" )
	btnHerramienta:translate( display.contentWidth - 35, 25 )
	grupoToolbar:insert(btnHerramienta)
	
	local menu = display.newRect( 0, h + 55, display.contentWidth, 75 )
	menu.anchorX = 0
	menu.anchorY = 0
	menu:setFillColor( 189/255, 203/255, 206/255 )
	homeScreen:insert(menu)
	
	groupMenu = display.newGroup()
	groupMenu.y = h + 60
	homeScreen:insert(groupMenu)
	
	local imgBtnBack = display.newImage( "img/btn/btnBackward.png" )
	imgBtnBack.x= 30
	imgBtnBack.y = 30
    groupMenu:insert( imgBtnBack )
	imgBtnBack:addEventListener( "tap", returnHome )
	
	local imgBtnUp = display.newImage( "img/btn/btnUp.png" )
	imgBtnUp.x= 420
	imgBtnUp.y = 30
    groupMenu:insert( imgBtnUp )
	
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	settings = DBManager.getSettings()
	buildCoupon()
end

-- Remove Listener
function scene:exitScene( event )
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene