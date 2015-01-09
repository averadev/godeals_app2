	function loadAllEvents(items)
	Globals.Items = items
    titleLoading.text = "Descargando imagenes..."
    for y = 1, #Globals.Items, 1 do 
        Globals.Items[y].callback = noCallback
    end
	local encabezadoEventos = display.newRect( 0, 0, display.contentWidth, 20 )
	encabezadoEventos.anchorX = 0
	encabezadoEventos.anchorY = 0
	encabezadoEventos:setFillColor( 1 )	-- red
	scrollViewContent2:insert(encabezadoEventos)
	lastY = 0
    loadImageAllEvent(1)
	scrollViewContent2:setScrollHeight(  lastY + 150 )
	
end

function loadImageAllEvent(posc)
    -- Listener loading
    if not (Globals.Items[posc].image == nil) then
        local function networkListenerEvent( event )
            -- Verificamos el callback activo
            if #Globals.Items <  posc then 
                if not ( event.isError ) then
                    destroyImage(event.target)
                end
            elseif Globals.Items[posc].callback == noCallback then
			
                if ( event.isError ) then
                    native.showAlert( "Go Deals", "Network error :(", { "OK"})
                else
                    event.target.alpha = 0
                    imageItems[posc] = event.target
                    if posc < #Globals.Items and posc <= (noPackage * 10) then
                        loadImageAllEvent(posc + 1)
                    else
                        buildItemsAllEvent()
                    end
                end
            elseif not ( event.isError ) then
                destroyImage(event.target)
            end
        end
        -- Do call image
        Globals.Items[posc].idCupon = Globals.Items[posc].id
        Globals.Items[posc].id = posc
        local path = system.pathForFile( Globals.Items[posc].image, system.TemporaryDirectory )
        local fhd = io.open( path )
        -- Determine if file exists
        if fhd then
            fhd:close()
            imageItems[posc] = display.newImage( Globals.Items[posc].image, system.TemporaryDirectory )
			
            if Globals.Items[posc].callback == noCallback then
                imageItems[posc].alpha = 0
                if posc < #Globals.Items and posc <= (noPackage * 10) then
                    loadImageAllEvent(posc + 1)
                else
                    buildItemsAllEvent()
                end
            else
                destroyImage(imageItems[posc])
            end
        else
           display.loadRemoteImage( 'http://localhost:8080/godeals/assets/img/app/event/app/'..Globals.Items[posc].image, 
            "GET", networkListenerEvent, Globals.Items[posc].image, system.TemporaryDirectory ) 
        end
    else
        loadImageAllEvent(posc + 1)
    end
end

function buildItemsAllEvent()
    -- Stop loading sprite
	
    if noPackage == 1 then
        loading:setSequence("stop")
        loadingGrp.alpha = 0
    else
        events[#events]:removeSelf()
        events[#events] = nil
    end
    -- Build items
    local z = (noPackage * 10) - 9
    while z <= #Globals.Items and z <= (noPackage * 10) do
        -- Armar eventos
            setStdAllEvent(Globals.Items[z]) 
        z = z + 1
    end
    
    -- Validate Loading
    if  #Globals.Items > (noPackage * 10) then
        -- Create Loading
        events[#events + 1] = display.newContainer( 444, 150 )
        events[#events].x = midW
        events[#events].y = lastY + 60
        grupoScroll2:insert( events[#events] )
        
        -- Sprite and text
        local sheet = graphics.newImageSheet(Sprites.loading.source, Sprites.loading.frames)
        local loadingBottom = display.newSprite(sheet, Sprites.loading.sequences)
        loadingBottom.y = -10
        events[#events]:insert(loadingBottom)
        loadingBottom:setSequence("play")
        loadingBottom:play()
        local title = display.newText( "Cargando, por favor espere...", 0, 30, "Chivo", 16)
        title:setFillColor( .3, .3, .3 )
        events[#events]:insert(title) 
        
        -- Call new images
        noPackage = noPackage + 1
        loadImageAllEvent((noPackage * 10) - 9)
    else
        if navGrp.alpha == 1 then
            lastY = lastY + 70
        end
        
        -- Create Space
        events[#events + 1] = display.newContainer( 444, 40 )
        events[#events].x = midW
        events[#events].y = lastY + 40
        grupoScroll2:insert( events[#events] )
    end
end

-- Genera un cupon estandar
function setStdAllEvent(obj)
	
	---- sacamos la fecha
	
	local fecha = ""
	
	s = obj.date
	for k, v, u in string.gmatch(s, "(%w+)-(%w+)-(%w+)") do
		
		if v == "1" then
			fecha = u .. " de Enero de " .. k 
			tituloFecha = "Enero"
		elseif v == "2" then
			fecha = u .. " de Febrero de " .. k 
			tituloFecha = "Febrero"
		elseif v == "3" then
			fecha = u .. " de Marzo de " .. k  
			tituloFecha = "Marzo"
		elseif v == "4" then
			fecha = u .. " de Abril de " .. k
			tituloFecha = "Abril"
		elseif v == "5" then
			fecha = u .. " de Mayo de " .. k  
			tituloFecha = "Mayo"
		elseif v == "6" then
			fecha = u .. " de Junio de " .. k
			tituloFecha = "Junio"
		elseif v == "7" then
			fecha = u .. " de Julio de " .. k 
			tituloFecha = "Julio"
		elseif v == "8" then
			fecha = u .. " de Agosto de " .. k
			tituloFecha = "Agosto"
		elseif v == "9" then
			fecha = u .. " de Septiembre de " .. k 
			tituloFecha = "Septiembre"
		elseif v == "10" then
			fecha = u .. " de Octubre de " .. k
			tituloFecha = "Octubre"
			if contadorMes[10] == 0 then
				contadorMes[10] = 1
				contadorFecha = 1
			end
		elseif v == "11" then
			fecha = u .. " de Noviembre de " .. k
			tituloFecha = "Noviembre"
			if contadorMes[11] == 0 then
				contadorMes[11] = 1
				contadorFecha = 1
			end
		elseif v == "12" then
			fecha = u .. " de Diciembre de " .. k
			tituloFecha = "Diciembre"
			if contadorMes[12] == 0 then
				contadorMes[12] = 1
				contadorFecha = 1
			end
		end
		
	end
   
   -----
	
	if contadorFecha == 1 then
	
		lastY = lastY + 70
		local textTituloFecha = display.newText( {
					text = tituloFecha,     
					x = 270,
					y = lastY,
					width = intW,
					height =60,
					font = "Chivo-Black",   
					fontSize = 25,
					align = "left"
				})
				textTituloFecha:setFillColor( 0 )
				grupoScroll2:insert(textTituloFecha)
				contadorFecha = 0
		
   end

    -- Obtiene el total de cupones de la tabla y agrega uno
    local lastC = #events + 1
    -- Generamos contenedor
    events[lastC] = display.newContainer( 450, 100 )
    events[lastC].index = lastC
    events[lastC].x = 255
    events[lastC].type = 2
    events[lastC].y = lastY + 60
    grupoScroll2:insert( events[lastC] )
    events[lastC]:addEventListener( "tap", showCoupon )
    
    -- Agregamos rectangulo alfa al pie
    local maxShape = display.newRect( 0, 0, 480, 100 )
    maxShape:setFillColor( 1 )
    events[lastC]:insert( maxShape )
    
    -- Agregamos imagen
    imageItems[obj.id].alpha = 1
    imageItems[obj.id].index = lastC
    imageItems[obj.id].x= -175
    imageItems[obj.id].width = 80
    imageItems[obj.id].height  = 55
    events[lastC]:insert( imageItems[obj.id] )
    
    -- Agregamos textos
    local txtTitle = display.newText( {
        text = obj.name,     
        x = 25,
        y = -10,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 24,
        align = "left"
    })
    txtTitle:setFillColor( 0 )
    events[lastC]:insert(txtTitle)
	
	local txtDate = display.newText( {
        text = fecha,     
        x = 25,
        y = 20,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 18,
        align = "left"
    })
    txtDate:setFillColor( 146/255, 146/255, 146/255)
    events[lastC]:insert(txtDate)
	
	local txtPlace = display.newText( {
        text = obj.place,     
        x = 25,
        y = 40,
        width = 300,
        height =60,
        font = "Chivo",   
        fontSize = 18,
        align = "left"
    })
    txtPlace:setFillColor( 146/255, 146/255, 146/255)
    events[lastC]:insert(txtPlace)
    
    -- Agregamos linea negra al pie
    grupoScroll2:insert( events[lastC] )
    
    -- Guardamos la ultima posicion
    lastY = lastY + 102
    
end