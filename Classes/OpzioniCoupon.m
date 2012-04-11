//
//  OpzioniCoupon.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 14/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OpzioniCoupon.h"


@implementation OpzioniCoupon


@synthesize province=_province;

@synthesize doneBtn=_doneBtn, optPicker=_optPicker;


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	[[self.doneBtn layer] setCornerRadius:8.0f];
	[[self.doneBtn layer] setMasksToBounds:YES];
	[self.doneBtn setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	NSString *testoSalvato=[[NSUserDefaults standardUserDefaults] objectForKey:@"cittacoupon"];
	NSLog(@"Testo salvato:%@",testoSalvato);
	self.province = [NSArray arrayWithObjects:
                       @"Agrigento", @"Alessandria", @"Ancona", @"Aosta", @"Arezzo",
                       @"Ascoli Piceno", @"Asti", @"Avellino", @"Bari", 
                       @"Barletta Andria Trani", @"Belluno", @"Benevento", @"Bergamo",
                       @"Biella", @"Bologna", @"Bolzano", @"Brescia", @"Brindisi",
                       @"Cagliari", @"Caltanissetta", @"Campobasso", @"Carbonia Iglesias",
                       @"Caserta", @"Catania", @"Catanzaro", @"Chieti", @"Como", 
                       @"Cosenza", @"Cremona", @"Crotone", @"Cuneo", @"Enna", @"Fermo",
                       @"Ferrara", @"Firenze", @"Foggia", @"Forli' - Cesena", 
                       @"Frosinone", @"Genova", @"Gorizia", @"Grosseto" @"Imperia",
                       @"Isernia", @"L'Aquila", @"La Spezia" ,@"Latina", @"Lecce",
                       @"Lecco", @"Livorno", @"Lodi", @"Lucca", @"Macerata", 
                       @"Mantova", @"Massa Carrara", @"Matera", @"Medio Campidano",
                       @"Messina", @"Milano", @"Modena", @"Monza Brianza", @"Napoli",
                       @"Novara", @"Nuoro", @"Ogliastra", @"Olbia Tempio", @"Oristano",
                       @"Padova", @"Palermo", @"Parma", @"Pavia", @"Perugia", @"Pesaro",
                       @"Pescara", @"Piacenza", @"Pisa", @"Pistoia", @"Pordenone",
                       @"Potenza", @"Prato", @"Ragusa", @"Ravenna", @"Reggio Calabria",
                       @"Reggio Emilia", @"Rieti", @"Rimini", @"Roma", @"Rovigo", 
                       @"Salerno", @"Sassari", @"Savona", @"Siena", @"Siracusa",
                       @"Sondrio", @"Taranto", @"Teramo", @"Terni", @"Torino",
                       @"Trapani", @"Trento", @"Treviso", @"Trieste", @"Udine",
                       @"Varese", @"Venezia", @"Verbania", @"Vercelli", @"Verona",
                       @"Vibo Valentia", @"Vicenza", @"Viterbo", nil];
	
	
	[self.optPicker selectRow:[[defaults objectForKey:@"idcitycoupon"] integerValue] inComponent:0 animated:NO];
	NSLog(@"Indice selezionato: %d\n",[[defaults objectForKey:@"idcitycoupon"]integerValue]);
}


- (void)viewDidUnload {
    [super viewDidUnload];
	self.province = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.doneBtn = nil;
    self.optPicker.dataSource = nil;
    self.optPicker.delegate = nil;
    self.optPicker = nil;
}


- (void)dealloc {
    self.province = nil;
    self.optPicker.dataSource = nil;
    self.optPicker.delegate = nil;
    self.optPicker = nil;
    [super dealloc];
}


#pragma mark - UIPickerViewDataSource


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { 
	switch (component) {
		case 0:
			return [self.province count];			
			break;
		default:
			return 0;
			break;
	}
}


#pragma mark - UIPickerViewDelegate


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	switch (component) {
		case 0:
			return [self.province objectAtIndex:row]; 
		default:
			return 0;
			break;
	}
	
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	if (component == 0 ) {
        NSString *citycoupon = [NSString stringWithFormat:@"%@", 
                                [self.province objectAtIndex:row]];
        [defaults setObject:citycoupon forKey:@"cittacoupon"];
        [defaults synchronize];
    }
	NSLog(@"Confermo che hai selezioanto la città %@ alla riga %d", 
          [defaults objectForKey:@"cittacoupon"], row);
}


#pragma mark OpzioniCoupon (IBActions)


- (IBAction)chiudi:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *cityIdx = [NSNumber numberWithInteger:[self.optPicker selectedRowInComponent:0]];
	[defaults setObject:cityIdx forKey:@"idcitycoupon"];
	[defaults synchronize];
	NSLog(@"Indice salvato: %d", [[defaults objectForKey:@"idcitycoupon"] integerValue]);
    [self dismissModalViewControllerAnimated:YES];
}




@end







