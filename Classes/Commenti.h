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
	NSMutableArray *_dataModel; //era: rows
	IBOutlet UILabel *_titolo;
	NSInteger _identificativo;
	NSString *_nome;
    int indice;

	IBOutlet UITableViewCell *cellanews;
	IBOutlet UITableViewCell *cellafinale;
}

@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSMutableArray *dataModel;
@property (nonatomic, retain) UILabel *titolo;
@property (nonatomic, assign) NSInteger identificativo; 
@property (nonatomic, retain) NSString *nome;

- (int)aggiorna;


@end
