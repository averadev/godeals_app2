
---------------------------------------------------------------------------------
-- Encabezao general
---------------------------------------------------------------------------------
require('src.Tutorial')
require('src.Search')
local Sprites = require('src.resources.Sprites')
local Globals = require('src.resources.Globals')
local storyboard = require( "storyboard" )
local RestManager = require('src.resources.RestManager')
local DBManager = require('src.resources.DBManager')
local settings = DBManager.getSettings()

local txtCiudad = {}
local textoCiudad = ""
local menuScreenLeft = nil
local menuScreenRight = nil
 local groupSearchTool = display.newGroup()

Header = {}

function Header:new()
    -- Variables
	local grpLoading
    local isWifiBle = true
    local self = display.newGroup()
    local grpTool = display.newGroup()
    local grpSearch = display.newGroup()
    local imgSearch, btnClose, txtSearch
	local h = display.topStatusBarContentHeight
    
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
			storyboard.removeScene( "src.Wallet" )
            storyboard.gotoScene( "src.Wallet", { time = 400, effect = "slideLeft" })
        end
    end
    
    -- Obtener cupones descargados
    function showNotifications(event)
        if storyboard.getCurrentSceneName() ~= "src.Notifications" then
            Globals.noCallbackGlobal = Globals.noCallbackGlobal + 1
			storyboard.removeScene( "src.Notifications" )
            storyboard.gotoScene( "src.Notifications", { time = 400, effect = "slideLeft" })
        end
    end
    
	-- esconde la busqueda y el modal
    function hideSearch( event )
		
		native.setKeyboardFocus(nil)
		
		groupSearchTool:removeSelf()
		groupSearchTool = nil
		grpTool.alpha = 1
		groupSearchTool = display.newGroup()
		
		
		closeModalSearch()
    end
	
	--esconde la busqueda
	function hideSearch2( event )
	
		native.setKeyboardFocus(nil)
		
		groupSearchTool:removeSelf()
		groupSearchTool = nil
		groupSearchTool = display.newGroup()
		
		grpTool.alpha = 1
		
    end
    
	--muestra el formulario de busqueda
    function showSearch( event )
       -- grpTool.alpha = 0
       --[[ grpSearch.alpha = 1
        --txtSearch.y = 37
        transition.to( imgSearch, { x = 150, time = 400, transition = easing.outExpo, 
			onComplete=function() btnClose.alpha = 1 end
        })]]
		createSearch()
		createTxt("")
    end
	
	--instancia el textField de busqueda
	function createTxt(text)
		Globals.txtSearch = native.newTextField( 290, 30 + h, 250, 60 )
		Globals.txtSearch:setTextColor(1)
        Globals.txtSearch.method = "create"
        Globals.txtSearch.size = 18
        Globals.txtSearch.hasBackground = false 
		Globals.txtSearch:addEventListener( "userInput", onTxtFocusSearch )
		Globals.txtSearch.text = text
	end
	
	--intsancia los componentes de la busquesda
	function createSearch()
		
		bgSearchA = display.newRect( 85, 1 + h, display.contentWidth, 50 )
        bgSearchA.anchorX = 0
        bgSearchA.anchorY = 0
		bgSearchA:setFillColor( .2, .2, .2 )
		groupSearchTool:insert( bgSearchA )
		bgSearchA:addEventListener( 'tap', lockedSearch)
		bgSearchA:addEventListener( 'touch', lockedSearch)
		
		imgSearch = display.newImage( "img/btn/btnMenuSearch.png" )
        imgSearch:translate( display.contentWidth/4, 30 + h )
		imgSearch:addEventListener('tap', SearchText)
		groupSearchTool:insert( imgSearch )
        
        btnClose = display.newImage( "img/btn/btnMenuClose.png" )
        btnClose:translate( display.contentWidth - 30, 30 + h )
        btnClose:addEventListener( "tap", hideSearch )
		groupSearchTool:insert(btnClose)
        
        bgSearch = display.newImage( "img/btn/bgTxtSearch.png" )
        bgSearch:translate(290, 40 + h )
		groupSearchTool:insert( bgSearch )
		
		
	end
	
	--elimina el txtField de busqueda
	function deleteTxt()
		if Globals.txtSearch ~= nil then
			Globals.txtSearch:removeSelf()
			Globals.txtSearch = nil
		end
	end
	
	function lockedSearch( event )
		return true
	end
	
	--obtenemos el grupo de cada escena
	function getScreen()
		local currentScene = storyboard.getCurrentSceneName()
		if currentScene == "src.Home" then
			return getScreenH()
		elseif currentScene == "src.Event" then
			return getScreenE()
		elseif currentScene == "src.Coupon" then
			return getScreenC()
		elseif currentScene == "src.Partner" then
			return getScreenP()
		elseif currentScene == "src.Mapa" then
			return getScreenM()
		elseif currentScene == "src.Notifications" then
			return getScreenN()
		elseif currentScene == "src.Wallet" then
			return getScreenW()
		end
	end
	
	--mostramos el menu izquierdo
	function showMenuLeft( event )
		local screen = getScreen()
		screen.alpha = .5
		transition.to( screen, { x = 400, time = 400, transition = easing.outExpo } )
		transition.to( menuScreenLeft, { x = 40, time = 400, transition = easing.outExpo } )
		screen = nil
	end
	
	--esconde el menuIzquierdo
	function hideMenuLeft( event )
		local screen = getScreen()
		screen.alpha = 1
		transition.to( menuScreenLeft, { x = -480, time = 400, transition = easing.outExpo } )
		transition.to( screen, { x = 0, time = 400, transition = easing.outExpo } )
		screen = nil
		return true
	end
	
	--muestra el menu Derecho
	function showMenuRight( event )
		local screen = getScreen()
		screen.alpha = .5
		transition.to( screen, { x = -400, time = 400, transition = easing.outExpo } )
		transition.to( menuScreenRight, { x = 0, time = 400, transition = easing.outExpo } )
		screen = nil
	end
	
	--esconde el menu Derecho
	function hideMenuRight( event )
		local screen = getScreen()
		screen.alpha = 1
		transition.to( menuScreenRight, { x = 481, time = 400, transition = easing.outExpo } )
		transition.to( screen, { x = 0, time = 400, transition = easing.outExpo } )
		screen = nil
		return true
	end
	
	--mostramos el tutorial
	function showTutorial( event )
		hideMenuRight()
		createTutorial(getScreen())
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
	
	function onTxtFocusSearch(event)
		if ( "submitted" == event.phase ) then
			-- Hide Keyboard
			native.setKeyboardFocus(nil)
			modalSeach(Globals.txtSearch.text,getScreen())
		end
	end
	
	function SearchText( event )
		native.setKeyboardFocus(nil)
		--modalSeach(Globals.txtSearch.text,getScreen())
		if Globals.txtSearch.text == "" then
			modalSeach(" ",getScreen())
		else
			modalSeach(Globals.txtSearch.text,getScreen())
		end
		return true
	end
    
    -- Return to last scene
    function returnScene( event )
	
		print(#Globals.scene)
	
        -- Obtenemos escena anterior y eliminamos del arreglo
        if #Globals.scene > 1 then
			
            local previousScene = Globals.scene[#Globals.scene - 1]
			local currentScene = Globals.scene[#Globals.scene]
			
			if previousScene == currentScene then
				while previousScene == currentScene do
					previousScene = Globals.scene[#Globals.scene - 1]
					table.remove(Globals.scene, #Globals.scene)
				end
				
			else
				table.remove(Globals.scene, #Globals.scene)
				table.remove(Globals.scene, #Globals.scene)
			end
			
			deleteTxt()
			
			table.remove(txtCiudad, #txtCiudad)
			txtCiudad[#txtCiudad].text = textoCiudad
			
            storyboard.gotoScene( previousScene, { time = 400, effect = "slideRight" })
			
			showModalSearch()
		else
			Globals.scene = nil
			Globals.scene = {}
			storyboard.gotoScene( "src.Home", { time = 400, effect = "slideRight" })
        end
		
    end
	
	function getNoContent(obj, txtData)
		if not grpLoading then
			grpLoading = display.newGroup()
			obj:insert(grpLoading)
			
			local noData = display.newImage( "img/btn/noData.png" )
			noData.x = display.contentWidth / 2
			noData.y = (obj.height / 3) - 35
			grpLoading:insert(noData) 
			
			local title = display.newText( txtData, 0, 30, "Chivo", 16)
			title:setFillColor( .3, .3, .3 )
			title.x = display.contentWidth / 2
			title.y = (obj.height / 3) + 80
			grpLoading:insert(title) 
		end
	end
	
	function endLoading()
		if grpLoading then
			grpLoading:removeSelf()
			grpLoading = nil
		end
	end
	
	function getLoading(obj)
		if not grpLoading then
		
			grpLoading = display.newGroup()
			obj:insert(grpLoading)
			
			-- Sprite and text
			local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
			local loadingBottom = display.newSprite(sheet, Sprites.loading.sequences)
			loadingBottom.x = display.contentWidth / 2
			loadingBottom.y = obj.height / 3
			grpLoading:insert(loadingBottom)
			loadingBottom:setSequence("play")
			loadingBottom:play()

			local title = display.newText( "Cargando, por favor espere...", 0, 30, "Chivo", 16)
			title:setFillColor( .3, .3, .3 )
			title.x = display.contentWidth / 2
			title.y = (obj.height / 3) + 40
			grpLoading:insert(title)
		else
			obj:insert(grpLoading)
		end
	end
	
	-- regresamos a la escena de home
	function returnHome()
		Globals.scene = nil
		Globals.scene = {}
		storyboard.gotoScene( "src.Home", { time = 400, effect = "slideRight" })
	end
    
    -- Envia elemento a la cartera
    function sendToWallet( event )
        
    end
	
	--cierra la sesion
	function logout()
		DBManager.clearUser()
		storyboard.gotoScene( "src.Login", {
			time = 400,
			effect = "crossFade"
    }	)
	end
    
    -- Creamos la el toolbar
    function self:buildToolbar(homeScreen)
        
        -- Verificamos Wifi y BLE
        if getBeacon then
            isWifiBle = getBeacon.verifyWifiBLE()
        end
        
        
        -- Incluye botones que de se ocultaran en la bus
		local poscCiu = #txtCiudad + 1
        
        local toolbar = display.newRect( 0, 0, display.contentWidth, 80 )
        toolbar.anchorX = 0
        toolbar.anchorY = 0
        toolbar:setFillColor( .2, .2, .2 )
        self:insert(toolbar)
        
        local iconTool1 = display.newImage( "img/btn/iconTool1.png" )
        iconTool1:translate( 47, 35 )
		iconTool1:addEventListener("tap",showMenuLeft)
        self:insert(iconTool1)
        
        txtCiudad[poscCiu] = display.newText( {
            x = 47, y = 65,
			align = "center", width = 95,
            text = textoCiudad, font = "Lato-Bold", fontSize = 10,
        })
        txtCiudad[poscCiu]:setFillColor( 1 )
        self:insert(txtCiudad[poscCiu])
        if textoCiudad == "" then
			RestManager.getCityById()
		end
        
        -- Grupo que se oculta en la busqueda
        self:insert(grpTool)
        self:insert(grpSearch)
        
        -- Draw lines
        local line1 = display.newRect( 95, 40, 1, 80)
        line1.alpha = .1
		grpTool:insert(line1)
        local line2 = display.newRect( 190, 40, 1, 80)
        line2.alpha = .1
		grpTool:insert(line2)
        local line3 = display.newRect( 285, 40, 1, 80)
        line3.alpha = .1
		grpTool:insert(line3)
        local line4 = display.newRect( 380, 40, 1, 80)
        line4.alpha = .1
		grpTool:insert(line4)
        local bgToolB = display.newRect( 237, 40, 95, 80 )
        bgToolB:setFillColor( 64/255 )
        grpTool:insert(bgToolB)
        local bgToolD = display.newRect( 332, 40, 95, 80 )
        bgToolD:setFillColor( 50/255, 150/255, 0 )
        grpTool:insert(bgToolD)
        
        local iconTool2 = display.newImage( "img/btn/iconTool2.png" )
        iconTool2:translate( 142, 35 )
		--iconTool2:addEventListener("tap",showMenuLeft)
        grpTool:insert(iconTool2)
        local iconTool3 = display.newImage( "img/btn/iconTool3.png" )
        iconTool3:translate( 237, 35 )
		iconTool3:addEventListener("tap",showNotifications)
        grpTool:insert(iconTool3)
        local iconTool4 = display.newImage( "img/btn/iconTool4.png" )
        iconTool4:translate( 332, 35 )
		iconTool4:addEventListener("tap",showWallet)
        grpTool:insert(iconTool4)
        local iconTool5 = display.newImage( "img/btn/iconTool5.png" )
        iconTool5:translate( 425, 37 )
		iconTool5:addEventListener("tap",showSearch)
        self:insert(iconTool5)
        
        local txtTool2 = display.newText( {
            x = 142, y = 65,
			align = "center", width = 95,
            text = "CERCANOS", font = "Lato-Bold", fontSize = 10,
        })
        txtTool2:setFillColor( 1 )
        grpTool:insert(txtTool2)
        
        local txtTool3 = display.newText( {
            x = 237, y = 65,
			align = "center", width = 95,
            text = "MI BANDEJA", font = "Lato-Bold", fontSize = 10,
        })
        txtTool3:setFillColor( 1 )
        grpTool:insert(txtTool3)
        
        local txtTool4 = display.newText( {
            x = 332, y = 65,
			align = "center", width = 95,
            text = "MIS DESCARGAS", font = "Lato-Bold", fontSize = 10,
        })
        txtTool4:setFillColor( 1 )
        grpTool:insert(txtTool4)
        
        local txtTool5 = display.newText( {
            x = 425, y = 65,
			align = "center", width = 95,
            text = "BUSCADOR", font = "Lato-Bold", fontSize = 10,
        })
        txtTool5:setFillColor( 1 )
        grpTool:insert(txtTool5)
        
        
        
        

        --[[
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
        ]]--
                
        -- Search Elements
        grpSearch.alpha = 0
        
		--creamos la pantalla del menu
		if menuScreenLeft == nil then
			menuScreenLeft = MenuLeft:new()
			menuScreenRight = MenuRight:new()
		
			menuScreenLeft:builScreenLeft()
			menuScreenRight:builScreenRight()
		end
		
		--verificamos notificaciones
		RestManager.getNotificationsUnRead()
    end
    
    -- Creamos la pantalla del menu
    function self:buildWifiBle()
        if not (isWifiBle) then
            local toolWifiBLE = display.newRect( 0, 80, display.contentWidth, 30 )
            toolWifiBLE.anchorX = 0
            toolWifiBLE.anchorY = 0
            toolWifiBLE:setFillColor( .2, .5, .2 )
            self:insert(toolWifiBLE)

            local txtWifiBLE = display.newText( {
                x = 220, y = 95,
                align = "left", width = 400,
                text = "Para obtener mejores beneficios active su Wifi y/o bluetooth", font = "Lato-Bold", fontSize = 14,
            })
            txtWifiBLE:setFillColor( 1 )
            self:insert(txtWifiBLE)
            return 30
        else
            return 0
        end
        
    end
    
    -- Creamos la pantalla del menu
    function self:buildNavBar(texto)
        
        local hWB = 20
        if not (isWifiBle) then hWB = 50 end
        
        local menu = display.newRect( 0, 60 + hWB, display.contentWidth, 65 )
        menu.anchorX = 0
        menu.anchorY = 0
        menu:setFillColor( .87 )
        self:insert(menu)
        
        txtTitle = display.newText( {
            x = (display.contentWidth/2), y = 95 + hWB,
			width = 400, align = "center",
            text = texto, font = "Lato-Hairline", fontSize = 22,
        })
        txtTitle:setFillColor( .2 )
        self:insert(txtTitle)

        local imgBtnBack = display.newImage( "img/btn/btnBackward.png" )
        imgBtnBack.x= 30
        imgBtnBack.y = 92 + hWB
        imgBtnBack:addEventListener( "tap", returnScene )
        self:insert( imgBtnBack )
		
		local imgBtnHome = display.newImage( "img/btn/btnMenuHome.png" )
        imgBtnHome.x= 440
        imgBtnHome.y = 92 + hWB
		imgBtnHome:setFillColor( .5 )
        imgBtnHome:addEventListener( "tap", returnHome )
        self:insert( imgBtnHome )
        
    end
	
	function changeCityName(items)
		textoCiudad = items.txtMin
		txtCiudad[#txtCiudad].text = items.txtMin
		DBManager.updateCity(items.id)
		removeItemsGroupHome()
	end
	
	function changeTxtcity(item)
		textoCiudad = item
		txtCiudad[#txtCiudad].text = item
	end
    
    return self
end

