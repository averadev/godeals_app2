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

local toolbar, menu
local groupMenu, groupEvent, groupMenuEventText
local svCoupon, svInfo, svPromotions, svGallery
local h = display.topStatusBarContentHeight
local lastY = 200
local lastYCoupon = 0
local itemObj
local currentSv
local settings
local tmpRedimir

local info, promotions, gallery, MenuEventBar

local btnDownloadCoupon

--pantalla

local homeScreen = display.newGroup()
local menuScreenLeft = MenuLeft:new()
local menuScreenRight = MenuRight:new()

----------------------------------------------------------
-- Funciones
----------------------------------------------------------

--llama la pantalla del partner
function showPartner( event )

	storyboard.gotoScene( "src.Partner", {
		time = 400,
		effect = "crossFade",
		params = { idPartner = itemObj.partnerId, name = itemObj.partner }
	})
end

function showRedimir( event )
    if tmpRedimir then
        tmpRedimir:removeSelf()
        tmpRedimir = nil
    else
        tmpRedimir = display.newImage( "img/bgk/tmpRedimir.png" )
        tmpRedimir.x = midW
        tmpRedimir.y = midH
        tmpRedimir:addEventListener( "tap", showRedimir )
    end
end

function DownloadCoupon( event )
	RestManager.discountCoupon(event.target.idCoipon)
end

function changeButtonCoupon()
	btnDownloadCoupon:removeSelf();
	
	local btnCanjearCoupon = display.newImage( "img/btn/btnCanjearCoupon.png" )
        btnCanjearCoupon.alpha = 1
        btnCanjearCoupon.x= 240
        btnCanjearCoupon.y = lastYCoupon
        btnCanjearCoupon.width = 376
        btnCanjearCoupon.height  = 58
        svCoupon:insert( btnCanjearCoupon )
        btnCanjearCoupon:addEventListener( "tap", showRedimir )
end

--obtenemos el grupo homeScreen de la escena actual
function getSceneSearch( event )
	--modalSeach(txtSearch.text)
	SearchText(homeScreen)
	return true
end

--muestra el menuIzquierdo
function showMenuLeft( event )
	transition.to( homeScreen, { x = 400, time = 400, transition = easing.outExpo } )
	transition.to( menuScreenLeft, { x = 40, time = 400, transition = easing.outExpo } )
end

--esconde el menuIzquierdo
function hideMenuLeft( event )
	transition.to( menuScreenLeft, { x = -480, time = 400, transition = easing.outExpo } )
	transition.to( homeScreen, { x = 0, time = 400, transition = easing.outExpo } )
	return true
end

--muestra el menu Derecho
function showMenuRight( event )
	transition.to( homeScreen, { x = -400, time = 400, transition = easing.outExpo } )
	transition.to( menuScreenRight, { x = 0, time = 400, transition = easing.outExpo } )
end

--esconde el menu Derecho
function hideMenuRight( event )
	transition.to( menuScreenRight, { x = 481, time = 400, transition = easing.outExpo } )
	transition.to( homeScreen, { x = 0, time = 400, transition = easing.outExpo } )
	return true
end

function setCouponId( item )
	itemObj = item
	buildCoupon()
end

--llama a la funcion para crear un cupon
function createCoupon()
	buildCoupon()
end

--crea un cupon
function buildCoupon()

	svCoupon = widget.newScrollView
	{
		top = h + 125,
		left = 0,
		width = intW,
		height = intH - (h + 125),
		listener = scrollListenerContent1,
		horizontalScrollDisabled = false,
        verticalScrollDisabled = false,
		backgroundColor = { .96 }
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
        font = "Lato-Regular",   
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
        font = "Lato-Regular",   
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
        font = "Lato-Regular",   
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
		font = "Lato-Regular",
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
		font = "Lato-Regular",
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
		font = "Lato-Regular",
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
		font = "Lato-Regular",
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
		font = "Lato-Regular",
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
        btnCanjearCoupon:addEventListener( "tap", showRedimir )
    else
        btnDownloadCoupon = display.newImage( "img/btn/btnDownloadCoupon.png" )
        btnDownloadCoupon.alpha = 1
        btnDownloadCoupon.x= 240
        btnDownloadCoupon.y = lastY
        btnDownloadCoupon.width = 376
        btnDownloadCoupon.height  = 58
		btnDownloadCoupon.idCoipon = itemObj.id
        svCoupon:insert( btnDownloadCoupon )
		btnDownloadCoupon:addEventListener( "tap", DownloadCoupon )
    end
	
	lastYCoupon = lastY
	
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
		font = "Lato-Regular",
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
		font = "Lato-Regular",
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
		font = "Lato-Regular", fontSize = 22, align = "center"
	})
	txtAdditionalInformation:setFillColor( 0 )
	svCoupon:insert( txtAdditionalInformation )
	txtAdditionalInformation:addEventListener( "tap", showPartner )
    
    local lineLink = display.newRect( 50, lastY + 15, 360, 1 )
	lineLink.anchorX = 0
	lineLink.anchorY = 0
	lineLink:setFillColor( .2 )
	svCoupon:insert( lineLink )
	
	local spc = display.newRect( 0, lastY + 50, 1, 1 )
    spc:setFillColor( 0 )
    svCoupon:insert( spc )
	
end

----------------------------------------------------------
-- Funciones Default
----------------------------------------------------------

function scene:createScene( event )

	screen = self.view
	screen:insert(homeScreen)
	
	-- Build Component Header
	local header = Header:new()
    homeScreen:insert(header)
    header.y = h
    header:buildToolbar()
    header:buildNavBar(event.params.item.name, event.params.item.id)
	
	--creamos la pantalla del menu
	menuScreenLeft:builScreenLeft()
	menuScreenRight:builScreenRight()
	
	----obtenemos los parametros del cupon
	if event.params.item == nil then
		RestManager.getCouponById(1)
	else
		itemObj = event.params.item
		createCoupon()
	end
	
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