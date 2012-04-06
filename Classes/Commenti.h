//
//  Commenti.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 27/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import "Commento.h"
#import "Reachability.h"
#import "DatabaseAccess.h"

@interface Commenti : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, DatabaseAccessDelegate> {
	
@private
    UITableView *_tableview;
    NSMutableArray *_dataModel; //era: rows
    BOOL didFetchAllComments;
    DatabaseAccess *_dbAccess;
	NSInteger _idEsercente;
	NSString *_insegnaEsercente;
}

@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, assign) NSInteger idEsercente; 
@property (nonatomic, retain) NSString *insegnaEsercente;


@end
