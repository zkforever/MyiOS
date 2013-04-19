//
//  PatternLockAppViewController.m
//  PatternLockApp
//
//  Created by Purnama Santo on 11/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PatternLockAppViewController.h"
#import "DrawPatternLockViewController.h"

#define LOCKTIME 5


@implementation PatternLockAppViewController
@synthesize timelabel = _timelabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    isLock = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:LOCKTIME target:self selector:@selector(lock) userInfo:nil repeats:NO];
    [NSThread detachNewThreadSelector:@selector(updatetime) toTarget:self withObject:nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)lock{
    if (!isLock) {
        [self lockClicked:nil];
    }
}

- (void)updatetime{
    @autoreleasepool {
        int i = 0;
        while (YES) {
            NSDate * startDate = [[NSDate alloc] init];
            NSCalendar * chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSUInteger unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit |
            NSSecondCalendarUnit | NSDayCalendarUnit  |
            NSMonthCalendarUnit | NSYearCalendarUnit;
            
            NSDateComponents * cps = [chineseCalendar components:unitFlags fromDate:startDate];
            NSUInteger hour = [cps hour];
            NSUInteger minute = [cps minute];
            NSUInteger second = [cps second];
            _timelabel.text =  [[NSString alloc] initWithFormat:@"%02d:%02d:%02d",hour,minute,second];
            _timelabel.textColor = [UIColor blackColor];
            if (i%5 == 0) {
                i = 0;
                _timelabel.textColor = [UIColor redColor];
            }            
            [_timelabel performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES];
            i++;
            [NSThread sleepForTimeInterval:1.0];
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return NO;
}


- (void)lockEntered:(NSString*)key {
  NSLog(@"key: %@", key);
  
   NSString *lockkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"lockkey"];
    if (!lockkey || [lockkey isEqualToString:@""]) {
        lockkey = @"0102030609";
    }
    
  if (![key isEqualToString:lockkey]) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Wrong pattern!"
                                                       delegate:nil
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
  }
  else{
      isLock = NO;
      if (_timer) {
          [_timer invalidate];
          _timer = nil;
      }
      _timer = [NSTimer scheduledTimerWithTimeInterval:LOCKTIME target:self selector:@selector(lock) userInfo:nil repeats:NO];
      [self dismissModalViewControllerAnimated:YES];
  }
}

-(void)setLockKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:@"lockkey"];
    isLock = NO;
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)setLockkey:(id)sender{
    isLock = YES;
    DrawPatternLockViewController *lockVC = [[DrawPatternLockViewController alloc] init];
    [lockVC setTarget:self withAction:@selector(setLockKey:)];
    [self presentModalViewController:lockVC animated:YES];
    lockVC = nil;
}


- (IBAction)lockClicked:(id)sender {
  isLock = YES;
  DrawPatternLockViewController *lockVC = [[DrawPatternLockViewController alloc] init];
  [lockVC setTarget:self withAction:@selector(lockEntered:)];
  [self presentModalViewController:lockVC animated:YES];
    lockVC = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    isLock = NO;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:LOCKTIME target:self selector:@selector(lock) userInfo:nil repeats:NO];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:LOCKTIME target:self selector:@selector(lock) userInfo:nil repeats:NO];
    }
}
@end
