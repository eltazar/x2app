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
	UITableView *_tableview;
	
    IBOutlet UITableViewCell *cellanews;
	IBOutlet UITableViewCell *cellafinale;
    
@private
    NSMutableArray *_dataModel; //era: rows
    BOOL didFetchAllComments;
    DatabaseAccess *_dbAccess;
	IBOutlet UILabel *_titolo;
	NSInteger _identificativo;
	NSString *_nome;
}

@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) UILabel *titolo;
@property (nonatomic, assign) NSInteger identificativo; 
@property (nonatomic, retain) NSString *nome;

- (int)aggiorna;


@end
