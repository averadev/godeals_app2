
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
		container:addEventListener( "tap", showEvent )

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
-- MESSAGE
---------------------------------------------------------------------------------
Message = {}
local assigned = 0
function Message:new()
    -- Variables
    local self = display.newGroup()
	
	function AssignedCoupon(item)
		assigned = item
	end
    
    function showMessage(event)
        local Globals = require('src.resources.Globals')
        local storyboard = require( "storyboard" )
        Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		hideSearch2()
		deleteTxt()
		
        local current = storyboard.getCurrentSceneName()
		if current ~= "src.Message" then
            storyboard.removeScene( "src.Message" )
			storyboard.gotoScene( "src.Message", {
                time = 400,
                effect = "crossFade",
                params = { item = event.target.item }
            })
		end
    end
    
    -- Creamos la pantalla del menu
    function self:build(isBg, item, image)
        -- Generamos contenedor
        local container = display.newContainer( 480, 110 )
        container.x = 240
        container.y = 60
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showMessage )

        local maxShape = display.newRect( 0, 0, 460, 100 )
        maxShape:setFillColor( .84 )
        container:insert( maxShape )

        local maxShape = display.newRect( 0, 0, 456, 96 )
        maxShape:setFillColor( 1 )
        container:insert( maxShape )

        -- Agregamos imagen
        item.tipo  = "Message"
        image.alpha = 1
        image.x= -177
        image.item = item
        container:insert( image )

        -- Agregamos textos
        local txtPartner0 = display.newText( {
            text = "De:",     
            x = 45, y = -25,
            width = 340,
            font = "Lato-Bold", fontSize = 16, align = "left"
        })
        txtPartner0:setFillColor( 0 )
        container:insert(txtPartner0)
        
        local txtPartner = display.newText( {
            text = item.partner,     
            x = 55, y = -25,
            width = 300,
            font = "Lato-Bold", fontSize = 18, align = "left"
        })
        txtPartner:setFillColor( 0 )
        container:insert(txtPartner)
        
        local txtFecha = display.newText( {
            text = item.fechaFormat,     
            x = 200, y = -30,
            width = 100,
            font = "Lato-Bold", fontSize = 12, align = "left"
        })
        txtFecha:setFillColor( 0 )
        container:insert(txtFecha)
        
        local txtTitle0 = display.newText( {
            text = "Asunto: ",
            x = 45, y = 0,
            width = 340, height = 0,
            font = "Lato-Bold", fontSize = 16, align = "left"
        })
        txtTitle0:setFillColor( 0 )
        container:insert(txtTitle0)
        
        local txtTitle = display.newText( {
            text = item.name,
            x = 75, y = 0,
            width = 280, height = 0,
            font = "Lato-Bold", fontSize = 18, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtInfo = display.newText( {
            text = item.detail:sub(1,42).."...",
            x = 35, y = 25, width = 320,
            font = "Lato-Italic", fontSize = 14, align = "left"
        })
        txtInfo:setFillColor( .3 )
        container:insert(txtInfo)
        
        local btnForward = display.newImage( "img/btn/btnForward.png" )
        btnForward:translate( 200, 18)
        container:insert( btnForward )
        
    end

    return self
end

---------------------------------------------------------------------------------
-- PARTNER
---------------------------------------------------------------------------------
Partner = {}
function Partner:new()
    -- Variables
    local self = display.newGroup()
    
    function showPartner(event)
        local Globals = require('src.resources.Globals')
        local storyboard = require( "storyboard" )
        Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
		hideSearch2()
		deleteTxt()
        txtPHide()
		
        storyboard.removeScene( "src.Partner" )
        storyboard.gotoScene( "src.Partner", {
            time = 400,
            effect = "crossFade",
            params = { idPartner = event.target.item.id, name = event.target.item.name }
        })
    end
    
    -- Creamos la pantalla del menu
    function self:build(item)
        -- Generamos contenedor
        local container = display.newContainer( 480, 100 )
        container.x = 240
        container.y = 40
		container.item = item
        self:insert( container )
		container:addEventListener( "tap", showPartner )
        
        -- Agregamos imagen
        local iconReady = display.newImage( "img/btn/iconCategoryDeal/deal".. item.idFilter ..".png" )
        iconReady:translate( -190, 0 )
        container:insert(iconReady)
        
        -- Agregamos textos
        local txtName = display.newText( {
            text = item.name,
            x = 35, y = -15, width = 340,
            font = "Lato-Bold", fontSize = 18, align = "left"
        })
        txtName:setFillColor( 0 )
        container:insert(txtName)
        
        local txtInfo = display.newText( {
            text = item.info:sub(1,40).."...",
            x = 35, y = 10,
            width = 340, height = 20,
            font = "Lato-Italic", fontSize = 16, align = "left"
        })
        txtInfo:setFillColor( 0 )
        container:insert(txtInfo)
        
        local lineBottom = display.newRect( 0, 50, 480, 2)
        lineBottom.alpha = .3
        lineBottom:setFillColor( .3 )
		container:insert(lineBottom)
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
        
        if item.leido then 
            local txtInfo = display.newText( {
                text = item.detail,     
                x = 80, y = 35,
                width = 240, height = 50,
                font = "Lato-Italic", fontSize = 16, align = "left"
            })
            txtInfo:setFillColor( .3 )
            container:insert(txtInfo)
        else
            local imgBtnDown = display.newRoundedRect( 165, 55, 120, 40, 5 )
            imgBtnDown.id = item.id
            imgBtnDown:setFillColor( .75 )
            container:insert( imgBtnDown )

            local lbStatus = ""
            if item.assigned == 0  then
                lbStatus = "DESCARGAR"
                imgBtnDown:setFillColor( 68/255, 177/255, 13/255 )
                imgBtnDown:addEventListener( "tap", downloadDeal )

                local imgBtnShareB = display.newRoundedRect( 165, 65, 120, 20, 5 )
                imgBtnShareB:setFillColor( {
                    type = 'gradient',
                    color1 = { 68/255, 177/255, 13/255 }, 
                    color2 = { 38/255, 147/255, 0 },
                    direction = "bottom"
                } ) 
                imgBtnDown.grad = imgBtnShareB
                container:insert(imgBtnShareB)
            else
                if item.status == "1" then
                    lbStatus = "DESCARGADO"
                elseif item.status == "2" then
                    lbStatus = "REDIMIDO"
                elseif item.status == "3" then
                    lbStatus = "COMPARTIDO"
                end
            end

            local txtDescargar = display.newText( {
                text = lbStatus,     
                x = 165, y = 55, width = 120,
                font = "Lato-Bold", fontSize = 14, align = "center"
            })
            txtDescargar:setFillColor( 1 )
            container:insert(txtDescargar)
        
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
        end
        
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
        
        local bgShadowLogo = display.newImage( "img/bgk/bgShadowLogo.png" )
        bgShadowLogo.x = -123
        bgShadowLogo.y = 3
        container:insert(bgShadowLogo)
        
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
            font = "Lato Bold", fontSize = 19, align = "left"
        })
        txtTitle:setFillColor( 0 )
        container:insert(txtTitle)

        local txtPartner = display.newText( {
            text = item.partner,     
            x = 110, y = -20,
            width = 240, height =60,
            font = "Lato Bold", fontSize = 16, align = "left"
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
        
        local imgBtnDown = display.newRoundedRect( 45, 35, 120, 40, 5 )
        imgBtnDown.id = item.id
        imgBtnDown:setFillColor( .75 )
        container:insert( imgBtnDown )
        
        local lbStatus = ""
        if item.assigned == 0 then
            lbStatus = "DESCARGAR"
            imgBtnDown:setFillColor( 68/255, 177/255, 13/255 )
            imgBtnDown:addEventListener( "tap", downloadDeal )
            
            local imgBtnShareB = display.newRoundedRect( 45, 45, 120, 20, 5 )
            imgBtnShareB:setFillColor( {
                type = 'gradient',
                color1 = { 68/255, 177/255, 13/255 }, 
                color2 = { 38/255, 147/255, 0 },
                direction = "bottom"
            } ) 
            imgBtnDown.grad = imgBtnShareB
            container:insert(imgBtnShareB)
        else
            if item.status == "1" then
                lbStatus = "DESCARGADO"
            elseif item.status == "2" then
                lbStatus = "REDIMIDO"
            elseif item.status == "3" then
                lbStatus = "COMPARTIDO"
            end
        end
        
        local txtDescargar = display.newText( {
            text = lbStatus,     
            x = 45, y = 35, width = 120,
            font = "Lato-Bold", fontSize = 14, align = "center"
        })
        txtDescargar:setFillColor( 1 )
        container:insert(txtDescargar)
        
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