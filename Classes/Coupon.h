//
//  Coupon.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CJSONDeserializer.h"
#import "PerDueCItyCardAppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "AltreOfferte.h"
#import "Pagamento2.h"
#import "OpzioniCoupon.h"
#import "AsyncImageView.h"
#import "FBConnect.h"
#import "Facebook.h"

#import "DatabaseAccess.h"
#import "LoginControllerBis.h"

@interface Coupon : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,  FBSessionDelegate, FBDialogDelegate, FBRequestDelegate, DatabaseAccessDelegate,LoginControllerBisDelegate>{
        
	NSDictionary *_dataModel;
    NSInteger _idCoupon;
    
    // InfoCoupon.xib
    IBOutlet UILabel *_prezzoCouponLbl;
	IBOutlet UILabel *_scontoLbl;
	IBOutlet UILabel *_risparmioLbl;
    IBOutlet UILabel *_prezzoOrigLbl;
    IBOutlet UIActivityIndicatorView *_caricamentoImmagineSpinner;
    //
    IBOutlet UILabel *_titoloOffertaLbl; // è il testo a sx del tasto compra
    IBOutlet UIButton *_compraBtn;
    IBOutlet UIButton *_reloadBtn;
    IBOutlet UIActivityIndicatorView *_caricamentoSpinner;
    IBOutlet UILabel *_tempoLbl;    
    IBOutlet UITableView *_tableview;
    IBOutlet UIViewController *_FotoIngranditaViewController;
	IBOutlet UIImageView *_FotoIngranditaImageView;
    IBOutlet UIViewController *_dettagliOffertaViewContr;
	IBOutlet UIViewController *_terminiViewContr;
	IBOutlet UIViewController *_diPiuViewContr;
	IBOutlet UIViewController *_contattiViewContr;
    IBOutlet UIViewController *_faqViewController;
    IBOutlet UIWebView *_dettagliOffertaWebView;
	IBOutlet UIWebView *_condizioniWebView;
	IBOutlet UIWebView *_diPiuWebView;
    IBOutlet UIWebView *_faqWebView;

	IBOutlet UITableViewCell *_cellacoupon;
	IBOutlet UITableViewCell *_cellainfocoupon; //D
	IBOutlet UITableViewCell *_cellanomesercente; //D -> è identica a un'altra! O_O
    IBOutlet UITableViewCell *_cellaDescrizioneOfferta; //D
    IBOutlet UILabel *_cellaDescrizioneOffertaLbl;
}


@property (nonatomic, retain) NSDictionary *dataModel;
@property (nonatomic, assign) NSInteger idCoupon;

// InfoCoupon.xib
@property (nonatomic, retain) IBOutlet UILabel *prezzoCouponLbl;
@property (nonatomic, retain) IBOutlet UILabel *scontoLbl;
@property (nonatomic, retain) IBOutlet UILabel *risparmioLbl;
@property (nonatomic, retain) IBOutlet UILabel *prezzoOrigLbl;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *caricamentoImmagineSpinner;
//
@property (nonatomic, retain) IBOutlet UILabel *titoloOffertaLbl; // è il testo a sx del tasto compra
@property (nonatomic, retain) IBOutlet UIButton *compraBtn;
@property (nonatomic, retain) IBOutlet UIButton *reloadBtn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *caricamentoSpinner;
@property (nonatomic, retain) IBOutlet UILabel *tempoLbl;    
@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) IBOutlet UIViewController *FotoIngranditaViewController;
@property (nonatomic, retain) IBOutlet UIImageView *FotoIngranditaImageView;
@property (nonatomic, retain) IBOutlet UIViewController *dettagliOffertaViewContr;
@property (nonatomic, retain) IBOutlet UIViewController *terminiViewContr;
@property (nonatomic, retain) IBOutlet UIViewController *diPiuViewContr;
@property (nonatomic, retain) IBOutlet UIViewController *contattiViewContr;
@property (nonatomic, retain) IBOutlet UIViewController *faqViewController;
@property (nonatomic, retain) IBOutlet UIWebView *dettagliOffertaWebView;
@property (nonatomic, retain) IBOutlet UIWebView *condizioniWebView;
@property (nonatomic, retain) IBOutlet UIWebView *diPiuWebView;
@property (nonatomic, retain) IBOutlet UIWebView *faqWebView;

@property (nonatomic, retain) IBOutlet UITableViewCell *cellacoupon;
@property (nonatomic, retain) IBOutlet UITableViewCell *cellainfocoupon; //D
@property (nonatomic, retain) IBOutlet UITableViewCell *cellanomesercente; //D -> è identica a un'altra! O_O
@property (nonatomic, retain) IBOutlet UITableViewCell *cellaDescrizioneOfferta; //D
@property (nonatomic, retain) IBOutlet UILabel *cellaDescrizioneOffertaLbl; //D






/*facebook*/
-(void)getFacebookName;
-(void)postToWall;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isOffertaDelGiorno:(BOOL)isODG;

-(IBAction)refreshView:(id)sender;
- (IBAction)AltreOfferte:(id)sender;
//- (IBAction)Opzioni:(id)sender;
- (void)countDown;
-(void)Paga:(id)sender;

- (void) spinTheSpinner;
- (void) doneSpinning;
- (IBAction)chiudi:(id)sender;
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;

@end
