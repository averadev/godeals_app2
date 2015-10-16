//
//  BLReden.m
//  Plugin
//
//  Created by Beto on 3/3/15.
//
//

#import "BLReden.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <sqlite3.h>

@implementation BLReden

- (id)init{
    
    // Get Region
    NSString *UUID = @"f7826da6-4fa2-4e98-8024-bc5b71e0893e";
    NSLog(@"-------- region beacon: %@ ", UUID);
    
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: UUID];
    NSString *regionIdentifier = [@"godeals.region2" stringByAppendingString: UUID];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:beaconUUID identifier:regionIdentifier];
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    [self.locationManager startUpdatingLocation];
    NSLog(@"-------- region beacon ready ");
    
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:
(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    NSLog(@"-------- Near Beacon.");
    if(beacons.count > 0) {
        NSLog(@"-------- Near Beacon.");
    }
}

-(void)locationManager:(CLLocationManager *)manager
        didEnterRegion:(CLRegion *)region {
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"-------- You entered the region.");
}

-(void)locationManager:(CLLocationManager *)manager
         didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"-------- You exited the region.");
}

#pragma mark UIApplicationDelegate methods


@end
