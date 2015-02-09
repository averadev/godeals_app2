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

local txtInfo, txtBtn, txtTitleInfo
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
	print("Redimir")
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
	print("DownloadCoupon")
	transition.to( txtTitleInfo, { alpha = 0, time = 200, transition = easing.outExpo } )
	transition.to( txtInfo, { alpha = 0, time = 200, transition = easing.outExpo } )
	transition.to( txtBtn, { alpha = 0, time = 200, transition = easing.outExpo } )
	
	timer.performWithDelay(200, function() 
		txtTitleInfo.text = "Redime este Deal!"
		txtInfo.text = "Deja presionado el boton mientras lo acercas a nuestro dispositivo GO> "..
                            "disponible en todos los establecimientos afiliados. PREGUNTA POR EL!"
		txtBtn.text = "REDIMIR DEAL"
			
		transition.to( txtBtn, { alpha = 1, time = 200, delay = 200, transition = easing.outExpo } )
		transition.to( txtInfo, { alpha = 1, time = 200, delay = 200, transition = easing.outExpo } )
		transition.to( txtTitleInfo, { alpha = 1, time = 200, delay = 200, transition = easing.outExpo } )
	end, 1)
	
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
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		backgroundColor = { .96 }
	}
	homeScreen:insert(svCoupon)
	
	grupoSvCoupon = display.newGroup()
	svCoupon:insert(grupoSvCoupon)

	local imgShape = display.newRoundedRect( midW, 260, 450, 470,12 )
	imgShape:setFillColor( 1 )
	svCoupon:insert(imgShape)
	
	local imgBgCoupon = display.newImage( "img/bgk/bgCoupon.png" )
	imgBgCoupon.alpha = 1
    imgBgCoupon.x= midW
	imgBgCoupon.y = 260
    svCoupon:insert( imgBgCoupon )
    
    local mask = graphics.newMask( "img/bgk/maskBig.jpg" )
	local imgCoupon = display.newImage( itemObj.image, system.TemporaryDirectory )
    imgCoupon.x= 100
	imgCoupon.y = 122
    imgCoupon.width = 140
    imgCoupon.height  = 140
    svCoupon:insert( imgCoupon )
    imgCoupon:setMask( mask )
    
    local btnPartner = display.newImage( "img/btn/btnPartner.png" )
	btnPartner.x= 430
	btnPartner.y = 85
    btnPartner:addEventListener( "tap", showPartner )
    svCoupon:insert( btnPartner )
	
	local txtPartner = display.newText( {
        text = itemObj.partner,    
        x = 300, y = 80,
        width = 240, height =0,
        font = "Lato-Regular", fontSize = 30, align = "left"
    })
    txtPartner:setFillColor( 0 )
    svCoupon:insert( txtPartner )
    
	local txtTotalDeals = display.newText( {
        text = itemObj.total.." Deals",
        x = 300, y = 115,
        width = 240, height =25,
        font = "Lato-Regular", fontSize = 20, align = "left"
    })
    txtTotalDeals:setFillColor( 0 )
    svCoupon:insert( txtTotalDeals )
    
    local txtStock = display.newText( {
        text = itemObj.stock.." Disponibles",
        x = 300, y = 140,
        width = 240, height =25,
        font = "Lato-Regular", fontSize = 20, align = "left"
    })
    txtStock:setFillColor( .2, .6 ,0 )
    svCoupon:insert( txtStock )
    
    local txtValidity = display.newText( {
        text = "VIGENCIA: "..itemObj.validity,
        x = 300, y = 172,
        width = 240, height = 34 ,
        font = "Lato-Regular", fontSize = 14, align = "left"
    })
    txtValidity:setFillColor( 0 )
    svCoupon:insert( txtValidity )
    
    -- Reasigna posicion en textos grandes
    if txtPartner.contentHeight > 50 then
        txtPartner.y = txtPartner.y + 5
        txtTotalDeals.y = txtTotalDeals.y + 20
        txtStock.y = txtStock.y + 20
        txtValidity.y = txtValidity.y + 20
    end
    
    
    -- Max Desc
    local bgMaxDesc = display.newRect( midW, 260, 444, 80 )
	bgMaxDesc:setFillColor( .89 )
	svCoupon:insert(bgMaxDesc)
    
    local txtMaxDesc = display.newText( {
        text = itemObj.detail,
        x = 240, y = 260,
        width = 410, height = 0,
        font = "Lato-Regular", fontSize = 20, align = "center"
    })
    txtMaxDesc:setFillColor( 0 )
    svCoupon:insert( txtMaxDesc )
    
    
    -- Descarga / Redime
    if itemObj.stock == '0' then
            local agotado = display.newImage( "img/btn/agotadoMax.png" )
            agotado.x= 240
            agotado.y = 450
            agotado.alpha = .8
            svCoupon:insert(agotado)
    else
        txtTitleInfo = display.newText( {
            text = "¿Te interesa este Deal?",
            x = 240, y = 340,
            width = 400, height = 0,
            font = "Lato-Bold", fontSize = 16, align = "left"
        })
        txtTitleInfo:setFillColor( 0 )
        svCoupon:insert( txtTitleInfo )

        txtInfo = display.newText( {
            text =  "No lo pienses mas y descargalo, "..
                    "se guardara en tu cartera para que lo uses en tu proxima visita.",
            x = 240, y = 385,
            width = 400, height = 60,
            font = "Lato-Regular", fontSize = 16, align = "left"
        })
        txtInfo:setFillColor( 0 )
        svCoupon:insert( txtInfo )
        
        local rctBtn = display.newRoundedRect( midW, 450, 400, 55, 5 )
		rctBtn.idCoipon = itemObj.id
        rctBtn:setFillColor( .2, .6 ,0 )
        svCoupon:insert(rctBtn)
        
        txtBtn = display.newText( {
            text =  "DESCARGAR DEAL",
            x = 240, y = 450,
            width = 400, height = 0,
            font = "Lato-Regular", fontSize = 26, align = "center"
        })
        txtBtn:setFillColor( 1 )
        svCoupon:insert( txtBtn )
        
        if itemObj.assigned == 1 or itemObj.assigned == '1' then 
            txtTitleInfo.text = "Redime este Deal!"
            txtInfo.text =  "Deja presionado el boton mientras lo acercas a nuestro dispositivo GO> "..
                            "disponible en todos los establecimientos afiliados. PREGUNTA POR EL!"
            txtBtn.text = "REDIMIR DEAL"
            rctBtn:addEventListener( "tap", showRedimir )
        else
            rctBtn:addEventListener( "tap", DownloadCoupon )
        end
    end
    
    
    -- Detail Clauses
    local txtAdditionalInformation = display.newText({
		text = "Informacion Adicional:",
		x = 230, y =  560,
		height = 20, width = 400,
		font = "Lato-Bold", fontSize = 16, align = "left"
	})
	txtAdditionalInformation:setFillColor( 0 )
	svCoupon:insert(txtAdditionalInformation)
	
	local txtClauses = display.newText({
		text = itemObj.clauses,
		x = midW, y = 580,
		width = 420,
		font = "Lato-Regular", fontSize = 16, align = "left"
	})
	txtClauses:setFillColor( 0 )
    txtClauses.y = txtClauses.height/2 + 580
	svCoupon:insert( txtClauses )
    
    lastY = txtClauses.height + 620
    local spc = display.newRect( 0, lastY, 1, 1 )
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
    header:buildNavBar(event.params.item.name)
	
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