//
//  ControlloCartaController.h
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CartaPerDue.h"
#import "DatabaseAccess.h"

@interface DettaglioCartaViewController : UITableViewController<DatabaseAccessDelegate> {
}

@property (nonatomic, retain) IBOutlet UIView *viewForImage;

- (id)initWithCard:(CartaPerDue *)card;


@end