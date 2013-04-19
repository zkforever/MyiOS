//
//  PatternLockAppViewController.h
//  PatternLockApp
//
//  Created by Purnama Santo on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatternLockAppViewController : UIViewController{
    UILabel *_timelabel;
    NSTimer *_timer;
    BOOL isLock;
}

@property(retain,nonatomic)IBOutlet UILabel *timelabel;

- (IBAction)lockClicked:(id)sender;

- (IBAction)setLockkey:(id)sender;

@end
