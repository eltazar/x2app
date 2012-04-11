//
//  FindNearCompanyController.h
//  PerDueCItyCard
//
//  Created by mario greco on 03/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WMHTTPAccess.h"

@class CartaPerDue;

@interface FindNearCompanyController : UITableViewController <WMHTTPAccessDelegate,CLLocationManagerDelegate>
{
    NSString *_urlString;
    NSMutableArray *_rows;
    CLLocationManager *locationManager;
}

-(id) initWithCard:(CartaPerDue*)aCard;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSMutableArray *rows;
@end
