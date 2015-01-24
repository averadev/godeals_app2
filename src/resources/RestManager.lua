--Include sqlite
local RestManager = {}

	local json = require("json")
    local DBManager = require('src.resources.DBManager')
    local settings = DBManager.getSettings()
	
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
		local url = settings.url .. "api/getTodayDeal/format/json"
	   
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
		local url = settings.url .. "api/getMyDeals/format/json"
	   
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
		local url = settings.url .. "api/getAllDeal/format/json"
	   
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

return RestManager