//
//  PickerViewController.m
//  jobFinder
//
//  Created by mario greco on 05/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerViewController.h"

@implementation PickerViewController
@synthesize picker, arrayFields, objectsInRow;


-(id)initWithArray:(NSArray*)fields andNumber:(int)elements;{
    
    self = [super init];
    
    if(self){
        
        self.arrayFields = fields;
        numElements = elements;
    }
        
    return self;
}


#pragma mark - PickerDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
			forComponent:(NSInteger)component
{
	return [[arrayFields objectAtIndex:component] objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{    
    NSLog(@"SELEZIONATO SUL PICKER = %@, component = %d", [[arrayFields objectAtIndex:component] objectAtIndex:row], component);

    
    [objectsInRow replaceObjectAtIndex:component withObject:[[arrayFields objectAtIndex:component] objectAtIndex:row]];
    NSLog(@" object = %@", [objectsInRow objectAtIndex:component]);
    

}

#pragma mark - PickerDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return numElements;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[arrayFields objectAtIndex:component] count];
    
}

#pragma mark - View lifecycle

-(void)viewDidAppear:(BOOL)animated{

    [picker reloadAllComponents];
    [super viewDidAppear:animated];
     
}

- (void)viewDidLoad
{   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 20, 320, 216)];
    [self.view setFrame:CGRectMake(0, 20, 320, 216)];
    
    if(numElements == 1){
        self.view.tag = 777;
    }
    else if(numElements == 2){
        self.view.tag = 778;
    }
    
    // picker.autoresizingMask = UIViewAutoresizingNone;
    picker.showsSelectionIndicator = YES;       // note this is default to NO    
    
    // this view controller is the data source and delegate
    picker.delegate = self;
    picker.dataSource = self;
    //    self.view = picker;
    [self.view addSubview:picker];
    
    
    objectsInRow = [[NSMutableArray alloc] init];
    NSLog(@"oggetti in array = %d, capacità passata = %d", objectsInRow.count,numElements);
    
    for(int i = 0; i < numElements; i++){
        NSLog(@"aggiungo %@", [self.arrayFields objectAtIndex:0]);
        [objectsInRow addObject:[[self.arrayFields objectAtIndex:i] objectAtIndex:0]];
    }
    
    NSLog(@"oggetti in array = %d dopo init", objectsInRow.count);

    
}

- (void)viewDidUnload
{
    
    self.picker = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) dealloc
{
    self.arrayFields = nil;
    self.objectsInRow = nil,    
    [picker release];
    [super dealloc];    
    
}

@end