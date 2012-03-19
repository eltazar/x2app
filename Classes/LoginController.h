//
//  LoginController.h
//  PerDueCItyCard
//
//  Created by mario greco on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginController : UIViewController <UITextFieldDelegate>
{
    IBOutlet UILabel *emailLabel;
    IBOutlet UILabel *pswLabel;
    IBOutlet UILabel *messaggioEmailTrue;
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *pswTextField;
}

@end
