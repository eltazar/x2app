//
//  DettaglioEsercente.m
//  Per Due
//
//  Created by Gabriele "Whisky" Visconti on 04/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "DatabaseAccess.h"


@interface DettaglioEsercenteNew : UIViewController <UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,MKAnnotation, CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate, DatabaseAccessDelegate> {
    NSInteger _identificativo; 
    UIWebView *_webView;
    // IBOutlets:
    UITableView *_tableview;
    UIActivityIndicatorView *_activityIndicator;
    UIViewController *_mappa;
    UIViewController *_condizioni;
    UITextView *_cond;
    UISegmentedControl *_tipoMappa;
    MKMapView *_map;
    UITableViewCell *_cellavalidita;
    UIViewController *_sito;

	IBOutlet UITableViewCell *provacella;
	IBOutlet UITableViewCell *cellaindirizzo;
	IBOutlet UITableViewCell *CellaDettaglio1;
}


@property (nonatomic, assign) NSInteger identificativo; 
@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIViewController *mappa;
@property (nonatomic, retain) IBOutlet UIViewController *condizioni;
@property (nonatomic, retain) IBOutlet UITextView *cond;
@property (nonatomic, retain) IBOutlet UISegmentedControl *tipoMappa;
@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellavalidita;
@property (nonatomic, retain) IBOutlet UIViewController *sito;


- (IBAction)mostraTipoMappa:(id)sender;


@end


/*********************************************************************/


@interface IndexPathMapper : NSObject {}

- (void)setKey:(NSString *)key forSection:(NSInteger)section row:(NSInteger)row;
- (NSString *)keyForSection:(NSInteger)section row:(NSInteger)row; 
- (void)removeKeyAtSection:(NSInteger)section row:(NSInteger)row;
- (void)removeKey:(NSString *)key;

- (NSInteger)sections;
- (NSInteger)rowsInSection:(NSInteger)section;

- (void)setKey:(NSString *)key forIndexPath:(NSIndexPath *)indexPath;
- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath;
- (void)removeKeyAtIndexPath:(NSIndexPath *)indexPath;

@end






