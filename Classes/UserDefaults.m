//
//  UserDefaults.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDefaults.h"

@implementation UserDefaults


+ (NSString *)city {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"citta"];
    
}

+ (NSString *)weekDay {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *dayFromDefaults = [NSString stringWithFormat:@"%@", [defaults objectForKey:@"giorno"]];
    
    if ([dayFromDefaults isEqualToString:@"Lunedì"]){
        return [[[NSString alloc] initWithString:@"Lunedi"] autorelease];
    }
    if ([dayFromDefaults isEqualToString:@"Martedì"]){
        return [[[NSString alloc] initWithString:@"Martedi"] autorelease];
    }
    if ([dayFromDefaults isEqualToString:@"Mercoledì"]){
        return [[[NSString alloc] initWithString:@"Mercoledi"] autorelease];
    }
    if ([dayFromDefaults isEqualToString:@"Giovedì"]){
        return [[[NSString alloc] initWithString:@"Giovedi"] autorelease];
    }
    if ([dayFromDefaults isEqualToString:@"Venerdì"]){
        return [[[NSString alloc] initWithString:@"Venerdi"] autorelease];
    }
    if ([dayFromDefaults isEqualToString:@"Sabato"]){
        return [[[NSString alloc] initWithString:@"Sabato"] autorelease];
    }
    if ([dayFromDefaults isEqualToString:@"Domenica"]){
        return [[[NSString alloc] initWithString:@"Domenica"] autorelease];
    }
    if ([dayFromDefaults isEqualToString:@"Oggi"]){
        NSDate *data = [NSDate date];
        
        int weekDay = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:data] weekday];
        
        switch (weekDay) {
            case 1:
                return [[[NSString alloc] initWithString:@"Domenica"] autorelease];
                break;
                
            case 2:
                return [[[NSString alloc] initWithString:@"Lunedi"] autorelease];
                break;
                
            case 3:
                return [[[NSString alloc] initWithString:@"Martedi"] autorelease];
                break;
                
            case 4:
                return [[[NSString alloc] initWithString:@"Mercoledi"] autorelease];
                break;
                
            case 5:
                return [[[NSString alloc] initWithString:@"Giovedi"] autorelease];
                break;
                
            case 6:
                return [[[NSString alloc] initWithString:@"Venerdi"] autorelease];
                break;
                
            case 7:
                return [[[NSString alloc] initWithString:@"Sabato"] autorelease];
                break;
                
            default:
                break;
                
        }
    }
    return [[[NSString alloc] init] autorelease];
}


@end
