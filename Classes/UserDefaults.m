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
        return @"Lunedi";
    }
    if ([dayFromDefaults isEqualToString:@"Martedì"]){
        return @"Martedi";
    }
    if ([dayFromDefaults isEqualToString:@"Mercoledì"]){
        return @"Mercoledi";
    }
    if ([dayFromDefaults isEqualToString:@"Giovedì"]){
        return @"Giovedi";
    }
    if ([dayFromDefaults isEqualToString:@"Venerdì"]){
        return @"Venerdi";
    }
    if ([dayFromDefaults isEqualToString:@"Sabato"]){
        return @"Sabato";
    }
    if ([dayFromDefaults isEqualToString:@"Domenica"]){
        return @"Domenica";
    }
    if ([dayFromDefaults isEqualToString:@"Oggi"]){
        NSDate *data = [NSDate date];
        
        int weekDay = [[[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:data] weekday];
        
        switch (weekDay) {
            case 1:
                return @"Domenica";
                break;
                
            case 2:
                return @"Lunedi";
                break;
                
            case 3:
                return @"Martedi";
                break;
                
            case 4:
                return @"Mercoledi";
                break;
                
            case 5:
                return @"Giovedi";
                break;
                
            case 6:
                return @"Venerdi";
                break;
                
            case 7:
                return @"Sabato";
                break;
                
            default:
                break;
                
        }
    }
    return @"";
}


@end
