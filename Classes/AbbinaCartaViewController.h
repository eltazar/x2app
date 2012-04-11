//
//  AbbinaCartaViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHTTPAccess.h"

@class PickerViewController;
@protocol AbbinaCartaDelegate;

@interface AbbinaCartaViewController : UITableViewController <UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate, WMHTTPAccessDelegate> {
    id<AbbinaCartaDelegate> _delegate;
    PickerViewController *_pickerDate;
}


@property (nonatomic, retain) id<AbbinaCartaDelegate> delegate;
@property (nonatomic, retain) PickerViewController *pickerDate;

@end


# pragma mark - AbbinaCartaDelegate


@protocol AbbinaCartaDelegate <NSObject>

-(void)didAssociateNewCard;

@end