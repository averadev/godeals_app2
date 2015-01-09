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
local toolbar, menu, textTitulo1, textTitulo2, textTitulo3, loading, mask
local groupMenu, grupoScroll1, grupoScroll2, grupoScroll3 
local scrollViewContent1, scrollViewContent2, scrollViewContent3
local imageBusqueda
local imageItems = {}
local coupons = {}
local events = {}
local content1
local noCallback = 0
local noPackage = 1
local noPackage2 = 1
local loading, titleLoading
local h = display.topStatusBarContentHeight
local lastY = 175;
local settings
local modal, btnModalC, btnModal
local contadorFecha = 0, tituloFecha
local contadorMes = {0,0,0,0,0,0,0,0,0,0,0,0}
local tipoConsulta
local totalEventos = 0

local intW = display.contentWidth
local intH = display.contentHeight
local midW = display.contentCenterX
local midH = display.contentCenterY

--pantalla

local homeScreen = display.newGroup()
local grupoModal = display.newGroup()

--- scrollView function

local function scrollListenerContent1( event )
	if event.phase == "began" then
		
		scrollViewContent1:setScrollWidth(  480 )
		diferenciaX = event.x - scrollViewContent1.x
		posicionMenu = groupMenu.x
    elseif event.phase == "moved" then
		if  event.direction == "left"  or event.direction == "right" then
		posicionNueva = event.x-diferenciaX
		scrollViewContent1.x = posicionNueva
		scrollViewContent2.x = 480+posicionNueva
		--groupMenu.x = posicionNueva/3 + posicionMenu
		groupMenu.x = ((posicionNueva - 240) / 3) + posicionMenu
		end
		
		movimiento = "c"
		if(event.direction == "left") then
			movimiento = "i"
		elseif event.direction == "right" then
			movimiento = "d"
		end
		
    elseif event.phase == "ended" or event.phase == "cancelled" then
		--scrollViewContent1:setScrollWidth(  480 )
		if event.x <= 100 and movimiento == "i" then
			transition.to( scrollViewContent1, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.35, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent2, { x = 240, time = 400, transition = easing.outExpo } )
			textTitulo1:setFillColor( 161/255, 161/255, 161/255 )
			textTitulo3:setFillColor( 161/255, 161/255, 161/255 )
			textTitulo2:setFillColor( 0 )
		--[[elseif event.x  >= 380 and movimiento == "d" then
			transition.to( scrollViewContent1, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * 0.35, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent2, { x = 720, time = 400, transition = easing.outExpo } )]]
		else
			transition.to( scrollViewContent1, { x = 240, time = 400, transition = easing.outExpo } )
			--transition.to( grupoScroll1, { x = 480, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = 0, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent2, { x = 720, time = 400, transition = easing.outExpo } )
		end
    end
end

local function scrollListenerContent2( event )
    local phase = event.phase
    if ( phase == "began" ) then 
		diferenciaX = event.x - scrollViewContent2.x
		diferenciaTextX =  groupMenu.x
    elseif ( phase == "moved" ) then
	
		if  event.direction == "left"  or event.direction == "right" then
		
		diferenciaTextX = diferenciaTextX - 1
		posicionNueva = event.x-diferenciaX
		scrollViewContent2.x = posicionNueva
		groupMenu.x = (posicionNueva - 740) / 3
		scrollViewContent3.x = 480+(posicionNueva)
		scrollViewContent1.x = -480+posicionNueva
		end
		movimiento = "c"
		if(event.direction == "left") then
			movimiento = "i"
		elseif event.direction == "right" then
			movimiento = "d"
		end
    elseif ( phase == "ended" ) then
		if event.x <= 100 and movimiento == "i" then
			transition.to( scrollViewContent2, { x = -240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.70, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent3, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent1, { x = -240, time = 400, transition = easing.outExpo } )
			textTitulo1:setFillColor( 161/255, 161/255, 161/255 )
			textTitulo2:setFillColor( 161/255, 161/255, 161/255 )
			textTitulo3:setFillColor( 0 )
		elseif event.x  >= 380 and movimiento == "d" then
			transition.to( scrollViewContent2, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = 0, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent3, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent1, { x = 240, time = 400, transition = easing.outExpo } )
			textTitulo3:setFillColor( 161/255, 161/255, 161/255 )
			textTitulo2:setFillColor( 161/255, 161/255, 161/255 )
			textTitulo1:setFillColor( 0 )
		else
			transition.to( scrollViewContent2, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.35, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent3, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent1, { x = -240, time = 400, transition = easing.outExpo } )
		end
			
		
    end
    return true
end

local function scrollListenerContent3( event )
	if event.phase == "began" then
		diferenciaX = event.x - scrollViewContent3.x
		posicionMenu = groupMenu.x
    elseif event.phase == "moved" then
		if  event.direction == "left"  or event.direction == "right" then
		posicionNueva = event.x-diferenciaX
		scrollViewContent3.x = posicionNueva
		scrollViewContent2.x = -480+posicionNueva
		--groupMenu.x = posicionNueva/3 - (-posicionMenu)
		groupMenu.x = ((posicionNueva - 240) / 3) + posicionMenu
		end
		
		movimiento = "c"
		if(event.direction == "left") then
			movimiento = "i"
		elseif event.direction == "right" then
			movimiento = "d"
		end
		
    elseif event.phase == "ended" or event.phase == "cancelled" then
		--[[if event.x <= 100 and movimiento == "i" then
			transition.to( scrollViewContent3, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.35, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent2, { x = -240, time = 400, transition = easing.outExpo } )]]
		if event.x  >= 380 and movimiento == "d" then
			transition.to( scrollViewContent3, { x = 720, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.35, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent2, { x = 240, time = 400, transition = easing.outExpo } )
			textTitulo1:setFillColor( 161/255, 161/255, 161/255 )
			textTitulo3:setFillColor( 161/255, 161/255, 161/255 )
			textTitulo2:setFillColor( 0 )
		else
			transition.to( scrollViewContent3, { x = 240, time = 400, transition = easing.outExpo } )
			transition.to( groupMenu, { x = display.contentWidth * - 0.70, time = 400, transition = easing.outExpo } )
			transition.to( scrollViewContent2, { x = -240, time = 400, transition = easing.outExpo } )
		end
    end
end

local function tapTitulo1(event)
	scrollViewContent1:setScrollWidth(  480 )
	transition.to( scrollViewContent2, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( groupMenu, { x = 0, time = 400, transition = easing.outExpo } )
	transition.to( scrollViewContent3, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( scrollViewContent1, { x = 240, time = 400, transition = easing.outExpo } )
	textTitulo2:setFillColor( 161/255, 161/255, 161/255 )
	textTitulo3:setFillColor( 161/255, 161/255, 161/255 )
	textTitulo1:setFillColor( 0 )
end

local function tapTitulo2(event)
	transition.to( scrollViewContent2, { x = 240, time = 400, transition = easing.outExpo } )
	transition.to( groupMenu, { x = display.contentWidth * - 0.35, time = 400, transition = easing.outExpo } )
	transition.to( scrollViewContent3, { x = 720, time = 400, transition = easing.outExpo } )
	transition.to( scrollViewContent1, { x = -240, time = 400, transition = easing.outExpo } )
	textTitulo1:setFillColor( 161/255, 161/255, 161/255 )
	textTitulo3:setFillColor( 161/255, 161/255, 161/255 )
	textTitulo2:setFillColor( 0 )
	
end

local function tapTitulo3(event)
	transition.to( scrollViewContent3, { x = 240, time = 400, transition = easing.outExpo } )
	transition.to( groupMenu, { x = display.contentWidth * - 0.70, time = 400, transition = easing.outExpo } )
	transition.to( scrollViewContent2, { x = -240, time = 400, transition = easing.outExpo } )
	textTitulo1:setFillColor( 161/255, 161/255, 161/255 )
	textTitulo2:setFillColor( 161/255, 161/255, 161/255 )
	textTitulo3:setFillColor( 0 )
end

 function CloseModal( event )
	--btnModalC:removeSelf()
	rect1Modal:removeSelf()
	rect2Modal:removeSelf()
	rect3Modal:removeSelf()
	rect4Modal:removeSelf()
	modal:removeSelf()
	bgModal:removeSelf()
	scrollViewContent1:setIsLocked( false )
	return true
end

function modalFunction( event )
	return true
end

 function openModal ( event )
 
	bgModal = display.newRect(0,0,intW,intH)
	bgModal.anchorX = 0
	bgModal.anchorY = 0
	bgModal:setFillColor( 187, 219, 255, .1 )
	grupoModal:insert(bgModal)
	bgModal:addEventListener( "tap", CloseModal )
	
	modal = display.newRect(30,midH / 3,intW - 60,(intH / 2) * 1.5)
	modal.anchorX = 0
	modal.anchorY = 0
	modal:setFillColor( 0)
	grupoModal:insert(modal)
	modal:addEventListener( "tap", modalFunction )
	
	rect1Modal = display.newRect(50,midH / 3 + 30,modal.contentWidth /2 - 50,250)
	rect1Modal.anchorX = 0
	rect1Modal.anchorY = 0
	rect1Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect1Modal)
	rect1Modal:addEventListener("tap", rectModal)
	
	rect2Modal = display.newRect(modal.contentWidth /2 + 60,midH / 3 + 30,modal.contentWidth /2 - 50,250)
	rect2Modal.anchorX = 0
	rect2Modal.anchorY = 0
	rect2Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect2Modal)
	rect2Modal:addEventListener("tap", rectModal)
	
	rect3Modal = display.newRect(50, modal.contentHeight / 1.3, modal.contentWidth /2 - 50, 250)
	rect3Modal.anchorX = 0
	rect3Modal.anchorY = 0
	rect3Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect3Modal)
	rect3Modal:addEventListener("tap", rectModal)
	
	rect4Modal = display.newRect(modal.contentWidth /2 + 60, modal.contentHeight / 1.3, modal.contentWidth /2 - 50, 250)
	rect4Modal.anchorX = 0
	rect4Modal.anchorY = 0
	rect4Modal:setFillColor( .63,.85,.12)
	grupoModal:insert(rect4Modal)
	rect4Modal:addEventListener("tap", rectModal)
	
	local halfW = display.contentWidth * 0.5
	local halfH = display.contentHeight * 0.5

	--[[btnModalC = display.newImage( "img/btn/detailCity.png" )
	btnModalC:translate( modal.contentWidth - 10,modal.contentHeight + (midH / 3) - 40)
	btnModalC.isVisible = true
	btnModalC.height = 80
	btnModalC.width = 80
	grupoModal:insert(btnModalC)
	btnModalC:addEventListener( "tap", CloseModal )]]
	
	scrollViewContent1:setIsLocked( true )
	
	--btnModal:setIsLocked( true )
	return true
	
end

function rectModal( event )
	return true
end

function showCoupon(event)
	
	--storyboard.gotoScene("src.detail")
	
	storyboard.gotoScene( "src.detail", {
		time = 400,
		effect = "crossFade",
		params = { index = event.target.index }
	})

    --[[if isHome and mask.alpha == 0 then
        storyboard.gotoScene( "src.Coupon", {
            time = 400,
            effect = "crossFade",
            params = { index = event.target.index }
        })
    end]]
end

function scene:createScene( event )
	screen = self.view
	
	screen:insert(homeScreen)
	screen:insert(grupoModal)
	
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
	menu:setFillColor( 245/255, 245/255, 245/255 )
	homeScreen:insert(menu)
	
	local triangle = display.newImage( "img/btn/triangle.png" )
	triangle:translate( display.contentWidth * .5, 123 + h)
	triangle:setFillColor( 1 )
	triangle.isVisible = true
	triangle.height = 15
	triangle.width = 24
	homeScreen:insert(triangle)
	
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
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(scrollViewContent2)
	
	scrollViewContent3 = widget.newScrollView
	{
		top = h + 125,
		left = 480,
		width = display.contentWidth,
		height = display.contentHeight,
		listener = scrollListenerContent3,
		backgroundColor = { 245/255, 245/255, 245/255 }
	}
	homeScreen:insert(scrollViewContent3)
	
	groupMenu = display.newGroup()
	homeScreen:insert(groupMenu)
	
	grupoScroll1 = display.newGroup()
	scrollViewContent1:insert(grupoScroll1)
	
	grupoScroll2 = display.newGroup()
	scrollViewContent2:insert(grupoScroll2)
	
	grupoScroll3 = display.newGroup()
	scrollViewContent3:insert(grupoScroll3)
	
	textTitulo1 = display.newText( {
    text = "Inicio",     
    x = display.contentWidth * .5,
    y = menu.y + 30,
    font = "Chivo",
    fontSize = 30,
	})
	textTitulo1:setFillColor( 0 )	-- black
	groupMenu:insert(textTitulo1)
	textTitulo1:addEventListener( "tap", tapTitulo1 )
	
	textTitulo2 = display.newText( {
    text = "Eventos",     
    x = display.contentWidth * .85,
    y = menu.y + 30,
    font = "Chivo",
    fontSize = 30,
	})
	textTitulo2:setFillColor( 161/255, 161/255, 161/255 )	-- black
	groupMenu:insert(textTitulo2)
	textTitulo2:addEventListener( "tap", tapTitulo2 )
	
	textTitulo3 = display.newText( {
    text = "Deals",     
    x = display.contentWidth * 1.2,
    y = menu.y + 30,
    font = "Chivo",
    fontSize = 30,
	})
	textTitulo3:setFillColor( 161/255, 161/255, 161/255 )	-- black
	groupMenu:insert(textTitulo3)
	textTitulo3:addEventListener( "tap", tapTitulo3 )
	
	--[[titleLoading = display.newText( "adios", 0, 0, native.systemFont, 20)
	titleLoading:setFillColor( 0 )	-- black
	titleLoading.x = display.contentWidth * 0.5
	titleLoading.y = 300
	scrollViewContent1:insert(titleLoading)]]
	
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
	
	cleanHome()
	
	local grupoSeparadorEventos = display.newGroup()
	scrollViewContent1:insert(grupoSeparadorEventos)
	
	local separadorEventos = display.newImage( "img/btn/btnArrowBlack.png" )
	separadorEventos:translate( 41, lastY)
	separadorEventos:setFillColor( 1 )
	separadorEventos.isVisible = true
	separadorEventos.height = 20
	separadorEventos.width = 20
	grupoSeparadorEventos:insert(separadorEventos)
	
	local textSeparadorEventos = display.newText( {
        text = "Recomendaciones de eventos y actividades.",     
        x = 300,
        y = lastY + 27,
        width = intW,
        height =80,
        font = "Chivo",
        fontSize = 19,
        align = "left"
	})
		textSeparadorEventos:setFillColor( 85/255, 85/255, 85/255 )
		grupoSeparadorEventos:insert(textSeparadorEventos)
	
	
	lastY = lastY + 5
	
	RestManager.getEvents()
	--RestManager.getCoupon()
	
	navGrp = display.newGroup()
    homeScreen:insert(navGrp)
	
	settings = DBManager.getSettings()
	
	userData()
	
	--[[local btnFrame = display.newRect( intW - 100, intH - 100, 80, 80 )
	btnFrame.anchorX = 0
	btnFrame.anchorY = 0
	btnFrame:setFillColor( 0 )
	homeScreen:insert(btnFrame)]]
	
	btnModal = display.newImage( "img/btn/detailCity.png" )
	btnModal:translate( intW - 62, intH - 62)
	btnModal.isVisible = true
	btnModal.height = 80
	btnModal.width = 80
	homeScreen:insert(btnModal)
	btnModal:addEventListener( "tap", openModal )
	
	btnModal:toFront()
end

function loadMenuCoupon(items,tipo)

	contadorMes = {0,0,0,0,0,0,0,0,0,0,0,0}
	
	Globals.ItemsCoupon = items
	
	tipoConsulta = tipo
    titleLoading.text = "Descargando imagenes..."
    for y = 1, #Globals.ItemsCoupon, 1 do 
        Globals.ItemsCoupon[y].callback = noCallback
    end
	
	--[[local separadorCupones = display.newRect( 0, lastY - 40, display.contentWidth, 10 )
	separadorCupones.anchorX = 0
	separadorCupones.anchorY = 0
	separadorCupones:setFillColor( 0 )	-- black
	grupoScroll1:insert(separadorCupones)]]
	
    loadImageCoupon(1)
	
	return true
end

function loadImageCoupon(posc)
    -- Listener loading
    if not (Globals.ItemsCoupon[posc].image == nil) then
        local function networkListener( event )
            -- Verificamos el callback activo
            if #Globals.ItemsCoupon <  posc then 
                if not ( event.isError ) then
                    destroyImage(event.target)
                end
            elseif Globals.ItemsCoupon[posc].callback == noCallback then
			
                if ( event.isError ) then
                    native.showAlert( "Go Deals", "Network error :(", { "OK"})
                else
                    event.target.alpha = 0
                    imageItems[posc] = event.target
                    if posc < #Globals.ItemsCoupon and posc <= ( noPackage2 * 10) then
                        loadImageCoupon(posc + 1)
                    else
                        buildItemsCoupon()
                    end
                end
            elseif not ( event.isError ) then
                destroyImage(event.target)
            end
        end
        -- Do call image
        Globals.ItemsCoupon[posc].idCupon = Globals.ItemsCoupon[posc].id
        Globals.ItemsCoupon[posc].id = posc
        local path = system.pathForFile( Globals.ItemsCoupon[posc].image, system.TemporaryDirectory )
        local fhd = io.open( path )
        -- Determine if file exists
        if fhd then
            fhd:close()
            imageItems[posc] = display.newImage( Globals.ItemsCoupon[posc].image, system.TemporaryDirectory )
			
            if Globals.ItemsCoupon[posc].callback == noCallback then
                imageItems[posc].alpha = 0
                if posc < #Globals.ItemsCoupon and posc <= ( noPackage2 * 10) then
                    loadImageCoupon(posc + 1)
                else
                    buildItemsCoupon()
                end
            else
                destroyImage(imageItems[posc])
            end
        else
           display.loadRemoteImage( 'http://localhost:8080/godeals/assets/img/app/coupon/app/'..Globals.ItemsCoupon[posc].image, 
            "GET", networkListener, Globals.ItemsCoupon[posc].image, system.TemporaryDirectory ) 
        end
    else
        loadImageCoupon(posc + 1)
    end
end

function buildItemsCoupon()

    -- Stop loading sprite
    if  noPackage2 == 1 then
        loading:setSequence("stop")
        loadingGrp.alpha = 0
    else
        coupons[#coupons]:removeSelf()
        coupons[#coupons] = nil
    end
    -- Build items
	
    local z = ( noPackage2 * 10) - 9
	
    while z <= #Globals.ItemsCoupon and z <= ( noPackage2 * 10) do
        -- Armar cupones
        if tipoConsulta == 1 then
            setStdCoupon(Globals.ItemsCoupon[z]) 
        elseif tipoConsulta == 2 then
			setStdAllCoupon(Globals.ItemsCoupon[z])
		end
        z = z + 1
    end
    
    -- Validate Loading
    if  #Globals.ItemsCoupon > ( noPackage2 * 10) then
        -- Create Loading
        coupons[#coupons + 1] = display.newContainer( 444, 150 )
        coupons[#coupons].x = midW
        coupons[#coupons].y = lastY + 60
        grupoScroll1:insert( coupons[#coupons] )
        
        -- Sprite and text
        local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
        local loadingBottom = display.newSprite(sheet, Sprites.loading.sequences)
        loadingBottom.y = -10
        coupons[#coupons]:insert(loadingBottom)
        loadingBottom:setSequence("play")
        loadingBottom:play()
        local title = display.newText( "Cargando, por favor espere...", 0, 30, "Chivo", 16)
        title:setFillColor( .3, .3, .3 )
        coupons[#coupons]:insert(title) 
        
        -- Call new images
         noPackage2 =  noPackage2 + 1
        loadImageCoupon(( noPackage2 * 10) - 9)
    else
        if navGrp.alpha == 1 then
            lastY = lastY + 70
        end
        
        -- Create Space
        coupons[#coupons + 1] = display.newContainer( 444, 40 )
        coupons[#coupons].x = midW
        coupons[#coupons].y = lastY + 40
        grupoScroll1:insert( coupons[#coupons] )
    end
end

-- Genera un cupon estandar
function setStdCoupon(obj)

	totalEventos = totalEventos + 1

    -- Obtiene el total de cupones de la tabla y agrega uno
    local lastC = #coupons + 1
    -- Generamos contenedor
    coupons[lastC] = display.newContainer( 450, 100 )
    coupons[lastC].index = lastC
    coupons[lastC].x = 255
    coupons[lastC].type = 2
    coupons[lastC].y = lastY + 70
    grupoScroll1:insert( coupons[lastC] )
    coupons[lastC]:addEventListener( "tap", showCoupon )
    
    -- Agregamos rectangulo alfa al pie
    local maxShape = display.newRect( 0, 0, 480, 100 )
    maxShape:setFillColor( 1 )
    coupons[lastC]:insert( maxShape )
    
    -- Agregamos imagen
    imageItems[obj.id].alpha = 1
    imageItems[obj.id].index = lastC
    imageItems[obj.id].x= -175
    imageItems[obj.id].width = 80
    imageItems[obj.id].height  = 55
    coupons[lastC]:insert( imageItems[obj.id] )
    
    -- Agregamos textos
    local txtTitle = display.newText( {
        text = obj.description,     
        x = 25,
        y = -10,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 24,
        align = "left"
    })
    txtTitle:setFillColor( 0 )
    coupons[lastC]:insert(txtTitle)
	
	
	---- sacamos la fecha 
	
	local fecha = ""
	
	s = obj.iniDate
	for k, v, u in string.gmatch(s, "(%w+)-(%w+)-(%w+)") do
		if v == "01" then
			fecha = u .. " de Enero de " .. k  
		elseif v == "02" then
			fecha = u .. " de Febrero de " .. k  
		elseif v == "03" then
			fecha = u .. " de Marzo de " .. k  
		elseif v == "04" then
			fecha = u .. " de Abril de " .. k  
		elseif v == "05" then
			fecha = u .. " de Mayo de " .. k  
		elseif v == "06" then
			fecha = u .. " de Junio de " .. k  
		elseif v == "07" then
			fecha = u .. " de Julio de " .. k  
		elseif v == "08" then
			fecha = u .. " de Agosto de " .. k  
		elseif v == "09" then
			fecha = u .. " de Septiembre de " .. k  
		elseif v == "10" then
			fecha = u .. " de Octubre de " .. k  
		elseif v == "11" then
			fecha = u .. " de Noviembre de " .. k  
		elseif v == "12" then
			fecha = u .. " de Diciembre de " .. k  
		end
		
	end
   
   -----
	
	local txtDate = display.newText( {
        text = fecha,     
        x = 25,
        y = 20,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 18,
        align = "left"
    })
    txtDate:setFillColor( 146/255, 146/255, 146/255)
    coupons[lastC]:insert(txtDate)
	
	--[[local txtPlace = display.newText( {
        text = obj.place,     
        x = 25,
        y = 40,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 18,
        align = "left"
    })
    txtPlace:setFillColor( 146/255, 146/255, 146/255)
    coupons[lastC]:insert(txtPlace)]]
    
    -- Agregamos linea negra al pie
    grupoScroll1:insert( coupons[lastC] )
    
    -- Guardamos la ultima posicion
    lastY = lastY + 102
	
	if totalEventos == 3 then
	
	scrollViewContent1:setScrollHeight(  lastY + 200 )
	
	totalEventos = 0
	
	local encabezadoEventos = display.newRect( 0, 0, display.contentWidth, 20 )
	encabezadoEventos.anchorX = 0
	encabezadoEventos.anchorY = 0
	encabezadoEventos:setFillColor( 1 )	-- red
	scrollViewContent2:insert(encabezadoEventos)
	lastY = -70
	
	RestManager.getAllEvent()
	
	
	end
    
end

-- generamos todos los eventos vigentes
function setStdAllCoupon(obj)
	
	---- sacamos la fecha
	
	totalEventos = totalEventos + 1
	
	local fecha = ""
	
	s = obj.iniDate
	for k, v, u in string.gmatch(s, "(%w+)-(%w+)-(%w+)") do
		
		if v == "01" then
			fecha = u .. " de Enero de " .. k 
			tituloFecha = "Enero " .. k
			if contadorMes[1] == 0 then
				contadorMes[1] = 1
				contadorFecha = 1
			end
		elseif v == "02" then
			fecha = u .. " de Febrero de " .. k 
			tituloFecha = "Febrero " .. k
			if contadorMes[2] == 0 then
				contadorMes[2] = 1
				contadorFecha = 1
			end
		elseif v == "03" then
			fecha = u .. " de Marzo de " .. k  
			tituloFecha = "Marzo " .. k
			if contadorMes[3] == 0 then
				contadorMes[3] = 1
				contadorFecha = 1
			end
		elseif v == "04" then
			fecha = u .. " de Abril de " .. k
			tituloFecha = "Abril " .. k
			if contadorMes[4] == 0 then
				contadorMes[4] = 1
				contadorFecha = 1
			end
		elseif v == "05" then
			fecha = u .. " de Mayo de " .. k  
			tituloFecha = "Mayo " .. k
			if contadorMes[5] == 0 then
				contadorMes[5] = 1
				contadorFecha = 1
			end
		elseif v == "06" then
			fecha = u .. " de Junio de " .. k
			tituloFecha = "Junio " .. k
			if contadorMes[6] == 0 then
				contadorMes[6] = 1
				contadorFecha = 1
			end
		elseif v == "07" then
			fecha = u .. " de Julio de " .. k 
			tituloFecha = "Julio " .. k
			if contadorMes[7] == 0 then
				contadorMes[7] = 1
				contadorFecha = 1
			end
		elseif v == "08" then
			fecha = u .. " de Agosto de " .. k
			tituloFecha = "Agosto " .. k
			if contadorMes[8] == 0 then
				contadorMes[8] = 1
				contadorFecha = 1
			end
		elseif v == "09" then
			fecha = u .. " de Septiembre de " .. k 
			tituloFecha = "Septiembre " .. k
			if contadorMes[9] == 0 then
				contadorMes[9] = 1
				contadorFecha = 1
			end
		elseif v == "10" then
			fecha = u .. " de Octubre de " .. k
			tituloFecha = "Octubre " .. k
			if contadorMes[10] == 0 then
				contadorMes[10] = 1
				contadorFecha = 1
			end
		elseif v == "11" then
			fecha = u .. " de Noviembre de " .. k
			tituloFecha = "Noviembre " .. k
			if contadorMes[11] == 0 then
				contadorMes[11] = 1
				contadorFecha = 1
			end
		elseif v == "12" then
			fecha = u .. " de Diciembre de " .. k
			tituloFecha = "Diciembre " .. k
			if contadorMes[12] == 0 then
				contadorMes[12] = 1
				contadorFecha = 1
			end
		end
		
	end
   
   -----
	
	if contadorFecha == 1 then
		lastY = lastY + 70
		local textTituloFecha = display.newText( {
					text = tituloFecha,     
					x = 270,
					y = lastY,
					width = intW,
					height =60,
					font = "Chivo-Black",   
					fontSize = 25,
					align = "left"
		})
		textTituloFecha:setFillColor( 0 )
		grupoScroll3:insert(textTituloFecha)
		contadorFecha = 0
		
   end

    -- Obtiene el total de cupones de la tabla y agrega uno
    local lastC = #coupons + 1
    -- Generamos contenedor
    coupons[lastC] = display.newContainer( 450, 100 )
    coupons[lastC].index = lastC
    coupons[lastC].x = 255
    coupons[lastC].type = 2
    coupons[lastC].y = lastY + 60
    grupoScroll3:insert( coupons[lastC] )
    coupons[lastC]:addEventListener( "tap", showCoupon )
    
    -- Agregamos rectangulo alfa al pie
    local maxShape = display.newRect( 0, 0, 480, 100 )
    maxShape:setFillColor( 1 )
    coupons[lastC]:insert( maxShape )
    
    -- Agregamos imagen
    imageItems[obj.id].alpha = 1
    imageItems[obj.id].index = lastC
    imageItems[obj.id].x= -175
    imageItems[obj.id].width = 80
    imageItems[obj.id].height  = 55
    coupons[lastC]:insert( imageItems[obj.id] )
    
    -- Agregamos textos
    local txtTitle = display.newText( {
        text = obj.description,     
        x = 25,
        y = -10,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 24,
        align = "left"
    })
    txtTitle:setFillColor( 0 )
    coupons[lastC]:insert(txtTitle)
	
	local txtDate = display.newText( {
        text = fecha,     
        x = 25,
        y = 20,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 18,
        align = "left"
    })
    txtDate:setFillColor( 146/255, 146/255, 146/255)
    coupons[lastC]:insert(txtDate)
	
	--[[local txtPlace = display.newText( {
        text = obj.place,     
        x = 25,
        y = 40,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 18,
        align = "left"
    })
    txtPlace:setFillColor( 146/255, 146/255, 146/255)
    coupons[lastC]:insert(txtPlace)]]
    
    -- Agregamos linea negra al pie
    grupoScroll3:insert( coupons[lastC] )
    
    -- Guardamos la ultima posicion
    lastY = lastY + 102
	
	scrollViewContent3:setScrollHeight(  lastY + 150 )
    
end

---------- eventos -------------

function loadMenuEvent(items,tipo)

	Globals.ItemsEvents = items
	tipoConsulta = tipo
    titleLoading.text = "Descargando imagenes..."
    for y = 1, #Globals.ItemsEvents, 1 do 
        Globals.ItemsEvents[y].callback = noCallback
    end
	
	loadImageEvent(1)
	
end

function loadImageEvent(posc)
    -- Listener loading
    if not (Globals.ItemsEvents[posc].image == nil) then
        local function networkListenerEvent( event )
            -- Verificamos el callback activo
            if #Globals.ItemsEvents <  posc then 
                if not ( event.isError ) then
                    destroyImage(event.target)
                end
            elseif Globals.ItemsEvents[posc].callback == noCallback then
			
                if ( event.isError ) then
                    native.showAlert( "Go Deals", "Network error :(", { "OK"})
                else
                    event.target.alpha = 0
                    imageItems[posc] = event.target
                    if posc < #Globals.ItemsEvents and posc <= (noPackage * 10) then
                        loadImageEvent(posc + 1)
                    else
                        buildItemsEvent()
                    end
                end
            elseif not ( event.isError ) then
                destroyImage(event.target)
            end
        end
        -- Do call image
        Globals.ItemsEvents[posc].idCupon = Globals.ItemsEvents[posc].id
        Globals.ItemsEvents[posc].id = posc
        local path = system.pathForFile( Globals.ItemsEvents[posc].image, system.TemporaryDirectory )
        local fhd = io.open( path )
        -- Determine if file exists
        if fhd then
            fhd:close()
            imageItems[posc] = display.newImage( Globals.ItemsEvents[posc].image, system.TemporaryDirectory )
			
            if Globals.ItemsEvents[posc].callback == noCallback then
                imageItems[posc].alpha = 0
                if posc < #Globals.ItemsEvents and posc <= (noPackage * 10) then
                    loadImageEvent(posc + 1)
                else
					buildItemsEvent()
                end
            else
                destroyImage(imageItems[posc])
            end
        else
           display.loadRemoteImage( 'http://localhost:8080/godeals/assets/img/app/event/app/'..Globals.ItemsEvents[posc].image, 
            "GET", networkListenerEvent, Globals.ItemsEvents[posc].image, system.TemporaryDirectory ) 
        end
    else
        loadImageEvent(posc + 1)
    end
end

function buildItemsEvent()
    -- Stop loading sprite
    if noPackage == 1 then
        loading:setSequence("stop")
        loadingGrp.alpha = 0
    else
        coupons[#coupons]:removeSelf()
        coupons[#coupons] = nil
    end
    -- Build items
    local z = (noPackage * 10) - 9
    while z <= #Globals.ItemsEvents and z <= (noPackage * 10) do 
        
        -- Armar cupones
        if tipoConsulta == 1 then
            setStdEvent(Globals.ItemsEvents[z]) 
        elseif tipoConsulta == 2 then
			setStdAllEvent(Globals.ItemsEvents[z])
		end
        z = z + 1
    end
    
    -- Validate Loading
    if  #Globals.ItemsEvents > (noPackage * 10) then
        -- Create Loading
        coupons[#coupons + 1] = display.newContainer( 444, 150 )
        coupons[#coupons].x = midW
        coupons[#coupons].y = lastY + 60
        grupoScroll1:insert( coupons[#coupons] )
        
        -- Sprite and text
        local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
        local loadingBottom = display.newSprite(sheet, Sprites.loading.sequences)
        loadingBottom.y = -10
        coupons[#coupons]:insert(loadingBottom)
        loadingBottom:setSequence("play")
        loadingBottom:play()
        local title = display.newText( "Cargando, por favor espere...", 0, 30, "Chivo", 16)
        title:setFillColor( .3, .3, .3 )
        coupons[#coupons]:insert(title) 
        
        -- Call new images
        noPackage = noPackage + 1
        loadImageEvent((noPackage * 10) - 9)
    else
        if navGrp.alpha == 1 then
            lastY = lastY + 70
        end
        
        -- Create Space
        coupons[#coupons + 1] = display.newContainer( 444, 40 )
        coupons[#coupons].x = midW
        coupons[#coupons].y = lastY + 40
        grupoScroll1:insert( coupons[#coupons] )
    end
end

-- Genera un 3 eventos principales
function setStdEvent(obj)

	totalEventos = totalEventos + 1

    -- Obtiene el total de cupones de la tabla y agrega uno
    local lastC = #coupons + 1
    -- Generamos contenedor
    coupons[lastC] = display.newContainer( 450, 100 )
    coupons[lastC].index = lastC
    coupons[lastC].x = 255
    coupons[lastC].type = 2
    coupons[lastC].y = lastY + 70
    grupoScroll1:insert( coupons[lastC] )
    coupons[lastC]:addEventListener( "tap", showCoupon )
    
    -- Agregamos rectangulo alfa al pie
    local maxShape = display.newRect( 0, 0, 480, 100 )
    maxShape:setFillColor( 1 )
    coupons[lastC]:insert( maxShape )
    
    -- Agregamos imagen
    imageItems[obj.id].alpha = 1
    imageItems[obj.id].index = lastC
    imageItems[obj.id].x= -175
    imageItems[obj.id].width = 80
    imageItems[obj.id].height  = 55
    coupons[lastC]:insert( imageItems[obj.id] )
    
    -- Agregamos textos
    local txtTitle = display.newText( {
        text = obj.name,     
        x = 25,
        y = -10,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 24,
        align = "left"
    })
    txtTitle:setFillColor( 0 )
    coupons[lastC]:insert(txtTitle)
	
	---- sacamos la fecha 
	
	local fecha = ""
	
	s = obj.date
	for k, v, u in string.gmatch(s, "(%w+)-(%w+)-(%w+)") do
		
		if v == "1" then
			fecha = u .. " de Enero de " .. k  
		elseif v == "2" then
			fecha = u .. " de Febrero de " .. k  
		elseif v == "3" then
			fecha = u .. " de Marzo de " .. k  
		elseif v == "4" then
			fecha = u .. " de Abril de " .. k  
		elseif v == "5" then
			fecha = u .. " de Mayo de " .. k  
		elseif v == "6" then
			fecha = u .. " de Junio de " .. k  
		elseif v == "7" then
			fecha = u .. " de Julio de " .. k  
		elseif v == "8" then
			fecha = u .. " de Agosto de " .. k  
		elseif v == "9" then
			fecha = u .. " de Septiembre de " .. k  
		elseif v == "10" then
			fecha = u .. " de Octubre de " .. k  
		elseif v == "11" then
			fecha = u .. " de Noviembre de " .. k  
		elseif v == "12" then
			fecha = u .. " de Diciembre de " .. k  
		end
		
	end
   
   -----
	
	local txtDate = display.newText( {
        text = fecha,     
        x = 25,
        y = 20,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 18,
        align = "left"
    })
    txtDate:setFillColor( 146/255, 146/255, 146/255)
    coupons[lastC]:insert(txtDate)
	
	local txtPlace = display.newText( {
        text = obj.place,     
        x = 25,
        y = 40,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 18,
        align = "left"
    })
    txtPlace:setFillColor( 146/255, 146/255, 146/255)
    coupons[lastC]:insert(txtPlace)
    
    -- Agregamos linea negra al pie
    grupoScroll1:insert( coupons[lastC] )
    
    -- Guardamos la ultima posicion
    lastY = lastY + 102	
	
	if tipoConsulta == 1 and totalEventos == 3 then
	
	local grupoSeparadorCupones = display.newGroup()
	scrollViewContent1:insert(grupoSeparadorCupones)
	
	local separadorCupones = display.newImage( "img/btn/btnArrowBlack.png" )
	separadorCupones:translate( 41, lastY + 60)
	separadorCupones:setFillColor( 1 )
	separadorCupones.isVisible = true
	separadorCupones.height = 20
	separadorCupones.width = 20
	grupoSeparadorCupones:insert(separadorCupones)
	
	local textSeparadorCupones = display.newText( {
        text = "Recomendaciones de promociones para ti.",     
        x = 300,
        y = lastY + 90,
        width = intW,
        height =80,
        font = "Chivo",
        fontSize = 20,
        align = "left"
	})
	textSeparadorCupones:setFillColor( 85/255, 85/255, 85/255 )
	grupoSeparadorCupones:insert(textSeparadorCupones)
	
	RestManager.getCoupon()
	
	totalEventos = 0
	
	end
	
    
end

-- generamos todos los eventos vigentes
function setStdAllEvent(obj)
	
	---- sacamos la fecha
	
	totalEventos = totalEventos + 1
	
	local fecha = ""
	
	s = obj.date
	for k, v, u in string.gmatch(s, "(%w+)-(%w+)-(%w+)") do
		
		if v == "01" then
			fecha = u .. " de Enero de " .. k 
			tituloFecha = "Enero " .. k
			if contadorMes[1] == 0 then
				contadorMes[1] = 1
				contadorFecha = 1
			end
		elseif v == "02" then
			fecha = u .. " de Febrero de " .. k 
			tituloFecha = "Febrero " .. k
			if contadorMes[2] == 0 then
				contadorMes[2] = 1
				contadorFecha = 1
			end
		elseif v == "03" then
			fecha = u .. " de Marzo de " .. k  
			tituloFecha = "Marzo " .. k
			if contadorMes[3] == 0 then
				contadorMes[3] = 1
				contadorFecha = 1
			end
		elseif v == "04" then
			fecha = u .. " de Abril de " .. k
			tituloFecha = "Abril " .. k
			if contadorMes[4] == 0 then
				contadorMes[4] = 1
				contadorFecha = 1
			end
		elseif v == "05" then
			fecha = u .. " de Mayo de " .. k  
			tituloFecha = "Mayo " .. k
			if contadorMes[5] == 0 then
				contadorMes[5] = 1
				contadorFecha = 1
			end
		elseif v == "06" then
			fecha = u .. " de Junio de " .. k
			tituloFecha = "Junio " .. k
			if contadorMes[6] == 0 then
				contadorMes[6] = 1
				contadorFecha = 1
			end
		elseif v == "07" then
			fecha = u .. " de Julio de " .. k 
			tituloFecha = "Julio " .. k
			if contadorMes[7] == 0 then
				contadorMes[7] = 1
				contadorFecha = 1
			end
		elseif v == "08" then
			fecha = u .. " de Agosto de " .. k
			tituloFecha = "Agosto " .. k
			if contadorMes[8] == 0 then
				contadorMes[8] = 1
				contadorFecha = 1
			end
		elseif v == "09" then
			fecha = u .. " de Septiembre de " .. k 
			tituloFecha = "Septiembre " .. k
			if contadorMes[9] == 0 then
				contadorMes[9] = 1
				contadorFecha = 1
			end
		elseif v == "10" then
			fecha = u .. " de Octubre de " .. k
			tituloFecha = "Octubre " .. k
			if contadorMes[10] == 0 then
				contadorMes[10] = 1
				contadorFecha = 1
			end
		elseif v == "11" then
			fecha = u .. " de Noviembre de " .. k
			tituloFecha = "Noviembre " .. k
			if contadorMes[11] == 0 then
				contadorMes[11] = 1
				contadorFecha = 1
			end
		elseif v == "12" then
			fecha = u .. " de Diciembre de " .. k
			tituloFecha = "Diciembre " .. k
			if contadorMes[12] == 0 then
				contadorMes[12] = 1
				contadorFecha = 1
			end
		end
		
	end
   
   -----
	
	if contadorFecha == 1 then
	
		lastY = lastY + 70
		local textTituloFecha = display.newText( {
					text = tituloFecha,     
					x = 270,
					y = lastY,
					width = intW,
					height =60,
					font = "Chivo-Black",   
					fontSize = 25,
					align = "left"
		})
		textTituloFecha:setFillColor( 0 )
		grupoScroll2:insert(textTituloFecha)
		contadorFecha = 0
		
   end

    -- Obtiene el total de cupones de la tabla y agrega uno
    local lastC = #coupons + 1
    -- Generamos contenedor
    coupons[lastC] = display.newContainer( 450, 100 )
    coupons[lastC].index = lastC
    coupons[lastC].x = 255
    coupons[lastC].type = 2
    coupons[lastC].y = lastY + 60
    grupoScroll2:insert( coupons[lastC] )
    coupons[lastC]:addEventListener( "tap", showCoupon )
    
    -- Agregamos rectangulo alfa al pie
    local maxShape = display.newRect( 0, 0, 480, 100 )
    maxShape:setFillColor( 1 )
    coupons[lastC]:insert( maxShape )
    
    -- Agregamos imagen
    imageItems[obj.id].alpha = 1
    imageItems[obj.id].index = lastC
    imageItems[obj.id].x= -175
    imageItems[obj.id].width = 80
    imageItems[obj.id].height  = 55
    coupons[lastC]:insert( imageItems[obj.id] )
    
    -- Agregamos textos
    local txtTitle = display.newText( {
        text = obj.name,     
        x = 25,
        y = -10,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 24,
        align = "left"
    })
    txtTitle:setFillColor( 0 )
    coupons[lastC]:insert(txtTitle)
	
	local txtDate = display.newText( {
        text = fecha,     
        x = 25,
        y = 20,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 18,
        align = "left"
    })
    txtDate:setFillColor( 146/255, 146/255, 146/255)
    coupons[lastC]:insert(txtDate)
	
	local txtPlace = display.newText( {
        text = obj.place,     
        x = 25,
        y = 40,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 18,
        align = "left"
    })
    txtPlace:setFillColor( 146/255, 146/255, 146/255)
    coupons[lastC]:insert(txtPlace)
    
    -- Agregamos linea negra al pie
    grupoScroll2:insert( coupons[lastC] )
    
    -- Guardamos la ultima posicion
    lastY = lastY + 102
	
	scrollViewContent2:setScrollHeight(  lastY + 150 )
	
	if totalEventos == #Globals.ItemsEvents then
	
		totalEventos = 0
	
		local encabezadoCupones = display.newRect( 0, 0, display.contentWidth, 20 )
		encabezadoCupones.anchorX = 0
		encabezadoCupones.anchorY = 0
		encabezadoCupones:setFillColor( 1 )	-- red
		scrollViewContent3:insert(encabezadoCupones)
		
		lastY = -70
		
		RestManager.getAllCoupon()
	end
    
end
	
---- user ----------	
	
	function userData()
		local sizeAvatar = 'width=130&height=100'
        local maskAvatar = ''
		
		contenerUser = display.newContainer( display.contentWidth * 2, 350 )
		contenerUser.x = 0
		contenerUser.y = 0
		scrollViewContent1:insert( contenerUser )
		
		local bgFotoFacebook = display.newRect( 0, 0, display.contentWidth, 90 )
		bgFotoFacebook.anchorX = 0
		bgFotoFacebook.anchorY = 0
		bgFotoFacebook:setFillColor( 1 )	-- red
		contenerUser:insert(bgFotoFacebook)
		
        local path = system.pathForFile( "avatarFb"..settings.fbId, system.TemporaryDirectory )
        local fhd = io.open( path )
        if fhd then
            fhd:close()
			
            local avatar = display.newImage("avatarFb"..settings.fbId, system.TemporaryDirectory )
            avatar.x = 70
            avatar.y = 90
			avatar.height = 100
			avatar.width = 130
            contenerUser:insert(avatar)
        else
            local function networkListenerFB( event )
                -- Verificamos el callback activo
                if ( event.isError ) then
                else
                    --local mask = graphics.newMask( "img/bgk/maskAvatar"..maskAvatar..".jpg" )
                    event.target.x = 70
                    event.target.y = 90
                    --event.target:setMask( mask )
                    contenerUser:insert( event.target )
                end
            end
            display.loadRemoteImage( "http://graph.facebook.com/".. settings.fbId .."/picture?type=large&"..sizeAvatar, 
                "GET", networkListenerFB, "avatarFb"..settings.fbId, system.TemporaryDirectory )
				 
        end
		
	local textNombre = display.newText( {
		text = settings.name .. " Chi Zum",     
		x = 260,
		y = 40,
		width = intW,
		height =60,
		font = "Chivo-Black",   
		fontSize = 26,
		align = "left"
	})
	textNombre:setFillColor( 0 )
	contenerUser:insert(textNombre)
		
	local textSaludo = display.newText( {
		text = "Actualmente esta viendo eventos y cupones de Cancún",     
		x =320,
		y = 80,
		width = 350,
		height =60,
		font = "Chivo",   
		fontSize = 18,
		align = "left"
	})
	textSaludo:setFillColor( 176/255, 176/255, 176/255 )
	contenerUser:insert(textSaludo)
	
	end
	
	-- Limpiamos scrollview
function cleanHome()
    
    -- Play loading
    loadingGrp.alpha = 1
    loading:setSequence("play")
    loading:play()
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
    storyboard.removeAll()
end

-- Remove Listener
function scene:exitScene( event )
    if storeBar then
        storeBar:removeSelf()
        storeBar = nil
    end
end

scene:addEventListener("createScene", scene )
scene:addEventListener("enterScene", scene )
scene:addEventListener("exitScene", scene )

return scene