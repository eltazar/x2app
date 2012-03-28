//
//  AbbinaCartaViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@class PickerViewController;
@protocol AbbinaCartaDelegate;

@interface AbbinaCartaViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate, DatabaseAccessDelegate> {
    id<AbbinaCartaDelegate> _delegate;
    PickerViewController *_pickerDate;
    IBOutlet UIButton *_abbinaButton;
}


@property (nonatomic, retain) id<AbbinaCartaDelegate> delegate;
@property (nonatomic, retain) PickerViewController *pickerDate;

@property (nonatomic, retain) IBOutlet UIButton *abbinaButton;


-(IBAction)abbinaButtonClicked:(id)sender;


@end


# pragma mark - AbbinaCartaDelegate


@protocol AbbinaCartaDelegate <NSObject>

-(void)didAssociateNewCard;

@end