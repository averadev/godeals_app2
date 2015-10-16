//
//  BLReden.h
//  Plugin
//
//  Created by Beto on 3/3/15.
//
//


#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <sqlite3.h>


@interface BLReden : NSObject< CLLocationManagerDelegate >

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *databasePath;
@property sqlite3 *godealsDB;

@end