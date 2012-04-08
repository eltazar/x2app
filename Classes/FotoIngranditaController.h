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
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil imageUrlString:(NSString *)aUrl;

- (IBAction)chiudi:(id)sender;

    
@end


@protocol FotoIngranditaDelegate <NSObject>
- (IBAction)chiudi:(id)sender;
@end