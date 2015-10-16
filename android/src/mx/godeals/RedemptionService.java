
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
    
public class RedemptionService extends IntentService implements BeaconConsumer {
	
	int setRed = 0;
    MySQLiteHelper db;
	DecimalFormat df = new DecimalFormat("#.00");
	protected List<Ads> ads;
	
    NotificationManager nManager;
	BeaconManager beaconManager = BeaconManager.getInstanceForApplication(this);

	/**
	* A constructor is required, and must call the super RangingBeaconService(String)
	* constructor with a name for the worker thread.
	*/
	public RedemptionService() {
		super("RedemptionService");
	}
	
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		
		// Instanciamos el servicio de Beacons
		Log.i("BconV", "Start Service");
        
        if (getPackageManager().hasSystemFeature("android.hardware.bluetooth_le") &&
           android.os.Build.VERSION.SDK_INT >= 16){
                
            BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            if (mBluetoothAdapter != null) {
                if (mBluetoothAdapter.isEnabled()) {
                    
                    Log.i("BconV", "isOnBLE");
                    db = new MySQLiteHelper(this);
                    
                    // Enabled parser
                    beaconManager.getBeaconParsers().add(new BeaconParser().setBeaconLayout(
                            "m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24,d:25-25"));
                    beaconManager.bind(this);   
                    // Instanciamos e inicializamos nuestro manager.
                    nManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
                }
            }
        }
        
        super.onStartCommand(intent,flags,startId);
        return START_STICKY; 
	}
    
	/**
	* The IntentService calls this method from the default worker thread with
	* the intent that started the service. When this method returns, IntentService
	* stops the service, as appropriate.
	*/
	@Override
	protected void onHandleIntent(Intent intent) {
		 SystemClock.sleep(4000);
	}

	@Override
	public void onBeaconServiceConnect() {
		
		beaconManager.setRangeNotifier(new RangeNotifier() {
			@Override 
	        public void didRangeBeaconsInRegion(Collection<Beacon> beacons, Region region) {
                Log.i("BconV", "Beacons = "+beacons.size());

				if (beacons.size() > 0) {
	            	// Recorremos Beacons en el rango
	            	for (Beacon beacon : beacons){
	            		String tmpUuid = beacon.getId1().toString();
                        if (tmpUuid.equals("f7826da6-4fa2-4e98-8024-bc5b71e0893e")){
                            int major = beacon.getId2().toInt();
                            double beaconDis = Double.valueOf(df.format(beacon.getDistance()));
                            Log.i("BconV", "Beacon - Major:"+major+" Distance="+beaconDis);
                            if (beaconDis < 3){
                                if (setRed == 0){
                                    setRed = 1;
                                    db.updateRed();
                                    Log.i("BconV", "Update Redemption");
                                }
                            }
                        }
	            	}
	            }
	        }
		});
		
		try {
			Log.i("BconV", "Bcon - Start Ranging");
		    beaconManager.startRangingBeaconsInRegion(new Region("RangoID", null, null, null));
		} catch (RemoteException e) {   }
	}
	
	@Override
    public void onDestroy() {
		Log.i("BconV", "Destroy - Service");
    }
	
	
}

