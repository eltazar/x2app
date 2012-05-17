//
//  ToucHotelViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToucHotelViewController : UIViewController
{
    @private
    IBOutlet UIButton *openTHbtn;
    IBOutlet UIButton *openStoreBtn;
}
@property(nonatomic, retain) IBOutlet UIButton *openStoreBtn;
@property(nonatomic, retain) IBOutlet UIButton *openTHbtn;
@property(nonatomic, retain) IBOutlet UIWebView *descriptionWebView;
-(IBAction)downloadFromAppStore:(id)sender;
-(IBAction)launchThApp:(id)sender;
@end
