	//
	//  ScegliGiorno.m
	//  Per Due
	//
	//  Created by Giuseppe Lisanti on 02/05/11.
	//  Copyright 2011 __MyCompanyName__. All rights reserved.
	//

#import "Opzioni.h"


@implementation Opzioni

@synthesize giorni, provinceattive, fatto;


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 2;
}


- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { 
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


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { 
    switch (component) {
		case 0:
			return [provinceattive objectAtIndex:row]; 
			break;
		case 1:
			return [giorni objectAtIndex:row]; 
			break;
		default:
			return 0;
			break;
	}
}



- (void)viewDidLoad {
    [super viewDidLoad];
	[[fatto layer] setCornerRadius:8.0f];
	[[fatto layer] setMasksToBounds:YES];
	[fatto setBackgroundImage:[UIImage imageNamed:@"yellow3.jpg"] forState:UIControlStateNormal];
	defaults = [NSUserDefaults standardUserDefaults];

	NSString *testoSalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"citta"];
	NSLog(@"Testo salvato:%@", testoSalvato);
	self.provinceattive = [[[NSArray alloc] initWithObjects:
                           @"Qui vicino", @"Catania", @"Cosenza",  @"Firenze",
                           @"Frosinone",  @"Genova",  @"Grosseto", @"L'Aquila",
                           @"Latina",     @"Lecce",   @"Matera",   @"Napoli", 
                           @"Perugia",    @"Rieti",   @"Roma",     @"Siena",
                           @"Terni",      @"Trapani", @"Viterbo",
                           nil] autorelease];
	
	
	self.giorni = [[[NSArray alloc] initWithObjects:
                            @"Oggi",    @"Lunedì",  @"Martedì", @"Mercoledì",
							@"Giovedì", @"Venerdì", @"Sabato",  @"Domenica",
                            nil] autorelease];
	
	[optPicker  selectRow:[[defaults objectForKey:@"idcity"]integerValue] inComponent:0 animated:NO];
	[optPicker  selectRow:[[defaults objectForKey:@"idday"]integerValue] inComponent:1 animated:NO];
	NSLog(@"Indici selezionati: %d e %d\n",[[defaults objectForKey:@"idcity"]integerValue],[[defaults objectForKey:@"idday"]integerValue]);

}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	defaults = [NSUserDefaults standardUserDefaults];
	if (component == 0){
		if (row == 0) { 
            //scrivo solo "Qui" per non avere problemi con spazi vuoti
			NSString *city = @"Qui";
			[defaults setObject:city forKey:@"citta"];
			[defaults synchronize];
			
        } else { 
            //prendo direttamente il nome della proincia 
			NSString *city= [provinceattive objectAtIndex:row];
			[defaults setObject:city forKey:@"citta"];
			[defaults synchronize];
			
			}

		NSLog(@"Confermo che hai selezioanto la città %@ alla riga %d",[defaults objectForKey:@"citta"],row);
	}
	if (component == 1){
		NSString *day = [giorni objectAtIndex:row];
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
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    self.giorni = nil;
    self.provinceattive = nil;
    [super dealloc];
}


@end
