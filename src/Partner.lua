
require('src.Menu')
require('src.Header')
local widget = require( "widget" )
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
local scene = storyboard.newScene()

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local toolbar, menu
local srvPartnerD
local groupMenu, groupPartner, groupMenuPartnerText
local svCoupon, svMenuTxt
local h = display.topStatusBarContentHeight
local lastY = 200
local lastYImage
local idPartner
local settings
local timeMarker
local hWBPar = 0

local info, promotions, gallery, MenuPartnerBar

local callbackCurrent = 0

-- tablas

local srvPartner = {}
local txtMenuPartner = {}
local imagePartnerDeals = {}
local imagePartnerGallery = {}
local itemGallery = {}
local itemPartner = {}

---- grupos ----

local homeScreen = display.newGroup()

-------------------------------------------------------
---------Funciones-------------------------------------
-------------------------------------------------------

--llama al telefono del comercio
function callPhone( event )
	system.openURL( "tel:" .. event.target.phone )
end

-- redireciona a la pagina del comercio
function openSocialNetwork( event )
	system.openURL( event.target.url )
end

-- Obtiene el mapa
function showMapa( event )
    storyboard.removeScene( "src.Mapa" )
	storyboard.gotoScene( "src.Mapa", {
		time = 400,
		effect = "crossFade",
		params = { itemObj = itemPartner }
	})
end

--obtenemos el grupo homeScreen de la escena actual
function getSceneSearchP( event )
	--modalSeach(txtSearch.text)
	SearchText(homeScreen)
	return true
end

--obtenemos el homeScreen de la escena
function getScreenP()
	return homeScreen
end

---------------------------------------------------------
---------build Partner
---------------------------------------------------------
function loadPartner(item)
	itemPartner = item
	if callbackCurrent == Globals.noCallbackGlobal then
        loadImagePartner(1)
		buildPartnerInfo(item)
	end
	
end

function buildPartnerInfo(item)
    
    local bgAddress = display.newRoundedRect( midW, 200, 440, 70, 10 )
    bgAddress.anchorY = 0
	bgAddress:setFillColor( 1 )
	srvPartnerD:insert(bgAddress)
    
    local bgMap = display.newRoundedRect( 410, 200, 100, 70, 10 )
    bgMap.anchorY = 0
	bgMap:setFillColor( .2 )
	srvPartnerD:insert(bgMap)
    
    local bgMapL = display.newRect( 370, 200, 20, 70)
    bgMapL.anchorY = 0
	bgMapL:setFillColor( .2 )
	srvPartnerD:insert(bgMapL)
    
    local iconTool2 = display.newImage( "img/btn/iconTool2.png" )
    iconTool2.itemObj = itemObj
    iconTool2:translate( 410, 235 )
	iconTool2:addEventListener( "tap", showMapa )
    srvPartnerD:insert(iconTool2)
    
	local txtInfo1 = display.newText({
		text = item.name,
		x = 195,
		y =  225,
		font = "Lato-Regular",
		width = 320,
		fontSize = 30,
		align = "left"
	})
	txtInfo1:setFillColor( .2 )
	srvPartnerD:insert( txtInfo1 )
    
    local txtInfo3 = display.newText({
		text = item.address,
		x = 195,
		y =  255,
		font = "Lato-Bold",
		width = 320,
		fontSize = 16,
		align = "left"
	})
	txtInfo3:setFillColor( .2 )
	srvPartnerD:insert( txtInfo3 )
    
    local xtraH = 0
    if txtInfo1.height > 50 then
        txtInfo1.y = txtInfo1.y + 17
        txtInfo3.y = txtInfo3.y + 30
        xtraH = xtraH + 30
    end
    if txtInfo3.height > 25 then
        txtInfo3.y = txtInfo3.y + ((txtInfo3.height/2) - 10)
        xtraH = xtraH + (txtInfo3.height/2)
    end
    
    -- Ajustes
    local newH = txtInfo1.height + txtInfo3.height + 20
    bgAddress.height = newH
    bgMap.height = newH
    bgMapL.height = newH
    iconTool2.y = bgAddress.y + (bgAddress.height / 2)
    
    lastY = bgAddress.height + 220
    
    local bgInfo = display.newRoundedRect( midW, lastY, 440, 70, 10 )
    bgInfo.anchorY = 0
	bgInfo:setFillColor( .2 )
	srvPartnerD:insert(bgInfo)
    
    local txtInfo4 = display.newText({
		text = item.info,
		x = midW,
		y =  lastY + 35,
		font = "Lato-Bold",
		width = 410,
		fontSize = 16,
		align = "left"
	})
	txtInfo4:setFillColor( 1 )
	srvPartnerD:insert( txtInfo4 )
    
    xtraH = 0
    if txtInfo4.height > 28 then
        xtraH = (txtInfo4.height / 2) - 16
        txtInfo4.y = txtInfo4.y + xtraH
        bgInfo.height = txtInfo4.height + 35
    end
    
    lastY = lastY + bgInfo.height + 20
    
    local bgPhone1 = display.newRoundedRect( midW, lastY, 440, 60, 10 )
    bgPhone1.anchorY = 0
	bgPhone1:setFillColor( 1 )
	srvPartnerD:insert(bgPhone1)
    
    local bgPhone2 = display.newRoundedRect( 410, lastY, 100, 60, 10 )
    bgPhone2.anchorY = 0
	bgPhone2:setFillColor( .19, .6, 0 )
	srvPartnerD:insert(bgPhone2)
     
    local bgPhone3 = display.newRect( 370, lastY, 20, 60)
    bgPhone3.anchorY = 0
	bgPhone3:setFillColor( .19, .6, 0 )
	bgPhone3:addEventListener( "tap", callPhone )
	srvPartnerD:insert(bgPhone3)
    
    local iconPhone = display.newImage( "img/btn/iconPhone.png" )
    iconPhone:translate( 410, lastY + 29 )
    srvPartnerD:insert(iconPhone)
    
    local txtInfo5 = display.newText({
		text = item.phone,
		x = 205,
		y =  lastY + 30,
		font = "Lato-Regular",
		width = 320,
		fontSize = 26,
		align = "left"
	})
	txtInfo5:setFillColor( 0 )
	srvPartnerD:insert( txtInfo5 )
    
    lastY = bgPhone1.y + bgPhone1.height + 20
    
    local btnFacebook = display.newImage( "img/btn/facebook.png" )
    btnFacebook.anchorY = 0
    btnFacebook:translate( intW/4 + 10, lastY )
	btnFacebook.url = item.facebook
    srvPartnerD:insert(btnFacebook)
	
	if #item.facebook > 1 then
		btnFacebook:addEventListener( "tap", openSocialNetwork )
	else
		btnFacebook.alpha = .5
	end
	
	local btnTwitter = display.newImage( "img/btn/twitter.png" )
    btnTwitter.anchorY = 0
    btnTwitter:translate( intW/2 + (intW/4) - 10, lastY )
	btnTwitter.url = item.twitter
    srvPartnerD:insert(btnTwitter)
	
	if #item.twitter > 1 then
		btnTwitter:addEventListener( "tap", openSocialNetwork )
	else
		btnTwitter.alpha = .5
	end
    
    -- Deals
    lastY = lastY + 80
    
    local bgTitleDeal = display.newRect( midW, lastY, intW, 40)
    bgTitleDeal.anchorY = 0
	bgTitleDeal:setFillColor( .19, .6, 0 )
	srvPartnerD:insert(bgTitleDeal)
    
    local txtInfo6 = display.newText({
		text = Globals.language.partnerTxtInfo6,
		x = midW,
		y =  lastY + 20,
		font = "Lato-Bold",
		width = 430,
		fontSize = 16,
		align = "left"
	})
	txtInfo6:setFillColor( 1 )
	srvPartnerD:insert( txtInfo6 )
    
    -- Get Deals
    lastY = lastY + 80
    srvPartnerD:setScrollHeight(lastY)
    RestManager.getDealsByPartner(idPartner,"partner")
	
end

--mostramos los deals del comercio
function buildPartnerPromociones(items)
	if #items > 0 then
		for y = 1, #items, 1 do 
            -- Create container
			imagePartnerDeals[y] = display.newImage( items[y].image, system.TemporaryDirectory )
			imagePartnerDeals[y].alpha = 1
			
            local deal = Deal:new()
            srvPartnerD:insert(deal)
            deal:build(true, items[y], imagePartnerDeals[y])
            deal.y = lastY
			lastY = lastY + 180
        end
        srvPartnerD:setScrollHeight(lastY + 50)
	end
end

function loadImagePartner(typeImage)

	local path
	if typeImage == 2 then
		path = system.pathForFile( itemPartner.image, system.TemporaryDirectory )
	else
		path = system.pathForFile( itemPartner.banner, system.TemporaryDirectory )
	end
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		
			--diferenciamos si es el logo o banner del comercio
			if callbackCurrent == Globals.noCallbackGlobal then
				if typeImage == 2 then
					-- creamos la mascara
					local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
					local imgPartner = display.newImage( itemPartner.image, system.TemporaryDirectory )
					--cargando el logo del comercio
					imgPartner.alpha = 1
					imgPartner.x = 90
					imgPartner.y = 120
					imgPartner.width = 120
					imgPartner.height = 120
					imgPartner:setMask( mask )
					srvPartnerD:insert( imgPartner )
				else
					--cargando el banner del comercio
					local imgBgPartner = display.newImage( itemPartner.banner, system.TemporaryDirectory )
					imgBgPartner.alpha = 1
					imgBgPartner.x = 240
					imgBgPartner.y = 200
					imgBgPartner.height = 400
					srvPartnerD:insert( imgBgPartner )
					imgBgPartner:toBack()
					loadImagePartner( 2 )
				end
			end
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImagePartnerListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
				event.target.alpha = 0
				
				--diferenciamos si es el logo o banner del comercio
			if callbackCurrent == Globals.noCallbackGlobal then
				if typeImage == 2 then
					-- creamos la mascara
					local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
					local imgPartner = display.newImage( itemPartner.image, system.TemporaryDirectory )
					--cargando el logo del comercio
					imgPartner.alpha = 1
					imgPartner.x = 90
					imgPartner.y = 120
					imgPartner.width = 120
					imgPartner.height = 120
					imgPartner:setMask( mask )
					srvPartnerD:insert( imgPartner )
				else
					--cargando el banner del comercio
					local imgBgPartner = display.newImage( itemPartner.banner, system.TemporaryDirectory )
					imgBgPartner.alpha = 1
					imgBgPartner.x = 240
					imgBgPartner.y = 200
					imgBgPartner.height = 400
					srvPartnerD:insert( imgBgPartner )
					imgBgPartner:toBack()
					loadImagePartner( 2 )
				end
			end
            end
        end
		
		local imageUrl
		local imageName
		
		if typeImage == 2 then
			imageUrl = settings.url.."assets/img/app/partner/image/"..itemPartner.image
			imageName = itemPartner.image
		else
			imageUrl = settings.url.."assets/img/app/partner/banner/"..itemPartner.banner
			imageName = itemPartner.banner
		end
        
        -- Descargamos de la nube
        display.loadRemoteImage( imageUrl, "GET", loadImagePartnerListener, imageName, system.TemporaryDirectory ) 
    end
end

function scene:createScene( event )
	screen = self.view   
	idPartner = event.params.idPartner
	screen:insert(homeScreen)
     
    local title = ''
    if event.params.name then title = event.params.name end
	
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
    header:buildNavBar(title)
    hWBPar = 5 + header:buildWifiBle()
	
	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
    
    srvPartnerD = widget.newScrollView
	{
		top = h + hWBPar + 125,
		left = 0,
		width = intW,
		height = intH - (h + 125 + hWBPar),
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
		backgroundColor = { .85 }
	}
	homeScreen:insert(srvPartnerD)
	
    settings = DBManager.getSettings()
	RestManager.getPartner(idPartner)
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