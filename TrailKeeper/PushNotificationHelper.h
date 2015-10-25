//
//  PushNotificationHelper.h
//  TrailKeeper
//
//  Created by Jeremey Rodriguez on 10/11/15.
//  Copyright © 2015 Jeremey Rodriguez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushNotificationHelper : NSObject

+(NSString*)FormatChannelName:(NSString*)trail;
+(NSString*)CreateChannelName:(NSString*)trail;
+(void)SendOutAPushNotificationForNewComment:(NSString*)trailNameString trailObjectId:(NSString*)trailObjectId comment:(NSString*)Comment;
+(void)SendOutAPushNotificationForStatusUpdate:(NSString*)trailNameString trailObjectId:(NSString*)trailObjectId status:(NSNumber*)Status;

-(void)GetNewPush:(NSString*)jsonString;

@end
