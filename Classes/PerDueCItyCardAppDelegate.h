//
//  PerDueAppDelegate.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FBSession.h"
@class LocalDBAccess;

@interface PerDueCItyCardAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	FBSession *_session;
	NSString * ultimavista;

}
@property(nonatomic,retain) LocalDBAccess *localDbAccess;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic,retain) FBSession *_session;

@end
