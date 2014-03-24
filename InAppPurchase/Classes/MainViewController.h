//
//  MainViewController.h
//  InAppPurchase
//
//  Created by Myounggyu JANG on 10. 12. 25..
//  Copyright 2010 귀여운 아들. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "inAppPurchaseController.h"

//In App Purchase Code
#define kProdectId1 @"net.hanmail.powernix.demoiapsec.item1" // Consumable
#define kProdectId2 @"net.hanmail.powernix.demoiapsec.item2" // Non-Consumable

@class inAppPurchaseController;

@interface MainViewController : UIViewController <inAppPurchaseControllerDelegate, UIAlertViewDelegate> {

	UIButton *Button1;
	UIButton *Button2;
	
	UIAlertView * _alertView;
	
	NSString	* _productID;
	SKProduct	* _products;
	
	UIAlertView * _processAlertView;	
	UIAlertView * _requestAlertView;
	UIActivityIndicatorView * _activityView;
	NSInteger _productType;
	
	inAppPurchaseController * _inAppPurchase;
}
- (void)OnClickButton1:(id)sender;
- (void)OnClickButton2:(id)sender;

- (void) inAppPurchaseInit;
- (void) loadProductsInfo:(NSString *)productID;
- (void) showAlertView:(id)sender;
- (void) dismissProcessAlertView;
- (void) processAlertView;

- (void) presentActionSheet:(id)sender;
- (void) dismissActionSheet;
@end
