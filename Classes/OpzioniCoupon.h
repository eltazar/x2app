//
//  OpzioniCoupon.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 14/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface OpzioniCoupon : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
	IBOutlet UIButton *fatto;
	NSArray *province;
	NSIndexPath    *lastIndexPath;
	IBOutlet UIPickerView * optPicker;
	NSUserDefaults *defaults;
	
}

@property (nonatomic, retain) IBOutlet UIButton *fatto;
@property (nonatomic, retain) NSArray *province;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
- (IBAction)chiudi:(id)sender;

@end