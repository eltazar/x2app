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
#import "WMHTTPAccess.h"

@interface Commenti : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, WMHTTPAccessDelegate> {
	
@private
    NSMutableArray *_dataModel; //era: rows
    BOOL didFetchAllComments;
    BOOL queryingMoreComments;
	NSInteger _idEsercente;
	NSString *_insegnaEsercente;
    
    UITableView *_tableview;
    UIActivityIndicatorView *_activityIndicator;
    
@protected
    NSString *urlFormatString;
}

@property (nonatomic, assign) NSInteger idEsercente; 
@property (nonatomic, retain) NSString *insegnaEsercente;
@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, retain, readonly) NSMutableArray *dataModel;


@end
