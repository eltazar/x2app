//
//  LoginControllerBis.h
//  PerDueCItyCard
//
//  Created by mario greco on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@protocol LoginControllerBisDelegate;
@interface LoginControllerBis : UITableViewController<UITextFieldDelegate,DatabaseAccessDelegate>
{
    
    NSArray *sectionData;
    NSArray *sectionDescription;
    int idUtente;
    DatabaseAccess *dbAccess;
    

}

@property(nonatomic,assign)id<LoginControllerBisDelegate> delegate;
@end

@protocol LoginControllerBisDelegate <NSObject>

-(void)didLogin:(int)idUtente;
-(void)didAbortLogin;

@end