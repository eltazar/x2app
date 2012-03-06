//
//  AbbinaCartaViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AbbinaCartaDelegate;

@interface AbbinaCartaViewController : UIViewController <UITextFieldDelegate>
{
    BOOL isViewUp;
}

@property(nonatomic,assign) id<AbbinaCartaDelegate> delegate;

@property(nonatomic, retain)NSString *titolare;
@property(nonatomic, retain)NSString *numeroCarta;
@property(nonatomic, retain)NSString *scadenza;

@property(nonatomic,retain) IBOutlet UIView *viewPulsante;
@property(nonatomic,retain) IBOutlet UIButton *abbinaButton;

-(IBAction)abbinaButtonClicked:(id)sender;
@end


@protocol AbbinaCartaDelegate <NSObject>

-(void)didMatchNewCard;

@end