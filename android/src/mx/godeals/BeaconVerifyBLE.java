
package mx.godeals;

import android.app.Activity;
import android.content.Context;
import android.content.pm.*;
import android.content.pm.PackageManager;
import android.bluetooth.BluetoothAdapter;
    
public class BeaconVerifyBLE implements com.naef.jnlua.NamedJavaFunction {
   /**
    * Gets the name of the Lua function as it would appear in the Lua script.
    * @return Returns the name of the custom Lua function.
    */
   @Override
   public String getName() {
      return "verifyBLE";
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
       int value = 0;
       
        if (activity.getPackageManager().hasSystemFeature("android.hardware.bluetooth_le") &&
           android.os.Build.VERSION.SDK_INT >= 16){
            value = 1;
                
            BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            if (mBluetoothAdapter != null) {
                if (mBluetoothAdapter.isEnabled()) {
                    value = 2;
                }
            }
        }
       
       
       // Return value
       luaState.pushInteger(value);
       
      return 1;
   }
	
}

