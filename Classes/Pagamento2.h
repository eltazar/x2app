//
//  Pagamento2.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Contatti.h"
#import "PerDueCItyCardAppDelegate.h"
#import "DatiPagamentoController.h"
//#import "DatiUtenteController.h"
#import "WMHTTPAccess.h"
#import "DataLoginController.h"
@class PickerViewController;

@interface Pagamento2 : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate, DatiPagamentoDelegate, /*DatiUtenteDelegate,*/WMHTTPAccessDelegate/*,DataLoginDelegate*/> {
	
    NSInteger identificativo;
	double valore;
	int quant;
	double totale;
	
    IBOutlet UIButton *compra;

	IBOutlet UILabel *titololabel;
	IBOutlet UILabel *datopersonale;

	NSString *titolo;

	//NSURL *url;
	IBOutlet UITableView *tablegenerale;


	NSMutableArray *rows;
	NSDictionary *dict;
	IBOutlet UITableViewCell *celladato;
	
	IBOutlet UITableViewCell *cellapag;
	IBOutlet UITableViewCell *celladatipagamento;
	IBOutlet UITableViewCell *celladaticarta;	
	IBOutlet UITableViewCell *cellamail;

	CGFloat animatedDistance;
    	    
    BOOL isQtField;
}

@property(nonatomic,retain)NSString *utente;
@property(nonatomic, retain)NSString *email;
@property(nonatomic,assign)int idUtente;
@property (nonatomic, readwrite) double  quant; 
@property (nonatomic, readwrite) double  valore; 
@property (nonatomic, readwrite) double  totale; 

@property (nonatomic, retain,) NSString *titolo;


@property (nonatomic, readwrite) NSInteger identificativo; 

@property (nonatomic,retain) IBOutlet UILabel *titololabel;
@property (nonatomic,retain) IBOutlet UILabel *datopersonale;

@property (nonatomic,retain) IBOutlet UITableView *tablegenerale;
@property (nonatomic, retain) IBOutlet UIViewController *vistadatipersonali;
@property (nonatomic, retain) IBOutlet UIViewController *vistadatipagamento;
@property (nonatomic, retain) IBOutlet UIButton *compra;

@property (nonatomic,retain) UIViewController *info;

-(IBAction)editingEnded:(id)sender;

- (IBAction)compra:(id)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (IBAction)OpenInfo:(id)sender;
- (IBAction)chiudi:(id)sender;
-(IBAction)logoutBtnClicked:(id)sender;

@end


