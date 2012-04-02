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
    NSInteger currentDay;
    
    NSDateComponents *dateComp = [[NSCalendar currentCalendar]components:(NSYearCalendarUnit | NSMonthCalendarUnit)  fromDate:now];
    currentYear = [dateComp year];
    currentMonth = [dateComp month];
    currentDay = [dateComp day];
    
    if (self.expiryYear > currentYear)
        return NO;
    else if (self.expiryYear == currentYear)
        if (self.expiryMonth > currentMonth)
            return NO;
        else if (self.expiryMonth == currentMonth)
            if (self.expiryDay > currentDay)
                return NO;
    else 
        return YES;
}


#pragma mark - Implementazione properties scadenza


- (void)setExpiryDay:(NSInteger)newExpiryDay {
    NSInteger maxExpiryDay = 0;
    if (newExpiryDay > 0) {
        switch (self.expiryMonth) {
            case 10:    // Trenta dì conta Novembre,
            case  4:    // con April,
            case  6:    // Giugno
            case  9:    // e Settembre
                maxExpiryDay = 30;
                break;
                
            case  2:    // Di ventotto ce n'è uno
                maxExpiryDay = 28;
                break;
                
            default:    // Tutti gli altri ne han trentuno! :D
                maxExpiryDay = 31;
        }
        if (newExpiryDay <= maxExpiryDay)
            _expiryDay = newExpiryDay;
    }
}


- (void)setExpiryMonth:(NSInteger)newExpiryMonth{
    if (newExpiryMonth > 0 && newExpiryMonth < 13)
        _expiryMonth = newExpiryMonth;
}


- (void)setExpiryYear:(NSInteger)newExpiryYear{
    if (newExpiryYear > 2000 && newExpiryYear < 9999)
        _expiryYear = newExpiryYear;
}


- (NSInteger)expiryDay {return _expiryDay;}


- (NSInteger)expiryMonth {return _expiryMonth;}


- (NSInteger)expiryYear  {return _expiryYear;}


- (void)setExpiryString:(NSString *)expiryString {
    NSArray *tokens = [expiryString componentsSeparatedByString:@"/"];
    if (tokens.count == 3) {
        self.expiryYear  = [[tokens objectAtIndex:2] integerValue];
        self.expiryMonth = [[tokens objectAtIndex:1] integerValue];
        self.expiryDay   = [[tokens objectAtIndex:0] integerValue];
    }
}


- (NSString*)expiryString {
    return [NSString stringWithFormat: @"%02d/%02d/%04d", self.expiryDay, self.expiryMonth, self.expiryYear];
}


@end
