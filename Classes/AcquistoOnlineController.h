//
//  AcquistoOnlineController.h
//  PerDueCItyCard
//
//  Created by mario greco on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHTTPAccess.h"
#import "IAPHelper.h"
#import "MBProgressHUD.h"

#define kPurchasedCard      @"PurchasedCard"

@interface AcquistoOnlineController : UITableViewController <WMHTTPAccessDelegate>
{
    NSSet *productsId;
    
    IBOutlet UITableViewCell *cellProdotto;

    @private
    NSArray *products;
    
    IBOutlet UIView *retrieveView;
}

@end
