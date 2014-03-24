//
//  InAppPurchaseAppDelegate.h
//  InAppPurchase
//
//  Created by Myounggyu JANG on 10. 12. 25..
//  Copyright 2010 귀여운 아들. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CONSUMABLE		0
#define NonCONSUMABLE   1

@class MainViewController;

@interface InAppPurchaseAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MainViewController * mainViewControll;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

