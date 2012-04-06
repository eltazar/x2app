//
//  Commento.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 27/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Commento.h"


@implementation Commento


@synthesize insegnaEsercente=_insegnaEsercente, data=_data, testoCommento=_testoCommento;
@synthesize insegnaEsercenteLbl=_insegnaEsercenteLbl, dataLbl=_dataLbl, testoCommentoTextView=_testoCommentoTextView;


/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
} */


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.insegnaEsercenteLbl.text   = self.insegnaEsercente;
	self.dataLbl.text               = self.data;
	self.testoCommentoTextView.text = self.testoCommento;

}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    self.insegnaEsercente = nil;
    self.data = nil;
    self.testoCommento = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.insegnaEsercenteLbl = nil;
    self.dataLbl = nil;
    self.testoCommentoTextView = nil;
}


- (void)dealloc {
    self.insegnaEsercente   = nil;
    self.data               = nil;
    self.testoCommento      = nil;
   
    self.insegnaEsercenteLbl    = nil;
    self.dataLbl                = nil;
    self.testoCommentoTextView  = nil;
    [super dealloc];
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

@end
