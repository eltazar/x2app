//
//  ControlloCartaController.h
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface ControlloCartaController : UIViewController

@property(nonatomic,retain) IBOutlet UIButton *cercaButton;
@property(nonatomic,retain) NSDictionary *datiCarta;
@property(nonatomic,retain) IBOutlet UILabel *cercaLabel;
@property(nonatomic,retain) IBOutlet UILabel *scadutaLabel;
@property(nonatomic,retain) IBOutlet UIButton *acquistaButton;
@property(nonatomic,retain) IBOutlet UIButton *richiediButton;

-(IBAction)cercaButtonClicked:(id)sender;
-(IBAction)acquistaButtonClicked:(id)sender;
-(IBAction)richiediButtonClicked:(id)sender;

-(id)initWithCardDetail:(NSDictionary*)dati;

@end
