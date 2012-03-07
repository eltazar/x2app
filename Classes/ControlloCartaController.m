//
//  ControlloCartaController.m
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControlloCartaController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ControlloCartaController
@synthesize viewPulsante, cercaButton, datiCarta;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCardDetail:(NSDictionary*)dati{
    
    self = [super initWithNibName:@"ControlloCartaController" bundle:nil];
    
    if(self){
        self.datiCarta = dati;
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    viewPulsante.layer.cornerRadius = 6;
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroundPattern.png"]]];
    
    UIImageView *cartaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartaGrande.png"]];
    [cartaView setFrame:CGRectMake(11, 20, 300, 180)];
    cartaView.userInteractionEnabled = YES;
    
    
    //    
    //    UITextField *titolareTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 191, 31)];
    //    titolareTextField.tag = 5;
    //    
    //    [self.view addSubview:titolareTextField];
    //    [self.view addSubview:cartaView];
    
    
    UITextField *titolareLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, cartaView.frame.size.height/2 + 10, 191, 28)];
    titolareLabel.font = [UIFont systemFontOfSize:15];
    titolareLabel.text = [datiCarta objectForKey:@"titolare"];
    //titolareLabel.tag = 5;

    
    UITextField *numeroCartaLabel = [[UITextField alloc] initWithFrame:CGRectMake(10, cartaView.frame.size.height/2 + titolareLabel.frame.size.height+20, 160, 28)];
        numeroCartaLabel.font = [UIFont systemFontOfSize:15];
    numeroCartaLabel.text = [datiCarta objectForKey:@"tessera"];
    //numeroCartaLabel.tag = 4;
    
    UITextField *scadenzaLabel = [[UITextField alloc] initWithFrame:CGRectMake(numeroCartaLabel.frame.origin.x+numeroCartaLabel.frame.size.width+50, cartaView.frame.size.height/2 + titolareLabel.frame.size.height+20, 100, 28)];
    scadenzaLabel.font = [UIFont systemFontOfSize:15];
    scadenzaLabel.text = [datiCarta objectForKey:@"scadenza"];
    //scadenzaLabel.tag = 3;
    
    [cartaView addSubview:scadenzaLabel];
    [cartaView addSubview:numeroCartaLabel];
    [cartaView addSubview:titolareLabel];
    
    [self.view addSubview:cartaView];
    
    [cartaView release];
    [numeroCartaLabel release];
    [titolareLabel release];
    [scadenzaLabel release];


}

- (void)viewDidUnload
{
    self.cercaButton = nil;
    self.viewPulsante = nil;
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
    [viewPulsante release];
    self.datiCarta = nil;
    
    [super dealloc];
}

@end
