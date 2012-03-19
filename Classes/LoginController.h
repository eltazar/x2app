//
//  LoginController.h
//  PerDueCItyCard
//
//  Created by mario greco on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface LoginController : UIViewController <UITextFieldDelegate,DatabaseAccessDelegate>
{
    IBOutlet UILabel *emailLabel;
    IBOutlet UILabel *pswLabel;
    IBOutlet UILabel *messaggioEmailTrue;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *pswTextField;
    
    IBOutlet UILabel *nonRicordoPswLabel;
    IBOutlet UIButton *ricordaBtn;
    
    DatabaseAccess *dbAccess;
    
    NSString *utente;
    NSString *psw;
    
    int idUtente;
}

@property(nonatomic,retain)NSString *usr;
@property(nonatomic, retain) NSString *psw;

@end
