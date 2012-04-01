//
//  AltreOfferte.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
//#import "Offerta.h"
#import "AsyncImageView.h"
#import "DatabaseAccess.h"
#import "Reachability.h"

@interface AltreOfferte : UIViewController <UITableViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,DatabaseAccessDelegate> {
	
    UITableView *tableview;
	NSMutableArray *rows;
	UIViewController *detail;
	NSMutableDictionary *dict;
	IBOutlet UITableViewCell *cellaofferte;
	//NSURL *url;
	IBOutlet UIView* footerView;
	IBOutlet UIActivityIndicatorView *CellSpinner;
    IBOutlet UILabel *citta;
    DatabaseAccess *dbAccess;
    IBOutlet UIActivityIndicatorView *spinnerView;
}


@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) NSMutableArray *rows;
@property (retain,nonatomic) NSMutableDictionary *dict;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *CellSpinner;

- (IBAction)Opzioni:(id)sender;
- (int)check:(Reachability*)curReach;
- (void) spinTheSpinner;
- (void) doneSpinning;
@end
