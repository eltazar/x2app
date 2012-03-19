//
//  LoginController.h
//  PerDueCItyCard
//
//  Created by mario greco on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@protocol LoginControllerDelegate;

@interface LoginController : UIViewController <UITextFieldDelegate,DatabaseAccessDelegate>
{
    
    DatabaseAccess *dbAccess;
    
    NSString *utente;
    NSString *psw;
    
    int idUtente;
}


@property(nonatomic,retain) IBOutlet UILabel *emailLabel;
@property(nonatomic,retain) IBOutlet UILabel *pswLabel;
@property(nonatomic,retain) IBOutlet UILabel *messaggioEmailTrue;
@property(nonatomic,retain) IBOutlet UITextField *emailTextField;
@property(nonatomic,retain) IBOutlet UITextField *pswTextField;

@property(nonatomic,retain) IBOutlet UILabel *nonRicordoPswLabel;
@property(nonatomic,retain) IBOutlet UIButton *ricordaBtn;


@property(nonatomic,assign)id<LoginControllerDelegate> delegate;
@property(nonatomic,retain)NSString *usr;
@property(nonatomic, retain) NSString *psw;

@end

@protocol LoginControllerDelegate <NSObject>

-(void)didLogin:(int)idUtente;
-(void)didAbortLogin;

@end