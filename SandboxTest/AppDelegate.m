//
//  AppDelegate.m
//  SandboxTest
//
//  Created by mikeusagi on 2014/02/10.
//  Copyright (c) 2014年 mikeusagi. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

NSUserDefaults *defaults;
AVAudioPlayer *player;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    defaults = [NSUserDefaults standardUserDefaults];
}

// ファイルを選択
- (IBAction)openFile:(id)sender
{
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseFiles:YES];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseDirectories:NO];
    [openPanel setCanCreateDirectories:NO];
    
    if ([openPanel runModal] == NSFileHandlingPanelOKButton) {
        NSURL *bookmarkURL = [openPanel URL];
        //NSLog(@"URL = %@",bookmarkURL);
        
        NSData *bookmarkData = [bookmarkURL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:nil];
        
        if (!bookmarkData) {
            NSLog(@"Bookmark is nil");
            return;
        }
        // BookmarkDataをUserDefaultsに書き込み
        [defaults setObject:bookmarkData forKey:@"Bookmark"];
        [defaults synchronize];
    }
}


// ファイルを再生
- (IBAction)playFile:(id)sender
{
    // UserDefaultsからBookmarkDataを読み込み
    NSData *bookmarkData = [defaults objectForKey:@"Bookmark"];
    
    // BookmarkDataからURLを取得
    NSURL *bookmarkURL = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithSecurityScope relativeToURL:nil bookmarkDataIsStale:nil error:nil];
    // bookmarkURLのチェック
    if (!bookmarkURL) {
         NSLog(@"bookmarkURL is nil");
        return;
    }
    
    /*
     OS 10.7 ~ 10.7.2環境では、
     "startAccessingSecurityScopedResource","stopAccessingSecurityScopedResource"
     が無効?な為,respondsToSelectorでチェック
     http://stackoverflow.com/questions/12188865/mac-app-store-sandboxing-and-handling-security-scoped-bookmarks-prior-to-10-7-3
     */
    if([bookmarkURL respondsToSelector:@selector(startAccessingSecurityScopedResource)]) {
        //NSLog(@"Start Access");
        [bookmarkURL startAccessingSecurityScopedResource];
    }
    
    
    //  ファイルを再生
    NSError *error = nil;
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:bookmarkURL error:&error];
    if (error != nil)
    {
        NSLog(@"Error : %@",[error localizedDescription]);
    } else [player play];
    
    NSLog(@"isPlaying = %d",player.isPlaying);
    
    
    // startと同じくrespondsToSelectorでチェック
    if([bookmarkURL respondsToSelector:@selector(stopAccessingSecurityScopedResource)]) {
        //NSLog(@"Stop Access");
        [bookmarkURL stopAccessingSecurityScopedResource];
    }
}
@end
