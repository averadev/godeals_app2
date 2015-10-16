
package mx.godeals;

import java.text.DecimalFormat;
import java.util.Collection;
import java.util.List;

import org.altbeacon.beacon.Beacon;
import org.altbeacon.beacon.BeaconConsumer;
import org.altbeacon.beacon.BeaconManager;
import org.altbeacon.beacon.BeaconParser;
import org.altbeacon.beacon.RangeNotifier;
import org.altbeacon.beacon.Region;

import android.app.IntentService;
import android.graphics.BitmapFactory;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.bluetooth.BluetoothAdapter;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.*;
import android.support.v4.app.NotificationCompat;
import android.util.Log;
import android.content.pm.*;
import android.location.*;
import android.app.Activity;
import android.content.pm.PackageManager;

public class BeaconRedemption implements com.naef.jnlua.NamedJavaFunction{
   
    
    
    /**
    * Gets the name of the Lua function as it would appear in the Lua script.
    * @return Returns the name of the custom Lua function.
    */
   @Override
   public String getName() {
      return "redemption";
   }

   /**
    * This method is called when the Lua function is called.
    * 

    * Warning! This method is not called on the main UI thread.
    * @param luaState Reference to the Lua state.
    * Needed to retrieve the Lua function's parameters and to return 
    * values back to Lua.
    * @return Returns the number of values to be returned by the Lua function.
    */
   @Override
   public int invoke(com.naef.jnlua.LuaState luaState) {
      com.ansca.corona.CoronaActivity activity = com.ansca.corona.CoronaEnvironment.getCoronaActivity();
      if (activity == null) {
         return 1;
      }

      // Push the boolean value to the Lua state's stack.
      // This is the value to be returned by the Lua function.
      Log.i("BconV", "On invoke");
       Intent intent = new Intent(activity, RedemptionService.class);
        activity.startService(intent);
      try {
        
          
        Thread.sleep(4200);                 //1000 milliseconds is one second.
      } catch(InterruptedException ex) {}
       
      Log.i("BconV", "On invoke Over");
      luaState.pushInteger(5);

      // Return 1 to indicate that this Lua function returns 1 value.
      return 1;
   }
    
	
	
}

