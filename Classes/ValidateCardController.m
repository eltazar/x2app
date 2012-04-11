//
//  ValidateCardController.m
//  PerDueCItyCard
//
//  Created by mario greco on 05/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ValidateCardController.h"
#import "CartaPerDue.h"
#import "MBProgressHUD.h"
#import "PDHTTPAccess.h"


@interface ValidateCardController(){
    CartaPerDue *_card;
    NSDictionary *_company;
}
@property(nonatomic, retain) NSDictionary* company;
@property(nonatomic, retain) CartaPerDue *card;
@end

@implementation ValidateCardController
@synthesize card = _card;
@synthesize company = _company;
@synthesize pushView = _pushView, cardLabel = _cardLabel, companyLabel = _companyLabel;
@synthesize validateBtn = _validateBtn;

-(id) initWhitCard:(CartaPerDue*)aCard company:(NSDictionary*)aCompany{
    self = [super initWithNibName:@"ValidateCardController" bundle:nil];
    if(self){
        self.card = aCard;
        self.company = aCompany;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - WMHTTPAccessDelegate


-(void)didReceiveString:(NSString *)receivedString {
    NSLog(@"received data = %@", receivedString);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


-(void)didReceiveError:(NSError *)error{
    NSLog(@"error = %@", [error description]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore connessione" message:@"Non è stato possibile eseguire la richiesta, riprovare" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


#pragma mark - bottoni view


-(IBAction)validateRequestBtn:(id)sender{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Invio richiesta...";
    [PDHTTPAccess sendValidateRequest:self.card companyID:[[self.company objectForKey:@"IDesercente"]intValue] delegate:self];
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Verifica carta";
    
    self.companyLabel.text = [self.company objectForKey:@"Insegna_Esercente"];
    self.cardLabel.text = self.card.number;
    
    [self.validateBtn setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
    self.validateBtn.layer.cornerRadius = 6;
    self.validateBtn.layer.masksToBounds = YES;
    
    [self.view addSubview:self.pushView];
}


- (void)viewDidUnload {
    [super viewDidUnload];

    self.validateBtn = nil;
    self.cardLabel = nil;
    self.companyLabel = nil;
    self.pushView = nil;

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {

    
    self.validateBtn = nil;
    self.cardLabel = nil;
    self.companyLabel = nil;
    self.pushView = nil;
    self.company = nil;
    self.card = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
