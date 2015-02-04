

---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
local Globals = require('src.resources.Globals')
local storyboard = require( "storyboard" )
local RestManager = require('src.resources.RestManager')

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
    
    function showSearch( event )
        
    end
    
    -- Temporal
    function saveBeacon( event )
        -- Move
        
    end
	
	function createNotBubble(totalBubble)
	
		local tTxt = #Globals.txtBubble + 1
	
		Globals.notBubble[tTxt] = display.newCircle( display.contentWidth - 132, 10, 10 )
        Globals.notBubble[tTxt]:setFillColor(1,.1,.1)
        Globals.notBubble[tTxt].strokeWidth = 2
        Globals.notBubble[tTxt]:setStrokeColor(.8)
        self:insert(Globals.notBubble[tTxt])
        Globals.txtBubble[tTxt] = display.newText( {
            x = display.contentWidth - 131, y = 10,
            text = totalBubble, font = "Chivo", fontSize = 12,
        })
        Globals.txtBubble[tTxt]:setFillColor( 1 )
        self:insert(Globals.txtBubble[tTxt])
		
		if #Globals.txtBubble > 0 then
			Globals.txtBubble[tTxt].text = Globals.txtBubble[1].text
		end
		
		if Globals.txtBubble[1].text == nil then
			Globals.notBubble[tTxt]:removeSelf()
			Globals.txtBubble[tTxt]:removeSelf()
		end
		
	end
    
    -- Return to last scene
    function returnScene( event )
        -- Obtenemos escena anterior y eliminamos del arreglo
        if #Globals.scene > 1 then
            local previousScene = Globals.scene[#Globals.scene - 1]
            table.remove(Globals.scene, #Globals.scene)
            table.remove(Globals.scene, #Globals.scene)
            -- Movemos a la escena anterior
            storyboard.gotoScene( previousScene, { time = 400, effect = "slideRight" })
        end
    end
    
    -- Envia elemento a la cartera
    function sendToWallet( event )
        
    end
    
    -- Creamos la el toolbar
    function self:buildToolbar(desc)
        -- Incluye botones que de se ocultaran en la bus
        
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
        btnSearch:addEventListener( "tap", showSearch )
        self:insert(btnSearch)
        -- Temporal bubble
        --[[local notBubble = display.newCircle( display.contentWidth - 132, 10, 10 )
        notBubble:setFillColor(1,.1,.1)
        notBubble.strokeWidth = 2
        notBubble:setStrokeColor(.8)
        self:insert(notBubble)
        local txtBubble = display.newText( {
            x = display.contentWidth - 131, y = 10,
            text = "3", font = "Chivo", fontSize = 12,
        })
        txtBubble:setFillColor( .1 )
        self:insert(txtBubble)]]

        local btnMensaje = display.newImage( "img/btn/btnMenuNotification.png" )
        btnMensaje:translate( display.contentWidth - 150, 25 )
        btnMensaje:addEventListener( "tap", showNotifications )
        self:insert(btnMensaje)

        local btnHerramienta = display.newImage( "img/btn/btnMenuUser.png" )
        btnHerramienta:translate( display.contentWidth - 35, 25 )
        btnHerramienta:addEventListener( "tap", saveBeacon )
        self:insert(btnHerramienta)
		
		--verificamos notificaciones
		RestManager.getNotificationsUnRead()
		
    end
    
    -- Creamos la pantalla del menu
    function self:buildNavBar(texto, idElement)
        
        local menu = display.newRect( 0, 55, display.contentWidth, 75 )
        menu.anchorX = 0
        menu.anchorY = 0
        menu:setFillColor( 189/255, 203/255, 206/255 )
        self:insert(menu)
        
        txtTitle = display.newText( {
            x = (display.contentWidth/2), y = 95,
            text = texto, font = "Chivo", fontSize = 22,
        })
        txtTitle:setFillColor( .2 )
        self:insert(txtTitle)

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

