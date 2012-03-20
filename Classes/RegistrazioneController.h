//
//  RegistrazioneController.h
//  PerDueCItyCard
//
//  Created by mario greco on 19/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface RegistrazioneController : UITableViewController{
        
        NSMutableArray *sectionData;
        NSMutableArray *sectionDescription;
        UISegmentedControl *segmentedCtrl;
        
}
@end

