//
//  DataLoginController.h
//  PerDueCItyCard
//
//  Created by mario greco on 22/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDidLogoutNotification                 @"didLogout"
#define kDidAbortLogoutNotification             @"didAbortLogout"

//@protocol DataLoginDelegate;

@interface DataLoginController : UITableViewController{
    NSArray *sectionDescripition;
    NSArray *sectionData;
    NSUserDefaults *prefs;
}

//@property(nonatomic,assign) id<DataLoginDelegate> delegate;

@end

/*
 @protocol DataLoginDelegate <NSObject>

-(void)didLogout;
-(void)didAbortLogout;

@end
 */