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

@class IndexPathMapper;

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
    
@private
    IndexPathMapper *_idxMap;
    NSDictionary *_dataModel;
    DatabaseAccess *_dbAccess;
    BOOL isDataModelReady;
    
@protected
    BOOL isGenerico;
    BOOL isCoupon;
    NSString *urlString;
    NSString *urlStringCoupon;
    NSString *urlStringGenerico;
    NSString *urlStringValiditaCarta;
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

// property "protected" (na mezza specie): nell'interfaccia pubblica non ha l'ivar corrispondente, che è solo nella privata. nella privata viede ridefinita come readwrite.
@property (nonatomic, retain, readonly) NSDictionary *dataModel;
@property (nonatomic, retain, readonly) IndexPathMapper *idxMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil couponMode:(BOOL)couponMode genericoMode:(BOOL)genericoMode;
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
- (NSIndexPath *)indexPathForKey:(NSString *) key;


@end






