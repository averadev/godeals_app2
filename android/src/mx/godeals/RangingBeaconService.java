
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
import android.R;
import android.support.v4.app.NotificationCompat;
import android.util.Log;
import android.content.pm.*;
import android.location.*;
    
public class RangingBeaconService extends IntentService implements BeaconConsumer {
	
	int rangNo = 0;
	boolean isLive = false;
	boolean isPause = true;
	boolean isBlank = true;
    MySQLiteHelper db;
	DecimalFormat df = new DecimalFormat("#.00");
	protected List<Ads> ads;
	
	NotificationManager nManager;
	BeaconManager beaconManager = BeaconManager.getInstanceForApplication(this);

	/**
	* A constructor is required, and must call the super RangingBeaconService(String)
	* constructor with a name for the worker thread.
	*/
	public RangingBeaconService() {
		super("RangingBeaconService");
	}
	
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		
		// Instanciamos el servicio de Beacons
		Log.i("Bcon", "Start Service");
        boolean isOnBLE = false;
        
        if (getPackageManager().hasSystemFeature("android.hardware.bluetooth_le") &&
           android.os.Build.VERSION.SDK_INT >= 16){
                
            BluetoothAdapter mBluetoothAdapter = BluetoothAdapter.getDefaultAdapter();
            if (mBluetoothAdapter != null) {
                if (mBluetoothAdapter.isEnabled()) {
                    
                    Log.i("Bcon", "isOnBLE");
                    isOnBLE = true;
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
        
        if (! isOnBLE){
            Log.i("Bcon", "Not OnBLE");
            PackageManager pm = this.getPackageManager();
            // Location Manager
            LocationManager manager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
            // Instanciamos e inicializamos nuestro manager.
            nManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
            // Obtenemos publicidad de base de datos
            db = new MySQLiteHelper(this);
            ads = db.getAllAds();
            ByGPS(manager);  
        }
	    
        super.onStartCommand(intent,flags,startId);
        return START_STICKY; 
	}
    
    /**
	* Send Notication
	*/
    protected void sendNotification(Ads ad){
        // Set new Intent
        Intent myIntent = new Intent(getBaseContext(), com.ansca.corona.CoronaActivity.class);
        myIntent.putExtra("type", "beacon");
        myIntent.putExtra("beaconId", ad.getId());
        myIntent.putExtra("partnerId", ad.getPartnerId());

        PendingIntent pendingIntent = PendingIntent.getActivity(
                getBaseContext(), 
                0, 
                myIntent, 
                Intent.FLAG_ACTIVITY_NEW_TASK);

        String txtTicker = "GoDeals - "+ad.getMessage();
        // Make notification
        NotificationCompat.Builder builder = new NotificationCompat.Builder(
                getBaseContext())
                .setAutoCancel(true)
                .setContentIntent(pendingIntent)
                .setSmallIcon(mx.godeals.R.drawable.icon)
                .setContentTitle("Go Deals")
                .setContentText(ad.getMessage())
                .setPriority(2)
                .setTicker(txtTicker)
                .setWhen(System.currentTimeMillis());
        // Make sound
        Uri alarmSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        builder.setSound(alarmSound);
        // Send notification
        nManager.notify(12345, builder.build());
    }
    
    /**
	* Verify with GPS
	*/
    protected void ByGPS(LocationManager manager){
        // Define a listener that responds to location updates
        LocationListener locationListener = new LocationListener() {
            public void onLocationChanged(Location location) {
                // Called when a new location is found by the network location provider.
                if (location != null && isPause) {
                    isPause = false;
                    double lat = location.getLatitude();
                    double lng = location.getLongitude();
                    Log.i("Bcon", "Check ads: ");
                    for (Ads ad : ads){
                        if (ad.getStatus() == 1){
                            if ((lat+.0004)>ad.getLatitude() && (lat-.0004)<ad.getLatitude()){
                                if ((lng+.0004)>ad.getLongitude() && (lng-.0004)<ad.getLongitude()){
                                    if(isBlank){
                                        isBlank = false;
                                        Log.i("Bcon", "ID Reden: "+ad.getId());
                                        db.updateAds(ad);
                                        ad.setStatus(0);
                                        sendNotification(ad);
                                    }
                                }
                            }
                        }
                    }
                    
                }
            }
            public void onStatusChanged(String provider, int status, Bundle extras) {}
            public void onProviderEnabled(String provider) {}
            public void onProviderDisabled(String provider) {}
        };
        manager.requestLocationUpdates(LocationManager.NETWORK_PROVIDER,0,0,locationListener);
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
                Log.i("Bcon", "Beacons = "+beacons.size());

				if (beacons.size() > 0) {
	            	// Recorremos Beacons en el rango
	            	for (Beacon beacon : beacons){
	            		String tmpUuid = beacon.getId1().toString();
                        if (tmpUuid.equals("f7826da6-4fa2-4e98-8024-bc5b71e0893e")){
                            int major = beacon.getId2().toInt();
                            double beaconDis = Double.valueOf(df.format(beacon.getDistance()));
                            Log.i("Bcon", "Beacon - Major:"+major+" Distance="+beaconDis);
                            ads = db.getByMajor(major);
                            for (Ads ad : ads){
                                Log.i("Bcon", "Beacon Distance="+beaconDis+" AddMax="+ ad.getDistanceMax()+" AddMin="+ ad.getDistanceMin() );
                                if (beaconDis < ad.getDistanceMax() && beaconDis > ad.getDistanceMin() && ad.getStatus() == 1){
                                    // Desactivate element
                                    db.updateAds(ad);
                                    sendNotification(ad);
                                }
                            }
                        }
	            	}
	            }
	        }
		});
		
		try {
			Log.i("Bcon", "Bcon - Start Ranging");
		    beaconManager.startRangingBeaconsInRegion(new Region("RangoID", null, null, null));
		} catch (RemoteException e) {   }
	}
	
	@Override
    public void onDestroy() {
		Log.i("Bcon", "Destroy - Service");
    }
	
	
}

