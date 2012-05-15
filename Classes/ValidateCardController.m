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
#import "WebViewController.h"


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
@synthesize pushView = _pushView, cardLabel = _cardLabel, companyLabel = _companyLabel, spinner;
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
    
    [self.spinner stopAnimating];
    
    if([receivedString isEqualToString:@"push"]){
        [self.validateBtn addTarget:self action:@selector(sendPush:) forControlEvents:UIControlEventTouchUpInside];
        
        [UIView animateWithDuration:0.2
                         animations:^(void){
                             self.validateBtn.alpha = 1.0;
                         }
         ];

    }
    else if([receivedString isEqualToString:@"webpage"]){
        [self.validateBtn addTarget:self action:@selector(launchWebPage:) forControlEvents:UIControlEventTouchUpInside];
        //[self.validateBtn setHidden:NO];
        [UIView animateWithDuration:0.2
                         animations:^(void){
                             self.validateBtn.alpha = 1.0;
                         }
         ];
        
    }
    else if([receivedString isEqualToString:@"not_found"]){
        
        //mostra label "esercente non accetta carta virtuale"
    }
    else {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
}


-(void)didReceiveError:(NSError *)error{
    
    [self.spinner stopAnimating];
    
    NSLog(@"error = %@", [error description]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore connessione" message:@"Non è stato possibile eseguire la richiesta, riprovare" delegate:self cancelButtonTitle:@"Chiudi" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


#pragma mark - bottoni view

-(void)launchWebPage:(id)sender{
    NSLog(@"lancio safari = %@",self.card.number);

    //lancia safari con i dati in GET
    /*
    NSString *numberMod = [self.card.number stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/app_esercenti/verificaCarta.php?name=%@&surname=%@&number=%@",self.card.name,self.card.surname,numberMod];
    NSLog(@"url string = %@",    urlString);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
     */
  
    NSString *numberMod = [self.card.number stringByReplacingOccurrencesOfString:@" " withString:@"_"];

    NSString *urlString = [NSString stringWithFormat: @"http://www.cartaperdue.it/partner/app_esercenti/verificaCarta.php?name=%@&surname=%@&number=%@",self.card.name,self.card.surname,numberMod];
   
    WebViewController *webViewController = [[WebViewController alloc] initWithUrlString:urlString];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    
    [self.navigationController presentModalViewController:navController animated:YES];

    [webViewController release];
    [navController release];
}


-(IBAction)sendPush:(id)sender{
    
    NSLog(@"lancio push");
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Invio richiesta...";
    [PDHTTPAccess sendValidateRequest:self.card companyID:[[self.company objectForKey:@"IDesercente"]intValue] delegate:self];
}


#pragma mark - View lifecycle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.spinner startAnimating];
    [PDHTTPAccess checkCompanyValidateMethod:[[self.company objectForKey:@"IDesercente"] intValue]  delegate:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Verifica carta";
    
    self.companyLabel.text = [self.company objectForKey:@"Insegna_Esercente"];
    self.cardLabel.text = self.card.number;
    
    [self.validateBtn setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
    self.validateBtn.layer.cornerRadius = 6;
    self.validateBtn.layer.masksToBounds = YES;
    //nascondo appena caricata la view
    //[self.validateBtn setHidden:YES];
    self.validateBtn.alpha = 0.0;
    [self.view addSubview:self.pushView];
}


- (void)viewDidUnload {
    

    self.spinner = nil;
    self.validateBtn = nil;
    self.cardLabel = nil;
    self.companyLabel = nil;
    self.pushView = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {

    self.spinner = nil;
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
