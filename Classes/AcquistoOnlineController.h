//
//  AcquistoOnlineController.h
//  PerDueCItyCard
//
//  Created by mario greco on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
@interface AcquistoOnlineController : UITableViewController <DatabaseAccessDelegate>
{
    NSMutableArray *sectionDescription;
    NSMutableArray *sectionData;
    DatabaseAccess *dbAccess;
}
@end
