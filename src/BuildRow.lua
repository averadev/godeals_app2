
---------------------------------------------------------------------------------
-- MONTH TITLE
---------------------------------------------------------------------------------
MonthTitle = {}
function MonthTitle:new()
    -- Variables
    local self = display.newGroup()
    
    -- Creamos la pantalla del menu
    function self:build(desc)
        
        -- Generamos contenedor
        local container = display.newContainer( 480, 70 )
        container.x = 0
        container.y = 35
        self:insert( container )
        
        local txtTitleDate = display.newText( {
            text = desc,     
            x = 245, y = 15,
            width = 470, height = 35,
            font = "Lato-Bold", fontSize = 24, align = "left"
		})
		txtTitleDate:setFillColor( 0 )
		container:insert(txtTitleDate)
    end

    return self
end


---------------------------------------------------------------------------------
-- EVENTO
---------------------------------------------------------------------------------
Event = {}
function Event:new()
    -- Variables
    local self = display.newGroup()

    function showEvent(event)
        local Globals = require('src.resources.Globals')
        local storyboard = require( "storyboard" )
        Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		
		if event.target.item.identificador then
			--hideModalSearch()
		end
		
		hideSearch2()
		deleteTxt()
		
        local current = storyboard.getCurrentSceneName()
		if current ~= "src.Event" then
			storyboard.removeScene( "src.Event" )
		else
			storyboard.gotoScene( "src.Home")
			storyboard.removeScene( "src.Event" )
		end
        storyboard.gotoScene( "src.Event", {
            time = 400,
            effect = "crossFade",
            params = { item = event.target.item }
        })
    end
    
    -- Creamos la pantalla del menu
    function self:build(isBg, item, image)
        
        -- Generamos contenedor
        local container = display.newContainer( 480, 180 )
        container.x = 240
        container.y = 60
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showCoupon )

        local maxShape = display.newRect( 0, 0, 460, 170 )
        maxShape:setFillColor( .84 )
        container:insert( maxShape )

        local maxShape = display.newRect( 0, 0, 456, 166 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )

        -- Agregamos imagen
        item.tipo  = "Event"
        image.alpha = 1
        image.x= -145
        image.width = 160
        image.height  = 160
        image.item = item
        container:insert( image )

        -- Agregamos textos
        local txtTitle = display.newText( {
            text = item.name ,     
            x = 80, y = -45,
            width = 240, height = 0,
            font = "Lato-Bold", fontSize = 19, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtPartner = display.newText( {
            text = getDate(item.iniDate),     
            x = 80, y = 5,
            width = 240, height =60,
            font = "Lato-Bold", fontSize = 16, align = "left"
        })
        txtPartner:setFillColor( .3 )
        container:insert(txtPartner)
        
        local txtPlace = display.newText( {
            text = item.address,     
            x = 80, y = 30,
            width = 240, height =60,
            font = "Lato-Regular", fontSize = 18, align = "left"
        })
        txtPlace:setFillColor( .3 )
        container:insert(txtPlace)
        
		-- Fix Height
		if txtTitle.height > 35 then
			txtTitle.height = 60
			txtTitle.y = -45
			txtPartner.y = 15
			txtPlace.y = 40
		end
        
        
        
    end

    return self
end


---------------------------------------------------------------------------------
-- DEAL
---------------------------------------------------------------------------------
Deal = {}
local assigned = 0
function Deal:new()
    -- Variables
    local self = display.newGroup()
	
	function AssignedCoupon(item)
		assigned = item
	end
    
    function showCoupon(event)
        local Globals = require('src.resources.Globals')
        local storyboard = require( "storyboard" )
        Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		
		hideSearch2()
		deleteTxt()
		
        local current = storyboard.getCurrentSceneName()
		if current ~= "src.Coupon" then
			storyboard.removeScene( "src.Coupon" )
		else
			storyboard.gotoScene( "src.Home")
			storyboard.removeScene( "src.Coupon" )
		end
		
        storyboard.gotoScene( "src.Coupon", {
            time = 400,
            effect = "crossFade",
            params = { item = event.target.item }
        })
    end
    
    -- Creamos la pantalla del menu
    function self:build(isBg, item, image)
        -- Generamos contenedor
        local container = display.newContainer( 480, 180 )
        container.x = 240
        container.y = 60
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showCoupon )

        local maxShape = display.newRect( 0, 0, 460, 170 )
        maxShape:setFillColor( .84 )
        container:insert( maxShape )

        local maxShape = display.newRect( 0, 0, 456, 166 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )

        -- Agregamos imagen
        item.tipo  = "Coupon"
        image.alpha = 1
        image.x= -145
        image.width = 160
        image.height  = 160
        image.item = item
        container:insert( image )

        -- Agregamos textos
        local txtTitle = display.newText( {
            text = item.name ,     
            x = 80, y = -45,
            width = 240, height = 0,
            font = "Lato-Bold", fontSize = 19, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtPartner = display.newText( {
            text = item.partner,     
            x = 80, y = 5,
            width = 240, height =60,
            font = "Lato-Bold", fontSize = 16, align = "left"
        })
        txtPartner:setFillColor( .3 )
        container:insert(txtPartner)
        
        local btnDescargarDes = display.newImage( "img/btn/btnDescargarDes.png" )
        btnDescargarDes:translate( 165, 55 )
        container:insert(btnDescargarDes)
        
        local iconReady = display.newImage( "img/btn/iconReady.png" )
        iconReady:translate( -30, 60 )
        container:insert(iconReady)

        local txtStock = display.newText( {
            text = item.stock.." Disponibles",     
            x = 105, y = 60,
            width = 240, height =20,
            font = "Lato-Regular", fontSize = 16, align = "left"
        })
        if item.stock == '0' then
            txtStock:setFillColor( .8, .5, .5 )
        else
            txtStock:setFillColor( .3 )
        end
        container:insert(txtStock)
        
		-- Fix Height
		if txtTitle.height > 35 then
			txtTitle.height = 60
			txtTitle.y = -45
			txtPartner.y = 15
		end
    end

    return self
end

---------------------------------------------------------------------------------
-- DEAL MAIN
---------------------------------------------------------------------------------
DealMain = {}
local assigned = 0
function DealMain:new()
    -- Variables
    local self = display.newGroup()
	
	function AssignedCoupon(item)
		assigned = item
	end
    
    function showCoupon(event)
        local Globals = require('src.resources.Globals')
        local storyboard = require( "storyboard" )
        Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		
		hideSearch2()
		deleteTxt()
		
        local current = storyboard.getCurrentSceneName()
		if current ~= "src.Coupon" then
			storyboard.removeScene( "src.Coupon" )
		else
			storyboard.gotoScene( "src.Home")
			storyboard.removeScene( "src.Coupon" )
		end
		
        storyboard.gotoScene( "src.Coupon", {
            time = 400,
            effect = "crossFade",
            params = { item = event.target.item }
        })
    end
    
    -- Creamos la pantalla del menu
    function self:build(isBg, item, image, logo)
        -- Generamos contenedor
        local container = display.newContainer( 480, 220 )
        container.x = 240
        container.y = 60
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showCoupon )

        local maxShape = display.newRect( 0, 0, 460, 210 )
        maxShape:setFillColor( .84 )
        container:insert( maxShape )

        local maxShape = display.newRect( 0, 0, 456, 206 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )
        
        -- Agregamos imagen
        item.tipo  = "Coupon"
        image.alpha = 1
        image.x= -125
        image.width = 200
        image.height  = 200
        image.item = item
        container:insert( image )
        
        local mask = graphics.newMask( "img/bgk/maskImgRow.jpg" )
        logo:setMask( mask )
        logo.alpha = 1
        logo.x= -125
        logo.width = 100
        logo.height  = 100
        logo.item = item
        container:insert( logo )

        -- Agregamos textos
        local txtTitle = display.newText( {
            text = item.name ,     
            x = 110, y = -65,
            width = 240, height = 0,
            font = "Lato-Bold", fontSize = 19, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtPartner = display.newText( {
            text = item.partner,     
            x = 110, y = -20,
            width = 240, height =60,
            font = "Lato-Bold", fontSize = 16, align = "left"
        })
        txtPartner:setFillColor( .3 )
        container:insert(txtPartner)

        local txtDealDes = display.newText( {
            text = "DEAL DESTACADO", 
            x = 110, y = 15,
            width = 240, height =60,
            font = "Lato-Italic", fontSize = 16, align = "left"
        })
        txtDealDes:setFillColor( .3 )
        container:insert(txtDealDes)
        
        local btnDescargarDes = display.newImage( "img/btn/btnDescargarDes.png" )
        btnDescargarDes:translate( 45, 35 )
        container:insert(btnDescargarDes)
        
        local iconReady = display.newImage( "img/btn/iconReady.png" )
        iconReady:translate( 0, 75 )
        container:insert(iconReady)

        local txtStock = display.newText( {
            text = item.stock.." Disponibles",     
            x = 135, y = 75,
            width = 240, height =20,
            font = "Lato-Regular", fontSize = 16, align = "left"
        })
        if item.stock == '0' then
            txtStock:setFillColor( .8, .5, .5 )
        else
            txtStock:setFillColor( .3 )
        end
        container:insert(txtStock)
        
		-- Fix Height
		if txtTitle.height > 35 then
			txtTitle.height = 60
			txtTitle.y = -65
			txtPartner.y = -10
            txtDealDes.y = 15
		end
			
        
    end

    return self
end

---------------------------------------------------------------------------------
-- Gallery
---------------------------------------------------------------------------------
Gallery = {}
function Gallery:new()
    -- Variables
    local self = display.newGroup()
    
    -- Creamos la pantalla del menu
    function self:build(item, image)
        -- Generamos contenedor
        local container = display.newContainer( 480, 200 )
        container.x = 240
        container.y = 50
		container.name = 1
        self:insert( container )

        -- Agregamos imagen
        item.tipo  = "Gallery"
        image.alpha = 1
        image.x= 0
        image.width = 460
        image.height  = 200
        image.item = item
        container:insert( image )
        
    end

    return self
end