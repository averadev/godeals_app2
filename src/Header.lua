

---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
local Globals = require('src.resources.Globals')
local storyboard = require( "storyboard" )
Header = {}

function Header:new()
    -- Variables
    local self = display.newGroup()
    
    -- Obtener cupones descargados
    function showHome(event)
        if storyboard.getCurrentSceneName() ~= "src.Home" then
            Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
            storyboard.gotoScene( "src.Home", { time = 400, effect = "slideLeft" })
        end
    end
    
    -- Obtener cupones descargados
    function showWallet(event)
        if storyboard.getCurrentSceneName() ~= "src.Wallet" then
            Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
            storyboard.gotoScene( "src.Wallet", { time = 400, effect = "slideLeft" })
        end
    end
    
    -- Obtener cupones descargados
    function showNotifications(event)
        if storyboard.getCurrentSceneName() ~= "src.Notifications" then
            Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
            storyboard.gotoScene( "src.Notifications", { time = 400, effect = "slideLeft" })
        end
    end
    
    -- Temporal
    function saveBeacon( event )
        -- Move
        transition.to( event.target, { alpha = 0, time = 400, transition = easing.outExpo } )
        transition.to( event.target, { alpha = 1, time = 400, delay = 500, transition = easing.outExpo } )

        local dataTmp = {
            {id = '1', message = 'Bienvenido, hoy tenemos una oferta para ti.', uuid = '1a4f5be7-6683-44a6-b559-b8bf6efd9ad7', 
                latitude = '0', longitude = '0', distanceMin = '.3', distanceMax = '0', partnerId = '2'},
            {id = '2', message = 'Bienvenido, hoy tenemos una oferta para ti.', uuid = 'f7826da6-4fa2-4e98-8024-bc5b71e0893e', 
                latitude = '0', longitude = '0', distanceMin = '.3', distanceMax = '0', partnerId = '2'},
            {id = '3', message = 'Bienvenido, hoy tenemos una oferta para ti.', uuid = 'a1ea8136-0e1b-d4a1-b840-63f88c8da1ea', 
                latitude = '0', longitude = '0', distanceMin = '.3', distanceMax = '0', partnerId = '2'}
        }
        DBManager.saveAds(dataTmp)
    end
    
    -- Return to last scene
    function returnScene( event )
        -- Obtenemos escena anterior y eliminamos del arreglo
        local previousScene = Globals.scene[#Globals.scene - 1]
        table.remove(Globals.scene, #Globals.scene)
        table.remove(Globals.scene, #Globals.scene)
        -- Movemos a la escena anterior
        storyboard.gotoScene( previousScene, { time = 400, effect = "slideRight" })
    end
    
    -- Envia elemento a la cartera
    function sendToWallet( event )
        
    end
    
    -- Creamos la el toolbar
    function self:buildToolbar(desc)
        
        local toolbar = display.newRect( 0, 0, display.contentWidth, 55 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( 221/255, 236/255, 241/255 )
        self:insert(toolbar)
        
        local logo = display.newImage( "img/btn/logo.png" )
        logo:translate( 45, 23 )
        self:insert(logo)

        local txtCancun = display.newText( {
            x = 130, y = 23,
            text = "Cancun", font = "Chivo", fontSize = 25,
        })
        txtCancun:setFillColor( .1 )
        self:insert(txtCancun)

        local btnWallet = display.newImage( "img/btn/btnMenuWallet.png" )
        btnWallet:translate( display.contentWidth - 212, 23 )
        btnWallet:addEventListener( "tap", showWallet )
        self:insert(btnWallet)

        local btnSearch = display.newImage( "img/btn/btnMenuSearch.png" )
        btnSearch:translate( display.contentWidth - 90, 25 )
        self:insert(btnSearch)
        -- Temporal bubble
        local notBubble = display.newCircle( display.contentWidth - 132, 10, 10 )
        notBubble:setFillColor(128,128,128)
        notBubble.strokeWidth = 2
        notBubble:setStrokeColor(.8)
        self:insert(notBubble)
        local txtBubble = display.newText( {
            x = display.contentWidth - 131, y = 10,
            text = "3", font = "Chivo", fontSize = 12,
        })
        txtBubble:setFillColor( .1 )
        self:insert(txtBubble)

        local btnMensaje = display.newImage( "img/btn/btnMenuNotification.png" )
        btnMensaje:translate( display.contentWidth - 150, 25 )
        btnMensaje:addEventListener( "tap", showNotifications )
        self:insert(btnMensaje)

        local btnHerramienta = display.newImage( "img/btn/btnMenuUser.png" )
        btnHerramienta:translate( display.contentWidth - 35, 25 )
        btnHerramienta:addEventListener( "tap", saveBeacon )
        self:insert(btnHerramienta)
    end
    
    -- Creamos la pantalla del menu
    function self:buildNavBar(idElement)
        
        local menu = display.newRect( 0, 55, display.contentWidth, 75 )
        menu.anchorX = 0
        menu.anchorY = 0
        menu:setFillColor( 189/255, 203/255, 206/255 )
        self:insert(menu)

        local imgBtnBack = display.newImage( "img/btn/btnBackward.png" )
        imgBtnBack.x= 30
        imgBtnBack.y = 90
        imgBtnBack:addEventListener( "tap", returnScene )
        self:insert( imgBtnBack )

        if idElement ~= nil then
            local imgToWallet = display.newImage( "img/btn/btnUp.png" )
            imgToWallet.x= 420
            imgToWallet.y = 90
            imgToWallet.id = idElement
            imgToWallet:addEventListener( "tap", sendToWallet )
            self:insert( imgToWallet )
        end
    end

    return self
end

