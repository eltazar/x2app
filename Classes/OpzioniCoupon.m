//
//  OpzioniCoupon.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 14/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpzioniCoupon.h"


@implementation OpzioniCoupon

@synthesize province,lastIndexPath,fatto;


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { // This method needs to be used. It asks how many columns will be used in the UIPickerView
	return 1; // We only need one column so we will return 1.
}



- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { // This method also needs to be used. This asks how many rows the UIPickerView will have.
	switch (component) {
		case 0:
			return [province count];			
			break;
		default:
			return 0;
			break;
	}
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	switch (component) {
		case 0:
			return [province objectAtIndex:row]; // We will set a new row for every string used in the array.
		default:
			return 0;
			break;
	}
	
}



	// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[[fatto layer] setCornerRadius:8.0f];
	[[fatto layer] setMasksToBounds:YES];
	[fatto setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
	defaults = [NSUserDefaults standardUserDefaults];
	
	NSString *testoSalvato=[[NSUserDefaults standardUserDefaults] objectForKey:@"cittacoupon"];
	NSLog(@"Testo salvato:%@",testoSalvato);
	NSArray *arraycitta = [[NSArray alloc] initWithObjects:@"Agrigento",@"Alessandria",@"Ancona",@"Aosta",@"Arezzo",@"Ascoli Piceno",@"Asti",@"Avellino",@"Bari",@"Barletta Andria Trani",@"Belluno",@"Benevento",@"Bergamo",@"Biella",@"Bologna",@"Bolzano",@"Brescia",@"Brindisi",@"Cagliari",@"Caltanissetta",@"Campobasso",@"Carbonia Iglesias",@"Caserta",@"Catania",@"Catanzaro",@"Chieti",@"Como",@"Cosenza",@"Cremona",@"Crotone",@"Cuneo",@"Enna",@"Fermo",@"Ferrara",@"Firenze",@"Foggia",@"Forli' - Cesena",@"Frosinone",@"Genova",@"Gorizia",@"Grosseto",@"Imperia",@"Isernia",@"L'Aquila",@"La Spezia",@"Latina",@"Lecce",@"Lecco",@"Livorno",@"Lodi",@"Lucca",@"Macerata",@"Mantova",@"Massa Carrara",@"Matera",@"Medio Campidano",@"Messina",@"Milano",@"Modena",@"Monza Brianza",@"Napoli",@"Novara",@"Nuoro",@"Ogliastra",@"Olbia Tempio",@"Oristano",@"Padova",@"Palermo",@"Parma",@"Pavia",@"Perugia",@"Pesaro",@"Pescara",@"Piacenza",@"Pisa",@"Pistoia",@"Pordenone",@"Potenza",@"Prato",@"Ragusa",@"Ravenna",@"Reggio Calabria",@"Reggio Emilia",@"Rieti",@"Rimini",@"Roma",@"Rovigo",@"Salerno",@"Sassari",@"Savona",@"Siena",@"Siracusa",@"Sondrio",@"Taranto",
						   @"Teramo",@"Terni",@"Torino",@"Trapani",@"Trento",@"Treviso",@"Trieste",@"Udine",@"Varese",@"Venezia",@"Verbania",@"Vercelli",@"Verona",@"Vibo Valentia",@"Vicenza",@"Viterbo",nil];
	
	
		
	self.province= arraycitta;
	[optPicker  selectRow:[[defaults objectForKey:@"idcitycoupon"]integerValue] inComponent:0 animated:NO];
	NSLog(@"Indice selezionato: %d\n",[[defaults objectForKey:@"idcitycoupon"]integerValue]);
	
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	defaults = [NSUserDefaults standardUserDefaults];
	if (component==0){
			NSString *citycoupon= [NSString stringWithFormat:@"%@",[province objectAtIndex:row]];
			[defaults setObject:citycoupon forKey:@"cittacoupon"];
			[defaults synchronize];
			
		}
	NSLog(@"Confermo che hai selezioanto la città %@ alla riga %d",[defaults objectForKey:@"cittacoupon"],row);

	
}


- (IBAction)chiudi:(id)sender {
	[defaults setObject:[NSNumber numberWithInt:[optPicker selectedRowInComponent:0]] forKey:@"idcitycoupon"];
	[defaults synchronize];
	NSLog(@"Indice salvato: %d",[[defaults objectForKey:@"idcitycoupon"]integerValue]);
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