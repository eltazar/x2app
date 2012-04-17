//
//  FindNearCompanyController2.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriaCommerciale.h"
#import "CartaPerDue.h"


@interface FindNearCompanyController : CategoriaCommerciale <CLLocationManagerDelegate> {
@private
    CartaPerDue *_card;
    CLLocationManager *_locationManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil card:(CartaPerDue *)card;

@end
