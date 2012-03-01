//
//  Offerta.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 04/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import "PerDueCItyCardAppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "Info.h"
#import "DettaglioRistoPub.h"
#import "DettaglioEsercenti.h"
#import "DettaglioEsercenteGenerico.h"
#import "Coupon.h"
#import "FBConnect.h"
#import "FBSession.h"
#import "Reachability.h"

@interface Offerta : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,FBSessionDelegate,FBRequestDelegate>  {
	NSInteger identificativo;
	NSInteger identificativoesercente;

	IBOutlet UIViewController *insintesi;
	IBOutlet UIViewController *termini;
	IBOutlet UIViewController *dipiu;
	
	IBOutlet UIViewController *contatti;
	
	NSMutableArray *rows;
	NSDictionary *dict2;
	NSURL *url;
	NSURL *url2;
	NSDictionary *dict;
	UIViewController *detail;
	
	IBOutlet UILabel *titolo;
	IBOutlet UILabel *riepilogo;

	IBOutlet UILabel *sconto;
	IBOutlet UILabel *risparmio;
	IBOutlet UIButton *compra;
	IBOutlet UIButton *compratermini;
	IBOutlet UIButton *comprasintesi;
	IBOutlet UIButton *compradipiu;

	UITableView *tableview;
	IBOutlet UITableViewCell *cellacoupon;
	IBOutlet UITableViewCell *cellainfocoupon;
	IBOutlet UITableViewCell *cellanomesercente;

	NSString *sintesitxt;
	IBOutlet UIWebView *insintesitext;
	
	IBOutlet UIActivityIndicatorView *CellSpinner;
	
	NSString *condizionitext;
	IBOutlet UIWebView *condizionitxt;
	
	NSString *dipiutxt;
	IBOutlet UIWebView *dipiutext;
	int tipodettaglio;
	
	IBOutlet UILabel *tempo;
	
	NSTimer *timer;
	int secondsLeft;
	
	/*facebook*/
	UIAlertView *facebookAlert;
	FBSession *usersession;
	NSString *username;
	BOOL post;
    PerDueCItyCardAppDelegate *appDelegate;	
	Reachability* internetReach;
	Reachability* wifiReach;
	UIActionSheet *aSheet;
	UIActionSheet *aSheet2;
	IBOutlet UIViewController *fotoingrandita;
	IBOutlet UIImageView *photobig;
	IBOutlet UIViewController *faq;
	IBOutlet UIWebView *faqwebview;
	IBOutlet UILabel *titololabel; //Per view "In sintesi"



}

@property (nonatomic,retain) IBOutlet UILabel *titolo;
@property (nonatomic,retain) IBOutlet UILabel *riepilogo;
@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *CellSpinner;
@property (nonatomic,retain) IBOutlet UILabel *sconto;
@property (nonatomic,retain) IBOutlet UILabel *risparmio;
@property (nonatomic, retain) IBOutlet UIButton *compra;
@property (nonatomic, retain) IBOutlet UIButton *compratermini;
@property (nonatomic, retain) IBOutlet UIButton *comprasintesi;
@property (nonatomic, retain) IBOutlet UIButton *compradipiu;
@property (nonatomic, readwrite) NSInteger identificativo; 

@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic,retain) UIViewController *fotoingrandita;
@property (nonatomic,retain) UIViewController *faq;

@property (nonatomic,retain) IBOutlet UIImageView *photobig;
@property (nonatomic, retain) UIWebView *faqwebview;


/*facebook*/
@property(nonatomic,retain) UIAlertView *facebookAlert;
@property(nonatomic,retain) FBSession *usersession;
@property(nonatomic,retain) NSString *username;
@property(nonatomic,assign) BOOL post;

/*facebook*/
-(void)getFacebookName;
-(void)postToWall;


-(void)Paga:(id)sender;
-(int)check:(Reachability*) curReach;
- (void) spinTheSpinner;
- (void) doneSpinning;
- (IBAction)chiudi:(id)sender;
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;

@end