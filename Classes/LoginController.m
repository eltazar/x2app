//
//  LoginController.m
//  PerDueCItyCard
//
//  Created by mario greco on 12/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginController.h"
#import "RegistrazioneController.h"

/*l *emailLabel;
 @property(nonatomic,retain) IBOutlet UILabel *pswLabel;
 @property(nonatomic,retain) IBOutlet UILabel *messaggioEmailTrue;
 @property(nonatomic,retain) IBOutlet UITextField *emailTextField;
 @property(nonatomic,retain) IBOutlet UITextField *pswTextField;*/

@implementation LoginController
@synthesize usr,psw,delegate, pswLabel,emailLabel, messaggioEmailTrue, emailTextField, pswTextField,nonRicordoPswLabel,ricordaBtn;

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
            
            //emailTextField.enabled = NO;
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

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField.tag == 11){
        
        [UIView animateWithDuration:0.2
                         animations:^(void){
                             self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - 50, self.view.frame.size.width, self.view.frame.size.height);
                         }
                        completion:^(BOOL finished){
        
                        }
         ];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    if( txtField.tag == 10){
        self.usr = txtField.text;
    }
    else if(txtField.tag == 11){
        self.psw = txtField.text;
        [UIView animateWithDuration:0.1
                         animations:^(void){
                             self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y + 50, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished){
                             
                         }
         ];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    if(textField.tag == 10 && ![textField.text isEqualToString:@""] && [pswTextField isHidden]){
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

#pragma mark - Gestione bottoni view
-(void)cancel{
    
    if(delegate && [delegate respondsToSelector:@selector(didAbortLogin)])
        [self.delegate didAbortLogin];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:139.0/255 green:29.0/255 blue:0.0 alpha:1]];
    
    //UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Conferma" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = cancelBtn;
    //self.navigationItem.rightBarButtonItem = saveBtn;
    
    //[saveBtn release];
    [cancelBtn release];
    
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
    self.emailLabel = nil;
    self.pswLabel = nil;
    self.messaggioEmailTrue = nil;
    self.emailTextField = nil;
    self.pswTextField = nil;
    self.ricordaBtn = nil;
    self.nonRicordoPswLabel = nil;
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
    
    [nonRicordoPswLabel release];
    [ricordaBtn release];
    [emailLabel release];
    [pswLabel release];
    [messaggioEmailTrue release];
    [pswTextField release];
    [emailTextField release];
    
    [dbAccess release];
    [super dealloc];
}

@end
