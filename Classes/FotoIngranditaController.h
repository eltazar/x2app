//
//  FotoIngranditaController.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 06/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CachedAsyncImageView.h"


@protocol FotoIngranditaDelegate;
@class Coupon;

@interface FotoIngranditaController : UIViewController  {
@private
    NSString *_imageUrl;
    //IBoutlets
    CachedAsyncImageView *_imageView;
}

@property (nonatomic, retain) IBOutlet CachedAsyncImageView *imageView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil imageUrlString:(NSString *)aUrl;

- (IBAction)chiudi:(id)sender;

    
@end


@protocol FotoIngranditaDelegate <NSObject>
- (IBAction)chiudi:(id)sender;
@end