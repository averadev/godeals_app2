--Include sqlite
local dbManager = {}

	require "sqlite3"
	local path, db
    local lfs = require "lfs"

	--Open rackem.db.  If the file doesn't exist it will be created
	local function openConnection( )
        local pathBase = system.pathForFile(nil, system.DocumentsDirectory)
        if findLast(pathBase, "/data/data") > -1 then
            local newFile = pathBase:gsub("/app_data", "") .. "/databases/godeals.db"
            local fhd = io.open( newFile )
            if fhd then
                fhd:close()
            else
                local success = lfs.chdir(  pathBase:gsub("/app_data", "") )
                if success then
                    lfs.mkdir( "databases" )
                end
            end
            db = sqlite3.open( newFile )
        else
            db = sqlite3.open( system.pathForFile("godeals.db", system.DocumentsDirectory) )
        end
	end

	local function closeConnection( )
		if db and db:isopen() then
			db:close()
		end     
	end
	 
	--Handle the applicationExit event to close the db
	local function onSystemEvent( event )
	    if( event.type == "applicationExit" ) then              
	        closeConnection()
	    end
	end

    -- Find substring
    function findLast(haystack, needle)
        local i=haystack:match(".*"..needle.."()")
        if i==nil then return -1 else return i-1 end
    end

	dbManager.getSettings = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM config;") do
			closeConnection( )
			return  row
		end
		closeConnection( )
		return 1
	end
	
	dbManager.getReden = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM config;") do
            local status = tonumber(row.reden)
			closeConnection( )
            return status
		end
		closeConnection( )
		return 0
	end

    dbManager.setReden = function()
		openConnection( )
        local query = "UPDATE config SET reden = 0"
        db:exec( query )
		closeConnection( )
	end
	
    dbManager.updateReden = function()
		openConnection( )
        local query = "UPDATE config SET reden = 1"
        db:exec( query )
		closeConnection( )
	end

	dbManager.getIdComer = function()
		local result = {}
		openConnection( )
		for row in db:nrows("SELECT * FROM config;") do
            local idComer = tonumber(row.idComer)
			if idComer > 0 then
                query = "UPDATE config SET idComer = 0"
                db:exec( query )
            end
		    closeConnection( )
			return  row.idComer
		end
		closeConnection( )
		return 0
	end

    dbManager.updateIdComer = function(idComer)
		openConnection( )
        local query = ''
        query = "UPDATE config SET idComer = "..idComer
        db:exec( query )
		closeConnection( )
	end
	
	dbManager.updateCity = function(city)
		openConnection( )
        local query = ''
        query = "UPDATE config SET city = " .. city ..";"
        db:exec( query )
		closeConnection( )
	end
	
	dbManager.updateTutorial = function(city)
		openConnection( )
        local query = ''
        query = "UPDATE config SET tutorial = 0;"
        db:exec( query )
		closeConnection( )
	end

    dbManager.updateUser = function(idApp, email, password, name, fbId)
		openConnection( )
        local query = ''
        if fbId == '' then
            query = "UPDATE config SET idApp = "..idApp..", email = '"..email.."', password = '"..password.."', idComer = 0;"
        else
            query = "UPDATE config SET idApp = "..idApp..", email = '"..email.."', name = '"..name.."', fbId = '"..fbId.."', idComer = 0;"
        end
        db:exec( query )
		closeConnection( )
	end

    dbManager.clearUser = function()
        openConnection( )
        query = "UPDATE config SET idApp = 0, email = '', password = '', name = '', fbId = '';"
        db:exec( query )
		closeConnection( )
    end
    
	dbManager.saveBeacons = function(items)
		openConnection( )
    
        -- Delete all
        query = "DELETE FROM ads WHERE status = 1;"
        db:exec( query )
    
        for row in db:nrows("SELECT id FROM ads;") do
            for z = 1, #items, 1 do 
                if tonumber(items[z].id) == tonumber(row.id) then
                    items[z] = nil;
                end
            end
		end
    
        -- Save update
		for z = 1, #items, 1 do 
            if not (items[z] == nil) then
				query = "INSERT INTO ads VALUES ("
                        ..items[z].id..","
                        ..items[z].major..","
                        ..items[z].type..","
                        ..items[z].partnerId..",'"
                        ..items[z].message.."',"
                        ..items[z].distanceMin..","
                        ..items[z].distanceMax..","
                        ..items[z].latitude..","
                        ..items[z].longitude..", 0, 1);"
				
                db:exec( query )
            end
        end
    
		closeConnection( )
		return 1
	end

	--Setup squema if it doesn't exist
	dbManager.setupSquema = function()
		openConnection( )
		
		local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idApp INTEGER, email TEXT, password TEXT, name TEXT, "..
					" fbId TEXT, idComer TEXT, url TEXT, city INTEGER, tutorial INTEGER, reden INTEGER);"
		db:exec( query )
    
        local query = "CREATE TABLE IF NOT EXISTS ads (id INTEGER PRIMARY KEY, major INTEGER, type INTEGER, partnerId INTEGER, "..
					"message TEXT, distanceMin REAL, distanceMax REAL, latitude REAL, longitude REAL, fecha INTEGER, status INTEGER);"
		db:exec( query )
	
		-- Verify Version APP
		local oldVersion = true
		for row in db:nrows("PRAGMA table_info(config);") do
			if row.name == 'tutorial' then
                oldVersion = false
            end
		end
		if oldVersion then 
		
			local query = "DROP TABLE config;"
			db:exec( query )
			
			local query = "DROP TABLE ads;"
			db:exec( query )
		
			local query = "CREATE TABLE IF NOT EXISTS config (id INTEGER PRIMARY KEY, idApp INTEGER, email TEXT, password TEXT, name TEXT, "..
						" fbId TEXT, idComer TEXT, url TEXT, city INTEGER, tutorial INTEGER, reden INTEGER);"
			db:exec( query )

			local query = "CREATE TABLE IF NOT EXISTS ads (id INTEGER PRIMARY KEY, major INTEGER, type INTEGER, partnerId INTEGER, "..
						"message TEXT, distanceMin REAL, distanceMax REAL, latitude REAL, longitude REAL, fecha INTEGER, status INTEGER);"
			db:exec( query )
		end

        -- Return if have connection
		for row in db:nrows("SELECT idApp FROM config;") do
            closeConnection( )
            if row.idApp == 0 then
                return false
            else
                return true
            end
		end
        
        -- Populate config
        --query = "INSERT INTO config VALUES (1, 0, '', '', '', '', 0, 'http://godeals.mx/');"
        --query = "INSERT INTO config VALUES (1, 0, '', '', '', '', 0, 'http://godeals.mx/admin/',1,1,0);"
		query = "INSERT INTO config VALUES (1, 0, '', '', '', '', 0, 'http://192.168.1.197/godeals2/',1,1,0);"
		
		db:exec( query )
    
		closeConnection( )
    
        return false
	end
	

	--setup the system listener to catch applicationExit
	Runtime:addEventListener( "system", onSystemEvent )
    

return dbManager