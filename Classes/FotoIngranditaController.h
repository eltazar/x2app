//
//  FotoIngranditaController.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"


@protocol FotoIngranditaDelegate;
@class Coupon;

@interface FotoIngranditaController : UIViewController <DatabaseAccessDelegate> {
@private
    NSString *_imageUrl;
    DatabaseAccess *_dbAccess;
    //IBoutlets
    UIImageView *_imageView;
    UIActivityIndicatorView *_activityIndicator;
    Coupon *_couponViewController;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet Coupon *couponViewController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil imageUrlString:(NSString *)aUrl;
+ (FotoIngranditaController *) fotoIngranditaControllerWithImageUrlString:(NSString *)aUrl delegate:(Coupon *)couponViewController;
    
@end


@protocol FotoIngranditaDelegate <NSObject>
- (IBAction)chiudi:(id)sender;
@end