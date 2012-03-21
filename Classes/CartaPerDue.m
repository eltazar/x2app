//
//  CartaPerDue.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 20/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartaPerDue.h"
#import "DatabaseAccess.h"

@implementation CartaPerDue

@synthesize name, surname, expiryDate, number;


- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (BOOL)isValid {
    return ([[NSDate date] laterDate:self.expiryDate] == self.expiryDate);  
}

- (void) queryAssociationToThisDevice {
    DatabaseAccess*  dbAccess = [[DatabaseAccess init] autorelease]; 
    [dbAccess checkThisDeviceAssociatedWithCard:self.number];

}

#pragma mark - DatabaseAccessDelegate
// Ma va dichiarato da qualche parte che implemento sto delegato?

-(void)didReceiveCoupon:(NSDictionary *)dic{
    //Chiamare un metodo di un futuro delegato
}


//PALESE LEAK / DEALLOCAZIONE PREMATURA di dbAccess !! (pure senza debug se capisce)
//SISTEMARE ***SUBITO***

@end
