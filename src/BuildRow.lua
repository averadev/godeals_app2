

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
        storyboard.removeScene( "src.Event" )
        storyboard.gotoScene( "src.Event", {
            time = 400,
            effect = "crossFade",
            params = { item = event.target.item }
        })
    end
    
    -- Creamos la pantalla del menu
    function self:build(item, image)
        
        -- Generamos contenedor
        local container = display.newContainer( 450, 100 )
        container.x = 255
        container.y = 50
		container.name = 2
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showEvent )

        -- Agregamos rectangulo alfa al pie
        local maxShape = display.newRect( 0, 0, 480, 100 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )

        -- Agregamos imagen
        local mask = graphics.newMask( "img/bgk/maskImgRow.jpg" )
        image:setMask( mask )
        item.tipo  = "Event"
        image.alpha = 1
        image.x= -175
        image.width = 80
        image.height  = 80
        image.item = item
        container:insert( image )

        -- Agregamos textos
        local txtTitle = display.newText( {
            text = item.name,     
            x = 30, y = -5,
            width = 300, height =60,
            font = "Lato-Regular", fontSize = 24, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtDate = display.newText( {
            text = getDate(item.iniDate),     
            x = 30, y = 25,
            width = 300, height =60,
            font = "Lato-Regular", fontSize = 18, align = "left"
        })
        txtDate:setFillColor( 146/255, 146/255, 146/255)
        container:insert(txtDate)

        local txtPlace = display.newText( {
            text = item.address,     
            x = 30, y = 45,
            width = 300, height =60,
            font = "Lato-Regular", fontSize = 18, align = "left"
        })
        txtPlace:setFillColor( 146/255, 146/255, 146/255)
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
        storyboard.removeScene( "src.Coupon" )
        storyboard.gotoScene( "src.Coupon", {
            time = 400,
            effect = "crossFade",
            params = { item = event.target.item }
        })
    end
    
    -- Creamos la pantalla del menu
    function self:build(item, image)
        -- Generamos contenedor
        local container = display.newContainer( 450, 100 )
        container.x = 255
        container.y = 50
		container.name = 1
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showCoupon )

        -- Agregamos rectangulo alfa al pie
        local maxShape = display.newRect( 0, 0, 480, 100 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )

        -- Agregamos imagen
        local mask = graphics.newMask( "img/bgk/maskImgRow.jpg" )
        image:setMask( mask )
        item.tipo  = "Coupon"
        image.alpha = 1
        image.x= -175
        image.width = 80
        image.height  = 80
        image.item = item
        container:insert( image )

        -- Agregamos textos
        local txtTitle = display.newText( {
            text = item.name ,     
            x = 30, y = 5,
            width = 300, height = 60,
            font = "Lato-Regular", fontSize = 24, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtDate = display.newText( {
            text = item.validity,     
            x = 30, y = 35,
            width = 300, height =60,
            font = "Lato-Regular", fontSize = 18, align = "left"
        })
        txtDate:setFillColor( 146/255, 146/255, 146/255)
        container:insert(txtDate)
        
        if item.stock == '0' then
            local agotado = display.newImage( "img/btn/agotado.png" )
            agotado:translate( 165, 0 )
            agotado.alpha = .8
            container:insert(agotado)
        --[[
        else
            local dealBubble = display.newCircle( 180, -27, 15 )
            dealBubble:setFillColor(.8, 1, .8)
            dealBubble.strokeWidth = 2
            dealBubble:setStrokeColor(.8)
            container:insert(dealBubble)
            
            local txtBubble = display.newText( {
                x = 182, y = -27,
                text = item.stock, font = "Lato-Regular", fontSize = 16,
            })
            txtBubble:setFillColor( .1 )
            container:insert(txtBubble)  --]]
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