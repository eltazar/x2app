//
//  DatiPag.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 02/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DatiPag.h"


@implementation DatiPag
@synthesize tableinfopagamento,campo,key;


-(IBAction)confermatipo:(id)sender{
	NSString *stringaTesto =[arrayTipi objectAtIndex:[tipoPicker selectedRowInComponent:0]] ;

	NSLog(@"Devo salvare: %@",stringaTesto);
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:stringaTesto forKey:@"TipoCarta"];
	[defaults synchronize];
	NSIndexPath * currentPath = [tableinfopagamento indexPathForSelectedRow];
	//NSLog(@"Path:%d",currentPath );

	Celladati * cell = (Celladati *)[tableinfopagamento cellForRowAtIndexPath:currentPath];
	cell.detail.text=stringaTesto;
	NSLog(@"Ho salvato %@",cell.detail.text);
	[tableinfopagamento reloadData];
	[tipocartaPick removeFromSuperview];
	
	NSIndexPath * nextPath = [NSIndexPath indexPathForRow:currentPath.row + 1 inSection:currentPath.section];
	Celladati * nextCell = (Celladati *)[tableinfopagamento cellForRowAtIndexPath:nextPath];
	[tableinfopagamento selectRowAtIndexPath:nextPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
	[nextCell.detail becomeFirstResponder];

	
}

-(IBAction)confermadata:(id)sender{
	NSString *mesescadenza= [arrayMesi objectAtIndex:[scadenzaPicker selectedRowInComponent:0]] ;
	NSString *annoscadenza=[arrayAnni objectAtIndex:[scadenzaPicker selectedRowInComponent:1]];
	NSLog(@"Devo salvare: %@ %@",mesescadenza, annoscadenza);
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:mesescadenza forKey:@"MeseScadenza"];
	[defaults setObject:annoscadenza forKey:@"AnnoScadenza"];
	[defaults synchronize];
	NSIndexPath * currentPath = [tableinfopagamento indexPathForSelectedRow];
	Celladati * cell = (Celladati *)[tableinfopagamento cellForRowAtIndexPath:currentPath];
	if( ([mesescadenza length] != 0) && ([annoscadenza length] != 0) )
		cell.detail.text=[NSString stringWithFormat:@"%@/%@",mesescadenza,annoscadenza];
	NSLog(@"Ho salvato %@",cell.detail.text);
	[tableinfopagamento reloadData];
	[scadenzacartaPick removeFromSuperview];	
	
	NSIndexPath * nextPath = [NSIndexPath indexPathForRow:currentPath.row + 1 inSection:currentPath.section];
	Celladati * nextCell = (Celladati *)[tableinfopagamento cellForRowAtIndexPath:nextPath];
	[tableinfopagamento selectRowAtIndexPath:nextPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
	[nextCell.detail becomeFirstResponder];
	
}



-(void)save:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	static NSString *cellID = @"celladatipersonali";
	
	Celladati *cell = (Celladati *)[tableinfopagamento dequeueReusableCellWithIdentifier:cellID];
	
	if (cell == nil)
	{
		NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"celladatipersonali" owner:nil options:nil];
		
		for (id currentObject in nibObjects)
		{
			if ([currentObject isKindOfClass:[Celladati class]])
			{
				cell = (Celladati *)currentObject;
				break;
			}
			
		}	
    }
    
    cell.detail.delegate = self;
	cell.detail.tag=indexPath.row;

    cell.mytext.text = @"";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	if(indexPath.row==0){

		NSString *testoSalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"TipoCarta"];
		NSLog(@"Tipo carta letto: %@",testoSalvato);
		cell.mytext.text =@"Tipo Carta:";
		cell.detail.placeholder =@"Tipo carta di credito";
		cell.detail.text = testoSalvato;
		[tipocartaPick setBackgroundColor:[UIColor clearColor]];

		[cell.detail setReturnKeyType:UIReturnKeyNext];
		[cell.detail setInputView:tipocartaPick];
		cell.key = @"TipoCarta";
		cell.detail.text=testoSalvato;

		[cell.labelRight removeFromSuperview];		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		//cell.detail.text=[arrayTipi objectAtIndex:[tipoPicker selectedRowInComponent:0]];
		
				
	}
	if (indexPath.row==1){
		NSString *testoSalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"NumeroCarta"];
		cell.mytext.text =@"Numero Carta:";
		cell.detail.placeholder =@"Numero carta di credito";
		cell.detail.text = testoSalvato;
		cell.detail.keyboardType = UIKeyboardTypeNumberPad;
		[cell.detail setReturnKeyType:UIReturnKeyNext];
		cell.key = @"NumeroCarta";
		[cell.labelRight removeFromSuperview];		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	if (indexPath.row==2){
		NSString *testoSalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"Cvv"];
		cell.mytext.text =@"CVV:";
		cell.detail.placeholder =@"CVV carta di credito";
		cell.detail.text = testoSalvato;
		cell.detail.keyboardType = UIKeyboardTypeNumberPad;
		[cell.detail setReturnKeyType:UIReturnKeyNext];
		cell.detail.secureTextEntry = YES;
		cell.key = @"Cvv";
		[cell.labelRight removeFromSuperview];		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	if(indexPath.row==3){
		NSString *mesescadenza = [[NSUserDefaults standardUserDefaults] objectForKey:@"MeseScadenza"];
		NSString *annoscadenza = [[NSUserDefaults standardUserDefaults] objectForKey:@"AnnoScadenza"];
		cell.mytext.text =@"Scadenza:";
		cell.detail.placeholder =@"Scadenza carta di credito";
		[cell.detail setReturnKeyType:UIReturnKeyNext];
		cell.key = @"Scadenza";
		[scadenzacartaPick setBackgroundColor:[UIColor clearColor]];
		[cell.detail setInputView:scadenzacartaPick];
		//NSString *s= [NSString stringWithFormat:@"%@/%@",[arrayMesi objectAtIndex:[scadenzaPicker selectedRowInComponent:0]],[arrayAnni objectAtIndex:[scadenzaPicker selectedRowInComponent:1]] ] ;
		if( ([mesescadenza length] != 0) && ([annoscadenza length] != 0) )
			cell.detail.text=[NSString stringWithFormat:@"%@/%@",mesescadenza,annoscadenza];
		[cell.labelRight removeFromSuperview];		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}	
	if(indexPath.row==4){
		NSString *testoSalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"Intestatario"];
		cell.mytext.text =@"Intestata a:";
		cell.detail.placeholder =@"Intestatario carta di credito";
		cell.detail.text = testoSalvato;
		[cell.detail setReturnKeyType:UIReturnKeyNext];
		cell.key = @"Intestatario";
		[cell.labelRight removeFromSuperview];		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;		
	}
	return cell;				
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	int z = textField.tag;                                              
    if (z == 2) {
		if (textField.text.length >= 4 && range.length == 0) {
			return NO; // return NO to not change text
		}
			else{
		return YES;
		}
	}
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
	self.navigationItem.rightBarButtonItem.enabled = FALSE;

	int z = textField.tag;                                              
	
    if (z > 2) { //le prime tre celle sono completamente visibili
		
		// ridimensiono la tableview per poter visualizzare correttamente i campi nascosti da keyboard /picker
		if (z==3) { //picker
			self.tableinfopagamento.frame = CGRectMake(0.0,0,320.0,158.0);
		}
		else { //tastiera
			self.tableinfopagamento.frame = CGRectMake(0.0,0,320.0,200.0);       
		}
		// adjust the contentInset
		
        tableinfopagamento.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);        
		
		// Scroll to the current text field
		
        [tableinfopagamento scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:z inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
		
    }
	
		Celladati * currentCell = (Celladati *)[[textField superview] superview];
		NSIndexPath * selectedPath = [tableinfopagamento indexPathForCell:currentCell];
		currentField = textField;
		
		//	nextPath = selectedPath;

		[tableinfopagamento selectRowAtIndexPath:selectedPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
		
		currentKey = currentCell.key;
	}
	
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {	
		NSIndexPath * currentPath = [tableinfopagamento indexPathForSelectedRow];
		NSIndexPath * nextPath = [NSIndexPath indexPathForRow:currentPath.row + 1 inSection:currentPath.section];
		
        if ( (currentPath.section == 0) && (currentPath.row >= 4) ) {  
			nextPath = [NSIndexPath indexPathForRow:0 inSection:0];
			[theTextField resignFirstResponder];
			return YES;
		}		
		
		Celladati * nextCell = (Celladati *)[tableinfopagamento cellForRowAtIndexPath:nextPath];
		[tableinfopagamento selectRowAtIndexPath:nextPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
		[nextCell.detail becomeFirstResponder];

		return YES;
	}
	
	
- (void)textFieldDidEndEditing:(UITextField *)textField {

	int z = textField.tag;  
	
    if (z > 2) {
	// resize the UITableView to the original size
		self.tableinfopagamento.frame = CGRectMake(0.0,0,320.0,416.0);       
	// Undo the contentInset
        tableinfopagamento.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	}
	if (textField.text) {
		NSString *stringaTesto = textField.text;
		textField.text = [[NSString alloc] initWithFormat:@"%@", stringaTesto];
		
		NSString *testoInserito = textField.text;
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:testoInserito forKey:currentKey];
		[defaults synchronize];
	}
	self.navigationItem.rightBarButtonItem.enabled = TRUE;
	tableinfopagamento.userInteractionEnabled = YES;


}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	arrayTipi = [[NSArray alloc] initWithObjects:@"",@"VISA",@"MasterCard",@"American Express", nil];
	arrayMesi= [[NSArray alloc] initWithObjects:@"",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
	arrayAnni= [[NSArray alloc] initWithObjects:@"",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020", nil];
	
	UIBarButtonItem *salva = [[UIBarButtonItem alloc]
							  initWithTitle:@"Salva"
							  style:UIBarButtonItemStyleBordered
							  target:self
							  action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = salva;
    
    //release messo da mario
    [salva release];
	
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView { // This method needs to be used. It asks how many columns will be used in the UIPickerView
	if( thePickerView==tipoPicker )
		return 1; 	
	else {//picker scadenza carta
		return 2;
	}
	
}
- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component { // This method also needs to be used. This asks how many rows the UIPickerView will have.
	
	if(thePickerView==tipoPicker)	
		return [arrayTipi count];
	else { //data scadenza picker
		if(component==0)
			return [arrayMesi count];
		if(component==1)
			return [arrayAnni count];
		
	}
	
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { // This method asks for what the title or label of each row will be.
	if(thePickerView==tipoPicker)		
		return [arrayTipi objectAtIndex:row];
	else { //picker scadenza carta
		if(component==0)
			return [arrayMesi objectAtIndex:row];
		if(component==1)
			return [arrayAnni objectAtIndex:row];
	}	
	
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
	
}

- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
		// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[tableinfopagamento release];
	
	[arrayTipi release];
	[arrayMesi release];
	[arrayAnni release];
	[tipocartaPick release];
	[scadenzacartaPick release];
	
	[currentKey release];
    [currentField release];
}


@end
