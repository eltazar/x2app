//
//  Commenti.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 27/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Commenti.h"
#import "Utilita.h"

@interface Commenti (){
}
@property (nonatomic, retain) NSMutableArray *dataModel;
@property (nonatomic, retain) DatabaseAccess *dbAccess;
- (void)fetchRowsFromNumber:(NSInteger)n;
- (NSString *)dateStringFromMySQLDate:(NSString *)mySQLDate;
- (void)prettifyNullValuesForCommentsInArray:(NSArray *)comments;

@end


@implementation Commenti


@synthesize tableview=_tableview;

@synthesize idEsercente=_idEsercente ,insegnaEsercente=_insegnaEsercente;

@synthesize dataModel=_dataModel, dbAccess=_dbAccess;


/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark - View Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titolo = (UILabel *)[self.view viewWithTag:1];
    titolo.text = self.insegnaEsercente;
    didFetchAllComments = FALSE;
    self.dbAccess = [[DatabaseAccess alloc] init];
    self.dbAccess.delegate = self;
    [self.dbAccess release];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow]  animated:YES];
    if (![Utilita networkReachable]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
        return;
	}
    if (!self.dataModel || self.dataModel.count == 0 ) {
        [self fetchRowsFromNumber:0];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    self.dbAccess.delegate = nil;
    self.dbAccess = nil;
	/*[rows release];
	[dict release];
	
	[tableview release];
	[cellanews release];
	[cellafinale release];
	[Nome release];
	[titolo release];
	[detail release];
	[url release];*/
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.dataModel.count < 5) {
		return 1;
	}	
	else {
		return 2;
		
	}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return self.dataModel.count;
		case 1:
			return 1;
		default:
			return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell;
    
	if (indexPath.section == 1) {		
		cell = [tableView dequeueReusableCellWithIdentifier:@"LastCell"];
		if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LastCell" owner:self options:NULL] objectAtIndex:0];
		}
		UILabel *altri  = (UILabel *)[cell viewWithTag:1];
        UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
		altri.text = @"Mostra altri...";
		altri2.text = @"";
	}
    
	else if (self.dataModel.count > 0) {
#warning sistemare il riuso
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (!cell) {
            [[NSBundle mainBundle] loadNibNamed:@"CellaNews" owner:self options:NULL];
            cell=cellanews;
        }
        
        NSDictionary *commento = [self.dataModel objectAtIndex: indexPath.row];
        UILabel *titolo = (UILabel *)[cell viewWithTag:1];
        UILabel *data   = (UILabel *)[cell viewWithTag:2];
        
        titolo.text = [commento objectForKey:@"comment_content"];
        NSString *dateString = [self dateStringFromMySQLDate:[commento objectForKey:@"comment_date"]];
        if ([[commento objectForKey:@"comment_author"] length] == 0 ) {
            data.text = [NSString stringWithFormat:@"Inviato da Anonimo %@ il %@",
                         [commento objectForKey:@"comment_author"],
                         dateString];
        }
        else {
            data.text = [NSString stringWithFormat:@"Inviato da %@ il %@", 
                         [commento objectForKey:@"comment_author"],
                         dateString];
            data.text = [data.text stringByReplacingOccurrencesOfString:@"&amp;"
                                                             withString:@"&"];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	
    if (indexPath.section == 0) {
        NSDictionary *commento = [self.dataModel objectAtIndex:indexPath.row];
        NSInteger idCommento = [[commento objectForKey:@"comment_ID"] integerValue];
        NSLog(@"L'id del commento da visualizzare è %d", idCommento);
        NSString *dateStr = [self dateStringFromMySQLDate:[commento objectForKey:@"comment_date"]];
        NSString *autore;
        if([[commento objectForKey:@"comment_author"] length] == 0 ) {
            autore = [NSString stringWithFormat:@"Inviato da Anonimo %@ il %@",
                      [commento objectForKey:@"comment_author"],
                      dateStr];
        }
        else {
            autore = [NSString stringWithFormat:@"Inviato da %@ il %@",
                      [commento objectForKey:@"comment_author"],
                      dateStr];
            autore = [autore stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            
        }
        Commento *detail = [[Commento alloc] initWithNibName:nil bundle:nil];
        detail.title = @"Commento";
        detail.data = autore;
        detail.nome = self.insegnaEsercente;
        detail.commento = [commento objectForKey:@"comment_content"];
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
        
    }
    
    else if (indexPath.section == 1) {
        if (didFetchAllComments) { // non ci sono alri commenti
            UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
            UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
            altri2.text = @"Non ci sono altri commenti da mostrare";
        }
    }
}


#pragma mark DatabaseAccessDelegate


- (void)didReceiveCoupon:(NSDictionary *)data {
#warning  stoppare lo spinner quando sarà messo

    NSObject *temp = [data objectForKey:@"Esercente"];
    
    if (![temp isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *fetchedComments = (NSMutableArray *)temp;
    [self prettifyNullValuesForCommentsInArray:fetchedComments];
    
    if (fetchedComments.count == 0) {
        // Abbiamo già scaricato tutti i commenti
        didFetchAllComments = TRUE;
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil];
        [self.tableview beginUpdates];
        [self.tableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableview endUpdates];
        [indexPaths release];
        return;
    }

    if (!self.dataModel || self.dataModel.count == 0) {
        self.dataModel = fetchedComments;
        [self.tableview reloadData];
        return;
    }
    
    NSInteger from  = self.dataModel.count;
    NSInteger to    = from + fetchedComments.count;
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:(to - from)]; 
    for (int i = from; i < to; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableview beginUpdates];
    [self.dataModel addObjectsFromArray: fetchedComments];
    [self.tableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableview endUpdates];
    [indexPaths release];
    return;
}


-  (void)didReceiveError:(NSError *)error {
#warning visualizzare alert errore di rete.
}


- (void)fetchRowsFromNumber:(NSInteger)n {
    NSString *urlString = [NSString stringWithFormat:@"http://www.cartaperdue.it/partner/commenti.php?id=%d&from=%d&to=10", self.idEsercente, n];
    [self.dbAccess getConnectionToURL:urlString];
}


- (NSString *)dateStringFromMySQLDate:(NSString *)mySQLDate {
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


- (void)prettifyNullValuesForCommentsInArray:(NSArray *)comments{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"comment_author", @"comment_content", @"comment_date", @"comment_ID", nil];
    for (NSMutableDictionary *c in comments) {
        for (NSString *k in keys) {
            if ([[c objectForKey:k] isKindOfClass: [NSNull class]]) {
                [c setObject:@"" forKey:k];
            }
        }
    }
}


@end
