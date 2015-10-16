//
//  AppCoronaDelegate.mm
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppCoronaDelegate.h"
#import "CoronaRuntime.h"
#import "CoronaLua.h"

#import "CoreLocation/CoreLocation.h"
#import "CoreBluetooth/CoreBluetooth.h"



@implementation AppCoronaDelegate

- (void)willLoadMain:(id<CoronaRuntime>)runtime
{
}

- (void)didLoadMain:(id<CoronaRuntime>)runtime
{
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:
(NSDictionary *)launchOptions
{
    // Notifications permissions
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    // Clear notifications
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    // New iOS 8 request for Always Authorization, required for iBeacons to work!
    self.locationManager = [[CLLocationManager alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    
    // Get Region
    NSString *UUID = @"f7826da6-4fa2-4e98-8024-bc5b71e0893e";
    NSLog(@"region beacon: %@ ", UUID);
    
    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString: UUID];
    NSString *regionIdentifier = [@"godeals.region" stringByAppendingString: UUID];
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc]
                                    initWithProximityUUID:beaconUUID identifier:regionIdentifier];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    
    [self.locationManager startMonitoringForRegion:beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    //[self.locationManager startUpdatingLocation];
    NSLog(@"region beacon ready ");
    return YES;
    
    
    
}


-(void)sendLocalNotificationWithMessage:(NSString*)message {
    NSLog(@"%@", message);
    
    // Clear notifications
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // Schedule the notification
    NSDate *pickerDate = [NSDate date];
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = pickerDate;
    localNotification.alertBody = message;
    //localNotification.alertTitle = @"GoDeals.";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"Tipo" forKey:@"Prox"];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:
(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    
    if(beacons.count > 0) {
        CLBeacon *nearestBeacon = beacons.firstObject;
        double accuracy = nearestBeacon.accuracy;
        NSNumber *major = nearestBeacon.major;
        
        //NSLog(@"region major: %@ accuracy: %f ", major, accuracy);
        NSString *docsDir;
        NSArray *dirPaths;
        sqlite3_stmt *statement;
        
        //NSLog(@"inRegion");
        
        // Get the documents directory
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        
        // Build the path to the database file
        _databasePath = [[NSString alloc]
                         initWithString: [docsDir stringByAppendingPathComponent:
                                          @"godeals.db"]];
        const char *dbpath = [_databasePath UTF8String];
        if (sqlite3_open(dbpath, &_godealsDB) == SQLITE_OK)
        {
            
            // Set loyalty
            bool lStatus = true;
            NSDate *now = [NSDate date];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
            [components setHour:0];
            NSDate *today10am = [calendar dateFromComponents:components];
            long unixTime = (long) [today10am timeIntervalSince1970];
            
            
            long unixNow = (long) [now timeIntervalSince1970];
            
            
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM beaconday WHERE major = %@ and fecha = %ld", major, unixTime];
            const char *query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(_godealsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    lStatus = false;
                }
                sqlite3_finalize(statement);
            }
            if (lStatus){
                querySQL = [NSString stringWithFormat: @"INSERT INTO beaconday (major, fecha, status) values  (%@, %ld, 1) ", major, unixTime];
                query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(_godealsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    NSLog(@"INSERT beaconday ");
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
            }
            
            
            querySQL = [NSString stringWithFormat: @"SELECT * FROM ads WHERE major = %@ and distanceMin < %f and distanceMax > %f and fecha < %ld", major, accuracy, accuracy, (unixNow - 86400)];  // 2 semanas
            int bId = 0;
            query_stmt = [querySQL UTF8String];
            if (sqlite3_prepare_v2(_godealsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    bId = sqlite3_column_int(statement, 0);
                    NSString *message = [[NSString alloc] initWithUTF8String:
                               (const char *) sqlite3_column_text(statement, 4)];
                    // Send Notification
                    [self sendLocalNotificationWithMessage:message];
                }
                sqlite3_finalize(statement);
            }
            
            // if get beacon in range
            if (bId > 0){
                querySQL = [NSString stringWithFormat: @"UPDATE ads SET fecha = %ld, status = 1 WHERE id = %d", unixNow, bId];
                query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(_godealsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    NSLog(@"UPDATE STATUS: %ld", unixNow);
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
                // Insert to IOS
                querySQL = [NSString stringWithFormat: @"INSERT INTO toNotif (id) values  (%d) ", bId];
                query_stmt = [querySQL UTF8String];
                if (sqlite3_prepare_v2(_godealsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    NSLog(@"INSERT NEW NOTIF ");
                    sqlite3_step(statement);
                    sqlite3_finalize(statement);
                }
            }
            
            // Verify Redention
            if (accuracy < 3) {
                querySQL = [NSString stringWithFormat: @"SELECT * FROM config WHERE reden = 1"];
                query_stmt = [querySQL UTF8String];
                bool rStatus = false;
                if (sqlite3_prepare_v2(_godealsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        rStatus = true;
                    }
                    sqlite3_finalize(statement);
                }
                // if get beacon in range
                if (rStatus){
                    querySQL = [NSString stringWithFormat: @"UPDATE config SET reden = 0"];
                    query_stmt = [querySQL UTF8String];
                    if (sqlite3_prepare_v2(_godealsDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        NSLog(@"UPDATE REDETION ");
                        sqlite3_step(statement);
                        sqlite3_finalize(statement);
                    }
                }
            }
            
        }
        sqlite3_close(_godealsDB);
    }
}

-(void)locationManager:(CLLocationManager *)manager
        didEnterRegion:(CLRegion *)region {
    [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager startUpdatingLocation];
    
    NSLog(@"You entered the region.");
}

-(void)locationManager:(CLLocationManager *)manager
         didExitRegion:(CLRegion *)region {
    [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    [self.locationManager stopUpdatingLocation];
    
    NSLog(@"You exited the region.");
}

#pragma mark UIApplicationDelegate methods

// The following are stubs for common delegate methods. Uncomment and implement
// the ones you wish to be called. Or add additional delegate methods that
// you wish to be called.

/*
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
*/

/*
- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
*/

/*
- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
*/

/*
- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
*/

/*
- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
*/

@end
