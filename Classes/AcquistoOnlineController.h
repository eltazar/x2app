//
//  AcquistoOnlineController.h
//  PerDueCItyCard
//
//  Created by mario greco on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
#import "IAPHelper.h"
#import "MBProgressHUD.h"

@interface AcquistoOnlineController : UITableViewController <DatabaseAccessDelegate>
{
    DatabaseAccess *dbAccess;
    NSSet *productsId;
    
    IBOutlet UITableViewCell *cellProdotto;
}

@property (retain) MBProgressHUD *hud;

@end
