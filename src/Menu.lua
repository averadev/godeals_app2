MenuLeft = {}
MenuRight = {}

function MenuLeft:new()
    
    local DBManager = require('src.resources.DBManager')
	local RestManager = require('src.resources.RestManager')
	
	local intW = display.contentWidth
	local intH = display.contentHeight
	local h = display.topStatusBarContentHeight
	local rectCancun, rectPlaya
	local lineLeft = {}

	local selfL = display.newGroup()
    local grpCity = display.newGroup()
	
	selfL.x = -480
	
	function selfL:builScreenLeft()
		
		local bgMenuLeft = display.newRect( display.contentCenterX, display.contentCenterY + h, intW, intH )
		bgMenuLeft:setFillColor( 1 )
		bgMenuLeft.alpha = .2
		bgMenuLeft:addEventListener("tap",hideMenuLeft)
		bgMenuLeft:addEventListener("touch",blockMenu)
		selfL:insert(bgMenuLeft)
		
		local MenuLeft = display.newRect( display.contentCenterX - 80, display.contentCenterY + h, 400, intH )
		MenuLeft:setFillColor( .1 )
		MenuLeft.alpha = 1
		MenuLeft:addEventListener("tap",blockMenu)
		MenuLeft:addEventListener("touch",blockMenu)
		selfL:insert(MenuLeft)
		
		RestManager.getCity()
		
	end
    
    local function changeCity( event )
        hideMenuLeft()
        local t = event.target
        t.alpha = 1
        transition.to( t, { alpha = .1, time = 200, transition = easing.outExpo } )
        changeCityName(event.target)
    end

    local function getCities( event )
        if grpCity.y == intH - 60 then
            transition.to( grpCity, { y = intH - 180, time = 800, transition = easing.outExpo } )
        else
            transition.to( grpCity, { y = intH - 60, time = 800, transition = easing.outExpo } )
        end
    end
    
    local function cerrarSession( event )
        hideMenuLeft()
        logout()
    end
	
	function createMenuLeft(items)
        
        local settings = DBManager.getSettings()
        local sizeAvatar = 'width=200&height=200'
        
		if settings.fbId == "" then
            local mask = graphics.newMask( "img/bgk/maskBig.jpg" )
			local avatar = display.newImage( "img/bgk/user.png" )
            avatar:setMask( mask )
			avatar.x = 150
            avatar.y = h + 160
            avatar.width = 200
            avatar.height  = 200
			selfL:insert(avatar)
		else
			local path = system.pathForFile( "avatarFb"..settings.fbId, system.TemporaryDirectory )
			local fhd = io.open( path )
			if fhd then
				fhd:close()
                local avatar = display.newImage("avatarFb"..settings.fbId, system.TemporaryDirectory )
                avatar:translate( 150, h + 160)
                avatar.width = 200
                avatar.height  = 200
				selfL:insert(avatar)
                local mask = display.newImage( "img/bgk/bgAvatar.png" )
                mask:translate( 150, h + 160)
				selfL:insert(mask)
			else
				local function networkListenerFB( event )
					-- Verificamos el callback activo
					if ( event.isError ) then
					else
                        local mask = graphics.newMask( "img/bgk/maskBig.jpg" )
						event.target:setMask( mask )
                        event.target.x = 150
                        event.target.y = h + 160
                        event.target.height = 200
                        event.target.width = 200
						selfL:insert( event.target )
					end
				end
				display.loadRemoteImage( "http://graph.facebook.com/".. settings.fbId .."/picture?type=large&"..sizeAvatar, 
					"GET", networkListenerFB, "avatarFb"..settings.fbId, system.TemporaryDirectory )
			end
		end
        
        local textSaludo = display.newText( {
            text = "HOLA",     
            x = 225, y = h + 280,
            width = 350, height =20,
            font = "Lato-Regular",  fontSize = 16, align = "left"
        })
        textSaludo:setFillColor( 1 )
        selfL:insert(textSaludo)

        local textNombre = display.newText( {
            text = settings.name,     
            x = 225, y = h + 310,
            width = 350, height = 30,
            font = "Lato-Bold",  fontSize = 30, align = "left"
        })
        textNombre:setFillColor( 1 )
        selfL:insert(textNombre)
        if settings.fbId == "" then
            textNombre.text = settings.email
        end
        
        -- Menu Buttons
        local lineTop = display.newRect( 160, h + 350, 400, 1)
        lineTop.alpha = .5
		selfL:insert(lineTop)
        local lineBottom = display.newRect( 160, h + 450, 400, 1)
        lineBottom.alpha = .5
		selfL:insert(lineBottom)
        local lineH1 = display.newRect( 85, h + 400, 2, 100)
        lineH1.alpha = .5
		selfL:insert(lineH1)
        local lineH2 = display.newRect( 230, h + 400, 2, 100)
        lineH2.alpha = .5
		selfL:insert(lineH2)
        
        local icoMenu1 = display.newImage( "img/btn/icoMenu1.png" )
        icoMenu1:translate( 20, h + 390 )
        icoMenu1:addEventListener( "tap", showTutorial )
		selfL:insert(icoMenu1)
        local icoMenu2 = display.newImage( "img/btn/icoMenu2.png" )
        icoMenu2:translate( 160, h + 390 )
        icoMenu2.alpha = .5
		selfL:insert(icoMenu2)
        local icoMenu3 = display.newImage( "img/btn/icoMenu3.png" )
        icoMenu3:translate( 295, h + 390 )
        icoMenu3:addEventListener( "tap", cerrarSession )
		selfL:insert(icoMenu3)
        
        local txtMenu1 = display.newText( {
            text = "Tutorial",
            x = 20, y = h + 440,
            width = 100, height = 30,
            font = "Lato-Bold",  fontSize = 14, align = "center"
        })
		selfL:insert(txtMenu1)
        local txtMenu2 = display.newText( {
            text = "Configuración",
            x = 160, y = h + 440,
            width = 100, height = 30,
            font = "Lato-Bold",  fontSize = 14, align = "center"
        })
        txtMenu2:setFillColor( .5 )
		selfL:insert(txtMenu2)
        local txtMenu3 = display.newText( {
            text = "Cerrar Sesión",
            x = 295, y = h + 440,
            width = 100, height = 30,
            font = "Lato-Bold",  fontSize = 14, align = "center"
        })
		selfL:insert(txtMenu3)
        
        -- Menu Ciudades
		local lastY = 90
		local rectCity = {}
        selfL:insert(grpCity)
        grpCity.y = intH - 60
		
		local MenuLeftCiudad = display.newRect( display.contentCenterX - 80, 30 , 400, 60 )
		MenuLeftCiudad:setFillColor( .56 )
        MenuLeftCiudad:addEventListener( "tap", getCities )
		grpCity:insert(MenuLeftCiudad)
        
        local icoMenuCity = display.newImage( "img/btn/icoMenuCity.png" )
        icoMenuCity:translate( 320, 30)
        grpCity:insert(icoMenuCity)
        
        titleLeft = display.newText( {    
            x = 150, y = 32, align = "left", width = 300,
            text = "CAMBIAR CIUDAD",  font = "Lato-Bold", fontSize = 18,
        })
        titleLeft:setFillColor( 1 )
        grpCity:insert(titleLeft)
		
		
		--creamos los botones del menu
		for y = 1, #items, 1 do
			rectCity[y] = display.newRect(  display.contentCenterX - 80, lastY, 400, 60 )
			rectCity[y]:setFillColor( .7 )
			rectCity[y].txtMin = items[y].name
			rectCity[y].id = items[y].idCity
			rectCity[y]:addEventListener( "tap", changeCity )
			grpCity:insert(rectCity[y])
            
            txtCity = display.newText( {    
                x = 150, y = MenuLeftCiudad.height + lastY - 60, align = "left", width = 300,
                text = " - " .. items[y].name,  font = "Lato-Bold", fontSize = 18,
            })
			txtCity:setFillColor( 0 )
			grpCity:insert(txtCity)
			
			lineLeft[y] = display.newLine(-40, lastY + 30, 360, lastY + 30)
			grpCity:insert(lineLeft[y])
			
			lastY = lastY + 60
		end
		
		-- Border Right
        local borderRight = display.newRect( 358, intH / 2, 4, intH )
        borderRight:setFillColor( {
            type = 'gradient',
            color1 = { .1, .1, .1, .7 }, 
            color2 = { .9, .9, .9, .4 },
            direction = "left"
        } ) 
        borderRight:setFillColor( 0, 0, 0 ) 
        selfL:insert(borderRight)
		
	end
	
	function blockMenu( event )
		return true
	end
	
	return selfL
	
end

function MenuRight:new()
	
	local intW = display.contentWidth
	local intH = display.contentHeight
	local h = display.topStatusBarContentHeight

	local selfR = display.newGroup()
	
	selfR.x = 520
	
	function selfR:builScreenRight()
		
		local bgMenuRight = display.newRect( display.contentCenterX, display.contentCenterY + h, intW, intH )
		bgMenuRight:setFillColor( 1 )
		bgMenuRight.alpha = .2
		bgMenuRight:addEventListener("tap",hideMenuRight)
		bgMenuRight:addEventListener("touch",blockMenu)
		selfR:insert(bgMenuRight)
		
		local MenuRight = display.newRect( 280, display.contentCenterY + h, 400, intH )
		MenuRight:setFillColor( .92 )
		MenuRight.alpha = 1
		MenuRight:addEventListener("tap",blockMenu)
		MenuRight:addEventListener("touch",blockMenu)
		selfR:insert(MenuRight)
		
		createMenuRight()
		
	end
	
	function createMenuRight()
		local MenuLeftOthers = display.newRect( 280, h + 30 , 400, 60 )
		MenuLeftOthers:setFillColor( .66 )
		MenuLeftOthers.alpha = 1
		MenuLeftOthers:addEventListener("tap",blockMenu)
		MenuLeftOthers:addEventListener("touch",blockMenu)
		selfR:insert(MenuLeftOthers)
        
        titleR = display.newText( {    
            x = 290, y = h + 30, align = "left", width = 300,
            text = "Opciónes",  font = "Lato-Light", fontSize = 25,
        })
        titleR:setFillColor( 1 )
        selfR:insert(titleR)
		
		-- tutorial
		local rectTutorial = display.newRect(  280, 90 + h, 400, 60 )
        rectTutorial:setFillColor( .5 )
		rectTutorial.alpha = .1
		rectTutorial:addEventListener( "tap", showTutorial )
		selfR:insert(rectTutorial)
        
        local icoMenuTuto = display.newImage( "img/btn/icoOptTuto.png" )
        icoMenuTuto:translate( 160, MenuLeftOthers.height + 30 + h)
        selfR:insert(icoMenuTuto)
		
		local txtTutorial = display.newText( {    
            x = 300, y = MenuLeftOthers.height + 30 + h, align = "left", width = 200,
            text = "Tutorial",  font = "Lato-Light", fontSize = 25,
		})
		txtTutorial:setFillColor( 0 )
		selfR:insert(txtTutorial)
		
		local line1 = display.newLine(80, 120 + h, 480, 120 + h)
		selfR:insert(line1)
		
		-- Cerrar session
		local rectSession = display.newRect(  280, 150 + h, 400, 60 )
        rectSession:setFillColor( .5 )
		rectSession.alpha = .1
		--rectSession:addEventListener( "tap", cerrarSession )
		selfR:insert(rectSession)
        
        local icoMenuSess = display.newImage( "img/btn/icoOptSess.png" )
        icoMenuSess:translate( 160, MenuLeftOthers.height + 90 + h)
        selfR:insert(icoMenuSess)
		
		local txtSession = display.newText( {    
            x = 300, y = MenuLeftOthers.height + 90 + h, align = "left", width = 200,
            text = "Cerrar sesión",  font = "Lato-Light", fontSize = 25,
		})
		txtSession:setFillColor( 0 )
		selfR:insert(txtSession)
		
		local line2 = display.newLine(80, 180 + h, 480, 180 + h)
		selfR:insert(line2)
				
		-- Border Right
        local borderRight = display.newRect( 80, intH / 2, 4, intH )
        borderRight:setFillColor( {
            type = 'gradient',
            color1 = { .1, .1, .1, .7 }, 
            color2 = { .4, .4, .4, .2 },
            direction = "right"
        } ) 
        borderRight:setFillColor( 0, 0, 0 )
        selfR:insert(borderRight)
	end
	
	function blockMenu( event )
		return true
	end
	
	return selfR
	
end



