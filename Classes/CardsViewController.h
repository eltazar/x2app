//
//  CarteViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbbinaCartaViewController.h"
#import "LoginControllerBis.h"
#import "WMHTTPAccess.h"
#import "DataLoginController.h"

@interface CardsViewController : UITableViewController <AbbinaCartaDelegate, LoginControllerBisDelegate, WMHTTPAccessDelegate,DataLoginDelegate> { 
}

@end
