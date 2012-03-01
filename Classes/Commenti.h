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

@interface Commenti : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate> {
	UITableView *tableview;
	NSMutableArray *rows;
	NSInteger identificativo;
	NSMutableDictionary *dict;
	IBOutlet UITableViewCell *cellanews;
	IBOutlet UITableViewCell *cellafinale;
	NSString *Nome;
	IBOutlet UILabel *titolo;
	int indice;
	UIViewController *detail;
	NSURL *url;
	Reachability* internetReach;
	Reachability* wifiReach;


}

@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) UILabel *titolo;
@property (retain,nonatomic) NSMutableDictionary *dict;
@property (nonatomic, readwrite) NSInteger identificativo; 
@property (nonatomic, retain) NSString *Nome;
@property (nonatomic, retain) NSURL *url;

- (int)aggiorna;
- (void) spinTheSpinner;
- (void) doneSpinning;
-(int)check:(Reachability*) curReach;

@end
