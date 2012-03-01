	//
	//  ScegliGiorno.m
	//  Per Due
	//
	//  Created by Giuseppe Lisanti on 02/05/11.
	//  Copyright 2011 __MyCompanyName__. All rights reserved.
	//

#import "Opzioni.h"


@implementation Opzioni

@synthesize giorni,provinceattive,lastIndexPath,fatto;


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { // This method needs to be used. It asks how many columns will be used in the UIPickerView
	return 2; // We only need one column so we will return 1.
}



- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { // This method also needs to be used. This asks how many rows the UIPickerView will have.
	switch (component) {
		case 0:
			return [provinceattive count];			
			break;
		case 1:
			return [giorni count];			
			break;
		default:
			return 0;
			break;
	}
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	switch (component) {
		case 0:
			return [provinceattive objectAtIndex:row]; // We will set a new row for every string used in the array.
			break;
		case 1:
			return [giorni objectAtIndex:row]; // We will set a new row for every string used in the array.
			break;
		default:
			return 0;
			break;
	}
	
}



	// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[super viewDidLoad];
	[[fatto layer] setCornerRadius:8.0f];
	[[fatto layer] setMasksToBounds:YES];
	[fatto setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
	defaults = [NSUserDefaults standardUserDefaults];

	NSString *testoSalvato=[[NSUserDefaults standardUserDefaults] objectForKey:@"citta"];
	NSLog(@"Testo salvato:%@",testoSalvato);
	NSArray *arraycitta = [[NSArray alloc] initWithObjects:@"Qui vicino",@"Catania",@"Cosenza",@"Firenze",@"Frosinone",@"Genova",@"Grosseto", @"L'Aquila", @"Latina",@"Lecce",@"Matera",@"Napoli",@"Perugia",@"Rieti",@"Roma",@"Siena",@"Terni",@"Trapani",@"Viterbo", nil];
	
	
	NSArray *arraygiorni = [[NSArray alloc] initWithObjects:@"Oggi",@"Lunedì",@"Martedì", @"Mercoledì",
							@"Giovedì", @"Venerdì", @"Sabato",@"Domenica", nil];
	
	self.provinceattive= arraycitta;
	self.giorni= arraygiorni;
	[optPicker  selectRow:[[defaults objectForKey:@"idcity"]integerValue] inComponent:0 animated:NO];
	[optPicker  selectRow:[[defaults objectForKey:@"idday"]integerValue] inComponent:1 animated:NO];
	NSLog(@"Indici selezionati: %d e %d\n",[[defaults objectForKey:@"idcity"]integerValue],[[defaults objectForKey:@"idday"]integerValue]);

}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	defaults = [NSUserDefaults standardUserDefaults];
	if (component==0){
		if(row==0){ //scrivo solo "Qui" per non avere problemi con spazi vuoti
			NSString *city= [NSString stringWithFormat:@"Qui"];
			[defaults setObject:city forKey:@"citta"];
			[defaults synchronize];
			
			}
		else { //prendo direttamente il nome della proincia 
			NSString *city= [NSString stringWithFormat:@"%@",[provinceattive objectAtIndex:row]];
			[defaults setObject:city forKey:@"citta"];
			[defaults synchronize];
			
			}

		NSLog(@"Confermo che hai selezioanto la città %@ alla riga %d",[defaults objectForKey:@"citta"],row);
	}
	if (component==1){
		NSString *day= [NSString stringWithFormat:@"%@",[giorni objectAtIndex:row]];
		[defaults setObject:day forKey:@"giorno"];
		[defaults synchronize];
		NSLog(@"Confermo che hai selezioanto il giorno %@ alla riga %d",[defaults objectForKey:@"giorno"],row);
	}
	

}


- (IBAction)chiudi:(id)sender {
	[defaults setObject:[NSNumber numberWithInt:[optPicker selectedRowInComponent:0]] forKey:@"idcity"];
	[defaults setObject:[NSNumber numberWithInt:[optPicker selectedRowInComponent:1]] forKey:@"idday"];
	[defaults synchronize];
	NSLog(@"Indici salvati: %d e %d\n",[[defaults objectForKey:@"idcity"]integerValue],[[defaults objectForKey:@"idday"]integerValue]);
    [self dismissModalViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
		// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
    [super dealloc];
}


@end
