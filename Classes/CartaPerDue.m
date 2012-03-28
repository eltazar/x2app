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

@synthesize name = _name, surname = _surname, number =_number;


- (id) init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}


- (BOOL)isExpired {
    NSDate *now = [NSDate date];
    NSInteger currentMonth;
    NSInteger currentYear;
    
    NSDateComponents *dateComp = [[NSCalendar currentCalendar]components:(NSYearCalendarUnit | NSMonthCalendarUnit)  fromDate:now];
    currentYear = [dateComp year];
    currentMonth = [dateComp month];
    
    if (self.expiryYear > currentYear)
        return NO;
    else if (self.expiryYear == currentYear)
        if (self.expiryMonth > currentMonth)
            return NO;
        else
            return YES;
    else 
        return YES;
}


#pragma mark - Implementazione properties scadenza


- (void)setExpiryMonth:(NSInteger)newExpiryMonth{
    if (newExpiryMonth > 0 && newExpiryMonth < 13)
        _expiryMonth = newExpiryMonth;
}


- (void)setExpiryYear:(NSInteger)newExpiryYear{
    if (newExpiryYear > 2000 && newExpiryYear < 9999)
        _expiryYear = newExpiryYear;
}


- (NSInteger)expiryMonth {return _expiryMonth;}


- (NSInteger)expiryYear  {return _expiryYear;}


- (void)setExpiryString:(NSString *)expiryString {
    NSArray *tokens = [expiryString componentsSeparatedByString:@"/"];
    if (tokens.count == 2) {
        self.expiryMonth = [[tokens objectAtIndex:0] integerValue];
        self.expiryYear = [[tokens objectAtIndex:1] integerValue];
    }
}


- (NSString*)expiryString {
    return [NSString stringWithFormat: @"%2d/%4d", self.expiryMonth, self.expiryYear];
}


@end
