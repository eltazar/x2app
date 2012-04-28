//
//  ToucHotelViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToucHotelViewController : UIViewController

@property(nonatomic, retain) IBOutlet UIWebView *descriptionWebView;
-(IBAction)downloadFromAppStore:(id)sender;
@end
