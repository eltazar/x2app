	//
	//  ScegliGiorno.h
	//  Per Due
	//
	//  Created by Giuseppe Lisanti on 02/05/11.
	//  Copyright 2011 __MyCompanyName__. All rights reserved.
	//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Home.h"

@interface Opzioni: UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
	IBOutlet UIButton *fatto;
	NSArray *giorni;
	NSArray *provinceattive;
	NSIndexPath    *lastIndexPath;
	IBOutlet UIPickerView * optPicker;
	NSUserDefaults *defaults;
	
}

@property (nonatomic, retain) IBOutlet UIButton *fatto;
@property (nonatomic, retain) NSArray *giorni;
@property (nonatomic, retain) NSArray *provinceattive;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
- (IBAction)chiudi:(id)sender;

@end