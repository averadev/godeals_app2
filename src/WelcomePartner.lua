
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

local header

--grupos
local groupWPartner


local toolbar, menu
local groupMenu, groupPartner, groupMenuPartnerText
local  svCoupon, svMenuTxt
local h = display.topStatusBarContentHeight
local lastY = 200
local lastYImage
local idPartner
local settings
local timeMarker

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

------cargamos las imagen full
function loadWelcomeFull(imageName)
     -- Determinamos si la imagen existe
    local path = system.pathForFile( imageName, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
        endLoading()
        buildPartner(itemPartner)
    else
        -- Listener de la carga de la imagen del servidor
        local function loadImageListener( event )
            if ( event.isError ) then
                native.showAlert( "Go Deals", "Network error :(", { "OK"})
            else
                event.target:removeSelf()
                event.target = nil
                endLoading()
                buildPartner(itemPartner)
            end
        end
        
        -- Descargamos de la nube
        display.loadRemoteImage( settings.url.."assets/img/app/message/"..imageName, 
        "GET", loadImageListener, imageName, system.TemporaryDirectory ) 
    end
end

---------------------------------------------------------
---------build Partner
---------------------------------------------------------
function loadPartner(item)
	
	itemPartner = item
	
	groupPartner = display.newGroup()
	homeScreen:insert( groupPartner )
    header:buildNavBar(itemPartner.name)
    
    loadWelcomeFull(itemPartner.displayImage)
    
	
	--endLoading()
	--
	
end

function buildPartner(item)

	groupWPartner = display.newGroup()
	homeScreen:insert( groupWPartner )
	
	createScrollViewPartner()
	
	lastY = 82
	
	lastYImage = lastY
	
	local bgHeader = display.newRect( midW, lastY, intW, 165 )
	bgHeader:setFillColor( 1 )
	srvPartner[#srvPartner]:insert(bgHeader)
	
	local txtWelcome = display.newText({
		text = "BIENVENIDO A:",
		x = 320,
		y =  lastY - 32,
		font = "Lato-Regular",
		width = 300,
		fontSize = 20,
		align = "left"
	})
	txtWelcome:setFillColor( 0 )
	srvPartner[#srvPartner]:insert( txtWelcome )
	
	local txtPartner = display.newText({
		text = item.name,
		x = 320,
		y =  lastY,
		font = "Lato-Regular",
		width = 300,
		fontSize = 30,
		align = "left"
	})
	txtPartner:setFillColor( 0 )
	srvPartner[#srvPartner]:insert( txtPartner )
	
	txtPartner.y = txtPartner.y + txtPartner.height/2
	
	lastY = lastY + bgHeader.height - 10
	
	local btnFacebook = display.newImage( "img/btn/facebook.png" )
    btnFacebook:translate( intW/4 + 10, lastY )
	btnFacebook.url = item.facebook
    srvPartner[#srvPartner]:insert(btnFacebook)
	
	if #item.facebook > 1 then
		btnFacebook:addEventListener( "tap", openSocialNetwork )
	else
		btnFacebook.alpha = .5
	end
	
	local btnTwitter = display.newImage( "img/btn/twitter.png" )
    btnTwitter:translate( intW/2 + (intW/4) - 10, lastY )
	btnTwitter.url = item.twitter
    srvPartner[#srvPartner]:insert(btnTwitter)
	
	--if item.twitter ~= "" or item.twitter ~= nil or #item.twitter > 1 then
	if #item.twitter > 1 then
		btnTwitter:addEventListener( "tap", openSocialNetwork )
	else
		btnTwitter.alpha = .5
	end
	
	lastY = lastY + btnFacebook.height
	
	local bgPartner = display.newRect( midW, lastY, 440, 600 )
	bgPartner:setFillColor( 1 )
	srvPartner[#srvPartner]:insert(bgPartner)
	
	lastY = lastY + 30
	
	local txtWelcomeIntro = display.newText({
		text = item.displayInfo,
		x = 240,
		y =  lastY,
		font = "Lato-Regular",
		width = 400,
		fontSize = 20,
		align = "center"
	})
	txtWelcomeIntro:setFillColor( 0 )
	srvPartner[#srvPartner]:insert( txtWelcomeIntro )
	
	txtWelcomeIntro.y = txtWelcomeIntro.y + txtWelcomeIntro.height/2
	
	lastY = lastY + txtWelcomeIntro.height
	
    local imgPartner = display.newImage( item.displayImage, system.TemporaryDirectory )
    imgPartner.x = midW
    imgPartner.y = lastY
    srvPartner[#srvPartner]:insert( imgPartner )
	
	imgPartner.y = lastY + imgPartner.height/2 + 30
	
	lastY = lastY + imgPartner.height + 60
	
	local txtWelcomeFooter = display.newText({
		text = item.info,
		x = 240,
		y =  lastY,
		font = "Lato-Regular",
		width = 400,
		fontSize = 20,
		align = "center"
	})
	txtWelcomeFooter:setFillColor( 0 )
	srvPartner[#srvPartner]:insert( txtWelcomeFooter )
	
	txtWelcomeFooter.y = txtWelcomeFooter.y + txtWelcomeFooter.height/2
	
	lastY = lastY + txtWelcomeFooter.height + 30
	
	bgPartner.height = txtWelcomeIntro.height + imgPartner.height + txtWelcomeFooter.height + 120
	
	bgPartner.y = bgPartner.y + bgPartner.height/2
	
	-----------------
	
	--lastY = lastY + txtbtnShowPromo.height
	
	lastY = lastY + 50
	
	srvPartner[#srvPartner]:setScrollHeight(lastY)
	
	loadImagePartner()
	

end

--creamos los crollview dinamicos
function createScrollViewPartner()
	
	local positionCurrent = #srvPartner + 1
	
	local positionScrollPartner
	if #srvPartner == 0 then
		positionScrollPartner = 0
	else
		positionScrollPartner = intW
	end
	
	srvPartner[positionCurrent] = widget.newScrollView
	{
		top = 120,
		left = positionScrollPartner,
		width = intW,
		height = intH - (h + 120),
		--listener = ListenerChangeScrollPartner,
		horizontalScrollDisabled = true,
		verticalScrollDisabled = false,
		backgroundColor = { 245/255, 245/255, 245/255 }
		--backgroundColor = { .1,.5,.3 }
	}
	groupWPartner:insert(srvPartner[positionCurrent])
	
end

-----------------------------------
--carga el logo del comercio
function loadImagePartner()

	local path = system.pathForFile( itemPartner.image, system.TemporaryDirectory )
    local fhd = io.open( path )
    if fhd then
        fhd:close()
		
			--diferenciamos si es el logo o banner del comercio
			if callbackCurrent == Globals.noCallbackGlobal then
					-- creamos la mascara
					local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
					local imgPartner = display.newImage( itemPartner.image, system.TemporaryDirectory )
					--cargando el logo del comercio
					imgPartner.alpha = 1
					imgPartner.x = 90
					imgPartner.y = lastYImage
					imgPartner.width = 120
					imgPartner.height = 120
					imgPartner:setMask( mask )
					srvPartner[1]:insert( imgPartner )
				
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
					-- creamos la mascara
					local mask = graphics.newMask( "img/bgk/maskLogo.jpg" )
					local imgPartner = display.newImage( itemPartner.image, system.TemporaryDirectory )
					--cargando el logo del comercio
					imgPartner.alpha = 1
					imgPartner.x = 90
					imgPartner.y = lastYImage
					imgPartner.width = 120
					imgPartner.height = 120
					imgPartner:setMask( mask )
					srvPartner[1]:insert( imgPartner )
				end
            end
        end
		
		local imageUrl = settings.url.."assets/img/app/partner/image/"..itemPartner.image
		local imageName = itemPartner.image
		
        -- Descargamos de la nube
        display.loadRemoteImage( imageUrl, "GET", loadImagePartnerListener, imageName, system.TemporaryDirectory ) 
    end
end


-----------------------------------

function scene:createScene( event )
	screen = self.view   
	idAd = event.params.idAd
	screen:insert(homeScreen)
	
	homeScreen.y = h
	
	local bg = display.newRect( 0, h, display.contentWidth, display.contentHeight )
	bg.anchorX = 0
	bg.anchorY = 0
	bg:setFillColor( 245/255, 245/255, 245/255 )
	homeScreen:insert(bg)
	
	-- Build Component Header
	header = Header:new()
    homeScreen:insert(header)
    header:buildToolbar()
	
	getLoading(homeScreen)
	
	Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
	callbackCurrent = Globals.noCallbackGlobal
	
    settings = DBManager.getSettings()
	RestManager.getAdPartner(idAd)
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    Globals.scene[#Globals.scene + 1] = storyboard.getCurrentSceneName()
end

-- Remove Listener
function scene:exitScene( event )
    if timeMarker then
        timer.cancel(timeMarker)
        print("cancel Marker")
    end
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene