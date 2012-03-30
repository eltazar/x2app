//
//  News.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "News.h"
#import "Utilita.h"

@implementation News

@synthesize rows,dict,lista,url;

#pragma mark -
#pragma mark View lifecycle

//-(int)check:(Reachability*) curReach{
//	NetworkStatus netStatus = [curReach currentReachabilityStatus];
//	
//	switch (netStatus){
//		case NotReachable:{
//			return -1;
//			break;
//		}
//		default:
//			return 0;
//	}
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dbAccess = [[DatabaseAccess alloc] init];
    dbAccess.delegate = self;
    
		//[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];
	
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(OpenInfo:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
	[infoButton release];
	[modalButton release];
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (IBAction)OpenInfo:(id)sender {
	Info *info = [[[Info alloc] init] autorelease];
	[self presentModalViewController:info animated:YES];
	
}


- (void)viewWillAppear:(BOOL)animated {
	//[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; 

    [super viewWillAppear:animated];
/*
	int wifi=0;
	int internet=0;
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	internet= [self check:internetReach];
	
	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	
    wifi=[self check:wifiReach];	
	
    if( (internet==-1) &&( wifi==-1) ){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
	}
	else{
    
        indice=0;        
        [dbAccess getNewsFromServer:indice];
    }
 */

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
//    int wifi=0;
//	int internet=0;
//	internetReach = [[Reachability reachabilityForInternetConnection] retain];
//	internet= [self check:internetReach];
//	
//	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
//	
//    wifi=[self check:wifiReach];	
//	
//    if( (internet==-1) &&( wifi==-1) ){
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
//		[alert show];
//         
//	}
    if( ! [Utilita networkReachable]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
        [alert show];
        [alert release];
    
    }
	else{
        
        if(self.view.window){
            indice=0;        
            [dbAccess getNewsFromServer:indice];
        }
    }
}

//#warning crasha wifireach PER ORA COMMENTATO -> RISOLVERE
- (void)viewWillDisappear:(BOOL)animated {
//	[wifiReach release];
//	[internetReach release];
    [super viewWillDisappear:animated];
	

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
;

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark - DatabaseAccess delegate

-(void)didReceiveCoupon:(NSDictionary *)coupon{
    
    NSLog(@"RICEVUTE NEWS DAL SERVER");
    
    dict = [[NSMutableDictionary alloc]initWithDictionary:coupon];
    
    NSMutableArray *r=[[NSMutableArray alloc] init];
    if (dict)
    {
        r = [[dict objectForKey:@"Esercente"] retain];
        
    }
    
    //NSLog(@"Array: %@",r);
    
    rows=[[NSMutableArray alloc] init];
    
    [rows addObjectsFromArray: r];
    
    NSLog(@"Ho aggiunto %d righe",[r count]);
    NSLog(@"Rows ha %d righe",[rows count]);
    [self.tableView reloadData];
    
}

#pragma mark -
#pragma mark Table view data source




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[NSThread detachNewThreadSelector:@selector(spinTheSpinner) toTarget:self withObject:nil];

    //INSERIRE CONTROLLO PRESENZA INTERNET SENNO CRASHA
    if([Utilita networkReachable]){
        if (indexPath.section==0) {
            dict = [rows objectAtIndex: indexPath.row];
            NSInteger i=[[dict objectForKey:@"ID"]integerValue];
            //NSLog(@"L'id della news da visualizzare è %d",i);
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            detail = [[Notizia alloc] initWithNibName:@"Notizia" bundle:[NSBundle mainBundle]];
            [(Notizia*)detail setIdentificativo:i];
            [detail setTitle:@"News"];
                //Facciamo visualizzare la vista con i dettagli
            [self.navigationController pushViewController:detail animated:YES];
                //rilascio controller
            [detail release];
            detail = nil; 
            //[tableView deselectRowAtIndexPath:indexPath animated:YES];

        }
        else {
            
            //NSLog(@"PREMUTOAGGIORNA");
            int i=[self aggiorna];
            if(i<10){ // non ci sono alri esercenti
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
                altri2.text = @"Non ci sono altre news da mostrare";
                
            }
            //[tableView deselectRowAtIndexPath:indexPath animated:YES];

            
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
        [alert show];
        [alert release];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
- (int)aggiorna {
	indice+=10;
	if (indice>=40) {
		NSLog(@"La tabella dovrebbe avere %d righe",[rows count]);
		return 0;
	}
	else {
		url = [NSURL URLWithString:[NSString stringWithFormat: @"http://www.cartaperdue.it/partner//news.php?from=%d&to=10",indice]];
		//NSLog(@"Url: %@", url);
	
		NSString *jsonreturn = [[NSString alloc] initWithContentsOfURL:url];
        //NSLog(@"%@",jsonreturn); // Look at the console and you can see what the restults are
	
		NSData *jsonData = [jsonreturn dataUsingEncoding:NSUTF8StringEncoding];
		NSError *error = nil;	
		dict = [[[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error] retain];	
		NSMutableArray *r=[[NSMutableArray alloc] init];
		if (dict)
		{
			r = [[dict objectForKey:@"Esercente"] retain];
		
		}
	
		//NSLog(@"Array: %@",r);
	
		[rows addObjectsFromArray: r];
	
	
		[jsonreturn release];
		[self.tableView reloadData];
		NSLog(@"Ho aggiunto %d righe",[r count]);
		NSLog(@"La tabella dovrebbe avere %d righe",[rows count]);
		return [r count];
		}
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
		// Return the number of sections.
    return 2;
}



	// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			NSLog(@"La tabella ha %d righe",[rows count]);
			return [rows count];
		case 1:
			return 1;
		default:
			return 0;
	}
}



- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	
	if (indexPath.section==0) {
		
		UITableViewCell *cell = [tableView
								 dequeueReusableCellWithIdentifier:@"cellID"];
		
		if (cell == nil){
			[[NSBundle mainBundle] loadNibNamed:@"CellaNews" owner:self options:NULL];
			cell=cellanews;
		}
		
		dict = [rows objectAtIndex: indexPath.row];
		UILabel *titolo = (UILabel *)[cell viewWithTag:1];
		titolo.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_title"]];
		titolo.text = [titolo.text stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
		titolo.text = [titolo.text stringByReplacingOccurrencesOfString:@"&#39" withString:@"'"];
		titolo.text = [titolo.text stringByReplacingOccurrencesOfString:@"&#146;" withString:@"'"];


		NSDateFormatter *formatoapp = [[NSDateFormatter alloc] init];
        [formatoapp setDateFormat:@"dd-MM-YYYY"];
		NSString *datadb = [NSString stringWithFormat:@"%@",[dict objectForKey:@"post_date"]];
		NSDateFormatter *formatodb=[[NSDateFormatter alloc] init];
        [formatodb setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		NSDate *d1=[formatodb dateFromString:datadb];
		NSString *dataapp = [formatoapp stringFromDate:d1];

		UILabel *data = (UILabel *)[cell viewWithTag:2];
		data.text = [NSString stringWithFormat:@"%@",dataapp];

		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		return cell;
		
	}
	else {
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		
		
		if (cell == nil){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"LastCell" owner:self options:NULL] objectAtIndex:0];
			
		}
		UILabel *altri = (UILabel *)[cell viewWithTag:1];
		altri.text = @"Mostra altre...";
		UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
		altri2.text = @"";	
		return cell;
	}
	
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	[rows release];
	
	[detail release];
	[dict release];
	[cellanews release];
	[cellafinale release];
	[url release];
	
}


- (void)dealloc {
    [super dealloc];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

