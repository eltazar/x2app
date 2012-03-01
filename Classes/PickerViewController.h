//
//  PickerViewController.h
//  jobFinder
//
//  Created by mario greco on 05/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerViewController : UIViewController< UIPickerViewDelegate, UIPickerViewDataSource>
{
    NSArray *jobListCategory;
    NSString *jobCategory;
    int numElements;

    
}
@property(nonatomic, retain) UIPickerView *picker;
@property(nonatomic, retain) NSArray *arrayFields;
@property(nonatomic, retain) NSArray *arrayDays;
@property(nonatomic, retain) NSArray *arrayMonths;

-(id)initWithArray:(NSArray*)fields andNumber:(int)elements;
-(id)initWithDictionary:(NSDictionary*)dic andNumber:(int)elements;;
@end