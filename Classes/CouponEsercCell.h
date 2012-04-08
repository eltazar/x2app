//
//  CouponEsercCell.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponEsercCell : UITableViewCell {
    //IBOs:
    UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
