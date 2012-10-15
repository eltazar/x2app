//
//  Utilita.m
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilita.h"
#import "Reachability.h"

#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

@implementation Utilita


+ (BOOL)networkReachable {
    Reachability *r = [[Reachability reachabilityForInternetConnection] retain];
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    BOOL result = NO;
    
    if(internetStatus == ReachableViaWWAN){
        //NSLog(@"3g");
        result =  YES;
        
    }
    else if(internetStatus == ReachableViaWiFi){
        //NSLog(@"Wifi");
        result = YES;
        
    }
    else if(internetStatus == NotReachable){
        result = NO;        
    }
    
    [r release];
    
    return  result;
}

+(NSString*)today{

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
            return @"";
            break;
    }

}

+ (NSString*)checkPhoneNumber:(NSString*) _phone {
    
    if([_phone isEqualToString:@""]){
        return @"";
    }
    
    BOOL isPlus = FALSE;
    
    //NSLog(@"_PHONE = %@",_phone);
    
    //se il numero di telefono ha il prefisso internazionale che comincia con +
    if([[_phone substringWithRange:NSMakeRange(0,1)] isEqualToString:@"+"]){
        isPlus = TRUE;
    }
    
    NSMutableString *strippedString = [NSMutableString 
                                       stringWithCapacity:_phone.length+1];
    
    NSScanner *scanner = [NSScanner scannerWithString:_phone];
    NSCharacterSet *numbers = [NSCharacterSet 
                               characterSetWithCharactersInString:@"0123456789"];
    
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            
            //reinserisco il + ad inizio stringa
            if(isPlus){
                strippedString = [NSMutableString stringWithFormat:@"%@",@"%2B"];
                //NSLog(@"stripped -> = %@",strippedString);
                isPlus = FALSE;
            }
            
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    
    //NSLog(@"STRIPPED STRING = %@",strippedString);

    return strippedString;
    
    /*
     if(![job.phone isEqualToString:@""] && [[job.phone substringWithRange:NSMakeRange(0,1)] isEqualToString:@"+"]){
     phoneTmp = [NSMutableString stringWithFormat:@"%@",job.phone];
     [phoneTmp setString:[phoneTmp stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]];
     }
     else{
     phoneTmp = [NSMutableString stringWithFormat:@"%@",job.phone];
     }
     */

}

+ (BOOL)isNumeric:(NSString*)inputString {
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

+ (BOOL)isStringEmptyOrWhite:(NSString*)string {
    
    //controlla che le stringhe non siano ne vuote ne formate da soli spazi bianchi
    if([allTrim(string) length] == 0)       
        return FALSE ;
    else return TRUE;
}

+ (BOOL)isEmailValid:(NSString*)email {
    
    NSString* emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:email];

}

+ (BOOL)isDateFormatValid:(NSString*)data {
    //controlla formato della stringa scadenza
    if([data isEqualToString:@"--/--"] || [[data substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"--"] || [[data substringWithRange:NSMakeRange(3, 2)] isEqualToString:@"--"]){
        return FALSE;
    }
    else return TRUE;
    
}


+ (NSString *)dateStringFromMySQLDate:(NSString *)mySQLDate {
    NSDateFormatter *mySQLDateFormatter = [[NSDateFormatter alloc] init];
    [mySQLDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter *appPerDueDateFormatter = [[NSDateFormatter alloc] init];
    [appPerDueDateFormatter setDateFormat:@"dd-MM-YYYY"];
    
    NSDate *date = [mySQLDateFormatter dateFromString:mySQLDate];
    NSString *appPerDueDate = [appPerDueDateFormatter stringFromDate:date];
    [mySQLDateFormatter release];
    [appPerDueDateFormatter release];
    return appPerDueDate;
}


+ (NSString *)formatPrice:(NSString *)price {
    // Oook, lo so, si vede che di base resto sempre un programmatore C...
    double p = [price doubleValue];
    if (p / 1.00 == (int)p) {
        return [NSString stringWithFormat:@"%d", (int)p];
    } 
    else {
        return [NSString stringWithFormat:@"%.2f", p];
    }
}


+ (void)resizeCell:(UITableViewCell *) cell {
    /* Attenzione: Il metodo fa il reflow del testo nella label con tag
     * uguale ad 1. sposta in basso tutte le label con tag maggiore, 
     * e allunga le UIImageView verso il _basso_.
     */
    UILabel *insegnaLbl = (UILabel *)[cell viewWithTag:1];
    if (![insegnaLbl isKindOfClass:[UILabel class]]) {
        NSLog(@"[Utilita resizeCell]: Impossibile ridimensionare la cella. La View con tag 1 deve essere una label");
        return;
    }
    
    CGFloat oldH = insegnaLbl.frame.size.height;
    CGFloat newH;
    CGFloat deltaH;
    
    /* Nota: la chiamata a sizeToFit modifica la larghezza della label 
     * (dopo il word wrap la label viene aumentata in altezza e diminuita
     * in larghezza, quindi bisogna reimpostare la vecchia larghezza
     */
    CGFloat width = insegnaLbl.frame.size.width;
    insegnaLbl.numberOfLines = 0;
    [insegnaLbl sizeToFit];
    
    // Ripristiniamo la vecchia larghezza:
    [insegnaLbl setFrame:CGRectMake(insegnaLbl.frame.origin.x, 
                                    insegnaLbl.frame.origin.y,
                                    width, insegnaLbl.frame.size.height)];
    
    // Calcoliamo la variazione d'altezza:
    newH = insegnaLbl.frame.size.height; 
    deltaH = newH - oldH;
    
    // La cella dovrà essere allungata di deltaH pixel
    [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, 
                              cell.frame.size.width, cell.frame.size.height + deltaH)];
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            // L'imageView va allungata di deltaH pixel
            [view setFrame:CGRectMake(view.frame.origin.x, 
                                      view.frame.origin.y, 
                                      view.frame.size.width, 
                                      view.frame.size.height + deltaH)];
        }
        else if ([view isKindOfClass:[UILabel class]]) {
            if (view.tag > 1) {
                // Le label sottostanti l'insegna vanno abbassate di deltaH pixel
                [view setFrame:CGRectMake(view.frame.origin.x, 
                                          view.frame.origin.y + deltaH, 
                                          view.frame.size.width, 
                                          view.frame.size.height)];
            }
            else { 
                // Le label con tag minore di 1 non vanno abbassate,
                // quella con tag == 1 è quella su cui viene eseguito il reflow.
                continue; 
            }
        }
        else {
            NSLog(@"ATTENZIONE: il resize della cella ha incontrato una view inaspettata: %@", view);
        }
    }
}





@end
