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
    int numElements;
    
    NSMutableArray *objectsInRow;
    
}
@property(nonatomic, retain) NSMutableArray *objectsInRow;
@property(nonatomic, retain) UIPickerView *picker;
@property(nonatomic, retain) NSArray *arrayFields;

-(id)initWithArray:(NSArray*)fields andNumber:(int)elements;
@end