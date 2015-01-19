--Include sqlite
local RestManager = {}

	local json = require("json")
    local DBManager = require('src.resources.DBManager')
    local settings = DBManager.getSettings()
	
	RestManager.getEvents = function()
		local url = settings.url .. "api/getEvent/format/json"
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setElements(data.items)
					loadImage({posc = 1, screen = 'MainEvent', path = 'assets/img/app/event/app/'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	   
	end
	
	RestManager.getCoupon = function()
		local url = settings.url .. "api/getCoupon/format/json"
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setElements(data.items)
					loadImage({posc = 1, screen = 'MainDeal', path = 'assets/img/app/coupon/app/'})
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
					loadImage({posc = 1, screen = 'EventPanel', path = 'assets/img/app/event/app/'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	   
	end
	
	RestManager.getAllCoupon = function()
		local url = settings.url .. "api/getAllCoupon/format/json"
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    setElements(data.items)
					loadImage({posc = 1, screen = 'DealPanel', path = 'assets/img/app/coupon/app/'})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	   
	end

	 RestManager.getPartner = function(idPartner)
		local url = "http://localhost:8080/godeals/"
        url = url.."api/getPartnertById/format/json"
		url = url.."/idPartner/" .. idPartner
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
                    loadImagePartner(data.items[1])
					
                else
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	   
	end

return RestManager