//
//  PerDueAppDelegate.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 08/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "IAPHelper.h"

@interface PerDueCItyCardAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, FBSessionDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	NSString * ultimavista;
    NSArray *permissions;

}
@property (nonatomic, retain) Facebook *facebook;

@property (nonatomic, retain) IAPHelper *iapHelper;

@property (readonly, retain, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, retain, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, retain, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)logIntoFacebook;
- (void)checkForPreviouslySavedAccessTokenInfo;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
