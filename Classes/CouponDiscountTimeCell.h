//
//  CouponDiscountTimeCell.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"
#import "AsyncImageView.h"

@interface CouponDiscountTimeCell : UITableViewCell <AsyncImageViewDelegate> {
@private
    NSString *_imgUrlString;
    
    AsyncImageView *_asyncImageView;
    UILabel *_prezzoCouponLbl;
	UILabel *_scontoLbl;
	UILabel *_risparmioLbl;
    UILabel *_prezzoOrigLbl;
    UILabel *_tempoLbl;  
    UIActivityIndicatorView *_caricamentoImmagineSpinner;
    Coupon *_viewController;
}


@property (nonatomic, retain) IBOutlet AsyncImageView *asyncImageView;
@property (nonatomic, retain) IBOutlet UILabel *prezzoCouponLbl;
@property (nonatomic, retain) IBOutlet UILabel *scontoLbl;
@property (nonatomic, retain) IBOutlet UILabel *risparmioLbl;
@property (nonatomic, retain) IBOutlet UILabel *prezzoOrigLbl;
@property (nonatomic, retain) IBOutlet UILabel *tempoLbl;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *caricamentoImmagineSpinner;
@property (nonatomic, retain) IBOutlet Coupon *viewController;


- (void)loadImageFromUrlString:(NSString *)urlString;

@end
