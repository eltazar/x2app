//
//  Celladati.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 03/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface Celladati : UITableViewCell  <UITextFieldDelegate>{
	
	IBOutlet UILabel * mytext;
	IBOutlet UILabel * labelRight;
	IBOutlet UITextField * detail;	
	NSString * key;
	
	
}


@property (nonatomic,retain) IBOutlet UILabel * mytext;
@property (nonatomic,retain) IBOutlet UILabel * labelRight;
@property (nonatomic,retain) IBOutlet UITextField * detail;
@property (nonatomic,retain) NSString * key;

@end
