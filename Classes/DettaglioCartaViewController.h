//
//  ControlloCartaController.h
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CartaPerDue.h"


@interface DettaglioCartaViewController : UITableViewController {
    CartaPerDue *_card;
    
    NSMutableArray *sectionData;
    NSMutableArray *sectionDescription;
}

@property(nonatomic, retain)IBOutlet UIView *viewForImage;
@property(nonatomic,retain) CartaPerDue *card;

- (id)initWithCard:(CartaPerDue *)card;

- (IBAction)cercaButtonClicked:(id)sender;
- (IBAction)acquistaButtonClicked:(id)sender;
- (IBAction)richiediButtonClicked:(id)sender;


@end
