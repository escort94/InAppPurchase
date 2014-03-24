//-----------InAppPurchaseController.h--------------
	 
#import <Foundation/Foundation.h>
	 
#import <StoreKit/StoreKit.h>
 
@protocol inAppPurchaseControllerDelegate;

@interface inAppPurchaseController : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
	 NSString   *_productId;
	  id <inAppPurchaseControllerDelegate> delegate;
}
	 
@property(nonatomic, retain) id <inAppPurchaseControllerDelegate> delegate;
@property(copy)     NSString    *productId;
	 
- (id) init;
- (void) loadProductsInfo:(NSString *)productID;
- (void) makePurchase: (SKProduct *) product productType:(NSNumber *)pType;
- (BOOL) isPresentNonFinishedTransaction;

@end

@protocol inAppPurchaseControllerDelegate

- (void) purchaseController: (inAppPurchaseController *) controller didLoadInfo: (SKProduct *) products;

- (void) purchaseController: (inAppPurchaseController *) controller didFailLoadProductInfo: (NSError *) error;

- (void) purchaseController: (inAppPurchaseController *) controller didFinishPaymentTransaction: (SKPaymentTransaction *) transaction;

- (void) purchaseController: (inAppPurchaseController *) controller didFailPaymentTransactionWithError: (NSError *) error;

- (void) purchaseController: (inAppPurchaseController *) controller processAlertView: (NSError *)error;
	
- (void) purchaseController: (inAppPurchaseController *) controller dismissProcessAlertView: (NSError *)error;
@end
