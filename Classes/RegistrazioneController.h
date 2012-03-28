//
//  RegistrazioneController.h
//  PerDueCItyCard
//
//  Created by mario greco on 19/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
@class MBProgressHUD;

@interface RegistrazioneController : UITableViewController<DatabaseAccessDelegate>{
        
    NSMutableArray *sectionData;
    NSMutableArray *sectionDescription;      
    DatabaseAccess *dbAccess;
}
@property (retain) MBProgressHUD *hud;
@end

