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
    
    IBOutlet UILabel *nonRegistratoLabel;
    IBOutlet UILabel *nonRicordoPswLabel;
    IBOutlet UIButton *registratiBtn;
    IBOutlet UIButton *ricordaBtn;
    
    DatabaseAccess *dbAccess;
}

@end
