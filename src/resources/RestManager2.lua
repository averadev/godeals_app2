--Include sqlite
local RestManager = {}

	local mime = require("mime")
    local json = require("json")
    local crypto = require("crypto")
    local DBManager = require('src.resources.DBManager')
    local Globals = require('src.resources.Globals')

    function urlencode(str)
          if (str) then
              str = string.gsub (str, "\n", "\r\n")
              str = string.gsub (str, "([^%w ])",
              function ( c ) return string.format ("%%%02X", string.byte( c )) end)
              str = string.gsub (str, " ", "%%20")
          end
          return str    
    end
	
	RestManager.getEvents = function()
		local url = "http://localhost:8080/godeals/"
        url = url.."api/getEvent/format/json"
       -- url = url.."/idApp/"..settings.idApp
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					--Globals.Items = data.items
					--print(data.items[2].id)
                    loadMenuEvent(data.items,1)
                else
					--print("adios")
                    --native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	   
	end
	
	RestManager.getAllEvent = function()
		local url = "http://localhost:8080/godeals/"
        url = url.."api/getAllEvent/format/json"
       -- url = url.."/idApp/"..settings.idApp
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					--Globals.Items = data.items
					--print(data.items[2].id)
                    loadMenuEvent(data.items,2)
                else
					--print("adios")
                    --native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	   
	end
	
	RestManager.getCoupon = function()
		local url = "http://localhost:8080/godeals/"
        url = url.."api/getCoupon/format/json"
       -- url = url.."/idApp/"..settings.idApp
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					--Globals.Items = data.items
					--print(data.items[2].id)
                    loadMenuCoupon(data.items,1)
                else
					--print("adios")
                    --native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	   
	end
	
	RestManager.getAllCoupon = function()
		local url = "http://localhost:8080/godeals/"
        url = url.."api/getAllCoupon/format/json"
       -- url = url.."/idApp/"..settings.idApp
	   
	   local function callback(event)
            if ( event.isError ) then
            else
				local data = json.decode(event.response)
                if data.success then
					--Globals.Items = data.items
					--print(data.items[2].id)
                    loadMenuCoupon(data.items,2)
                else
					--print("adios")
                    --native.showAlert( "Go Deals", data.message, { "OK"})
                end
            end
            return true
        end
        -- Do request
        network.request( url, "GET", callback )
	   
	end

    

return RestManager