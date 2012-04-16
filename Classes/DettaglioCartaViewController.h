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

#define kDeletedCard            @"deletedCard"

@interface DettaglioCartaViewController : UITableViewController <WMHTTPAccessDelegate> {
}

@property (nonatomic, retain) IBOutlet UIView *viewForImage;

- (id)initWithCard:(CartaPerDue *)card;


@end