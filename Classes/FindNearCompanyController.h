//
//  FindNearCompanyController.h
//  PerDueCItyCard
//
//  Created by mario greco on 03/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface FindNearCompanyController : UITableViewController<DatabaseAccessDelegate>
{
    NSString *_urlString;
    NSMutableArray *_rows;
}

@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) NSMutableArray *rows;
@end
