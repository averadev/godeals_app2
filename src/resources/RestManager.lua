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
		local url = settings.url .. "api/getRecommended/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setElements(data.items)
					loadImage({posc = 1, screen = 'MainScreen'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getMyDeals = function()
		
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
		local url = settings.url .. "api/getAllEvent/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
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
		local url = settings.url .. "api/getAllDeal/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
	   
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

	 RestManager.getPartner = function(idPartner)
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

    RestManager.getBeacons = function()
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
	
	RestManager.getDealsByPartner = function(idPartner,typeInfo)
		local url = settings.url .. "api/getDealsByPartner/format/json/idPartner/" .. idPartner .. "/city/" .. settings.city
	   
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
		local url = settings.url .. "api/getCouponById/format/json/idCoupon/" .. idCoupon
	   
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
	
	RestManager.createUser = function(email, password, name, fbId)
        --local settings = DBManager.getSettings()
        -- Set url
		
        password = crypto.digest(crypto.md5, password)
        local url = settings.url
        url = url.."api/createUser/format/json"
        url = url.."/email/"..urlencode(email)
        url = url.."/password/"..password
        url = url.."/name/"..urlencode(name)
        url = url.."/fbId/"..fbId
        
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
	
	RestManager.discountCoupon = function(idCoupon)
	
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
		
		local url = settings.url .. "api/getDealsRedimir/format/json/idApp/" .. settings.idApp .. "/city/" .. settings.city
	   
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
	
return RestManager