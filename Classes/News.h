//
//  News.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "Reachability.h"
#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import "Notizia.h"
#import "Info.h"
#import "Reachability.h"
#import "DatabaseAccess.h"

@interface News: UITableViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
	NSMutableArray *rows;
	UIViewController *detail;
	NSMutableDictionary *dict;
	IBOutlet UITableViewCell *cellanews;
	IBOutlet UITableViewCell *cellafinale;
	int indice;
	NSURL *url;
	Reachability* internetReach;
	Reachability* wifiReach;
    
    DatabaseAccess *dbAccess;
}


@property (nonatomic, retain) NSMutableArray *rows;
@property (retain,nonatomic) NSMutableDictionary *dict;
@property (nonatomic, retain) NSArray *lista;
@property (nonatomic, retain) NSURL *url;


- (IBAction)OpenInfo:(id)sender;
- (int)aggiorna;
- (void) spinTheSpinner;
- (void) doneSpinning;
-(int)check:(Reachability*) curReach;

@end
