//
//  AbbinaCartaViewController.m
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbbinaCartaViewController.h"

@implementation AbbinaCartaViewController

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

#pragma mark - UITextField delegate
- (void)textFieldDidEndEditing:(UITextField *)txtField
{   
    
    if(txtField.tag == 5){
        
    }
    else if(txtField.tag == 4){
        
    }
    else if(txtField.tag == 3){
        
    }
 

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{ 
    
    // riabbasso la view se si tratta dei texfield relativi a numeroCarta e scadenz
    if(isViewUp){
        [UIView animateWithDuration:0.3 animations:^void{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+25, self.view.frame.size.width, self.view.frame.size.height)];
        }
                         completion:^(BOOL finished){
                             isViewUp = FALSE;
                         }
         ];    
    }
	[textField resignFirstResponder];
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"iniziato editing");
    
    //alzo la view se si tratta dei texfield relativi a numeroCarta e scadenza
    
    if(!isViewUp){
        [UIView animateWithDuration:0.3 animations:^void{
            [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-25, self.view.frame.size.width, self.view.frame.size.height)];
        }
                         completion:^(BOOL finished){
                             isViewUp = TRUE;
                         }
        ];    
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"bla";
    
    isViewUp = FALSE;
    
    
    UIImageView *cartaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartaGrande.png"]];
    [cartaView setFrame:CGRectMake(11, 40, 300, 180)];
    cartaView.userInteractionEnabled = YES;
    
    
    //    
//    UITextField *titolareTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 191, 31)];
//    titolareTextField.tag = 5;
//    
//    [self.view addSubview:titolareTextField];
//    [self.view addSubview:cartaView];
    
    
    UITextField *titolareField = [[UITextField alloc] initWithFrame:CGRectMake(10, cartaView.frame.size.height/2 + 10, 191, 28)];
    titolareField.borderStyle = UITextBorderStyleRoundedRect;
    titolareField.font = [UIFont systemFontOfSize:15];
    titolareField.placeholder = @"Titolare";
    titolareField.autocorrectionType = UITextAutocorrectionTypeNo;
    titolareField.keyboardType = UIKeyboardTypeDefault;
    titolareField.returnKeyType = UIReturnKeyDone;
    titolareField.clearButtonMode = UITextFieldViewModeWhileEditing;
    titolareField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;   
    titolareField.tag = 5;
    titolareField.delegate = self;
    
    UITextField *numeroCartaField = [[UITextField alloc] initWithFrame:CGRectMake(10, cartaView.frame.size.height/2 + titolareField.frame.size.height+20, 160, 28)];
    numeroCartaField.borderStyle = UITextBorderStyleRoundedRect;
    numeroCartaField.font = [UIFont systemFontOfSize:15];
    numeroCartaField.placeholder = @"Numero carta";
    numeroCartaField.autocorrectionType = UITextAutocorrectionTypeNo;
    numeroCartaField.keyboardType = UIKeyboardTypeDefault;
    numeroCartaField.returnKeyType = UIReturnKeyDone;
    numeroCartaField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numeroCartaField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
    numeroCartaField.tag = 4;
    numeroCartaField.delegate = self;
    
    UITextField *scadenzaField = [[UITextField alloc] initWithFrame:CGRectMake(numeroCartaField.frame.origin.x+numeroCartaField.frame.size.width+20, cartaView.frame.size.height/2 + titolareField.frame.size.height+20, 100, 28)];
    scadenzaField.borderStyle = UITextBorderStyleRoundedRect;
    scadenzaField.font = [UIFont systemFontOfSize:15];
    scadenzaField.placeholder = @"Scadenza";
    scadenzaField.autocorrectionType = UITextAutocorrectionTypeNo;
    scadenzaField.keyboardType = UIKeyboardTypeDefault;
    scadenzaField.returnKeyType = UIReturnKeyDone;
    scadenzaField.clearButtonMode = UITextFieldViewModeWhileEditing;
    scadenzaField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter; 
    scadenzaField.tag = 3;
    scadenzaField.delegate = self;
    
    [cartaView addSubview:scadenzaField];
    [cartaView addSubview:numeroCartaField];
    [cartaView addSubview:titolareField];
    [numeroCartaField release];
    [titolareField release];
    [scadenzaField release];
    [self.view addSubview:cartaView];
    
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

@end
