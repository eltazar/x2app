//
//  LoginController.m
//  PerDueCItyCard
//
//  Created by mario greco on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"
#import "RegistrazioneController.h"

@implementation LoginController
@synthesize usr,psw,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - DBAccessDelegate

-(void)didReceiveCoupon:(NSDictionary *)coupon{
    
    NSLog(@"VALORE RITORNATO DA SERVER CHECK EMAIL = %@",coupon);
    
    NSArray *array;//= [[coupon objectForKey:@"checkEmail"] retain];
    
   // NSLog(@"DIMENSIONE ARRAY = %d",[array count]);
    
    if([coupon objectForKey:@"checkEmail"]){
      
        array = [[coupon objectForKey:@"checkEmail"] retain];  
        
        if(array.count == 2){
            NSLog(@"UTENTE ESISTE");
            idUtente = [[[array objectAtIndex:0] objectForKey:@"idcustomer"] intValue];
            NSLog(@" ID CUSTOMER CHECK = %d",idUtente);
            
            //mostro altri campi
            [messaggioEmailTrue setHidden:NO];
            [pswLabel setHidden:NO];
            [pswTextField setHidden:NO];
            [nonRicordoPswLabel setHidden:NO];
            [ricordaBtn setHidden:NO];
            
            emailTextField.enabled = NO;
        }
        else{
            NSLog(@"UTENTE NN ESISTE");
            
            //lancio controller registrazione
            RegistrazioneController *regController = [[RegistrazioneController alloc] initWithNibName:@"RegistrazioneController" bundle:nil];
            [self.navigationController pushViewController:regController animated:YES];
            [regController release];
        }
        
    }
    else if([coupon objectForKey:@"login"]){
            array = [[coupon objectForKey:@"login"] retain];
        if(array.count == 2){
            NSLog(@"UTENTE ESISTE");
            idUtente = [[[array objectAtIndex:0] objectForKey:@"idcustomer"] intValue];
            NSLog(@" ID CUSTOMER LOGIN = %d",idUtente);
            
            if(delegate && [delegate respondsToSelector:@selector(didLogin:)])
                [delegate didLogin:idUtente];
            
        }
        else{
            NSLog(@"PSW SBAGLIATA ");
        }
    }
    
    [array release];
    
}

-(void)didReceiveError:(NSError *)error{
    
    NSLog(@"ERRORE CHECK EMAIL SU SERVER = %@",[error description]);
}

#pragma mark - TextField and TextView Delegate

- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    if( txtField.tag == 10){
        self.usr = txtField.text;
    }
    else if(txtField.tag == 11){
        self.psw = txtField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    if(textField.tag ==10 && ![textField.text isEqualToString:@""]){
        NSLog(@"lancia query email");
        NSArray *data = [NSArray arrayWithObject:textField.text];
        [dbAccess checkUserFields:data];        
    }
    else if(textField.tag == 11){
        NSLog(@"lancia query email+psw");
        NSArray *data = [NSArray arrayWithObjects:self.usr, textField.text,nil];
        [dbAccess checkUserFields:data];
    }
	[textField resignFirstResponder];
	return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    utente = @"";
    
    dbAccess = [[DatabaseAccess alloc] init];
    dbAccess.delegate = self;
    
    [pswLabel setHidden:YES];
    [pswTextField setHidden:YES];
    [messaggioEmailTrue setHidden:YES];
    [nonRicordoPswLabel setHidden:YES];
    [ricordaBtn setHidden:YES];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Memory Management

- (void)dealloc {
    [dbAccess release];
    [super dealloc];
}

@end
