MenuLeft = {}
MenuRight = {}

function MenuLeft:new()
	
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
		
		createMenuLeft()
		
	end
	
	function createMenuLeft()
		
		local MenuLeftCiudad = display.newRect( display.contentCenterX - 80, h + 30 , 400, 60 )
		MenuLeftCiudad:setFillColor( .66 )
		MenuLeftCiudad.alpha = 1
		MenuLeftCiudad:addEventListener("tap",blockMenu)
		MenuLeftCiudad:addEventListener("touch",blockMenu)
		selfL:insert(MenuLeftCiudad)
		
		local function changeCity( event )
			hideMenuLeft()
			local t = event.target
			t.alpha = 1
			transition.to( t, { alpha = .1, time = 200, transition = easing.outExpo } )
			changeCityName(t.txtMin)
		end
		
		-- Cancun
		local rectCancun = display.newRect(  display.contentCenterX - 80, 90 + h, 400, 60 )
        rectCancun:setFillColor( .5 )
		rectCancun.alpha = .1
		rectCancun.txtMin = "CANCUN"
		rectCancun:addEventListener( "tap", changeCity )
		selfL:insert(rectCancun)
		
		local txtCancun = display.newText( {    
        x = 150, y = MenuLeftCiudad.height + 35 + h, align = "left", width = 300,
        text = "Cancun",  font = "Lato-Light", fontSize = 25,
		})
		txtCancun:setFillColor( 0 )
		selfL:insert(txtCancun)
		
		lineLeft[1] = display.newLine(-40, 120 + h, 360, 120 + h)
		selfL:insert(lineLeft[1])
		
		-- Playa
		local rectPlaya = display.newRect(  display.contentCenterX - 80, 150 + h, 400, 60 )
        rectPlaya:setFillColor( .5 )
		rectPlaya.alpha = .1
		rectPlaya.txtMin = "PLAYA"
		rectPlaya:addEventListener( "tap", changeCity )
		selfL:insert(rectPlaya)
		
		local txtPlaya = display.newText( {    
        x = 150, y = MenuLeftCiudad.height + 95 + h, align = "left", width = 300,
        text = "Playa del Carmen",  font = "Lato-Light", fontSize = 25,
		})
		txtPlaya:setFillColor( 0 )
		selfL:insert(txtPlaya)
		
		lineLeft[2] = display.newLine(-40, 180 + h, 360, 180 + h)
		selfL:insert(lineLeft[2])
		
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
		local MenuLeftCiudad = display.newRect( 280, h + 30 , 400, 60 )
		MenuLeftCiudad:setFillColor( .66 )
		MenuLeftCiudad.alpha = 1
		MenuLeftCiudad:addEventListener("tap",blockMenu)
		MenuLeftCiudad:addEventListener("touch",blockMenu)
		selfR:insert(MenuLeftCiudad)
		
		local function cerrarSession( event )
			saveBeacon()
			hideMenuRight()
		end
		
		-- Cerrar session
		local rectCancun = display.newRect(  280, 90 + h, 400, 60 )
        rectCancun:setFillColor( .5 )
		rectCancun.alpha = .1
		rectCancun.txtMin = "CANCUN"
		rectCancun:addEventListener( "tap", cerrarSession )
		selfR:insert(rectCancun)
		
		local txtCancun = display.newText( {    
        x = 290, y = MenuLeftCiudad.height + 35 + h, align = "left", width = 300,
        text = "Cerrar sessión",  font = "Lato-Light", fontSize = 25,
		})
		txtCancun:setFillColor( 0 )
		selfR:insert(txtCancun)
		
		local line1 = display.newLine(80, 120 + h, 480, 120 + h)
		selfR:insert(line1)
				
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


