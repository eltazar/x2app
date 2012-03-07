//
//  ControlloCartaController.h
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface ControlloCartaController : UIViewController

@property(nonatomic,retain) IBOutlet UIView *viewPulsante;
@property(nonatomic,retain) IBOutlet UIButton *cercaButton;
@property(nonatomic,retain) NSDictionary *datiCarta;

-(IBAction)cercaButtonClicked:(id)sender;
-(id)initWithCardDetail:(NSDictionary*)dati;

@end
