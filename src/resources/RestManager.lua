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
	
	RestManager.getTodayEvent = function()
		local url = settings.url .. "api/getTodayEvent/format/json"
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setElements(data.items)
					loadImage({posc = 1, screen = 'MainEvent', path = 'assets/img/app/event/'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	   
	end
	
	RestManager.getTodayDeal = function()
		local url = settings.url .. "api/getTodayDeal/format/json/idApp/" .. settings.idApp
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setElements(data.items)
					loadImage({posc = 1, screen = 'MainDeal', path = 'assets/img/app/deal/'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end

    RestManager.getMyDeals = function()
		
		local url = settings.url .. "api/getMyDeals/format/json/idApp/" .. settings.idApp
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setWalletElements(data.items)
					loadWalletImage({posc = 1, path = 'assets/img/app/deal/'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getAllEvent = function()
		local url = settings.url .. "api/getAllEvent/format/json"
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setElements(data.items)
					loadImage({posc = 1, screen = 'EventPanel', path = 'assets/img/app/event/'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getAllCoupon = function()
		local url = settings.url .. "api/getAllDeal/format/json/idApp/" .. settings.idApp
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setElements(data.items)
					loadImage({posc = 1, screen = 'DealPanel', path = 'assets/img/app/deal/'})
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

    RestManager.getAds = function()
        local url = settings.url .. "api/getAds/format/json"

        local function callback(event)
            if ( event.isError ) then
            else
                local data = json.decode(event.response)
                DBManager.saveAds(data.items)
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	end
	
	RestManager.getDealsByPartner = function(idPartner,typeInfo)
		local url = settings.url .. "api/getDealsByPartner/format/json/idPartner/" .. idPartner
	   
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
                    native.showAlert( "Go Deals", data.message, { "OK"})
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
	
	-- se obtiene las notificaciones del usuarios
	
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
					loadNotificationsImage({posc = 1})
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
					loadNotificationsImage({posc = 1})
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
	
return RestManager