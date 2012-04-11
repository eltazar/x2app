//
//  CarteViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbbinaCartaViewController.h"
#import "DatabaseAccess.h"
#import "LoginControllerBis.h"
@interface CardsViewController : UITableViewController <AbbinaCartaDelegate, DatabaseAccessDelegate,LoginControllerBisDelegate>
{ 
}

@end
