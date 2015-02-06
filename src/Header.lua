

---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
require('src.Search')
local Globals = require('src.resources.Globals')
local storyboard = require( "storyboard" )
local RestManager = require('src.resources.RestManager')

Header = {}

function Header:new()
    -- Variables
    local self = display.newGroup()
    local grpTool = display.newGroup()
    local grpSearch = display.newGroup()
    local imgSearch, btnClose, txtSearch
    
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
    
    function hideSearch( event )
        event.target.alpha = 0
        txtSearch.y = -100
        transition.to( imgSearch, { x = display.contentWidth - 90, time = 400, transition = easing.outExpo, 
			onComplete=function()
                    grpSearch.alpha = 0
					grpTool.alpha = 1
            end
        })
    end
    
    function showSearch( event )
        grpTool.alpha = 0
        grpSearch.alpha = 1
        txtSearch.y = 30
        transition.to( imgSearch, { x = 150, time = 400, transition = easing.outExpo, 
			onComplete=function() btnClose.alpha = 1 end
        })
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
        grpTool:insert(Globals.notBubble[tTxt])
        Globals.txtBubble[tTxt] = display.newText( {
            x = display.contentWidth - 131, y = 10,
            text = totalBubble, font = "Lato-Regular", fontSize = 12,
        })
        Globals.txtBubble[tTxt]:setFillColor( 1 )
        grpTool:insert(Globals.txtBubble[tTxt])
		
		if #Globals.txtBubble > 0 then
			Globals.txtBubble[tTxt].text = Globals.txtBubble[1].text
		end
		
		if Globals.txtBubble[1].text == nil then
			Globals.notBubble[tTxt]:removeSelf()
			Globals.txtBubble[tTxt]:removeSelf()
		end
	end
	
	function SearchText( homeScreen )
		--modalSeach(txtSearch.text,homeScreen)
		modalSeach("Fish",homeScreen)
		return true
	end
	
	function onTxtFocusSearch(event)
		if ( "submitted" == event.phase ) then
			-- Hide Keyboard
			native.setKeyboardFocus(nil)
			getSceneSearch()
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
        
        local toolbar = display.newRect( 0, 0, display.contentWidth, 60 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( .2, .2, .2 )
        self:insert(toolbar)
        
        local logo = display.newImage( "img/btn/logo.png" )
        logo:translate( 45, 30 )
        self:insert(logo)
        
        -- Grupo que se oculta en la busqueda
        self:insert(grpTool)
        self:insert(grpSearch)

        local txtCancun = display.newText( {
            x = 135, y = 30,
            text = "CANCUN", font = "Lato-Regular", fontSize = 25,
        })
        txtCancun:setFillColor( 1 )
        grpTool:insert(txtCancun)

        local btnWallet = display.newImage( "img/btn/btnMenuWallet.png" )
        btnWallet:translate( display.contentWidth - 212, 30 )
        btnWallet:addEventListener( "tap", showWallet )
        grpTool:insert(btnWallet)

        local btnSearch = display.newImage( "img/btn/btnMenuSearch.png" )
        btnSearch:translate( display.contentWidth - 90, 30 )
        btnSearch:addEventListener( "tap", showSearch )
        grpTool:insert(btnSearch)
        
        local btnMensaje = display.newImage( "img/btn/btnMenuNotification.png" )
        btnMensaje:translate( display.contentWidth - 150, 30 )
        btnMensaje:addEventListener( "tap", showNotifications )
        grpTool:insert(btnMensaje)

        local btnUser = display.newImage( "img/btn/btnMenuUser.png" )
        btnUser:translate( display.contentWidth - 35, 30 )
        btnUser:addEventListener( "tap", saveBeacon )
        grpTool:insert(btnUser)
                
        -- Search Elements
        grpSearch.alpha = 0
        txtSearch = native.newTextField( 300, -100, 250, 40 )
        txtSearch.method = "create"
        txtSearch.size = 18
        txtSearch.hasBackground = false 
		txtSearch:addEventListener( "userInput", onTxtFocusSearch )
        grpSearch:insert(txtSearch)
        
        imgSearch = display.newImage( "img/btn/btnMenuSearch.png" )
        imgSearch:translate( display.contentWidth - 90, 30 )
        grpSearch:insert(imgSearch)
		imgSearch:addEventListener('tap',getSceneSearch)
        
        btnClose = display.newImage( "img/btn/btnMenuClose.png" )
        btnClose:translate( display.contentWidth - 30, 30 )
        btnClose:addEventListener( "tap", hideSearch )
        grpSearch:insert(btnClose)
        
        bgSearch = display.newImage( "img/btn/bgTxtSearch.png" )
        bgSearch:translate(270, 50 )
        grpSearch:insert(bgSearch)
        
		
		--verificamos notificaciones
		RestManager.getNotificationsUnRead()
    end
    
    -- Creamos la pantalla del menu
    function self:buildNavBar(texto, idElement)
        
        local menu = display.newRect( 0, 60, display.contentWidth, 65 )
        menu.anchorX = 0
        menu.anchorY = 0
        menu:setFillColor( 189/255, 203/255, 206/255 )
        self:insert(menu)
        
        txtTitle = display.newText( {
            x = (display.contentWidth/2), y = 95,
            text = texto, font = "Lato-Regular", fontSize = 22,
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

