//
//  LoginControllerBis.h
//  PerDueCItyCard
//
//  Created by mario greco on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHTTPAccess.h"

@class MBProgressHUD;

@protocol LoginControllerBisDelegate;
@interface LoginControllerBis : UITableViewController <UITextFieldDelegate, WMHTTPAccessDelegate> {
    
    NSArray *sectionData;
    NSArray *sectionDescription;
    int idUtente;
    
    UIAlertView *rememberPswAlert;

}
@property (retain) MBProgressHUD *hud;
@property(nonatomic,assign)id<LoginControllerBisDelegate> delegate;
@end

@protocol LoginControllerBisDelegate <NSObject>

-(void)didLogin:(int)idUtente;
-(void)didAbortLogin;

@end