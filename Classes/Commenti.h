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

@interface Commenti : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	UITableView *_tableview;
	NSMutableArray *_rows;
	NSMutableDictionary *_dict;
	IBOutlet UILabel *_titolo;
	NSInteger _identificativo;
	NSString *_nome;
	NSURL *_url;
    int indice;
	UIViewController *detail;
	Reachability* internetReach;
	Reachability* wifiReach;

	IBOutlet UITableViewCell *cellanews;
	IBOutlet UITableViewCell *cellafinale;
}

@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSMutableDictionary *dict;
@property (nonatomic, retain) UILabel *titolo;
@property (nonatomic, assign) NSInteger identificativo; 
@property (nonatomic, retain) NSString *nome;
@property (nonatomic, retain) NSURL *url;

- (int)aggiorna;
- (void) spinTheSpinner;
- (void) doneSpinning;
- (int)check:(Reachability*) curReach;

@end
