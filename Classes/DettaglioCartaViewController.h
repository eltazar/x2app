//
//  ControlloCartaController.h
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CartaPerDue.h"
#import "WMHTTPAccess.h"

//#define kDeletedCard            @"deletedCard"

@protocol DettaglioCartaViewControllerDelegate;

@interface DettaglioCartaViewController : UITableViewController <WMHTTPAccessDelegate> {
}

@property(nonatomic, assign) id<DettaglioCartaViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIView *viewForImage;

- (id)initWithCard:(CartaPerDue *)card;


@end


@protocol DettaglioCartaViewControllerDelegate <NSObject>

-(void)didDeleteCard:(id)sender;
-(void)didBuyRequest:(id)sender;

@end