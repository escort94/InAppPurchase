//-------   InAppPurchaseController.m-----------
	 
#import "inAppPurchaseController.h"
#import "InAppPurchaseAppDelegate.h"	

@implementation inAppPurchaseController
	 
@synthesize productId = _productId;
@synthesize delegate;


- (id) init //1. 프로젝트 초기에 설정해야함 : 앱 결제 도중 중단될경우 다음 앱 실행시 나머지 과정을 자동으로 진행 되기 때문
{
	 
	if(self = [super init])
	 
	{
		NSLog(@"결제프로세스 대기중");
		[ [SKPaymentQueue defaultQueue] addTransactionObserver: self];
	
	}
	 
	return self;
	 
}
 
- (void) loadProductsInfo:(NSString *)productID //2
{
	self.productId = productID;
	
	SKProductsRequest *request = [ [SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: self.productId]];
	 
	[request setDelegate: self];
	 
	[request start];
	 
}

- (void) makePurchase: (SKProduct *) product productType:(NSNumber *)pType //3

{
	//SKPayment *payment;
	 
	if(![SKPaymentQueue canMakePayments])
	 
	{
	 
		[self.delegate purchaseController: self didFailPaymentTransactionWithError: [NSError errorWithDomain: @"payMentDomain" code:123 userInfo: [NSDictionary dictionaryWithObject: @"can not make paiments" forKey: NSLocalizedDescriptionKey]]];

	}
	
	// 1, 2 선택
	int productType = [pType intValue];
	switch (productType) {
		case CONSUMABLE:
			NSLog(@"1. Consumable	구매요청");
			[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
			break;			
		case NonCONSUMABLE:
			NSLog(@" 2. Non - Consumable 구매요청");
			SKPayment * payment = [SKPayment paymentWithProduct: product];
			[ [SKPaymentQueue defaultQueue] addPayment: payment];
			
			break;

	}
	
	[self.delegate purchaseController: self processAlertView:nil];
	 
}
	 
- (BOOL) isPresentNonFinishedTransaction //4
	 
	{
		
		NSLog(@"4");
		
	NSArray *arrTransactions = [ [SKPaymentQueue defaultQueue] transactions];
	 
	for(SKPaymentTransaction *transaction in arrTransactions)
	 
	{
	 
		if([transaction.payment.productIdentifier isEqualToString: self.productId])
	 
		{
		 
			if(transaction.transactionState == SKPaymentTransactionStatePurchasing)
		 
			{
			 
				return YES;
			 
			}
		 
			else if(transaction.transactionState == SKPaymentTransactionStateFailed)
			 
			{
				 
				[ [SKPaymentQueue defaultQueue] finishTransaction: transaction];
				 
			}
		 
		}
	 
	}
	 
	return NO;
	 
}
	 
#pragma mark ---------------request delegate-----------------
	 
- (void)requestDidFinish:(SKRequest *)request	 
{
	NSLog(@"5"); 
	[self.delegate purchaseController: self dismissProcessAlertView:nil];
}
 
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
	 
{
	NSLog(@"6"); 
	[self.delegate purchaseController: self didFailLoadProductInfo: error];
	 
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
 
{
 	NSLog(@"7");
	NSArray *invalidIdentifiers = [response invalidProductIdentifiers];
	 
	NSArray *products = [response products];
	 
	for(SKProduct *product in products)
	 
	{
	 
		NSString *strId = product.productIdentifier;
		 
		if([strId isEqualToString: self.productId])
		 
		{
		 
			[self.delegate purchaseController: self didLoadInfo: product];
			 
			return;
		 
		}
	 
	}
 
	if([invalidIdentifiers count])
	 
	{
	 
		[self.delegate purchaseController: self didFailLoadProductInfo: [NSError errorWithDomain: @"purchaseDomain" code: 143 userInfo: [NSDictionary dictionaryWithObject: @"No Products found" forKey: NSLocalizedDescriptionKey]]];
	 
	}
 
}
 
#pragma mark -------------------transaction observer-------------------
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
 
{
	NSLog(@"8"); 
	for(SKPaymentTransaction *transaction in transactions)
	 
	{
	 
		SKPayment *payment = [transaction payment];
		 
		if([payment.productIdentifier isEqualToString: self.productId])
		 
		{
		 
			if(transaction.transactionState == SKPaymentTransactionStatePurchased)
			 
			{
			 
				[self.delegate purchaseController: self didFinishPaymentTransaction: transaction];
				 
				[queue finishTransaction: transaction];
			 
			}
		 
			else if(transaction.transactionState == SKPaymentTransactionStateFailed)
			 
			{
			 
				[self.delegate purchaseController: self didFailPaymentTransactionWithError: [NSError errorWithDomain: @"purchaseDomain" code: 1542 userInfo: nil]];
				 
				[queue finishTransaction: transaction];
			
			}
		 
		}
		 
	}
 
}
 
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
	NSLog(@"9"); 
}
 

// Consumable Completed

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue { 
	
	NSLog(@"paymentQueueRestoreCompletedTransactionsFinished");
	
	[self.delegate purchaseController: self didFinishPaymentTransaction:nil];
	
}
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
	NSLog(@"restoreCompletedTransactionsFailedWithError");
	
	[self.delegate purchaseController: self didFailPaymentTransactionWithError: nil];				 
}

- (void) dealloc
{
 
	[ [SKPaymentQueue defaultQueue] removeTransactionObserver: self];
	 
	[super dealloc];
 
}
 
@end