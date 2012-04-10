//
//  AltreOfferte.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 03/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import "AsyncImageView.h"
#import "DatabaseAccess.h"

@interface AltreOfferte : UIViewController <UITableViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,DatabaseAccessDelegate> {
@private
    NSMutableArray *_dataModel;
    DatabaseAccess *_dbAccess;
    // IBOs:
    UITableView *_tableview;
	UIView *_footerView;
	UIActivityIndicatorView *_cellSpinner;
    UILabel *_citta;
    UIActivityIndicatorView *_spinnerView;
}


@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *cellSpinner;
@property (nonatomic, retain) IBOutlet UILabel *citta;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinnerView;


- (IBAction)opzioni:(id)sender;


@end
