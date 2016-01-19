//
//  ConnectionDetector.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface ConnectionDetector : NSObject

+(BOOL)hasConnectivity;
+(void)checkForOfflineTrailData;
+(void)checkForOfflineTrailStatusData;
+(void)checkForOfflineTrailCommentData;

@end
