//
//  LocalDatabaseAccess.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalDatabaseAccess.h"
#import "PerDueCItyCardAppDelegate.h"


@implementation LocalDatabaseAccess

static LocalDatabaseAccess *__instance = nil;
NSManagedObjectContext *context;

+ (LocalDatabaseAccess *)getInstance {
    @synchronized([LocalDatabaseAccess class])
	{
		if (!__instance)
			__instance = [[self alloc] init];
		return __instance;
	}
	return nil;
}


+ (id)alloc {
	@synchronized([LocalDatabaseAccess class])
	{
		NSAssert(__instance == nil, @"Attempted to allocate a second instance of a singleton.");
		__instance = [super alloc];
		return __instance;
	}
	return nil;
}


- (id)init {
	self = [super init];
	if (self != nil) {
		PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate *)[[UIApplication sharedApplication] delegate];
        context = [appDelegate managedObjectContext];
        [context retain];
	}
	return self;
}


- (void) dealloc {
    [context release];
    [super dealloc];
}


# pragma mark - LocalDatabaseAccess


- (NSArray *)fetchStoredCardsAndWriteErrorIn:(NSError **)error {
    //istanziamo la classe NSFetchRequest
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init]; 
    
    //istanziamo l'Entità da passare alla Fetch Request
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"CartaPerDue" inManagedObjectContext:context];
    //Settiamo la proprietà Entity della Fetch Request
    [fetchRequest setEntity:entity];
    
    //Eseguiamo la Fetch Request e salviamo il risultato in un array, per visualizzarlo nella tabella
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:error];
    [fetchRequest release];
    
    
    
    //se > 0 ci sono righe nella tabella, ovvero carte registrate
    if (fetchedObjects && fetchedObjects.count > 0) {
        
        //        NSLog(@ " --------> FO = %@ \n, fo count = %d, \n titolare = %@, carta = %@, scadenza = %@",tempArray,tempArray.count, [[tempArray objectAtIndex:0] valueForKey:@"titolare"], [[tempArray objectAtIndex:0] valueForKey:@"numero"], [[tempArray objectAtIndex:1] valueForKey:@"scadenza"]);
        NSLog(@"Did fetch this stuff: %@", fetchedObjects);
        NSMutableArray *tempCards = [[NSMutableArray alloc] init];
        for (int i = 0; i < fetchedObjects.count; i++) {
            CartaPerDue *carta = [[CartaPerDue alloc] init];
            NSManagedObject *fetchedObject = [fetchedObjects objectAtIndex:i];
            NSLog(@"Parsing object: %@", fetchedObject);
            carta.name = [fetchedObject valueForKey:@"nome"];
            carta.surname = [fetchedObject valueForKey:@"cognome"];
            carta.number = [fetchedObject valueForKey:@"numero"];
            carta.expiryString = [fetchedObject valueForKey:@"scadenza"];
            [tempCards addObject:carta];
            [carta release];
        }
        NSArray *cardsArray = [[[NSArray alloc] initWithArray:tempCards] autorelease];
        [tempCards release];
        return  cardsArray;
    }
    return [[[NSArray alloc] init] autorelease];
    
}


- (BOOL)storeCard:(CartaPerDue *)card AndWriteErrorIn:(NSError **)error {
    //Controlliamo prima che non sia già memorizzata la carta, in tal caso, nn facciamo nulla
    NSError *e;
    NSArray *storedCards = [self fetchStoredCardsAndWriteErrorIn:&e];
    for (CartaPerDue *c in storedCards) {
        if ([c.number isEqualToString:card.number]) {
            return TRUE;
        }
    }
    
    //Creiamo un'istanza di NSManagedObject per l'Entità che ci interessa
    NSManagedObject *cartaPD = [NSEntityDescription
                                insertNewObjectForEntityForName:@"CartaPerDue" 
                                inManagedObjectContext:context];
    
    //Usando il Key-Value Coding inseriamo i dati presi dall'interfaccia nell'istanza dell'Entità appena creata
    [cartaPD setValue:card.name forKey:@"nome"];
    [cartaPD setValue:card.surname forKey:@"cognome"];
    [cartaPD setValue:card.number forKey:@"numero"];
    [cartaPD setValue:card.expiryString forKey:@"scadenza"];
    
    //Effettuiamo il salvataggio gestendo eventuali errori
    return [context save:error];
}


@end
