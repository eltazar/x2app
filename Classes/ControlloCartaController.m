//
//  ControlloCartaController.m
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlloCartaController.h"
#import "RichiediCardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilita.h"

@implementation ControlloCartaController
@synthesize cercaButton, card, acquistaButton, richiediButton, cercaLabel, scadutaLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCard:(CartaPerDue *)aCard{
    
    self = [super initWithNibName:@"ControlloCartaController" bundle:nil];
    
    if(self){
        self.card = aCard;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Pulsanti  view

-(IBAction)cercaButtonClicked:(id)sender{
    
    NSLog(@"pulsante cerca premuto");
}

-(IBAction)acquistaButtonClicked:(id)sender{
    NSLog(@"pulsante acquista premuto");
    
    //carica sezione acquisti
}

-(IBAction)richiediButtonClicked:(id)sender{
    NSLog(@"pulsante richiedi premuto");
    
    //caricare come modal?
    
    RichiediCardViewController *richiediController = [[RichiediCardViewController alloc] initWithNibName:@"RichiediCardViewController" bundle:nil];
    
    [self.navigationController pushViewController:richiediController animated:YES];
    [richiediController release];

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //query su db per verificare se carta è stata abbinata ad altro dispositivo
    //se si viene mostrato avviso e rimuovere "cerca esercizi commerciali ...."
    //al suo posto mostare tasto "riabbina"
    //inoltre inserire tasto "rimuovi abbinamento"
    
    // Do any additional setup after loading the view from its nib.
    
    [scadutaLabel setHidden:YES];
    [acquistaButton setHidden:YES];
    [richiediButton setHidden:YES];
    
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
    if([Utilita isDateExpired:self.card.expiryString]){
        //attacco adesivo "scaduta"
        UIImageView *scadutaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scadutaImg.png"]];
        [scadutaView setFrame:CGRectMake(11, 20, 300, 180)];
        [self.view addSubview:scadutaView];
        [scadutaView release];
        
        //[viewPulsante removeFromSuperview];
        [cercaLabel setHidden:YES];
        [cercaButton setHidden:YES];
        [acquistaButton setHidden:NO];
        [richiediButton setHidden:NO];
        [scadutaLabel setHidden:NO];
    }

}

- (void)viewDidUnload
{
    self.richiediButton = nil;
    self.acquistaButton = nil;
    self.cercaButton = nil;
    self.scadutaLabel = nil;
    self.cercaLabel = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [cercaButton release];
    [scadutaLabel release];
    [cercaLabel release];
    [richiediButton release];
    [acquistaButton release];
    
    self.card = nil;
    
    [super dealloc];
}

@end
