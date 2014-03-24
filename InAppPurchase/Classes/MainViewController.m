    //
//  MainViewController.m
//  InAppPurchase
//
//  Created by Myounggyu JANG on 10. 12. 25..
//  Copyright 2010 귀여운 아들. All rights reserved.
//

#import "MainViewController.h"
#import "InAppPurchaseAppDelegate.h"

@implementation MainViewController

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0,80, 320, 30)];
	title.text = @"In App Purchase";
	title.textAlignment = UITextAlignmentCenter;
	[self.view addSubview:title];
	
	Button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[Button1 setTitle:@"상품 #1" forState:UIControlStateNormal];
	[Button1 setFrame:CGRectMake(50, 150, 220, 42)];
	[Button1 addTarget:self action:@selector(OnClickButton1:) forControlEvents:UIControlEventTouchUpInside];

	
	Button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[Button2 setTitle:@"상품 #2" forState:UIControlStateNormal];
	[Button2 setFrame:CGRectMake(50, 220, 220, 42)];
	[Button2 addTarget:self action:@selector(OnClickButton2:) forControlEvents:UIControlEventTouchUpInside];

	
	[self.view addSubview:Button1];
	[self.view addSubview:Button2];
	
	[self inAppPurchaseInit]; // In App Purchase 클래스를 뷰 초기에 미리 할당해 준다. 
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void) inAppPurchaseInit  {
	_inAppPurchase = [[inAppPurchaseController alloc] init];
	_inAppPurchase.delegate = self;
}

- (void)OnClickButton1:(id)sender {
	
	NSNumber * number = [NSNumber numberWithInt:CONSUMABLE];	
	[self showAlertView:number];
}

- (void)OnClickButton2:(id)sender {
	NSNumber * number = [NSNumber numberWithInt:NonCONSUMABLE];	
	[self showAlertView:number];
}


#pragma mark ALERTVIEW TEST
- (void) showAlertView:(id)sender {
	
	NSString * message ;
	NSString * title;
	
	int number = [sender intValue]; 
	
	
	switch (number) {
		case CONSUMABLE:
			title = @"Consumable";
			message = @"구입시 매번 결제를 합니다.\n구매 할까요?\n";
			_productID = kProdectId1;			
			_productType = CONSUMABLE;
			_alertView = [[UIAlertView alloc]	initWithTitle:title message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"BUY", nil];
			[_alertView show];
			[_alertView release];				
			break;
			
		case NonCONSUMABLE:
			title = @"Non Consumable";
			message = @"1회만 결제되며 다음부터는 무료입니다.\n구매 할까요?\n";
			_productID = kProdectId2;
			_productType = NonCONSUMABLE;
			_alertView = [[UIAlertView alloc]	initWithTitle:title message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"BUY", nil];
			[_alertView show];
			[_alertView release];
			break;
			
		default:
			break;
	}
	
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	if (alertView == _alertView) { // 애플사이트에 아이템 정보 요청하기
		if (buttonIndex == 0) // "취소" 버튼
		{
			
		} else { //"구매하기 위한 정보 요청"			
			[self processAlertView]; // 애플 서버 접속중임을 알림
			[self loadProductsInfo:_productID];
			
		}
	} else if (alertView == _requestAlertView) { // 애플사이트에 등록된 아이템 정보 확인용 알림창 
		if (buttonIndex == 0) // "취소" 버튼
		{
			//[self dismissActionSheet];
		} else { //"실제 애플서버에 구매요청"			
			NSNumber * pType = [NSNumber numberWithInt:_productType];
			[_inAppPurchase makePurchase:_products productType:pType];
		}
	} 
	
	
}
- (void) processAlertView {
	_processAlertView = [[UIAlertView alloc]	initWithTitle:nil message:@"잠시만 기다려 주세요." delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
	_activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[_processAlertView addSubview:_activityView];
	_activityView.frame = CGRectMake(120, 60, 30, 30);
	[_activityView startAnimating];
	[_processAlertView show];
	
}

- (void) loadProductsInfo:(NSString *)productID { // 애플서버 접속요청
	[_inAppPurchase  loadProductsInfo:productID];
}


- (void) dismissProcessAlertView {
	if(_processAlertView != nil) {
		[_processAlertView dismissWithClickedButtonIndex:0 animated:YES];
		[_processAlertView release];
		_processAlertView = nil;
	}
}

#pragma mark 구매 진행

//상품 정보를 본다.
- (void) purchaseController: (inAppPurchaseController *) controller didLoadInfo: (SKProduct *) products {
	
	
	
	NSLog(@"%@ : %@", products.localizedTitle, products.localizedDescription);
	NSString * title = [NSString stringWithFormat:@"%@",products.localizedTitle];
	NSString * message = [NSString stringWithFormat:@"%@", products.localizedDescription];
	
	NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
	[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
	[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle]; //달러 표기 하기
	[numberFormatter setLocale:products.priceLocale];
	NSString *strPrice = [numberFormatter stringFromNumber:products.price];
	[numberFormatter release];
	
    
    //2014.3.4 mgjang
    //_products = products; //변경전
	_products = [products retain]; //변경후
	
	//접속 성공, 실제 가격 정보 보기
	_requestAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:strPrice, nil];
	[_requestAlertView show];
	[_requestAlertView release];
	
}
 
/*
// 위 상풍 정보가 필요 없을 경우 바로 결제 처리 과정으로 진행한다.
 - (void) purchaseController: (inAppPurchaseController *) controller didLoadInfo: (SKProduct *) products {
 NSLog(@"1111");	
	[_inAppPurchase makePurchase:_productID productType:_productType];	
 
 }
*/ 
- (void) purchaseController: (inAppPurchaseController *) controller didFailLoadProductInfo: (NSError *) error {
	NSLog(@"실패");	
	[self dismissProcessAlertView];
	UIAlertView * alertView = [[UIAlertView alloc]	initWithTitle:@"알림" message:@"네트워크 접속이 불안정합니다.\n다시 시도해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
	[alertView show];
	[alertView release];
	
}

- (void) purchaseController: (inAppPurchaseController *) controller didFinishPaymentTransaction: (SKPaymentTransaction *) transaction {
	
	/*
	 결제 완료후 처리코드 부분
	 
	 
	 */
	[self dismissProcessAlertView];
	UIAlertView * alertView = [[UIAlertView alloc]	initWithTitle:@"구매해 주셔서 감사합니다." message:nil delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
	[alertView show];
	[alertView release];
	
}

- (void) purchaseController: (inAppPurchaseController *) controller didFailPaymentTransactionWithError: (NSError *) error {
	NSLog(@"이미 결제 되었거나 결제 취소됨");
	[self dismissProcessAlertView];
}

- (void) purchaseController: (inAppPurchaseController *) controller processAlertView: (NSError *)error {
	
	[self processAlertView];
	
}

- (void) purchaseController: (inAppPurchaseController *) controller dismissProcessAlertView: (NSError *)error {

	[self dismissProcessAlertView];

}
@end
