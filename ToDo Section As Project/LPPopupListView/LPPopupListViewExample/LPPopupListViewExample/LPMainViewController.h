//
//  LPMainViewController.h
//  LPPopupListViewExample
//
//  Created by Luka Penger on 27/03/14.
//  Copyright (c) 2014 Luka Penger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPPopupListView.h"


@interface LPMainViewController : UIViewController <LPPopupListViewDelegate>

@property (nonatomic, strong) IBOutlet UITextView *textView;

- (IBAction)buttonClicked:(id)selector;

@end
