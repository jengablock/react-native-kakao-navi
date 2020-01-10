//
//  ANKakaoNavi.m
//  RNCKakaoSDK
//
//  Created by Minhyuk Kim on 2019/11/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "ARNKakaoNavi.h"
#import <KakaoNavi/KakaoNavi.h>
#import <React/RCTLog.h>

@implementation ARNKakaoNavi

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

RCT_EXPORT_MODULE(ARNKakaoNavi)

RCT_EXPORT_METHOD(share: (NSDictionary *)location
                  options: (NSDictionary *)options
                  viaList: (NSArray *)viaList
                  shareWithResolver: (RCTPromiseResolveBlock) resolve
                  rejector: (RCTPromiseRejectBlock) reject)
{
  KNVLocation *destination = [KNVLocation locationWithName: location[@"name"]
                                                         x: location[@"x"]
                                                         y: location[@"y"]
                              ];
  NSMutableArray *newViaList = [NSMutableArray array];
  for(int i = 0; i < [viaList count]; i++) {
    id el = [viaList objectAtIndex:i];
    KNVLocation *via = [KNVLocation locationWithName: el[@"name"]
                                                   x: el[@"x"]
                                                   y: el[@"y"]
                        ];
    [newViaList addObject:via];
  }

  KNVOptions *newOptions = [KNVOptions options];
  newOptions.coordType = KNVCoordTypeWGS84;
  newOptions.vehicleType = KNVVehicleTypeFirst;
  newOptions.routeInfo = NO;
  newOptions.rpOption = KNVRpOptionFast;
  newOptions.startAngle = [NSNumber numberWithInt:-1];

  KNVParams *params = [KNVParams paramWithDestination:destination options:(KNVOptions *) newOptions viaList:newViaList];

  [[KNVNaviLauncher sharedLauncher] setEnableWebNavi:YES];
  [[KNVNaviLauncher sharedLauncher] shareDestinationWithParams: params completion:^(NSError * _Nullable error) {
    if (error) {
      RCTLogInfo(error.userInfo.description);
    } else {
      resolve(@"SUCCESS");
    }
  }];
  
}


RCT_EXPORT_METHOD(navigate: (NSDictionary *)location
                  options: (NSDictionary *)options
                  viaList:(NSArray *)viaList
                  shareWithResolver: (RCTResponseSenderBlock) resolve
                  rejector: (RCTPromiseRejectBlock) reject)
{
   KNVLocation *destination = [KNVLocation locationWithName: location[@"name"]
                                                          x: location[@"x"]
                                                          y: location[@"y"]
                               ];
   NSMutableArray *newViaList = [NSMutableArray array];
   for(int i = 0; i < [viaList count]; i++) {
     id el = [viaList objectAtIndex:i];
     KNVLocation *via = [KNVLocation locationWithName: el[@"name"]
                                                    x: el[@"x"]
                                                    y: el[@"y"]
                         ];
     [newViaList addObject:via];
   }

   KNVOptions *newOptions = [KNVOptions options];
   newOptions.coordType = KNVCoordTypeWGS84;
   newOptions.vehicleType = KNVVehicleTypeFirst;
   newOptions.routeInfo = NO;
   newOptions.rpOption = KNVRpOptionFast;
   newOptions.startAngle = [NSNumber numberWithInt:-1];

   KNVParams *params = [KNVParams paramWithDestination:destination options:(KNVOptions *) newOptions viaList:newViaList];
  
  
  [[KNVNaviLauncher sharedLauncher] setEnableWebNavi:YES];
  [[KNVNaviLauncher sharedLauncher] navigateWithParams: params completion:^(NSError * _Nullable error) {
    if (error) {
      resolve(error.userInfo.description);
    } else {
      resolve(@"SUCCESS");
    }
  }];
  
}


@end
