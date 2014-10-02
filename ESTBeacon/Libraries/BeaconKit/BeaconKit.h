//
//  BeaconKit.h
//  BeaconKit
//
//  Created by WEI-JEN TU on 2014-10-01.
//  Copyright (c) 2014 Cold Yam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol BeaconKitDelegate <NSObject>
- (void)manager:(CLLocationManager *)manager
didRangeBeacons:(NSArray *)beacons
       inRegion:(CLBeaconRegion *)region;
@end

@interface BeaconKit : NSObject
@property (nonatomic, assign) id<BeaconKitDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *trackers;
+ (id)sharedInstance;

/* Operation */
- (void)startMonitoring;
- (void)stopMonitoring;
- (void)resumeMonitoring;

/* Contexts */
- (NSString *)nameForBeacon:(CLBeacon *)beacon;
- (NSString *)nameForRegion:(CLBeaconRegion *)region;
- (NSString *)proximity:(CLBeacon *)beacon;
- (UIColor *)color:(CLBeacon *)beacon;
@end

@interface UIImage (tintColor)
- (UIImage *)tintColor:(UIColor *)color;
@end