//
//  Commenti.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 27/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Commenti.h"


@implementation Commenti
@synthesize rows, identificativo;
@synthesize dict,tableview, titolo,Nome,url;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


-(int)check:(Reachability*) curReach{
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	
	switch (netStatus){
		case NotReachable:{
			return -1;
			break;
		}
		default:
			return 0;
	}
}

	//settiamo il contenuto delle varie celle
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.section==1) {
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		
		if (cell == nil){
			[[NSBundle mainBundle] loadNibNamed:@"CellaFinale" owner:self options:NULL];
			cell=cellafinale;
			
		}
		UILabel *altri = (UILabel *)[cell viewWithTag:1];
		altri.text = @"Mostra altri...";
		UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
		altri2.text = @"";
		return cell;		
	}
	else {
		if ([rows count] >0){
		UITableViewCell *cell = [tableView
							 dequeueReusableCellWithIdentifier:@"cellID"];
			
			if (cell == nil){
				[[NSBundle mainBundle] loadNibNamed:@"CellaNews" owner:self options:NULL];
				cell=cellanews;
			}
	
			dict = [rows objectAtIndex: indexPath.row];
			titolo = (UILabel *)[cell viewWithTag:1];
			titolo.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"comment_content"]];
	
			NSDateFormatter *formatoapp = [[NSDateFormatter alloc] init];
			[formatoapp setDateFormat:@"dd-MM-YYYY"];
			NSString *datadb = [NSString stringWithFormat:@"%@",[dict objectForKey:@"comment_date"]];
			NSDateFormatter *formatodb=[[NSDateFormatter alloc] init];
			[formatodb setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			NSDate *d1=[formatodb dateFromString:datadb];
			NSString *dataapp = [formatoapp stringFromDate:d1];
	
			UILabel *data = (UILabel *)[cell viewWithTag:2];
			if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"comment_author"]] length]==0 ) {
				data.text = [NSString stringWithFormat:@"Inviato da Anonimo %@ il %@",[dict objectForKey:@"comment_author"],dataapp];
			}
			else {
				data.text = [NSString stringWithFormat:@"Inviato da %@ il %@",[dict objectForKey:@"comment_author"],dataapp];
				data.text = [data.text stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];

			}

	
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			return cell;
		}
	}
	

}


- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	
	switch (indexPath.section) {
		case 0:
			[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
			dict = [rows objectAtIndex: indexPath.row];
			NSInteger i=[[dict objectForKey:@"comment_ID"]integerValue];
			NSLog(@"L'id del commento da visualizzare è %d",i);
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			detail = [[Commento alloc] initWithNibName:@"Commento" bundle:[NSBundle mainBundle]];
			NSDictionary *diz = [rows objectAtIndex: indexPath.row];
			
			NSDateFormatter *formatoapp = [[NSDateFormatter alloc] init];
			[formatoapp setDateFormat:@"dd-MM-YYYY"];
			NSString *datadb = [NSString stringWithFormat:@"%@",[dict objectForKey:@"comment_date"]];
			NSDateFormatter *formatodb=[[NSDateFormatter alloc] init];
			[formatodb setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			NSDate *d1=[formatodb dateFromString:datadb];
			NSString *dataapp = [formatoapp stringFromDate:d1];
			NSString *autore;
			if([[NSString stringWithFormat:@"%@",[dict objectForKey:@"comment_author"]] length]==0 ) {
				autore = [NSString stringWithFormat:@"Inviato da Anonimo %@ il %@",[diz objectForKey:@"comment_author"],dataapp];
			}
			else {
				autore = [NSString stringWithFormat:@"Inviato da %@ il %@",[diz objectForKey:@"comment_author"],dataapp];
				autore = [autore stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];

			}

			
			[(Commento*)detail setData:autore];
			[(Commento*)detail setNome:Nome];
			NSString *cm=[NSString stringWithFormat:@"%@",[diz objectForKey:@"comment_content"]];
			[(Commento*)detail setCommento:cm];
			
			[detail setTitle:@"Commento"];
				//Facciamo visualizzare la vista con i dettagli
			[self.navigationController pushViewController:detail animated:YES];
				//rilascio controller
			[detail release];
			detail = nil; 
			break;
		case 1: 
			[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
			int ret=[self aggiorna];
			if(ret==0){ // non ci sono alri commenti
				UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
				UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
				altri2.text = @"Non ci sono altri commenti da mostrare";
			}
			break;
			
			
		default:
			break;
	}
}
	

-(void)spinTheSpinner {
    NSLog(@"Spin The Spinner");
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self performSelectorOnMainThread:@selector(doneSpinning) withObject:nil waitUntilDone:YES];
	
    [pool release]; 
}

-(void)doneSpinning {
    NSLog(@"done spinning");
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
	indice=0;
	NSLog(@"Il nome dell'esercente è %@",Nome);
	titolo.text=Nome;
	url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/commenti.php?id=%d&from=%d&to=10",identificativo,indice]];
	NSLog(@"Url: %@", url);
	
	NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
	NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
	
	NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
	rows=[[NSMutableArray alloc] initWithObjects:[dict allValues],nil];
	NSMutableArray *r=[[NSMutableArray alloc] init];
	
	if (dict)
	{
		r = [[dict objectForKey:@"Esercente"] retain];
		
	}
	
	NSLog(@"Array: %@",r);	
	rows= [[NSMutableArray alloc]init];
	[rows addObjectsFromArray: r];
	
	NSLog(@"Numero totale:%d",[rows count]);

	[jsonreturn release];
	jsonreturn=nil;
	[r release];
	r=nil;
	
	if ([rows count] >0) {
		dict = [rows objectAtIndex: 0];	
	}

}

- (int)aggiorna {
		indice+=10;
		url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner/commenti.php?id=%d&from=%d&to=10",identificativo,indice]];
		NSLog(@"Url: %@", url);
		NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
        NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
            
		NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error = nil;	
		dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
		NSMutableArray *r=[[NSMutableArray alloc] init];
		if (dict)
		{
			r = [[dict objectForKey:@"Esercente"] retain];
			
		}
		
		NSLog(@"Array: %@",r);
		
		[rows addObjectsFromArray: r];
		
		
		[tableview reloadData];
		NSLog(@"Ho aggiunto %d righe",[r count]);
		NSLog(@"La tabella dovrebbe avere %d righe",[rows count]);
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 
		int nuove=[r count];
		[jsonreturn release];
		jsonreturn=nil;
		[r release];
		r=nil;
		return nuove;

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([rows count]<5){
		return 1;
	}	
	else {
		return 2;
		
	}
}

	// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return [rows count];
		case 1:
			return 1;
		default:
			return 0;
	}
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated {
	int wifi=0;
	int internet=0;
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	internet= [self check:internetReach];
	
	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	wifi=[self check:wifiReach];	
	if( (internet==-1) &&( wifi==-1) ){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];

	}
	
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[wifiReach release];
	[internetReach release];
    [super viewWillDisappear:animated];
	
	
}
- (void)viewDidUnload {
    [super viewDidUnload];
	[rows release];
	[dict release];
	
	[tableview release];
	[cellanews release];
	[cellafinale release];
	[Nome release];
	[titolo release];
	[detail release];
	[url release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
