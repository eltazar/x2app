//
//  Utilita.m
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilita.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@implementation Utilita

+(BOOL)isNumeric:(NSString*)inputString{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

+(BOOL)isStringEmptyOrWhite:(NSString*)string{
    
    //controlla che le stringhe non siano ne vuote ne formate da soli spazi bianchi
    if([allTrim(string) length] == 0)       
        return FALSE ;
    else return TRUE;
}

+(BOOL)isEmailValid:(NSString*)email{
    
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:email];

}

+(BOOL)isDateFormatValid:(NSString*)data{
    
 
    //controlla formato della stringa scadenza
    if([data isEqualToString:@"--/--"] || [[data substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"--"] || [[data substringWithRange:NSMakeRange(3, 2)] isEqualToString:@"--"]){
        return FALSE;
    }
    else return TRUE;
    
}

@end
