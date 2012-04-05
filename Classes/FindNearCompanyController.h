//
//  FindNearCompanyController.h
//  PerDueCItyCard
//
//  Created by mario greco on 03/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"
@class CartaPerDue;

@interface FindNearCompanyController : UITableViewController<DatabaseAccessDelegate>
{
    NSString *_urlString;
    NSMutableArray *_rows;
}

-(id) initWithCard:(CartaPerDue*)aCard;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSMutableArray *rows;
@end
