//
//  AppCoronaDelegate.h
//  TemplateApp
//
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <sqlite3.h>

#import "CoronaDelegate.h"

@interface AppCoronaDelegate : NSObject< CoronaDelegate, UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *databasePath;
@property sqlite3 *godealsDB;

@end
