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

@synthesize name, surname, number;


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

#pragma mark - Implementazione properties scadenza
- (void) setExpiryMonth:(NSInteger)newExpiryMonth{
    if (newExpiryMonth > 0 && newExpiryMonth < 13)
        expiryMonth = newExpiryMonth;
}

- (void) setExpiryYear:(NSInteger)newExpiryYear{
    if (newExpiryYear > 2000 && newExpiryYear < 9999)
        expiryYear = newExpiryYear;
}

- (NSInteger) expiryMonth {return expiryMonth;}
- (NSInteger) expiryYear  {return expiryYear;}


- (void) setExpiryString:(NSString *)expiryString {
    NSArray *tokens = [expiryString componentsSeparatedByString:@"/"];
    if (tokens.count == 2) {
        self.expiryMonth = [[tokens objectAtIndex:0] integerValue];
        self.expiryYear = [[tokens objectAtIndex:1] integerValue];
    }
}

- (NSString*) expiryString {
    return [NSString stringWithFormat: @"%2d/%4d", self.expiryMonth, self.expiryYear];
}

#pragma mark - DatabaseAccessDelegate
// Ma va dichiarato da qualche parte che implemento sto delegato?

-(void)didReceiveCoupon:(NSDictionary *)dic{
    //Chiamare un metodo di un futuro delegato
}


//PALESE LEAK / DEALLOCAZIONE PREMATURA di dbAccess !! (pure senza debug se capisce)
//SISTEMARE ***SUBITO***




@end
