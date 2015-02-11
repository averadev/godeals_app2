

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
		
		--hideSearch2()
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
        local container = display.newContainer( 480, 120 )
        container.x = 240
        container.y = 60
		container.name = 2
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showEvent )

       -- Agregamos fondo
        if isBg then
            local maxShape = display.newRect( 0, 0, 460, 110 )
            maxShape:setFillColor( .89 )
            container:insert( maxShape )
        end

        -- Agregamos imagen
        local mask = graphics.newMask( "img/bgk/maskImgRow.jpg" )
        image:setMask( mask )
        item.tipo  = "Event"
        image.alpha = 1
        image.x= -175
        image.width = 100
        image.height  = 100
        image.item = item
        container:insert( image )

        -- Agregamos textos
        local txtTitle = display.newText( {
            text = item.name,     
            x = 40, y = -5,
            width = 300, height =60,
            font = "Lato-Regular", fontSize = 24, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtDate = display.newText( {
            text = getDate(item.iniDate),     
            x = 40, y = 25,
            width = 300, height =60,
            font = "Lato-Regular", fontSize = 18, align = "left"
        })
        txtDate:setFillColor( .3 )
        container:insert(txtDate)

        local txtPlace = display.newText( {
            text = item.address,     
            x = 40, y = 45,
            width = 300, height =60,
            font = "Lato-Regular", fontSize = 18, align = "left"
        })
        txtPlace:setFillColor( .3 )
        container:insert(txtPlace)
    end

    return self
end


---------------------------------------------------------------------------------
-- DEAL
---------------------------------------------------------------------------------
Deal = {}
function Deal:new()
    -- Variables
    local self = display.newGroup()
    
    function showCoupon(event)
        local Globals = require('src.resources.Globals')
        local storyboard = require( "storyboard" )
        Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		
		--hideSearch2()
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
        local container = display.newContainer( 480, 120 )
        container.x = 240
        container.y = 60
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showCoupon )

        -- Agregamos fondo
        if isBg then
            local maxShape = display.newRect( 0, 0, 460, 110 )
            maxShape:setFillColor( .89 )
            container:insert( maxShape )
        end

        -- Agregamos imagen
        local mask = graphics.newMask( "img/bgk/maskImgRow.jpg" )
        image:setMask( mask )
        item.tipo  = "Coupon"
        image.alpha = 1
        image.x= -175
        image.width = 100
        image.height  = 100
        image.item = item
        container:insert( image )

        -- Agregamos textos
        local txtTitle = display.newText( {
            text = item.name ,     
            x = 40, y = -5,
            width = 300, height = 60,
            font = "Lato-Regular", fontSize = 24, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtPartner = display.newText( {
            text = item.partner,     
            x = 40, y = 25,
            width = 300, height =60,
            font = "Lato-Regular", fontSize = 18, align = "left"
        })
        txtPartner:setFillColor( .3 )
        container:insert(txtPartner)

        local txtStock = display.newText( {
            text = item.stock.." Disponibles",     
            x = 40, y = 45,
            width = 300, height =60,
            font = "Lato-Regular", fontSize = 18, align = "left"
        })
        if item.stock == '0' then
            txtStock:setFillColor( .8, .5, .5 )
        else
            txtStock:setFillColor( .3 )
        end
        container:insert(txtStock)
        
        
        
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