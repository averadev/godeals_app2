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
require('src.Friends')
local storyboard = require( "storyboard" )
local Globals = require('src.resources.Globals')
local widget = require( "widget" )
local scene = storyboard.newScene()
local DBManager = require('src.resources.DBManager')
local RestManager = require('src.resources.RestManager')
local Sprites = require('src.resources.Sprites')

local redimirObj;
local platformName = system.getInfo( "platformName" )
if platformName == "iPhone OS" then
	redimirObj = require( "plugin.redimir" )
end

-- Variables
local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

local toolbar, menu
local groupMenu, groupEvent, groupMenuEventText, groupDesc, grpRedem
local svCoupon, svInfo, svPromotions, svGallery, sprCheck
local h = display.topStatusBarContentHeight
local lastY = 200
local lastYCoupon = 0
local itemObj
local currentSv
local settings
local rctBtn, rctBtnB
local FlagCoupon = 0
local imgBtnShare
local hWCup = 0

local txtInfo, txtBtn, txtTitleInfo, loadingRed, rctRed, txtRed
local info, promotions, gallery, MenuEventBar, txtInfoRedimir2
local btnDownloadCoupon, groupDownload

local fx = audio.loadStream( "fx/alert.wav" )


local TEXTA1 = Globals.language.dealsTEXTA1
local TEXTA2 = Globals.language.dealsTEXTA2
local TEXTB1 = Globals.language.dealsTEXTB1
local TEXTB2 = Globals.language.dealsTEXTB2


--pantalla

local wallScreen = display.newGroup()

----------------------------------------------------------
-- Funciones
----------------------------------------------------------

--llama la pantalla del partner
function showPartner( event )
	storyboard.removeScene( "src.Partner" )
	storyboard.gotoScene( "src.Partner", {
		time = 400,
		effect = "crossFade",
		params = { idPartner = itemObj.partnerId, name = itemObj.partner }
	})
end

--muestra la lista de amigos
function showFriends( event )
	showListFriends(event.target.id)
	return true;
end

function AssignedCoupon(item)
	if #item > 0 then
		if item[1].status == '1' then
			itemObj.assigned = 1
		elseif item[1].status == '2' then
			itemObj.assigned = 2
		elseif item[1].status == '3' then
			itemObj.assigned = 3
		end
		itemObj.code = item[1].code
	else
		itemObj.assigned = 0
	end
		
	if FlagCoupon == 0 then
		createCoupon()
	end
end

function lokedShowRedimir( event )
	return true
end
function doRedimir(  )
    -- Close window
    if groupDownload then
        groupDownload:removeSelf()
        groupDownload = nil
    end
    
    -- Redemption coupon
    RestManager.useCoupon(itemObj.id)
    
    -- change buttons
    lastY = lastY + 55
    groupDesc.y = 45
    rctBtn.height = 100
    txtBtn.text = ""
    rctBtn:setFillColor( 0, .2, .4 )
    rctBtnB.alpha = 0
    local txtBtn1 = display.newText( {
        text =  Globals.language.dealstxtBtn, x = midW, y = 395,
        font = "Lato-Heavy", fontSize = 32, align = "center"
    })
    txtBtn1:setFillColor( 1 )
    svCoupon:insert( txtBtn1 )
    local txtBtn2 = display.newText( {
        text =  os.date("%d-%b-%Y %H:%M"), x = midW, y = 435,
        font = "Lato-Heavy", fontSize = 26, align = "center"
    })
    txtBtn2:setFillColor( 1 )
    svCoupon:insert( txtBtn2 )
    txtTitleInfo.text = Globals.language.dealsTitleInfo
    txtInfo.text =  Globals.language.dealsInfo ..itemObj.partner.. Globals.language.dealsInfo2
	downloadDeal()
end
function locationCupon( event )
     -- Check for error (user may have turned off location services)
    if ( event.errorCode ) then
        print( "Location error: " .. tostring( event.errorMessage ) )
    else
        Runtime:removeEventListener( "location", locationCupon )
        if groupDownload.loading then
            groupDownload.loading:removeSelf()
            groupDownload.loading = nul
        end
        
        -- GPS .0005 = 55mts aprox
        if (event.latitude >= (itemObj.latitude - .0005) and event.latitude <= (itemObj.latitude + .0005)) and
            (event.longitude >= (itemObj.longitude - .0005) and event.longitude <= (itemObj.longitude + .0005)) then
            
            local bgDetail1 = display.newRoundedRect( midW, midH + 50, 430, 80, 10 )
            bgDetail1:setFillColor( .5 )
            groupDownload:insert(bgDetail1)
            local bgDetail2 = display.newRoundedRect( midW, midH + 50, 428, 78, 10 )
            bgDetail2:setFillColor( .15 )
            groupDownload:insert(bgDetail2)
            local txtDetail1 = display.newText( {
                text = Globals.language.dealsTxtUse1,
                x = midW, y = midH + 35, width = 420,
                font = "Lato-Regular", fontSize = 20, align = "center"
            })
            txtDetail1:setFillColor( 1 )
            groupDownload:insert( txtDetail1 )
            local txtDetail2 = display.newText( {
                text = Globals.language.dealsTxtUse2,
                x = midW, y = midH + 65, width = 420,
                font = "Lato-Heavy", fontSize = 23, align = "center"
            })
            txtDetail2:setFillColor( 1 )
            groupDownload:insert( txtDetail2 )

            local bgUse1 = display.newRoundedRect( midW, midH + 135, 430, 60, 5 )
            bgUse1:setFillColor( .2, .6 , 0 )
            bgUse1:addEventListener( "tap", doRedimir )
            groupDownload:insert(bgUse1)
            local txtUse2 = display.newText( {
                text = Globals.language.dealsTxtConfirm,
                x = midW - 15, y = midH + 135, width = 420,
                font = "Lato-Heavy", fontSize = 25, align = "center"
            })
            txtUse2:setFillColor( 1 )
            groupDownload:insert( txtUse2 )
            local btnCouponConfirm = display.newImage( "img/btn/btnCouponConfirm.png" )
            btnCouponConfirm:translate( midW + 100, midH + 135 )
            groupDownload:insert(btnCouponConfirm)

            if groupDownload.loading then
                groupDownload.loading:removeSelf()
                groupDownload.loading = nil
            end
        else
            local bgDetail1 = display.newRoundedRect( midW, midH + 90, 430, 120, 10 )
            bgDetail1:setFillColor( .5 )
            groupDownload:insert(bgDetail1)
            local bgDetail2 = display.newRoundedRect( midW, midH + 90, 428, 118, 10 )
            bgDetail2:setFillColor( .15 )
            groupDownload:insert(bgDetail2)
            local txtDetail = display.newText( {
                text = Globals.language.dealsTxtNear,
                x = midW, y = midH + 90, width = 420,
                font = "Lato-Regular", fontSize = 20, align = "center"
            })
            txtDetail:setFillColor( 1 )
            groupDownload:insert( txtDetail )
            
        end
    end
end

function useCoupon( event )
    local item = event.target.item
    if groupDownload then
        groupDownload:removeSelf()
        groupDownload = nil
    end
    
    -- Creamos anuncio
    groupDownload = display.newGroup()
    groupDownload:addEventListener( "tap", lokedShowRedimir )
    screen:insert(groupDownload)

    local bgShade = display.newRect( midW, midH, display.contentWidth, display.contentHeight )
    bgShade:setFillColor( 0, 0, 0, .7 )
    groupDownload:insert(bgShade)

    local bg = display.newRoundedRect( midW, midH+10, 440, 470, 10 )
    bg:setFillColor( .15 )
    groupDownload:insert(bg)
    
    local imgCoupon = display.newImage( item.image, system.TemporaryDirectory )
    imgCoupon.x= 135
	imgCoupon.y = midH -110
    imgCoupon.width = 220
    imgCoupon.height  = 220
    groupDownload:insert( imgCoupon )
    
    local bgDesc1 = display.newRoundedRect( 355, midH - 110, 200, 220, 10 )
    bgDesc1:setFillColor( .5 )
    groupDownload:insert(bgDesc1)
    
    local bgDesc2 = display.newRoundedRect( 355, midH - 110, 198, 218, 10 )
    bgDesc2:setFillColor( .15 )
    groupDownload:insert(bgDesc2)
    
    local txtMaxDesc = display.newText( {
        text = item.detail,
        x = 355, y = midH - 110, width = 190,
        font = "Lato-Regular", fontSize = 20, align = "center"
    })
    txtMaxDesc:setFillColor( 1 )
    groupDownload:insert( txtMaxDesc )
    
    -- Sprite loading
    local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
    groupDownload.loading = display.newSprite(sheet, Sprites.loading.sequences)
    groupDownload.loading.x = midW
    groupDownload.loading.y = midH + 95
    groupDownload:insert(groupDownload.loading)
    groupDownload.loading:setSequence("play")
    groupDownload.loading:play()
    
    function closeWin(event)
        Runtime:removeEventListener( "location", locationCupon )
        if groupDownload then
            groupDownload:removeSelf()
            groupDownload = nil
        end
    end
    local bgClose1 = display.newRoundedRect( midW - 115, midH + 205, 200, 55, 5 )
    bgClose1:setFillColor( .5 )
    bgClose1:addEventListener( "tap", closeWin )
    groupDownload:insert(bgClose1)
    local bgClose2 = display.newRoundedRect( midW - 115, midH + 205, 198, 53, 5 )
    bgClose2:setFillColor( .15 )
    groupDownload:insert(bgClose2)
    local txtClose = display.newText( {
        text = Globals.language.dealsTxtClose,    
        x = midW - 130, y = midH + 205,
        font = "Lato-Heavy", fontSize = 20
    })
    txtClose:setFillColor( 1 )
    groupDownload:insert( txtClose )
    local btnCouponReturn = display.newImage( "img/btn/btnCouponReturn.png" )
    btnCouponReturn:translate( midW - 70, midH + 205 )
    groupDownload:insert(btnCouponReturn)
    
    Runtime:addEventListener( "location", locationCupon )
    
end

function changeButtonCoupon()
	RestManager.getCouponDownload(itemObj.id)
	rctBtn:removeEventListener( "tap", DownloadCoupon )
	rctBtn:addEventListener( "tap", showRedimir )
    rctBtnB.alpha = 0
end

--obtenemos el grupo wallScreen de la escena actual
function getSceneSearchC( event )
	--modalSeach(txtSearch.text)
	SearchText(wallScreen)
	return true
end

--obtenemos el wallScreen de la escena
function getScreenC()
	return wallScreen
end

function setCouponId( item )
	itemObj = item
	buildCoupon()
end

--llama a la funcion para crear un cupon
function createCoupon()
	FlagCoupon = 1
	buildCoupon()
end

--cambia el boton a deals compartido
function changeBtnShare()
end

--cambia el boton a deals compartido
function doneReden()
end

--crea un cupon
function buildCoupon()

	lastY = 35;
	svCoupon = widget.newScrollView
	{
		top = h + 125 + hWCup,
		left = 0,
		width = intW,
		height = intH - (h + 125 + hWCup),
		listener = scrollListenerContent1,
		horizontalScrollDisabled = true,
        verticalScrollDisabled = false,
		backgroundColor = { .96 }
	}
	wallScreen:insert(svCoupon)
	
	grupoSvCoupon = display.newGroup()
	svCoupon:insert(grupoSvCoupon)

	local imgShape = display.newRoundedRect( midW, 12, 450, 528,12 )
    imgShape.anchorY = 0
	imgShape:setFillColor( 1 )
	svCoupon:insert(imgShape)
	
    local imgCoupon = display.newImage( itemObj.image, system.TemporaryDirectory )
    imgCoupon.x= 135
	imgCoupon.y = lastY + 96
    imgCoupon.width = 220
    imgCoupon.height  = 220
    svCoupon:insert( imgCoupon )
    
    local bgDesc0 = display.newImage( "img/bgk/maskCoupon.png" )
    bgDesc0.x = 135
    bgDesc0.y = lastY + 96
    svCoupon:insert(bgDesc0)
    
    local bgDesc1 = display.newRoundedRect( 353, lastY + 96, 200, 220, 5 )
    bgDesc1:setFillColor( .79 )
    svCoupon:insert(bgDesc1)
    
    local bgDesc2 = display.newRoundedRect( 353, lastY + 96, 198, 218, 5 )
    bgDesc2:setFillColor( 1 )
    svCoupon:insert(bgDesc2)
    
	local txtPartner = display.newText( {
        text = itemObj.partner,    
        x = 355, y = lastY + 50,
        width = 180, height =0,
        font = "Lato-Heavy", fontSize = 23, align = "left"
    })
    txtPartner:setFillColor( 0 )
    svCoupon:insert( txtPartner )
    
	local txtTotalDeals = display.newText( {
        text = itemObj.total.. Globals.language.dealsTxtTotalDeals,
        x = 355, y = lastY + 120,
        width = 180, height =25,
        font = "Lato-Heavy", fontSize = 20, align = "left"
    })
    txtTotalDeals:setFillColor( .58 )
    svCoupon:insert( txtTotalDeals )
    
    local iconReady = display.newImage( "img/btn/iconReady.png" )
    iconReady.x = 275
    iconReady.y = lastY + 150
    svCoupon:insert(iconReady)
    
    local txtStock = display.newText( {
        text = itemObj.stock.. Globals.language.buildAvailable,
        x = 383, y = lastY + 150,
        width = 180, height =25,
        font = "Lato-Heavy", fontSize = 20, align = "left"
    })
    txtStock:setFillColor( .2, .6 , 0 )
    svCoupon:insert( txtStock )
    
    -- Max Desc
    local bgMaxDesc = display.newRoundedRect( midW, lastY + 270, 430, 100, 8 )
	bgMaxDesc:setFillColor( .20 )
	svCoupon:insert(bgMaxDesc)
    
    local txtMaxDesc = display.newText( {
        text = itemObj.detail,
        x = 240, y = lastY + 270,
        width = 410, height = 0,
        font = "Lato-Regular", fontSize = 20, align = "center"
    })
    txtMaxDesc:setFillColor( 1 )
    svCoupon:insert( txtMaxDesc )
    
    -- Descarga / Redime
	rctBtn = display.newRoundedRect( midW, lastY + 332, 430, 55, 5 )
    rctBtn.anchorY = 0
	rctBtn.item = itemObj
	rctBtn:setFillColor( .2, .6, 0 )
	svCoupon:insert(rctBtn)
    
    rctBtnB = display.newRoundedRect( midW, lastY + 378, 430, 22, 5 )
    rctBtnB:setFillColor( {
        type = 'gradient',
        color1 = { .2, .6, 0 }, 
        color2 = { .1, .5, 0 },
        direction = "bottom"
    } ) 
    svCoupon:insert(rctBtnB)

	txtBtn = display.newText( {
		text =  Globals.language.dealsTxtBtnDowCre,
		x = midW, y = lastY + 360,
		width = 210, height = 0,
		font = "Lato-Heavy", fontSize = 18, align = "center"
	})
	txtBtn:setFillColor( 1 )
	svCoupon:insert( txtBtn )
    
    lastY = lastY + 60
    groupDesc = display.newGroup()
    svCoupon:insert(groupDesc)
    
    local btnCouponCommon = display.newImage( "img/btn/btnCouponCommon.png" )
    btnCouponCommon:translate(midW - 110, lastY + 370)
	btnCouponCommon:addEventListener( "tap", showPartner )
    groupDesc:insert(btnCouponCommon)
    local txtBtnPartner = display.newText( {
		text =  Globals.language.dealsTxtBtnPerfilComer,
		x = midW - 110, y = lastY + 370,
		font = "Lato-Heavy", fontSize = 14, align = "center"
	})
	txtBtnPartner:setFillColor( .2 )
	groupDesc:insert( txtBtnPartner )
    
    local imgBtnShare = display.newImage( "img/btn/btnCouponCommon.png" )
    imgBtnShare:translate(midW + 110, lastY + 370)
    imgBtnShare.id = itemObj.id
	imgBtnShare:addEventListener( "tap", showFriends )
    groupDesc:insert(imgBtnShare)
    local txtBtnComer = display.newText( {
		text =  Globals.language.dealsTxtBtnComer,
		x = midW + 110, y = lastY + 370,
		font = "Lato-Heavy", fontSize = 14, align = "center"
	})
	txtBtnComer:setFillColor( .2 )
	groupDesc:insert( txtBtnComer )
    
	txtTitleInfo = display.newText( {
		text = Globals.language.dealsTxtTitleInfoInterest,
		x = 240, y = lastY + 420,
		width = 400, height = 0,
		font = "Lato-Heavy", fontSize = 16, align = "left"
	})
	txtTitleInfo:setFillColor( 0 )
	groupDesc:insert( txtTitleInfo )

	txtInfo = display.newText( {
		text =  Globals.language.dealsTxtInfoWallet ..
				Globals.language.dealsTxtInfoWallet2,
		x = 240, y = lastY + 465,
		width = 400, height = 60,
		font = "Lato-Regular", fontSize = 16, align = "left"
	})
	txtInfo:setFillColor( 0 )
	groupDesc:insert( txtInfo )
    
    local txtValidity = display.newText( {
        text = Globals.language.dealsTxtValidity,
        x = 240, y = lastY + 510,
        width = 400, height = 20 ,
        font = "Lato-Heavy", fontSize = 16, align = "left"
    })
    txtValidity:setFillColor( 0 )
    groupDesc:insert( txtValidity )
    
    local txtValidityInfo = display.newText( {
		text =  itemObj.validity,
		x = 240, y = lastY + 540,
		width = 400, height = 40,
		font = "Lato-Regular", fontSize = 16, align = "left"
	})
	txtValidityInfo:setFillColor( 0 )
	groupDesc:insert( txtValidityInfo )
    
    -- Detail Clauses
    local txtAdditionalInformation = display.newText({
		text = Globals.language.dealsTxtAdditionalInformation,
		--x = 230, y =  560,
		x = 240, y =  lastY + 565,
		height = 20, width = 400,
		font = "Lato-Heavy", fontSize = 16, align = "left"
	})
	txtAdditionalInformation:setFillColor( 0 )
	groupDesc:insert(txtAdditionalInformation)
	
	lastY = lastY + 550
	local txtClauses = display.newText({
		text = itemObj.clauses,
		x = 230, y = 600,
		x = midW, y = lastY + 15,
		width = 400,
		font = "Lato-Regular", fontSize = 16, align = "left"
	})
	txtClauses:setFillColor( 0 )
    txtClauses.y = txtClauses.height/2 + txtClauses.y + 10
	groupDesc:insert( txtClauses )
    
	if itemObj.stock == '0' then
		txtTitleInfo.text = Globals.language.dealsTxtTitleInfoTired
		txtInfo.text =  Globals.language.dealsTxtInfoTired ..itemObj.partner..
						Globals.language.dealsTxtBtnTired2
		txtBtn.text = Globals.language.dealsTxtBtnTired
		rctBtn:setFillColor( .8, .6, .6 )
        rctBtnB.alpha = 0
		txtStock:setFillColor( .8, .5, .5 )
    elseif itemObj.assigned == 2 or itemObj.assigned == '2' then
        lastY = lastY + 55
        groupDesc.y = 45
        rctBtn.height = 100
        txtBtn.text = ""
        rctBtn:setFillColor( 0, .2, .4 )
        rctBtnB.alpha = 0
        local txtBtn1 = display.newText( {
            text =  Globals.language.dealstxtBtn, x = midW, y = 395,
            font = "Lato-Heavy", fontSize = 32, align = "center"
        })
        txtBtn1:setFillColor( 1 )
        svCoupon:insert( txtBtn1 )
        local txtBtn2 = display.newText( {
            text =  itemObj.redemptionDate, x = midW, y = 435,
            font = "Lato-Heavy", fontSize = 26, align = "center"
        })
        txtBtn2:setFillColor( 1 )
        svCoupon:insert( txtBtn2 )
        txtTitleInfo.text = Globals.language.dealsTitleInfo
		txtInfo.text =  Globals.language.dealsInfo ..itemObj.partner.. Globals.language.dealsInfo2
	else
		rctBtn:addEventListener( "tap", useCoupon )
	end
    
    txtClauses.height = txtClauses.height + 10
	lastY = lastY + txtClauses.height + 45
    imgShape.height = lastY + 5
    
    -- ReadOnly by Free Login
    if Globals.isReadOnly then
        rctBtn:setFillColor( .7 )
        rctBtnB.alpha = 0
        rctBtn:removeEventListener( "tap", useCoupon )
        rctBtn:removeEventListener( "tap", showRedimir )
        imgBtnShare:removeEventListener( "tap", showFriends )
    end
	
    local spc = display.newRect( 0, lastY + 60, 1, 1 )
    spc:setFillColor( 0 )
    svCoupon:insert( spc )
    
	svCoupon:setScrollHeight(lastY + 50)
    
end

----------------------------------------------------------
-- Funciones Default
----------------------------------------------------------

function scene:createScene( event )

	screen = self.view
	screen:insert(wallScreen)
	
	-- Build Component Header
	local header = Header:new()
    wallScreen:insert(header)
    header.y = h
    header:buildToolbar()
    header:buildNavBar(event.params.item.name)
    hWCup = 5 + header:buildWifiBle()
	
	--obtenemos los parametros del cupon
	if event.params.item == nil then
		RestManager.getCouponById(1)
	else
		itemObj = event.params.item
		--verifica si el cupon ha sido descargado
		RestManager.getCouponDownload(itemObj.id)
		--createCoupon()
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