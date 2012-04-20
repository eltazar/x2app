//
//  RichiediCardViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHTTPAccess.h"
@class PickerViewController;

@interface RichiediCardViewController : UITableViewController<UIActionSheetDelegate,WMHTTPAccessDelegate>{
    
    PickerViewController *pickerCards;
    NSMutableArray *sectionData;
    NSMutableArray *sectionDescription;
    BOOL isNew;

}
@end
