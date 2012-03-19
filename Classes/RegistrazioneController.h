//
//  RegistrazioneController.h
//  PerDueCItyCard
//
//  Created by mario greco on 19/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface RegistrazioneController : UIViewController<UITextFieldDelegate,DatabaseAccessDelegate>
{
    DatabaseAccess *dbAccess;
    
}

@property(nonatomic,retain)NSString *nome;
@property(nonatomic,retain)NSString *cognome;
@property(nonatomic,retain)NSString *email;
@property(nonatomic,retain)NSString *telefono;

-(IBAction)registraBtnClicked:(id)sender;
@end
