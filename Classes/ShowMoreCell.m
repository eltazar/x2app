//
//  ShowMoreCell.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 16/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowMoreCell.h"


@interface ShowMoreCell () {}
- (void)transitionToBlankState;
- (void)transitionToAnimatingState;
- (void)transitionToDoneState;
@end



@implementation ShowMoreCell

@synthesize activityIndicator=_activityIndicator, messageLabel=_messageLabel, doneMessage=_doneMessage, state=_state;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib {
    self.activityIndicator.hidden = NO;
    self.activityIndicator.alpha = 0;
    self.messageLabel.alpha = 0;
    self.messageLabel.text = @"";

    self.doneMessage = nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (self.state == ShowMoreCellDone) {
        [self transitionToDoneState];
    }
    else if (self.state == ShowMoreCellAnimating) {
        [self transitionToAnimatingState];
    }
    else if (self.state == ShowMoreCellBlank) {
        [self transitionToBlankState];
    }
}


#pragma  mark - ShowMoreCell (Metodi Privati)


- (void)transitionToAnimatingState {
    [self.activityIndicator startAnimating];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.activityIndicator.alpha = 1;
    self.messageLabel.alpha = 0;
    [UIView commitAnimations];
}


- (void)transitionToBlankState {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.75];
    self.activityIndicator.alpha = 0;
    self.messageLabel.alpha = 0;
    [UIView commitAnimations];
    [self.activityIndicator stopAnimating];
}


- (void)transitionToDoneState {
    self.messageLabel.text = self.doneMessage;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:3];
    self.messageLabel.alpha = 1;
    self.activityIndicator.alpha = 0;
    [UIView commitAnimations];
    [self.activityIndicator stopAnimating];
}

@end
