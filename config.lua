---------------------------------------------------------------------------------
-- Godeals App
-- Alberto Vera
-- GeekBucket Software Factory
---------------------------------------------------------------------------------

local mediaRes = display.pixelWidth  / 480

application = {
	content = {
		width = display.pixelWidth / mediaRes,
        height = display.pixelHeight / mediaRes
	},
	
	notification =
    {
        google = { projectNumber = "386747265171" },
        iphone =
        {
            types =
            {
                "badge", "sound", "alert"
            }
        }
    }
	
}
