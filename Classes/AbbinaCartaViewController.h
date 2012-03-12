//
//  AbbinaCartaViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerViewController;
@protocol AbbinaCartaDelegate;

@interface AbbinaCartaViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate>
{
    BOOL isViewUp;
    PickerViewController *pickerDate;
}

@property(nonatomic,assign) id<AbbinaCartaDelegate> delegate;

@property(nonatomic,retain) IBOutlet UIButton *abbinaButton;

-(IBAction)abbinaButtonClicked:(id)sender;
@end


@protocol AbbinaCartaDelegate <NSObject>

-(void)didMatchNewCard;

@end