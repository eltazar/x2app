//
//  Pagamento2.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "DatiPers.h"
#import "DatiPag.h"
#import "Contatti.h"
#import "PerDueCItyCardAppDelegate.h"
#import "DatiPagamentoController.h"

@interface Pagamento2 : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIActionSheetDelegate, DatiPagamentoDelegate> {
	NSInteger identificativo;
	double valore;
	double quant;
	double totale;
	IBOutlet UIButton *compra;

	IBOutlet UILabel *titololabel;
	IBOutlet UILabel *datopersonale;

	NSString *titolo;
	IBOutlet UIViewController *vistadatipersonali;
	IBOutlet UIViewController *vistadatipagamento;

	NSURL *url;
	IBOutlet UITableView *tablegenerale;


	NSMutableArray *rows;
	NSDictionary *dict;
	IBOutlet UITableViewCell *celladato;
	
	IBOutlet UITableViewCell *cellapag;
	IBOutlet UITableViewCell *celladatipagamento;
	IBOutlet UITableViewCell *celladaticarta;	
	IBOutlet UITableViewCell *cellamail;

	IBOutlet UIView *quantitaPickerv;
	IBOutlet UIPickerView * quantitaPicker;
	NSArray *arrayQuantita;
	

	CGFloat animatedDistance;
	
	IBOutlet UIToolbar *confermaquantita;
	
	
    NSString * currentKey;
    UITextField * currentField;
	
	UIViewController *detail;
	IBOutlet UIViewController *info;
    
    

}


@property (nonatomic, readwrite) double  quant; 
@property (nonatomic, readwrite) double  valore; 
@property (nonatomic, readwrite) double  totale; 

@property (nonatomic, retain,) NSString *titolo;


@property (nonatomic, readwrite) NSInteger identificativo; 

@property (nonatomic,retain) IBOutlet UILabel *titololabel;
@property (nonatomic,retain) IBOutlet UILabel *datopersonale;
@property (nonatomic,retain) IBOutlet UITextField *campo;

@property (nonatomic,retain) IBOutlet UITableView *tablegenerale;
@property (nonatomic, retain) IBOutlet UIViewController *vistadatipersonali;
@property (nonatomic, retain) IBOutlet UIViewController *vistadatipagamento;
@property (nonatomic, retain) IBOutlet UIToolbar *confermaquantita;
@property (nonatomic, retain) IBOutlet UIButton *compra;

@property (nonatomic,retain) UIViewController *info;

-(IBAction)editingEnded:(id)sender;

- (IBAction)compra:(id)sender;
-(IBAction)confermaquantita:(id)sender;
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (IBAction)OpenInfo:(id)sender;
- (IBAction)chiudi:(id)sender;


@end


