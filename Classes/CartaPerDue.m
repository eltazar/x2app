//
//  CartaPerDue.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 20/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartaPerDue.h"
#import "DatabaseAccess.h"
#import "PerDueCItyCardAppDelegate.h"

@implementation CartaPerDue

@synthesize name, surname, expiryMonth, expiryYear, number;


- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (BOOL)isValid {
    NSDate *now = [NSDate date];
    NSInteger currentMonth;
    NSInteger currentYear;
    
    NSDateComponents *dateComp = [[NSCalendar currentCalendar]components:(NSYearCalendarUnit | NSMonthCalendarUnit)  fromDate:now];
    currentYear = [dateComp year];
    currentMonth = [dateComp month];
    
    if (self.expiryYear > currentYear)
        return YES;
    else if (self.expiryYear == currentYear)
        return (self.expiryMonth >= currentMonth);
    else 
        return NO;
}

- (void)queryAssociationToThisDevice {
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
