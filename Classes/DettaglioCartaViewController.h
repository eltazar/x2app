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
    CartaPerDue *_card;
    
    NSMutableArray *sectionData;
    NSMutableArray *sectionDescription;
    DatabaseAccess *dbAccess;
    BOOL isNotBind;
}

@property(nonatomic, retain)IBOutlet UIView *viewForImage;
@property(nonatomic,retain) CartaPerDue *card;

- (id)initWithCard:(CartaPerDue *)card;


@end
