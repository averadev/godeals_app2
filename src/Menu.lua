MenuLeft = {}
MenuRight = {}

function MenuLeft:new()

	local RestManager = require('src.resources.RestManager')
	
	local intW = display.contentWidth
	local intH = display.contentHeight
	local h = display.topStatusBarContentHeight
	local rectCancun, rectPlaya
	local lineLeft = {}

	local selfL = display.newGroup()
	
	selfL.x = -480
	
	function selfL:builScreenLeft()
		
		local bgMenuLeft = display.newRect( display.contentCenterX, display.contentCenterY + h, intW, intH )
		bgMenuLeft:setFillColor( 1 )
		bgMenuLeft.alpha = .2
		bgMenuLeft:addEventListener("tap",hideMenuLeft)
		bgMenuLeft:addEventListener("touch",blockMenu)
		selfL:insert(bgMenuLeft)
		
		local MenuLeft = display.newRect( display.contentCenterX - 80, display.contentCenterY + h, 400, intH )
		MenuLeft:setFillColor( .92, .92, .92 )
		MenuLeft.alpha = 1
		MenuLeft:addEventListener("tap",blockMenu)
		MenuLeft:addEventListener("touch",blockMenu)
		selfL:insert(MenuLeft)
		
		RestManager.getCity()
		
	end
	
	function createMenuLeft(items)
	
		local lastY = 90
	
		local rectCity = {}
		
		local MenuLeftCiudad = display.newRect( display.contentCenterX - 80, h + 30 , 400, 60 )
		MenuLeftCiudad:setFillColor( .66 )
		MenuLeftCiudad.alpha = 1
		MenuLeftCiudad:addEventListener("tap",blockMenu)
		MenuLeftCiudad:addEventListener("touch",blockMenu)
		selfL:insert(MenuLeftCiudad)
        
        titleLeft = display.newText( {    
            x = 150, y = h + 30, align = "left", width = 300,
            text = "Seleccione una Ciudad",  font = "Lato-Light", fontSize = 25,
        })
        titleLeft:setFillColor( 1 )
        selfL:insert(titleLeft)
		
		local function changeCity( event )
			hideMenuLeft()
			local t = event.target
			t.alpha = 1
			transition.to( t, { alpha = .1, time = 200, transition = easing.outExpo } )
			changeCityName(event.target)
		end
		
		--creamos los botones del menu
		
		for y = 1, #items, 1 do
			rectCity[y] = display.newRect(  display.contentCenterX - 80, lastY + h, 400, 60 )
			rectCity[y]:setFillColor( .5 )
			rectCity[y].alpha = .1
			rectCity[y].txtMin = items[y].name
			rectCity[y].id = items[y].idCity
			rectCity[y]:addEventListener( "tap", changeCity )
			selfL:insert(rectCity[y])
            
            local icoMenuCity = display.newImage( "img/btn/icoMenuCity.png" )
            icoMenuCity:translate( 25, MenuLeftCiudad.height + lastY - 60 + h)
            selfL:insert(icoMenuCity)
			
			txtCity = display.newText( {    
			x = 165, y = MenuLeftCiudad.height + lastY - 60 + h, align = "left", width = 220,
			text = items[y].name,  font = "Lato-Light", fontSize = 25,
			})
			txtCity:setFillColor( 0 )
			selfL:insert(txtCity)
			
			lineLeft[y] = display.newLine(-40, lastY + 30 + h, 360, lastY + 30 + h)
			selfL:insert(lineLeft[y])
			
			lastY = lastY + 60
		end
		
		-- Border Right
        local borderRight = display.newRect( 358, intH / 2, 4, intH )
        borderRight:setFillColor( {
            type = 'gradient',
            color1 = { .1, .1, .1, .7 }, 
            color2 = { .4, .4, .4, .2 },
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
		
		local function cerrarSession( event )
			hideMenuRight()
			logout()
		end
		
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
		rectSession:addEventListener( "tap", cerrarSession )
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



