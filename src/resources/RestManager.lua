--Include sqlite
local RestManager = {}

	local mime = require("mime")
	local json = require("json")
	local crypto = require("crypto")
	local DBManager = require('src.resources.DBManager')
    local Globals = require('src.resources.Globals')
	local settings = DBManager.getSettings()
	
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
		local url = settings.url .. "api/getRecommended/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
	   print(url)
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setElements(data.items)
					loadImageLogos({posc = 1, screen = 'MainScreen'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getMyDeals = function()
	
		settings = DBManager.getSettings()
		
		local url = settings.url .. "api/getMyDeals/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
	   
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
		local url = settings.url .. "api/getAllEvent/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
		
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success and #data.items > 0 then
                    setElements(data.items)
					setFilterEvent(data.filter)
					loadImage({posc = 1, screen = 'EventPanel'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getAllCoupon = function()
		settings = DBManager.getSettings()
		local url = settings.url .. "api/getAllDeal/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
        print(url)
	    local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setElements(data.items)
					setFilterDeals(data.filter)
					loadImage({posc = 1, screen = 'DealPanel'})
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
        print(url)
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
		local url = settings.url .. "api/getAdPartner/format/json/idAd/" .. idAd
	   
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
		local url = settings.url .. "api/getPartnertById/format/json/idPartner/" .. idPartner
	   
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
        local url = settings.url .. "api/getPartnerList/format/json/idApp/" .. settings.idApp

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

    RestManager.getBeacons = function()
		settings = DBManager.getSettings()
        local url = settings.url .. "api/getBeacons/format/json"

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
        local url = settings.url .. "api/getComerciosGPS/format/json/idApp/" .. settings.idApp

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
		local url = settings.url .. "api/getDealsByPartner/format/json/idApp/" .. settings.idApp .. "/idPartner/" .. idPartner .. "/city/" .. settings.city
	   
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
		local url = settings.url .. "api/getCouponById/format/json/idCoupon/" .. idCoupon
	   print(url)
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
        --local settings = DBManager.getSettings()
        -- Set url
		
		settings = DBManager.getSettings()
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/createUser/format/json"
        url = url.."/email/"..urlencode(email)
        url = url.."/password/"..password
        url = url.."/name/"..urlencode(name)
        url = url.."/fbId/"..fbId
		url = url.."/birthday/"..urlencode(birthday)
		url = url.."/mac/"..mac
        
        local function callback(event)
            if ( event.isError ) then
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
                if data.success then
                    DBManager.updateUser(data.idApp, email, password, name, fbId)
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
	
	RestManager.validateUser = function(email, password)
        local settings = DBManager.getSettings()
        -- Set url
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/validateUser/format/json"
        url = url.."/idApp/"..settings.idApp
        url = url.."/email/"..urlencode(email)
        url = url.."/password/"..password
    
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
        url = url.."/idApp/"..settings.idApp
        
        local function callback(event)
            if ( event.isError ) then
            else
                --hideLoadLogin()
                local data = json.decode(event.response)
                if data.success then
					if data.items > 0 then
						createNotBubble(data.items)
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
		url = url.."/city/"..settings.city
    
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
        url = url.."api/getSearchCoupon/format/json/city/" .. settings.city
		url = url.."/texto/"..text
        url = url.."/idApp/"..settings.idApp
    
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
        print(url)
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
        print(url)
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
        url = url.."api/getFilter/format/json/idApp/" .. settings.idApp .."/city/" .. settings.city .. "/idFilter/" .. idFilter .. "/type/" .. typeF
        
        if typeF == "EVENTOS" and idFilter == 0 then
			url = settings.url .. "api/getAllEvent/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
		elseif not (typeF == "EVENTOS") and idFilter == 6 then
			url = settings.url .. "api/getAllDeal/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
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
		
		local url = settings.url .. "api/getDealsRedimir/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
	   print(url)
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
	    print(url)
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
	    print(url)
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
	
return RestManager