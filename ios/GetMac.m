//
//  GetMac.m
//  Plugin
//
//  Created by Beto on 5/18/15.
//
//

#import "GetMac.h"
#import <Foundation/Foundation.h>

const NSString *SEGCentralManagerClass = @"CBCentralManager";

@interface GetMac () <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) dispatch_queue_t queue;

@end



@implementation BLVerify

- (id)init {
    Class centralManager = NSClassFromString(@"CBCentralManager");
    
    if (!centralManager) return nil;
    if (!(self = [super init])) return nil;
    
    _queue = dispatch_queue_create("io.segment.bluetooth.queue", NULL);
    
    if (&CBCentralManagerOptionShowPowerAlertKey != NULL) {
        _manager = [[centralManager alloc] initWithDelegate:self queue:_queue options:@{ CBCentralManagerOptionShowPowerAlertKey: @NO }];
    } else {
        _manager = [[centralManager alloc] initWithDelegate:self queue:_queue];
    }
    
    return self;
}

- (BOOL)hasKnownState {
    return _manager.state == CBCentralManagerStatePoweredOff;
}

- (BOOL)isEnabled {
    return _manager.state == CBCentralManagerStatePoweredOn;
}


- (void)centralManagerDidUpdateState:(id)central {}

@end
