//
//  Celladati.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 03/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Celladati.h"


@implementation Celladati

@synthesize mytext,detail,key,labelRight;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
			// Initialization code
    }
	
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
	
    [super setSelected:selected animated:animated];
	
		// Configure the view for the selected state
}




- (void)dealloc {
	
		//NSLog(@"dealloc setting cell");
	
	if (mytext) {
		[mytext release];
		mytext = nil;
	}
	
	/*
	 if (detail) {
	 [detail release];
	 detail = nil;
	 }
	 */
	
	if (key) {
		[key release];
		key = nil;
	}
	
	if (labelRight) {
		[labelRight release];
		labelRight = nil;
	}
	
	
    [super dealloc];
}


@end
