//
//  ShowMoreCell.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {ShowMoreCellBlank, ShowMoreCellAnimating, ShowMoreCellDone} ShowMoreCellState;

@interface ShowMoreCell : UITableViewCell {
@private    
    UIActivityIndicatorView *_activityIndicator;
    UILabel *_messageLabel;
    NSString *_doneMessage;
    ShowMoreCellState _state;
}

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *messageLabel;
@property (nonatomic, retain) NSString *doneMessage;
@property (nonatomic, assign) ShowMoreCellState state;


@end
