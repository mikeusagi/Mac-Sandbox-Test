//
//  AppDelegate.h
//  SandboxTest
//
//  Created by mikeusagi on 2014/02/10.
//  Copyright (c) 2014年 mikeusagi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

- (IBAction)openFile:(id)sender;
- (IBAction)playFile:(id)sender;

@end
