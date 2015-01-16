

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
        local container = display.newContainer( 450, 70 )
        container.x = 0
        container.y = 35
        self:insert( container )
        
        local txtTitleDate = display.newText( {
					text = desc,     
					x = 130, y = 25,
					width = intW, height = 60,
					font = "Chivo-Black", fontSize = 25, align = "left"
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
    
    -- Creamos la pantalla del menu
    function self:build(item, image)
        
        -- Generamos contenedor
        local container = display.newContainer( 450, 100 )
        container.x = 255
        container.y = 50
		container.name = 2
        self:insert( container )
		container:addEventListener( "tap", showCoupon )

        -- Agregamos rectangulo alfa al pie
        local maxShape = display.newRect( 0, 0, 480, 100 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )

        -- Agregamos imagen
        image.alpha = 1
        image.x= -175
        image.width = 80
        image.height  = 55
        container:insert( image )

        -- Agregamos textos
        local txtTitle = display.newText( {
            text = item.name,     
            x = 25, y = -10,
            width = 300, height =60,
            font = "Chivo", fontSize = 24, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtDate = display.newText( {
            text = getDate(item.date),     
            x = 25, y = 20,
            width = 300, height =60,
            font = "Chivo", fontSize = 18, align = "left"
        })
        txtDate:setFillColor( 146/255, 146/255, 146/255)
        container:insert(txtDate)

        local txtPlace = display.newText( {
            text = item.place,     
            x = 25, y = 40,
            width = 300, height =60,
            font = "Chivo", fontSize = 18, align = "left"
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
    
    -- Creamos la pantalla del menu
    function self:build(item, image)
        
        -- Generamos contenedor
        local container = display.newContainer( 450, 100 )
        container.x = 255
        container.y = 50
		container.name = 1
        self:insert( container )

        -- Agregamos rectangulo alfa al pie
        local maxShape = display.newRect( 0, 0, 480, 100 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )

        -- Agregamos imagen
        image.alpha = 1
        image.x= -175
        image.width = 80
        image.height  = 55
        container:insert( image )

        -- Agregamos textos
        local txtTitle = display.newText( {
            text = item.description,     
            x = 25, y = -10,
            width = 300, height =60,
            font = "Chivo", fontSize = 24, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtDate = display.newText( {
            text = getDate(item.iniDate),     
            x = 25, y = 20,
            width = 300, height =60,
            font = "Chivo", fontSize = 18, align = "left"
        })
        txtDate:setFillColor( 146/255, 146/255, 146/255)
        container:insert(txtDate)
    end

    return self
end