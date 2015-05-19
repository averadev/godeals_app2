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
local groupMenu, groupEvent, groupMenuEventText, grpRedem
local svCoupon, svInfo, svPromotions, svGallery, sprCheck
local h = display.topStatusBarContentHeight
local lastY = 200
local lastYCoupon = 0
local itemObj
local currentSv
local settings
local rctBtn
local FlagCoupon = 0
local imgBtnShare = ""

local txtInfo, txtBtn, txtTitleInfo, loadingRed, rctRed, txtRed
local info, promotions, gallery, MenuEventBar, txtInfoRedimir2
local btnDownloadCoupon

local fx = audio.loadStream( "fx/alert.wav" )


local TEXTA1 = "* O activa tu bluetooth y solicita al comercio su dispositivo GO"
local TEXTA2 = "* O solicita al comercio su dispositivo GO"
local TEXTB1 = "* Activa tu bluetooth y acerca tu teléfono al dispositivo GO"
local TEXTB2 = "* Acerca tu teléfono al dispositivo GO"


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

function listenerBeaconIOS( event )
    if grpRedem.isInit then
        grpRedem.isInit = false
        rctRed.y = midH - 30
		txtRed.y = midH - 30
        rctRed:removeEventListener( "tap", showRedimir )
        rctRed:addEventListener( "tap", goBLEIos )
        
        if event.message == "1" then
            txtInfoRedimir2.text = TEXTA1
        elseif event.message == "2" then
            txtInfoRedimir2.text = TEXTA2
        else
            rctRed:addEventListener( "tap", showRedimir )
        end
    else
        -- Desactivamos loading
        loadingRed.alpha = 0
        loadingRed:setSequence("stop")
        loadingRed:play()
        
        rctRed.enable = true
        rctRed:setFillColor( .2, .6 ,0 )
        txtInfoRedimir2:setFillColor( 147/255, 0, 0 )
        
        if event.message == "1" then
            txtInfoRedimir2.text = TEXTB1
        elseif event.message == "2" then
            txtInfoRedimir2.text = TEXTB2
        end
        
        if  DBManager.getReden() == 1 then
            DBManager.setReden()
        else
            audio.play( fx )
            RestManager.redemptionDeal(itemObj.code)
            txtTitleInfo.text = "Deal redimido"
            txtInfo.text =  "No olvides consultar los otros Deals que "..itemObj.partner.." te ofrece."
            txtBtn.text = "DEAL REDIMIDO"
            rctBtn:setFillColor( .72, .82, .93 )
            rctBtn:removeEventListener( "tap", showRedimir )
            
            sprCheck.alpha = .7
            sprCheck:setSequence("play")
            sprCheck:play()
            timer.performWithDelay(1000, function() 
                showRedimir()
            end)
        end
    end
end

function goBLEIos(event)
	t = event.target
	if t.enable then
		-- Deshabilitar boton
		t.enable = false
		t:setFillColor( .4 )
        -- Redencion
        DBManager.updateReden();
        loadingRed.alpha = 1
        loadingRed:setSequence("play")
        loadingRed:play()
        DBManager.updateReden()
        timer.performWithDelay(3000, function() 
            redimirObj.getRed()
        end)
    end
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

function goBLE(event)
	t = event.target
	if t.enable then
		-- Deshabilitar boton
		t.enable = false
		t:setFillColor( .4 )
		
		-- Validar estado del BT
		local value = 0
		if getBeacon then
			value = getBeacon.verifyBLE()
		end
		
		if value == 1 then
			transition.to( txtInfoRedimir2, { alpha = 0, time = 200, 
				onComplete=function()
						txtInfoRedimir2.text = TEXTB1
						txtInfoRedimir2:setFillColor( 147/255, 0, 0 )
						transition.to( txtInfoRedimir2, { alpha = 1, time = 200})
						t.enable = true
						t:setFillColor( .2, .6 ,0 )
				end
			})
		elseif value == 2 then
			-- Activamos loading
			loadingRed.alpha = 1
			loadingRed:setSequence("play")
			loadingRed:play()
			DBManager.setReden()
			
			timer.performWithDelay(500, function() 
				-- Check Beacon
				getBeacon.redemption()
				value = DBManager.getReden()

				-- Desactivamos loading
				loadingRed.alpha = 0
				loadingRed:setSequence("stop")
				loadingRed:play()

				if value == 0 then
					transition.to( txtInfoRedimir2, { alpha = 0, time = 200, 
						onComplete=function()
								txtInfoRedimir2.text = TEXTB2
								txtInfoRedimir2:setFillColor( 147/255, 0, 0 )
								transition.to( txtInfoRedimir2, { alpha = 1, time = 200})
								t.enable = true
								t:setFillColor( .2, .6 ,0 )
						end
					})
				elseif value == 1 then
					audio.play( fx )
					DBManager.setReden()
					RestManager.redemptionDeal(itemObj.code)
					
					txtBtn.text = "DEAL REDIMIDO"
					rctBtn:setFillColor( .72, .82, .93 )
					rctBtn:removeEventListener( "tap", showRedimir )
                    
                    sprCheck.alpha = .7
                    sprCheck:setSequence("play")
                    sprCheck:play()
                    timer.performWithDelay(1000, function() 
                        showRedimir()
                    end)
				end
			end)
		end
	end
	
end

function showRedimir( event )

    if grpRedem then
        grpRedem:removeSelf()
        grpRedem = nil
    else
		if itemObj.code ~= nil then
			grpRedem = display.newGroup()
			wallScreen:insert(grpRedem)
			
			-- Creamos la mascara
			local mask = display.newRect( midW, midH, intW, intH )
			mask:setFillColor( 0 )
			mask.alpha = .9
			mask:addEventListener( "tap", lokedShowRedimir )
			mask:addEventListener( "touch", lokedShowRedimir )
			grpRedem:insert(mask)
			
			local bgRedimir = display.newImage( "img/bgk/redemption.png" )
			bgRedimir.x = midW
			bgRedimir.y = midH
			grpRedem:insert(bgRedimir)
			
			local btnClose = display.newImage( "img/btn/btnClose.png" )
			btnClose.x = intW - 25
			btnClose.y = midH - 310
			btnClose:addEventListener( "tap", showRedimir )
			btnClose:addEventListener( "touch", lokedShowRedimir )
			grpRedem:insert(btnClose)
		
			local txtCode = display.newText({
				text = "CODIGO PARA CANJEAR",
				x = midW, y = midH - 270,
				width = 480,
				font = "Lato-Black", fontSize = 30, align = "center"
			})
			txtCode:setFillColor( 0 )
			grpRedem:insert(txtCode)
		
			local txtCode = display.newText({
				text = itemObj.code,
				x = midW, y = midH - 230,
				width = 480,
				font = "Lato-Black", fontSize = 50, align = "center"
			})
			txtCode:setFillColor( 5/255, 147/255, 0 )
			grpRedem:insert(txtCode)
			
			local txtInfoRedimir = display.newText({
				text = "* Proporciona este código al comercio para hacer válido tu Deal",
				x = midW, y = midH - 160,
				width = 400,
				font = "Lato-Black", fontSize = 20, align = "left"
			})
			txtInfoRedimir:setFillColor( 0 )
			grpRedem:insert(txtInfoRedimir)

			rctRed = display.newRoundedRect( midW, midH -70, 270, 55, 5 )
			rctRed.enable = true
			rctRed.idCoipon = itemObj.id
			rctRed:setFillColor( .2, .6 ,0 )
			grpRedem:insert(rctRed)

			txtRed = display.newText( {
				text =  "CONTINUAR",
				x = midW, y = midH -70,
				width = 270, height = 0,
				font = "Lato-Regular", fontSize = 25, align = "center"
			})
			txtRed:setFillColor( 1 )
			grpRedem:insert(txtRed)
			
			-- Sprite and text
			local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
			loadingRed = display.newSprite(sheet, Sprites.loading.sequences)
			loadingRed.x = midW
			loadingRed.y = midH + 20
			loadingRed.alpha = 0
			grpRedem:insert(loadingRed)
			
			-- Validar BLE y android => JellyBean
			local value = 0
			if getBeacon then
				value = getBeacon.verifyBLE()
			end
			
			if value == 0 then
				rctRed:addEventListener( "tap", showRedimir )
			elseif value == 1 then
				txtInfoRedimir2 = display.newText({
					text = TEXTA1,
					x = midW, y = midH - 100,
					width = 400,
					font = "Lato-Black", fontSize = 20, align = "left"
				})
				txtInfoRedimir2:setFillColor( 0 )
				grpRedem:insert(txtInfoRedimir2)
				
				rctRed.y = midH - 30
				txtRed.y = midH - 30
				rctRed:addEventListener( "tap", goBLE )
				
			elseif value == 2 then
				txtInfoRedimir2 = display.newText({
					text = TEXTA2,
					x = midW, y = midH - 100,
					width = 380,
					font = "Lato-Black", fontSize = 20, align = "left"
				})
				txtInfoRedimir2:setFillColor( 0 )
				grpRedem:insert(txtInfoRedimir2)
				
				rctRed.y = midH - 30
				txtRed.y = midH - 30
				rctRed:addEventListener( "tap", goBLE )
			end	
			
            -- Verify for Android
			if redimirObj then
                txtInfoRedimir2 = display.newText({
                    text = "",
                    x = midW, y = midH - 100,
                    width = 400,
                    font = "Lato-Black", fontSize = 20, align = "left"
                })
                txtInfoRedimir2:setFillColor( 0 )
                grpRedem:insert(txtInfoRedimir2)
                grpRedem.isInit = true
                
                timer.performWithDelay(300, function() 
                    redimirObj.getStatus()
                end)
                
            end
			            
            --DoneReden
            local sheetCheck = graphics.newImageSheet(Sprites.check.source, Sprites.check.frames)
            sprCheck = display.newSprite(sheetCheck, Sprites.check.sequences)
            sprCheck.x = midW
            sprCheck.y = intH / 3
            sprCheck.alpha = 0
            grpRedem:insert(sprCheck)
            
		end
    end
end

function lokedShowRedimir( event )
	return true
end

function DownloadCoupon( event )
	transition.to( txtTitleInfo, { alpha = 0, time = 200, transition = easing.outExpo } )
	transition.to( txtInfo, { alpha = 0, time = 200, transition = easing.outExpo } )
	transition.to( txtBtn, { alpha = 0, time = 200, transition = easing.outExpo } )
	
	timer.performWithDelay(200, function() 
		txtTitleInfo.text = "Redime este Deal!"
		txtInfo.text = "Deja presionado el botón mientras lo acercas a nuestro dispositivo GO> "..
                            "disponible en todos los establecimientos afiliados. PREGUNTA POR EL!"
		txtBtn.text = "REDIMIR DEAL"
			
		transition.to( txtBtn, { alpha = 1, time = 200, delay = 200, transition = easing.outExpo } )
		transition.to( txtInfo, { alpha = 1, time = 200, delay = 200, transition = easing.outExpo } )
		transition.to( txtTitleInfo, { alpha = 1, time = 200, delay = 200, transition = easing.outExpo } )
	end, 1)
	
	RestManager.discountCoupon(event.target.idCoipon)
	
end

function changeButtonCoupon()
	RestManager.getCouponDownload(itemObj.id)
	rctBtn:removeEventListener( "tap", DownloadCoupon )
	rctBtn:addEventListener( "tap", showRedimir )
	imgBtnShare:removeEventListener( 'tap', showFriends )
	imgBtnShare.alpha = .2
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

	transition.to( txtTitleInfo, { alpha = 0, time = 200, transition = easing.outExpo } )
	transition.to( txtInfo, { alpha = 0, time = 200, transition = easing.outExpo } )
	transition.to( txtBtn, { alpha = 0, time = 200, transition = easing.outExpo } )
	
	imgBtnShare:removeEventListener( 'tap', showFriends )
	rctBtn:removeEventListener( "tap", DownloadCoupon )
	
	timer.performWithDelay(200, function() 
		txtTitleInfo.text = "Ha compartido este deals!"
		txtInfo.text = "No olvides consultar los otros Deals que "..itemObj.partner.." te ofrece"
		txtBtn.text = "DEAL COMPARTIDO"
		
		rctBtn:setFillColor( .72, .82, .93 )
		imgBtnShare.alpha = .2
			
		transition.to( txtBtn, { alpha = 1, time = 200, delay = 200, transition = easing.outExpo } )
		transition.to( txtInfo, { alpha = 1, time = 200, delay = 200, transition = easing.outExpo } )
		transition.to( txtTitleInfo, { alpha = 1, time = 200, delay = 200, transition = easing.outExpo } )
	end, 1)

end

--cambia el boton a deals compartido
function doneReden()
end

--crea un cupon
function buildCoupon()

	lastY = 55;

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
	wallScreen:insert(svCoupon)
	
	grupoSvCoupon = display.newGroup()
	svCoupon:insert(grupoSvCoupon)
	
	--[[local imgBtnShare = display.newImage( "img/btn/share.png" )
	imgBtnShare.alpha = 1
    imgBtnShare.x= intW - imgBtnShare.height
	imgBtnShare.y = lastY
    svCoupon:insert( imgBtnShare )
	imgBtnShare:addEventListener( 'tap', showFriends )]]

	local imgShape = display.newRoundedRect( midW, 296, 450, 528,12 )
	imgShape:setFillColor( 1 )
	svCoupon:insert(imgShape)
	
	local imgBgCoupon = display.newImage( "img/bgk/bgCoupon.png" )
	imgBgCoupon.alpha = 1
    imgBgCoupon.x= midW
	imgBgCoupon.y =  295
	--imgBgCoupon.y = 300
	imgBgCoupon.height = 530
    svCoupon:insert( imgBgCoupon )
    
    local mask = graphics.newMask( "img/bgk/maskBig.jpg" )
	local imgCoupon = display.newImage( itemObj.image, system.TemporaryDirectory )
    imgCoupon.x= 100
	imgCoupon.y = lastY + 122
    imgCoupon.width = 140
    imgCoupon.height  = 140
    svCoupon:insert( imgCoupon )
    imgCoupon:setMask( mask )
    
	local txtPartner = display.newText( {
        text = itemObj.partner,    
        x = 320, y = lastY + 80,
        width = 280, height =0,
        font = "Lato-Regular", fontSize = 30, align = "left"
    })
    txtPartner:setFillColor( 0 )
    svCoupon:insert( txtPartner )
    
	local txtTotalDeals = display.newText( {
        text = itemObj.total.." Deals",
        x = 300, y = lastY + 115,
        width = 240, height =25,
        font = "Lato-Regular", fontSize = 20, align = "left"
    })
    txtTotalDeals:setFillColor( 0 )
    svCoupon:insert( txtTotalDeals )
    
    local txtStock = display.newText( {
        text = itemObj.stock.." Disponibles",
        x = 300, y = lastY + 140,
        width = 240, height =25,
        font = "Lato-Regular", fontSize = 20, align = "left"
    })
    txtStock:setFillColor( .2, .6 ,0 )
    svCoupon:insert( txtStock )
	
	--img info--
	
	--[[local imgBtnInfo = display.newImage( "img/btn/info.png" )
	imgBtnInfo.alpha = 1
    imgBtnInfo.x= intW - imgBtnInfo.height
	imgBtnInfo.y = lastY + 70
    svCoupon:insert( imgBtnInfo )]]
	
	--btn de compartir
	imgBtnShare = display.newImage( "img/btn/share.png" )
	imgBtnShare.alpha = .2
    imgBtnShare.x= intW - imgBtnShare.height
	imgBtnShare.y = lastY + 20
	imgBtnShare.id = itemObj.id
    svCoupon:insert( imgBtnShare )
	
	----------
    
    local txtValidity = display.newText( {
        text = "VIGENCIA: "..itemObj.validity,
        x = 300, y = lastY + 172,
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
    local bgMaxDesc = display.newRect( midW, lastY + 260, 444, 80 )
	bgMaxDesc:setFillColor( .89 )
	svCoupon:insert(bgMaxDesc)
    
    local txtMaxDesc = display.newText( {
        text = itemObj.detail,
        x = 240, y = lastY + 260,
        width = 410, height = 0,
        font = "Lato-Regular", fontSize = 20, align = "center"
    })
    txtMaxDesc:setFillColor( 0 )
    svCoupon:insert( txtMaxDesc )
    
    
    -- Descarga / Redime
	txtTitleInfo = display.newText( {
		text = "¿Te interesa este Deal?",
		x = 240, y = lastY + 340,
		width = 400, height = 0,
		font = "Lato-Bold", fontSize = 16, align = "left"
	})
	txtTitleInfo:setFillColor( 0 )
	svCoupon:insert( txtTitleInfo )

	txtInfo = display.newText( {
		text =  "No lo pienses más y descárgalo, "..
				"se guardará en tu cartera para que lo uses en tu próxima visita.",
		x = 240, y = lastY + 385,
		width = 400, height = 60,
		font = "Lato-Regular", fontSize = 16, align = "left"
	})
	txtInfo:setFillColor( 0 )
	svCoupon:insert( txtInfo )

	rctBtn = display.newRoundedRect( midW, lastY + 450, 400, 55, 5 )
	rctBtn.idCoipon = itemObj.id
	rctBtn:setFillColor( .2, .6 ,0 )
	svCoupon:insert(rctBtn)

	txtBtn = display.newText( {
		text =  "DESCARGAR DEAL",
		x = 240, y = lastY + 450,
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
	elseif itemObj.assigned == 3 or itemObj.assigned == '3' then
		txtTitleInfo.text = "Deal compartido"
		txtInfo.text =  "No olvides consultar los otros Deals que "..itemObj.partner.." te ofrece."
		txtBtn.text = "DEAL COMPARTIDO"
		rctBtn:setFillColor( .72, .82, .93 )
	elseif itemObj.stock == '0' then
		txtTitleInfo.text = "Lo sentimos."
		txtInfo.text =  "Este Deal se ha agotado, pero no te preocupes "..itemObj.partner..
						" y el equipo de GoDeals tienen mas promociones para ti!"
		txtBtn.text = "AGOTADO"
		rctBtn:setFillColor( .8, .6, .6 )
		txtStock:setFillColor( .8, .5, .5 )
    elseif itemObj.assigned == 2 or itemObj.assigned == '2' then
		txtTitleInfo.text = "Deal redimido"
		txtInfo.text =  "No olvides consultar los otros Deals que "..itemObj.partner.." te ofrece."
		txtBtn.text = "DEAL REDIMIDO"
		rctBtn:setFillColor( .72, .82, .93 )
	else
		rctBtn:addEventListener( "tap", DownloadCoupon )
		imgBtnShare.alpha = 1
		imgBtnShare:addEventListener( 'tap', showFriends )
	end
	
	--btnFriends:addEventListener( 'tap', showFriends )
	
	lastY = 150 + lastY
	
	lastY = lastY + imgBgCoupon.height - 120
    
    -- Detail Clauses
    local txtAdditionalInformation = display.newText({
		text = "Informacion Adicional:",
		--x = 230, y =  560,
		x = 230, y =  lastY,
		height = 20, width = 400,
		font = "Lato-Bold", fontSize = 16, align = "left"
	})
	txtAdditionalInformation:setFillColor( 0 )
	svCoupon:insert(txtAdditionalInformation)
	
	lastY = lastY + txtAdditionalInformation.height + 10
	
	local txtClauses = display.newText({
		text = itemObj.clauses,
		--x = midW, y = 580,
		x = midW, y = lastY,
		width = 420,
		font = "Lato-Regular", fontSize = 16, align = "left"
	})
	txtClauses:setFillColor( 0 )
    txtClauses.y = txtClauses.height/2 + txtClauses.y
	svCoupon:insert( txtClauses )
	
	txtClauses.height = txtClauses.height + 10
	lastY = lastY + txtClauses.height + 40
	
	local txtAdditionalInformation = display.newText({
		text = "Consultar comercio",
		x = 230, y = lastY,
		height = 40, width = 400,
		font = "Chivo", fontSize = 22, align = "center"
	})
    txtAdditionalInformation.itemObj = itemObj
	txtAdditionalInformation:setFillColor( .27, .5, .7 )
	txtAdditionalInformation:addEventListener( "tap", showPartner )
	svCoupon:insert( txtAdditionalInformation )
    
	local lineLink = display.newRect( 130, lastY + 10, 200, 1 )
	lineLink.anchorX = 0
	lineLink.anchorY = 0
	lineLink:setFillColor( .27, .5, .7 )
	svCoupon:insert( lineLink )
	
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