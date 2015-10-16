package mx.godeals;

import java.util.LinkedList;
import java.util.List;
import java.lang.Exception;
import java.util.*;

import android.content.*;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;
 
public class MySQLiteHelper extends SQLiteOpenHelper {
 
    // Database Version
    private static final int DATABASE_VERSION = 1;
    // Database Name
    private static final String DATABASE_NAME = "godeals.db";
 
    public MySQLiteHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);  
    }
 
    @Override
    public void onCreate(SQLiteDatabase db) {
    }
 
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
    }
    
    // Get all Ads
    public List<Ads> getAllAds() {
        List<Ads> ads = new LinkedList<Ads>();
  
        // 1. build the query
        Date currentDate = new Date();
        // 1. build the query
        String query = "SELECT * FROM ads WHERE fecha < "+((currentDate.getTime() / 1000)-14400);
        try {
			
            // 2. get reference to writable DB
            SQLiteDatabase db = this.getReadableDatabase();
            Cursor cursor = db.rawQuery(query, null);

            // 3. go over each row, build ad and add it to list
            Ads ad = null;
            if (cursor.moveToFirst()) {
                do {
                    ad = new Ads();
                    ad.setId(Integer.parseInt(cursor.getString(0)));
                    ad.setType(Integer.parseInt(cursor.getString(2)));
                    ad.setPartnerId(Integer.parseInt(cursor.getString(3)));
                    ad.setMessage(cursor.getString(4));
                    ad.setDistanceMin(Double.parseDouble(cursor.getString(5)));
                    ad.setDistanceMax(Double.parseDouble(cursor.getString(6)));
                    ad.setLatitude(Double.parseDouble(cursor.getString(7)));
                    ad.setLongitude(Double.parseDouble(cursor.getString(8)));
                    ad.setStatus(1);

                    // Add ad to ads
                    ads.add(ad);

                } while (cursor.moveToNext());
            }
            
		} catch (Exception e) {  }
        
        // return ads
        return ads;
    }
    
    // Get all Ads
    public List<Ads> getByMajor(int major) {
        List<Ads> ads = new LinkedList<Ads>();
        
         // Unix Time
        Date currentDate = new Date();
        
        // 1. build the query
        String query = "SELECT * FROM ads WHERE fecha < "+((currentDate.getTime() / 1000)-14400)+" and major = " + major;
        try {
			
            // 2. get reference to writable DB
            SQLiteDatabase db = this.getReadableDatabase();
            Cursor cursor = db.rawQuery(query, null);

            // 3. go over each row, build ad and add it to list
            Ads ad = null;
            if (cursor.moveToFirst()) {
                do {
                    ad = new Ads();
                    ad.setId(Integer.parseInt(cursor.getString(0)));
                    ad.setType(Integer.parseInt(cursor.getString(2)));
                    ad.setPartnerId(Integer.parseInt(cursor.getString(3)));
                    ad.setMessage(cursor.getString(4));
                    ad.setDistanceMin(Double.parseDouble(cursor.getString(5)));
                    ad.setDistanceMax(Double.parseDouble(cursor.getString(6)));
                    ad.setLatitude(Double.parseDouble(cursor.getString(7)));
                    ad.setLongitude(Double.parseDouble(cursor.getString(8)));
                    ad.setStatus(1);

                    // Add ad to ads
                    ads.add(ad);

                } while (cursor.moveToNext());
            }
            
		} catch (Exception e) {  }
        
        // return ads
        return ads;
    }
    
    // Updating single Ad
    public int updateAds(Ads ad) {

        // 1. get reference to writable DB
        SQLiteDatabase db = this.getWritableDatabase();
        
        // Unix Time
        Date currentDate = new Date();

        // 2. create ContentValues to add key "column"/value
        ContentValues values = new ContentValues();
        values.put("status", 0); // set status 
        values.put("fecha", currentDate.getTime() / 1000); // set status 

        // 3. updating row
        int i = db.update("ads", //table
                values, // column/value
                "id = ?", // selections
                new String[] { String.valueOf(ad.getId()) }); //selection args
        // 4. close
        db.close();

        return i;

    }
    
    // Updating single Ad
    public int updateRed() {

        // 1. get reference to writable DB
        SQLiteDatabase db = this.getWritableDatabase();
        
        // Unix Time
        Date currentDate = new Date();

        // 2. create ContentValues to add key "column"/value
        ContentValues values = new ContentValues();
        values.put("reden", 1); // set status 

        // 3. updating row
        int i = db.update("config", //table
                values, // column/value
                "id = ?", // selections
                new String[] { String.valueOf(1) }); //selection args
        // 4. close
        db.close();

        return i;

    }

 
}