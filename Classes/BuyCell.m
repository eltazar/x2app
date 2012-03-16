//
//  BuyCell.m
//  PerDueCItyCard
//
//  Created by mario greco on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BuyCell.h"

@implementation BuyCell
@synthesize buyButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDictionary:(NSDictionary *)dictionary {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier withDictionary:dictionary]) {
		// Configuro il textfield secondo la necessità
        self.selectionStyle = UITableViewCellSelectionStyleNone;        
        [self.textLabel setAdjustsFontSizeToFitWidth:YES];
        self.textLabel.minimumFontSize = 11;

        self.buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [buyButton setTitle:@"Prezzo" forState:UIControlStateNormal];
        //[buttonRight setFrame: CGRectMake( self.contentView.frame.size.width -50, 7.0f, 80.0f, 30)];
        //[buyButton addTarget:self action:@selector(addToFavorites) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:buyButton];
		//[self.contentView addSubview:self.textField];
    }
    return self;
}

- (void)layoutSubviews {
    
    CGRect rect = CGRectMake(200,7,80,30);
    [buyButton setFrame:rect];
    
	[super layoutSubviews];
    

}
//-(void) setDelegate:(id<UITextFieldDelegate>)delegate
//{
//    buyButton.delegate = delegate; 
//}


#pragma mark - Memory management

-(void) dealloc
{
    self.buyButton = nil;
    [super dealloc];
}




@end

