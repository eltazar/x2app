//
//  ControlloCartaController.m
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DettaglioCartaViewController.h"
#import "RichiediCardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilita.h"

@implementation DettaglioCartaViewController


@synthesize card=_card;

@synthesize cercaLabel=_cercaLabel, cercaButton=_cercaButton, scadutaLabel=_scadutaLabel, acquistaButton=_acquistaButton, richiediButton=_richiediButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithCard:(CartaPerDue *)aCard {
    // Dato che nibName è nil, e non abbiamo fatto override di loadView, allora initwithNibName cerca di caricare nell'ordine: DettaglioCartaView.xib, DettaglioCartaViewController.xib.
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        self.card = aCard;
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"self.cercaLabel.shadowColor : %@", self.cercaLabel.shadowColor);
    //query su db per verificare se carta è stata abbinata ad altro dispositivo
    //se si viene mostrato avviso e rimuovere "cerca esercizi commerciali ...."
    //al suo posto mostare tasto "riabbina"
    //inoltre inserire tasto "rimuovi abbinamento"
    
    // Do any additional setup after loading the view from its nib.
    
    [self.scadutaLabel setHidden:YES];
    [self.acquistaButton setHidden:YES];
    [self.richiediButton setHidden:YES];
    
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundPattern.png"]]];
    
    UIImageView *cartaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartaGrande.png"]];
    [cartaView setFrame:CGRectMake(11, 20, 300, 180)];
    
    
    //    
    //    UITextField *titolareTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 191, 31)];
    //    titolareTextField.tag = 5;
    //    
    //    [self.view addSubview:titolareTextField];
    //    [self.view addSubview:cartaView];
    
    
    UITextField *titolareLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, cartaView.frame.size.height/2 + 10, 191, 28)];
    titolareLabel.font = [UIFont systemFontOfSize:15];
    titolareLabel.text = [NSString stringWithFormat:@"%@ %@", self.card.name, self.card.surname];
    //titolareLabel.tag = 5;
    
    
    UITextField *numeroCartaLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, cartaView.frame.size.height/2 + titolareLabel.frame.size.height+20, 160, 28)];
    numeroCartaLabel.font = [UIFont systemFontOfSize:15];
    numeroCartaLabel.text = self.card.number;
    //numeroCartaLabel.tag = 4;
    
    UITextField *scadenzaLabel = [[UITextField alloc] initWithFrame:CGRectMake(numeroCartaLabel.frame.origin.x+numeroCartaLabel.frame.size.width+50, cartaView.frame.size.height/2 + titolareLabel.frame.size.height+20, 100, 28)];
    scadenzaLabel.font = [UIFont systemFontOfSize:15];
    scadenzaLabel.text = self.card.expiryString;
    //scadenzaLabel.tag = 3;
    
    [cartaView addSubview:scadenzaLabel];
    [cartaView addSubview:numeroCartaLabel];
    [cartaView addSubview:titolareLabel];
    
    [self.view addSubview:cartaView];
    
    [cartaView release];
    [numeroCartaLabel release];
    [titolareLabel release];
    [scadenzaLabel release];
    
# warning TODO: rimuovere isDateExpired
    if ([Utilita isDateExpired:self.card.expiryString]) {
        //attacco adesivo "scaduta"
        UIImageView *scadutaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scadutaImg.png"]];
        [scadutaView setFrame:CGRectMake(11, 20, 300, 180)];
        [self.view addSubview:scadutaView];
        [scadutaView release];
        
        //[viewPulsante removeFromSuperview];
        [self.cercaLabel setHidden:YES];
        [self.cercaButton setHidden:YES];
        [self.acquistaButton setHidden:NO];
        [self.richiediButton setHidden:NO];
        [self.scadutaLabel setHidden:NO];
    }
}


- (void)viewDidUnload {
    self.cercaLabel = nil;
    self.cercaButton = nil;
    self.scadutaLabel = nil;
    self.acquistaButton = nil;
    self.richiediButton = nil;
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [_cercaLabel release];
    [_cercaButton release];
    [_scadutaLabel release];
    [_acquistaButton release];    
    [_richiediButton release];
    
    self.card = nil;
    
    [super dealloc];
}


#pragma mark - DettaglioCartaViewController


- (IBAction)cercaButtonClicked:(id)sender {
    NSLog(@"pulsante cerca premuto");
}


- (IBAction)acquistaButtonClicked:(id)sender {
    NSLog(@"pulsante acquista premuto");
}


- (IBAction)richiediButtonClicked:(id)sender {
    NSLog(@"pulsante richiedi premuto");
    // Caricare come modal?
    RichiediCardViewController *richiediController = [[RichiediCardViewController alloc] initWithNibName:@"RichiediCardViewController" bundle:nil];
    
    [self.navigationController pushViewController:richiediController animated:YES];
    [richiediController release];

}


@end
