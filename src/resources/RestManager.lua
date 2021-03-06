--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
	local DBManager = require('src.resources.DBManager')
    local Globals = require('src.resources.Globals')
	local OneSignal = require("plugin.OneSignal")
	
	local settings = DBManager.getSettings()
	local leng = settings.language
	
	local playerId = "a"
	
	function getPlayerId()
	
		--native.showAlert( "Go Deals 1", 'hola', { "OK"})
	
		
		local function IdsAvailable(playerID, pushToken)
			--print("PLAYER_ID:" .. playerID)
			playerId = playerID
			native.showAlert( "Go Deals 1", playerID, { "OK"})
		end
	
		OneSignal.IdsAvailableCallback(IdsAvailable)
	end
	
	function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end
	
	RestManager.getRecommended = function()
		
		settings = DBManager.getSettings()
		local url = settings.url .. "api/getRecommended/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city .. "/language/" .. leng
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success and #data.items > 0 then
                    setElements(data.items)
					loadImageLogos({posc = 1, screen = 'MainScreen'})
				else
					getNoItemsHome('home')
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getMyDeals = function()
	
		settings = DBManager.getSettings()
		
		local url = settings.url .. "api/getMyDeals/format/json/idApp/" .. settings.idApp .. "/language/" .. leng
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setWalletElements({items = data.items, screen = "noRedimir", posc = 1, path = 'assets/img/app/deal/'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getAllEvent = function()
		settings = DBManager.getSettings()
		local url = settings.url .. "api/getAllEvent/format/json/idApp/" .. settings.idApp  .. "/language/" .. leng
		
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					if #data.items > 0 then
						setElements(data.items)
						setFilterEvent(data.filter)
						loadImage({posc = 1, screen = 'EventPanel'})
					else
						getNoItemsHome('events')
					end
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getAllCoupon = function()
		settings = DBManager.getSettings()
		local url = settings.url .. "api/getAllDeal/format/json/idApp/" .. settings.idApp .. "/language/" .. leng
	    local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					if #data.items > 0 then
						setElements(data.items)
						setFilterDeals(data.filter)
						loadImage({posc = 1, screen = 'DealPanel'})
					else
						getNoItemsHome('deals')
					end
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

	RestManager.redemptionDeal = function(code)
		settings = DBManager.getSettings()
		local url = settings.url .. "api/redemptionDeal/format/json/code/" .. code
        -- Do request
        network.request( url, "GET", callback )
	end

	RestManager.initApp = function(idBeacon, fecha)
		settings = DBManager.getSettings()
		local url = settings.url .. "api/initApp/format/json/idApp/" .. settings.idApp
        -- Do request
        network.request( url, "GET", callback )
	end

	RestManager.initPlayerId= function()
		settings = DBManager.getSettings()
		local url = settings.url .. "api/initPlayerId/format/json/idApp/" .. settings.idApp
		url = url.."/playerId/" .. urlencode(Globals.playerIdToken)
        -- Do request
        network.request( url, "GET", callback )
	end
	
    RestManager.lealtad = function(idBeacon, fecha)
		settings = DBManager.getSettings()
		local url = settings.url .. "api/lealtadIOS/format/json/idApp/" .. settings.idApp .. "/idBeacon/".. idBeacon .. "/fecha/".. fecha
        -- Do request
        network.request( url, "GET", callback )
	end

	RestManager.getAdPartner = function(idAd)
		settings = DBManager.getSettings()
		local url = settings.url .. "api/getAdPartner/format/json/idAd/" .. idAd .. "/language/" .. leng
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    showAdd(data.items[1])
                else
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

	RestManager.getPartner = function(idPartner)
		settings = DBManager.getSettings()
		local url = settings.url .. "api/getPartnertById/format/json/idPartner/" .. idPartner .. "/language/" .. leng
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    loadPartner(data.items[1])
                else
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getPartnerList = function()
		settings = DBManager.getSettings()
        local url = settings.url .. "api/getPartnerList/format/json/idApp/" .. settings.idApp .. "/language/" .. leng

        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                setPartnerList(data.items)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getBeacons = function() --falta
		settings = DBManager.getSettings()
        local url = settings.url .. "api/getBeacons/format/json/" .. "/language/" .. leng
		
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                DBManager.saveBeacons(data.items)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getComerciosGPS = function()
		settings = DBManager.getSettings()
        local url = settings.url .. "api/getComerciosGPS/format/json/idApp/" .. settings.idApp .. "/language/" .. leng

        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                setComerciosGPS(data.items)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getDealsByPartner = function(idPartner,typeInfo)
		settings = DBManager.getSettings()
		local url = settings.url .. "api/getDealsByPartner/format/json/idApp/" .. settings.idApp .. "/idPartner/" .. idPartner .. "/language/" .. leng
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					if typeInfo == "event" then
						buildEventPromociones(data.items)
					else
						buildPartnerPromociones(data.items)
					end
                else
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getGallery = function(idPartner,typeGallery,typeInfo)
		settings = DBManager.getSettings()
		local url = settings.url .. "api/getGallery/format/json/idPartner/" .. idPartner .. "/type/" .. typeGallery
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					if typeInfo == "partner" then
						GalleryPartner(data.items)
					else
						GalleryEvent(data.items)
					end
                else
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	-- obtenemos cupon por id
	
	RestManager.getCouponById = function(idCoupon)
		settings = DBManager.getSettings()
		local url = settings.url .. "api/getCouponById/format/json/idCoupon/" .. idCoupon .. "/language/" .. leng
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					if #data.items then
						setCouponId(data.items[1])
					end
                else
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	--crear usuarios
	
	RestManager.createUser = function(email, password, name, fbId, birthday, mac)
	
		--native.showAlert( "Go Deals", Globals.playerIdToken, { "OK"})
		
		if birthday == "" then
			birthday = " "
		end
		
		if name == "" then
			name = " "
		end
		
		if fbId == " " then
			fbId = urlencode(fbId)
		end
		
		settings = DBManager.getSettings()
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/createUser/format/json"
        url = url.."/email/"..urlencode(email)
        url = url.."/password/"..password
        url = url.."/name/"..urlencode(name)
        url = url.."/fbId/"..fbId
		url = url.."/birthday/"..urlencode(birthday)
		--url = url.."/mac/"..mac
		--url = url.."/idDevice/" .. idDeviceIOS
		url = url.."/language/" .. leng
		url = url.."/playerId/" .. urlencode(Globals.playerIdToken)
		
		local platformName = system.getInfo( "platformName" )
		local idDeviceIOS = ""
		if platformName == "iPhone OS" then
			idDeviceIOS = system.getInfo( "deviceID" )
			url = url.."/idDevice/" .. idDeviceIOS
		else
			url = url.."/mac/"..mac
		end
		print(url)
        
        local function callback(event)
            if ( event.isError ) then
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
                if data.success then
					if fbId == "%20" then
						fbId = ""
					end
                    DBManager.updateUser(data.idApp, email, password, name, fbId)
                    if data.cityId then
						DBManager.updateCity(data.cityId)
					end
                    gotoHome()
                else
                    native.showAlert( "Go Deals", data.message, { "OK" })
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	RestManager.validateUser = function(email, password, mac)
	
		--native.showAlert( "Go Deals", mac, { "OK"})
		
		--print(mac .. 'aaaaa')
	
        local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/validateUser/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/email/"..urlencode(email)
        url = url.."/password/"..password
		--url = url.."/mac/".. mac
		--url = url.."/idDevice/" .. idDeviceIOS
		url = url.."/language/" .. leng
		url = url.."/playerId/" .. urlencode(Globals.playerIdToken)
		
		local platformName = system.getInfo( "platformName" )
		local idDeviceIOS = ""
		if platformName == "iPhone OS" then
			idDeviceIOS = system.getInfo( "deviceID" )
			url = url.."/idDevice/" .. idDeviceIOS
		else
			url = url.."/mac/".. mac
		end
		
		
    
        local function callback(event)
            if ( event.isError ) then
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
                if data.success then
					DBManager.updateUser(data.items[1].id, data.items[1].email, data.items[1].password, data.items[1].name, '')
                    gotoHome()
                else
                    native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	RestManager.updatePlayerId = function()
		--print(mac .. 'aaaaa')
	
        local settings = DBManager.getSettings()
        -- Set url
        local url = settings.url
        url = url.."api/updatePlayerId/format/json"
        url = url.."/idApp/"..settings.idApp
    
        local function callback(event)
            if ( event.isError ) then
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
                if data.success then
					DBManager.clearUser()
                else
                    native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	--pensar en un nombre para el metodo
	RestManager.couponDowload = function(email, password)
		settings = DBManager.getSettings()
        local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/validateUser/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/email/"..urlencode(email)
        url = url.."/password/"..password
		url = url.."/language/" .. leng
    
        local function callback(event)
            if ( event.isError ) then
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
                if data.success then
                    gotoHome()
                else
                    native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback ) 
    end
	
	RestManager.downloadCoupon = function(idCoupon)
		settings = DBManager.getSettings()
		local settings = DBManager.getSettings()
        local url = settings.url
        url = url.."api/discountCoupon/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/idCoupon/"..idCoupon
		url = url.."/language/" .. leng
    
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.useCoupon = function(idCoupon)
		settings = DBManager.getSettings()
		local settings = DBManager.getSettings()
        local url = settings.url
        url = url.."api/useCoupon/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/idCoupon/"..idCoupon
		url = url.."/language/" .. leng
        
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.discountCoupon = function(idCoupon)
		settings = DBManager.getSettings()
	
		local settings = DBManager.getSettings()
        local url = settings.url
        url = url.."api/discountCoupon/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/idCoupon/"..idCoupon
		url = url.."/language/" .. leng
    
        local function callback(event)
            if ( event.isError ) then
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
                if data.success then
					changeButtonCoupon()
                else
                    native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	-- se obtiene el total de notificaciones no leidas
	
	RestManager.getNotificationsUnRead = function()
		settings = DBManager.getSettings()
		
		local url = settings.url
        url = url.."api/getNotificationsUnRead/format/json"
        url = url.."/idApp/"..settings.idApp .. "/language/" .. leng
        
        local function callback(event)
            if ( event.isError ) then
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
                if data.success then
					if data.items > 0 then
						createNotBubble(data.items)
					else
						createNotBubble(0)
					end
                else
                    native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	RestManager.getNotifications = function()
		settings = DBManager.getSettings()
		
		local url = settings.url
        url = url.."api/getNotifications/format/json"
        url = url.."/idApp/"..settings.idApp
		url = url.."/language/" .. leng
		
        
        local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					setNotificationsElements(data.items)
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	---marca la notificacion como leida
	
	RestManager.notificationRead = function(idNotification)
		settings = DBManager.getSettings()
		
		local url = settings.url
        url = url.."api/notificationRead/format/json"
        url = url.."/idNotification/"..idNotification
    
        local function callback(event)
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
		
	end
	
	-- obtiene los eventos de la busqueda
	
	RestManager.getSearchEvent = function(text)
		settings = DBManager.getSettings()
		
		local url = settings.url
        url = url.."api/getSearchEvent/format/json"
		url = url.."/texto/"..text
        url = url.."/idApp/"..settings.idApp
		url = url.. "/language/" .. leng
		
    
        local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					if #data.items > 0 then
                    setSearchElements(data.items)
					loadSearchImage({posc = 1,path = "assets/img/app/event/",screen = "event"})
					else
						RestManager.getSearchCoupon(text)
					end
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	--obtiene los deals de la busqueda
	RestManager.getSearchCoupon = function(text)
		settings = DBManager.getSettings()
		
		local url = settings.url
        url = url.."api/getSearchCoupon/format/json/"
		url = url.."/texto/"..text
        url = url.."/idApp/"..settings.idApp
		url = url.. "/language/" .. leng
    
        local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					if #data.items > 0 then
						setSearchElements(data.items)
						loadSearchImage({posc = 1,path = "assets/img/app/deal/",screen = "deal"})
					else
						noSearchFind()
					end
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	--obtiene si el cupon esta descargado
	RestManager.getCouponDownload = function(idCoupon)
		settings = DBManager.getSettings()
		
		local url = settings.url
        url = url.."api/getCouponDownload/format/json"
		url = url.."/idApp/"..settings.idApp
		url = url.."/idCoupon/"..idCoupon
        local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    AssignedCoupon(data.items)
                else
					createCoupon()
				end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	--obtiene las ciudades
	RestManager.getCity = function()
		settings = DBManager.getSettings()
		
		local url = settings.url
        url = url.."api/getCity/format/json"
        
        local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    createMenuLeft(data.items)
				end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	--obtiene la ciudad
	RestManager.getCityById = function()
		settings = DBManager.getSettings()
		
		local url = settings.url
        url = url.."api/getCityById/format/json/city/" .. settings.city
        local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					changeTxtcity(data.items[1].name)
				end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	--obtiene los eventos o deals del filtro 
	RestManager.getFilter = function(idFilter,typeF)
		settings = DBManager.getSettings()
		
		local screen = ""
		if typeF == "EVENTOS" then
			typeF = 1
			screen = "FilterEvent"
			
		else
			typeF = 2
			screen = "DealPanel"
		end
		
		local url = settings.url
        url = url.."api/getFilter/format/json/idApp/" .. settings.idApp .. "/idFilter/" .. idFilter .. "/type/" .. typeF .. "/language/" .. leng
		
        if typeF == 1 and idFilter == 0 then
			--url = settings.url .. "api/getAllEvent/format/json/idApp/" .. settings.idApp .. "/language/" .. leng
			url = settings.url .. "api/getAllEvent/format/json/idApp/" .. settings.idApp  .. "/language/" .. leng
		elseif not (typeF == 1) and idFilter == 6 then
			url = settings.url .. "api/getAllDeal/format/json/idApp/" .. settings.idApp .. "/language/" .. leng
		end
		
        local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					if #data.items > 0 then
						setElements(data.items)
						loadImage({posc = 1, screen = screen})
					else
						if typeF == 1 then
							buildItems("noFilterEvent")
						else 
							buildItems("noFilterCoupon")
						end
					end
				end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getDealsRedimir = function()
		settings = DBManager.getSettings()
		
		local url = settings.url .. "api/getDealsRedimir/format/json/idApp/" .. settings.idApp
		url = url.. "/language/" .. leng
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setWalletElements({items = data.items, screen = "redimir", posc = 1, path = 'assets/img/app/deal/'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	--comparte el deals por face
	RestManager.shareDealsByFace = function(idFriend, idCoupon)
		settings = DBManager.getSettings()
		
		local url = settings.url .. "api/shareDealsByFace/format/json/idApp/" .. settings.idApp .. "/idFriend/" .. idFriend .. "/idCoupon/" .. idCoupon
		url = url.. "/language/" .. leng
		local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.share then
                    isFBShared()
                else
                    native.showAlert( "Go Deals", data.message, { "OK" })
                end
            end
            return true
		end
		-- Do request
		network.request( url, "GET", callback )
	end
	
	--comparte el deals por email
	RestManager.shareDealsByEmail = function(email, idCoupon)
		settings = DBManager.getSettings()
		
		local url = settings.url .. "api/shareDealsByEmail/format/json/idApp/" .. settings.idApp .. "/email/" .. urlencode(email) .. "/idCoupon/" .. idCoupon
	    url = url.. "/language/" .. leng
		local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.share then
                   isFBShared()
                else
                    native.showAlert( "Go Deals", data.message, { "OK" })
                end
            end
            return true
		end
		-- Do request
		network.request( url, "GET", callback )
	end
	
	--Redime el codigo especial
	RestManager.redeemCodePromoter = function(code)
		settings = DBManager.getSettings()
		
		local url = settings.url .. "api/redeemCodePromoter/format/json/idApp/" .. settings.idApp  .. "/language/" .. leng .. "/code/" .. urlencode(code)
		local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
				if data.success == true then
					showDealsRedeem(data.itemCoupon)
				else
					--native.showAlert( "Go Deals", data.message, { "OK" })
					showTextErrorCode(data.message)
				end
            end
            return true
		end
		-- Do request
		network.request( url, "GET", callback )
	end
	
	--Cambia la ciudad del usuario
	RestManager.changeUserCity = function(idCity)
		settings = DBManager.getSettings()
		
		local url = settings.url .. "api/updateUserCity/format/json/idApp/" .. settings.idApp  .. "/cityId/"  .. idCity
		local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
				if data.success == true then
				else
					--native.showAlert( "Go Deals", data.message, { "OK" })
				end
            end
            return true
		end
		-- Do request
		network.request( url, "GET", callback )
	end
	
	RestManager.changeLanguageManager = function()
		settings = DBManager.getSettings()
		leng = settings.language
	end
	
	RestManager.changeLanguageAds = function()
		settings = DBManager.getSettings()
        local url = settings.url .. "api/getBeacons/format/json/" .. "/language/" .. leng
		
        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                DBManager.updateBeaconsMSG(data.items)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getMessage = function(idMessage)
		settings = DBManager.getSettings()
		local url = settings.url .. "api/getMessageById/format/json/idApp/" .. settings.idApp  .. "/idMessage/" .. idMessage .. "/language/" .. leng
	   
		local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					setElementsMessage(data.items[1])
					BuildItemsMessage()
                else
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
--getPlayerId()	
	
return RestManager