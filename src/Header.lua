
---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
require('src.Search')
local Globals = require('src.resources.Globals')
local storyboard = require( "storyboard" )
local RestManager = require('src.resources.RestManager')
local DBManager = require('src.resources.DBManager')

Header = {}

function Header:new()
    -- Variables
    local self = display.newGroup()
    local grpTool = display.newGroup()
    local grpSearch = display.newGroup()
    local imgSearch, btnClose, txtSearch
	local txtCiudad
    
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
		native.setKeyboardFocus(nil)
        event.target.alpha = 0
        txtSearch.y = -100
        transition.to( imgSearch, { x = display.contentWidth - 90, time = 400, transition = easing.outExpo, 
			onComplete=function()
                    grpSearch.alpha = 0
					grpTool.alpha = 1
            end
        })
		closeModalSearch()
		txtSearch.text = ""
    end
    
    function showSearch( event )
        grpTool.alpha = 0
        grpSearch.alpha = 1
        txtSearch.y = 37
        transition.to( imgSearch, { x = 150, time = 400, transition = easing.outExpo, 
			onComplete=function() btnClose.alpha = 1 end
        })
    end
    
    -- Temporal
	function saveBeacon( event )
		-- Move
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
	
	function createNotBubble(totalBubble)
        local tTxt = #Globals.txtBubble + 1
	
		Globals.notBubble[tTxt] = display.newCircle( display.contentWidth - 132, 40, 10 )
        Globals.notBubble[tTxt]:setFillColor(.1,.5,.1)
        Globals.notBubble[tTxt].strokeWidth = 2
        Globals.notBubble[tTxt]:setStrokeColor(.8)
        grpTool:insert(Globals.notBubble[tTxt])
        Globals.txtBubble[tTxt] = display.newText( {
            x = display.contentWidth - 131, y = 40,
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
		modalSeach(txtSearch.text,homeScreen)
		--modalSeach("Fish",homeScreen)
		return true
	end
	
	function onTxtFocusSearch(event)
		if ( "submitted" == event.phase ) then
			-- Hide Keyboard
			native.setKeyboardFocus(nil)
			
			local currentScene =  storyboard.getCurrentSceneName()
			if currentScene == "src.Home" then
				getSceneSearchH()
			elseif currentScene == "src.Event" then
				getSceneSearchE()
			elseif currentScene == "src.Coupon" then
				getSceneSearchC()
			elseif currentScene == "src.Partner" then
				getSceneSearchP()
			elseif currentScene == "src.Mapa" then
				getSceneSearchM()
			elseif currentScene == "src.Notifications" then
				getSceneSearchN()
			elseif currentScene == "src.Wallet" then
				getSceneSearchW()
			end
		end
	end
	
	function getSceneSearch( event )
	
		native.setKeyboardFocus(nil)
		local currentScene =  storyboard.getCurrentSceneName()
		if currentScene == "src.Home" then
			getSceneSearchH()
		elseif currentScene == "src.Event" then
			getSceneSearchE()
		elseif currentScene == "src.Coupon" then
			getSceneSearchC()
		elseif currentScene == "src.Partner" then
			getSceneSearchP()
		elseif currentScene == "src.Mapa" then
			getSceneSearchM()
		elseif currentScene == "src.Notifications" then
			getSceneSearchN()
		elseif currentScene == "src.Wallet" then
			getSceneSearchW()
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
		logo:addEventListener("tap",showMenuLeft)
        self:insert(logo)
        
        -- Grupo que se oculta en la busqueda
        self:insert(grpTool)
        self:insert(grpSearch)

        txtCiudad = display.newText( {
            x = 135, y = 30,
			align = "left", width = 100,
            text = "CANCUN", font = "Lato-Bold", fontSize = 23,
        })
        txtCiudad:setFillColor( 1 )
        grpTool:insert(txtCiudad)

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
        --btnUser:addEventListener( "tap", saveBeacon )
		btnUser:addEventListener( "tap", showMenuRight )
        grpTool:insert(btnUser)
                
        -- Search Elements
        grpSearch.alpha = 0
		
        txtSearch = native.newTextField( 300, -100, 250, 60 )
		txtSearch:setTextColor(1)
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
    function self:buildNavBar(texto)
        
        local menu = display.newRect( 0, 60, display.contentWidth, 65 )
        menu.anchorX = 0
        menu.anchorY = 0
        menu:setFillColor( .87 )
        self:insert(menu)
        
        txtTitle = display.newText( {
            x = (display.contentWidth/2), y = 95,
            text = texto, font = "Lato-Regular", fontSize = 22,
        })
        txtTitle:setFillColor( .2 )
        self:insert(txtTitle)

        local imgBtnBack = display.newImage( "img/btn/btnBackward.png" )
        imgBtnBack.x= 30
        imgBtnBack.y = 92
        imgBtnBack:addEventListener( "tap", returnScene )
        self:insert( imgBtnBack )
        
    end
	
	function changeCityName(txtMin)
		txtCiudad.text = txtMin
	end
    
    return self
end

