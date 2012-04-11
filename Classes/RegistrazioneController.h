//
//  RegistrazioneController.h
//  PerDueCItyCard
//
//  Created by mario greco on 19/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHTTPAccess.h"
@class MBProgressHUD;

@interface RegistrazioneController : UITableViewController <WMHTTPAccessDelegate> {
        
    NSMutableArray *sectionData;
    NSMutableArray *sectionDescription;      
}
@property (retain) MBProgressHUD *hud;
@end

