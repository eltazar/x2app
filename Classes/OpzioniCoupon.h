//
//  OpzioniCoupon.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 14/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface OpzioniCoupon : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
@private
    NSUserDefaults  *_defaults;
    // IBOs:
	UIButton        *_doneBtn;
	NSArray         *_province;
	NSIndexPath     *_lastIndexPath;
	UIPickerView    *_optPicker;
}

@property (nonatomic, retain)          NSArray      *province;
@property (nonatomic, retain)          NSIndexPath  *lastIndexPath;
@property (nonatomic, retain) IBOutlet UIButton     *doneBtn;
@property (nonatomic, retain) IBOutlet UIPickerView *optPicker;


- (IBAction)chiudi:(id)sender;


@end