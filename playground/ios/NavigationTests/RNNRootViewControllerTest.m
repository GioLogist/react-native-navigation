#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <ReactNativeNavigation/RNNComponentViewController.h>
#import "RNNReactRootViewCreator.h"
#import "RNNTestRootViewCreator.h"
#import <React/RCTConvert.h>
#import "RNNNavigationOptions.h"
#import "RNNStackController.h"
#import "RNNBottomTabsController.h"
#import "RNNUIBarButtonItem.h"


@interface RNNComponentViewController (EmbedInTabBar)
- (void)embedInTabBarController;
@end

@implementation RNNComponentViewController (EmbedInTabBar)

- (void)embedInTabBarController {
	RNNBottomTabsController* tabVC = [[RNNBottomTabsController alloc] init];
	tabVC.viewControllers = @[self];
	[self viewWillAppear:false];
}

@end

@interface RNNRootViewControllerTest : XCTestCase

@property (nonatomic, strong) id<RNNComponentViewCreator> creator;
@property (nonatomic, strong) NSString* pageName;
@property (nonatomic, strong) NSString* componentId;
@property (nonatomic, strong) id emitter;
@property (nonatomic, strong) RNNNavigationOptions* options;
@property (nonatomic, strong) RNNLayoutInfo* layoutInfo;
@property (nonatomic, strong) RNNComponentViewController* uut;
@end

@implementation RNNRootViewControllerTest

- (void)setUp {
	[super setUp];
	self.creator = [[RNNTestRootViewCreator alloc] init];
	self.pageName = @"somename";
	self.componentId = @"cntId";
	self.emitter = nil;
	self.options = [[RNNNavigationOptions alloc] initWithDict:@{}];
	
	RNNLayoutInfo* layoutInfo = [RNNLayoutInfo new];
	layoutInfo.componentId = self.componentId;
	layoutInfo.name = self.pageName;
	
	id presenter = [OCMockObject partialMockForObject:[[RNNComponentPresenter alloc] init]];
	self.uut = [[RNNComponentViewController alloc] initWithLayoutInfo:layoutInfo rootViewCreator:self.creator eventEmitter:self.emitter presenter:presenter options:self.options defaultOptions:nil];
}

-(void)testTopBarBackgroundColor_validColor{
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.topBar.background.color = [[Color alloc] initWithValue:[RCTConvert UIColor:inputColor]];
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];

	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.backgroundColor isEqual:expectedColor]);
}

-(void)testTopBarBackgroundColorWithoutNavigationController{
	NSNumber* inputColor = @(0xFFFF0000);
	self.options.topBar.background.color = [[Color alloc] initWithValue:[RCTConvert UIColor:inputColor]];

	XCTAssertNoThrow([self.uut viewWillAppear:false]);
}

- (void)testStatusBarHidden_default {
	[self.uut viewWillAppear:false];

	XCTAssertFalse([self.uut prefersStatusBarHidden]);
}

- (void)testStatusBarVisible_false {
	self.options.statusBar.visible = [[Bool alloc] initWithValue:@(0)];
	[self.uut viewWillAppear:false];

	XCTAssertTrue([self.uut prefersStatusBarHidden]);
}

- (void)testStatusBarVisible_true {
	self.options.statusBar.visible = [[Bool alloc] initWithValue:@(1)];
	[self.uut viewWillAppear:false];
	
	XCTAssertFalse([self.uut prefersStatusBarHidden]);
}

- (void)testStatusBarHideWithTopBar_false {
	self.options.statusBar.hideWithTopBar = [[Bool alloc] initWithValue:@(0)];
	self.options.topBar.visible = [[Bool alloc] initWithValue:@(0)];
	[self.uut viewWillAppear:false];

	XCTAssertFalse([self.uut prefersStatusBarHidden]);
}

- (void)testStatusBarHideWithTopBar_true {
	self.options.statusBar.hideWithTopBar = [[Bool alloc] initWithValue:@(1)];
	self.options.topBar.visible = [[Bool alloc] initWithValue:@(0)];
	__unused RNNStackController* nav = [self createNavigationController];

	[self.uut viewWillAppear:false];

	XCTAssertTrue([self.uut prefersStatusBarHidden]);
}

-(void)testTitle_string{
	NSString* title =@"some title";
	self.options.topBar.title.text = [[Text alloc] initWithValue:title];

	[self.uut viewWillAppear:false];
	XCTAssertTrue([self.uut.navigationItem.title isEqual:title]);
}

-(void)testTitle_default{
	[self.uut viewWillAppear:false];
	XCTAssertNil(self.uut.navigationItem.title);
}

-(void)testTopBarTextColor_validColor{
	UIColor* inputColor = [RCTConvert UIColor:@(0xFFFF0000)];
	self.options.topBar.title.color = [[Color alloc] initWithValue:inputColor];
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.titleTextAttributes[@"NSColor"] isEqual:expectedColor]);
}

-(void)testbackgroundColor_validColor{
	UIColor* inputColor = [RCTConvert UIColor:@(0xFFFF0000)];
	self.options.layout.backgroundColor = [[Color alloc] initWithValue:inputColor];
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.view.backgroundColor isEqual:expectedColor]);
}

-(void)testTopBarTextFontFamily_validFont{
	NSString* inputFont = @"HelveticaNeue";
	__unused RNNStackController* nav = [self createNavigationController];
	self.options.topBar.title.fontFamily = [[Text alloc] initWithValue:inputFont];
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont fontWithName:inputFont size:17];
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
}

-(void)testTopBarHideOnScroll_true {
	NSNumber* hideOnScrollInput = @(1);
	__unused RNNStackController* nav = [self createNavigationController];
	self.options.topBar.hideOnScroll = [[Bool alloc] initWithValue:hideOnScrollInput];;
	[self.uut viewWillAppear:false];
	XCTAssertTrue(self.uut.navigationController.hidesBarsOnSwipe);
}

-(void)testTopBarTranslucent {
	NSNumber* topBarTranslucentInput = @(0);
	self.options.topBar.background.translucent = [[Bool alloc] initWithValue:topBarTranslucentInput];
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	XCTAssertFalse(self.uut.navigationController.navigationBar.translucent);
}

-(void)testTabBadge {
	NSString* tabBadgeInput = @"5";
	self.options.bottomTab.badge = [[Text alloc] initWithValue:tabBadgeInput];
	__unused RNNBottomTabsController* vc = [[RNNBottomTabsController alloc] init];
	NSMutableArray* controllers = [NSMutableArray new];
	UITabBarItem* item = [[UITabBarItem alloc] initWithTitle:@"A Tab" image:nil tag:1];
	[self.uut setTabBarItem:item];
	[controllers addObject:self.uut];
	[vc setViewControllers:controllers];
	[self.uut viewWillAppear:false];
	XCTAssertTrue([self.uut.tabBarItem.badgeValue isEqualToString:tabBadgeInput]);

}

-(void)testTopBarLargeTitle_default {
	[self.uut viewWillAppear:false];

	XCTAssertEqual(self.uut.navigationItem.largeTitleDisplayMode,  UINavigationItemLargeTitleDisplayModeNever);
}

-(void)testTopBarLargeTitle_true {
	self.options.topBar.largeTitle.visible = [[Bool alloc] initWithValue:@(1)];
	[self.uut viewWillAppear:false];
	
	XCTAssertEqual(self.uut.navigationItem.largeTitleDisplayMode, UINavigationItemLargeTitleDisplayModeAlways);
}

-(void)testTopBarLargeTitle_false {
	self.options.topBar.largeTitle.visible = [[Bool alloc] initWithValue:@(0)];
	[self.uut viewWillAppear:false];
	
	XCTAssertEqual(self.uut.navigationItem.largeTitleDisplayMode, UINavigationItemLargeTitleDisplayModeNever);
}


-(void)testTopBarLargeTitleFontSize_withoutTextFontFamily_withoutTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	self.options.topBar.largeTitle.fontSize = [[Number alloc] initWithValue:topBarTextFontSizeInput];
	__unused RNNStackController* nav = [self createNavigationController];
	UIFont* initialFont = self.uut.navigationController.navigationBar.standardAppearance.largeTitleTextAttributes[@"NSFont"];
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont fontWithDescriptor:initialFont.fontDescriptor size:topBarTextFontSizeInput.floatValue];
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.largeTitleTextAttributes[@"NSFont"] isEqual:expectedFont]);
}

-(void)testTopBarLargeTitleFontSize_withoutTextFontFamily_withTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	UIColor* inputColor = [RCTConvert UIColor:@(0xFFFF0000)];
	self.options.topBar.largeTitle.fontSize = [[Number alloc] initWithValue:topBarTextFontSizeInput];
	self.options.topBar.largeTitle.color = [[Color alloc] initWithValue:inputColor];
	__unused RNNStackController* nav = [self createNavigationController];
	UIFont* initialFont = self.uut.navigationController.navigationBar.standardAppearance.largeTitleTextAttributes[@"NSFont"];
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont fontWithDescriptor:initialFont.fontDescriptor size:topBarTextFontSizeInput.floatValue];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.largeTitleTextAttributes[@"NSFont"] isEqual:expectedFont]);
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.largeTitleTextAttributes[@"NSColor"] isEqual:expectedColor]);
}

-(void)testTopBarLargeTitleFontSize_withTextFontFamily_withTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	UIColor* inputColor = [RCTConvert UIColor:@(0xFFFF0000)];
	NSString* inputFont = @"HelveticaNeue";
	self.options.topBar.largeTitle.fontSize = [[Number alloc] initWithValue:topBarTextFontSizeInput];
	self.options.topBar.largeTitle.color = [[Color alloc] initWithValue:inputColor];
	self.options.topBar.largeTitle.fontFamily = [[Text alloc] initWithValue:inputFont];
	
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	UIFont* expectedFont = [UIFont fontWithName:inputFont size:15];
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.largeTitleTextAttributes[@"NSFont"] isEqual:expectedFont]);
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.largeTitleTextAttributes[@"NSColor"] isEqual:expectedColor]);
}

-(void)testTopBarLargeTitleFontSize_withTextFontFamily_withoutTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	NSString* inputFont = @"HelveticaNeue";
	self.options.topBar.largeTitle.fontSize = [[Number alloc] initWithValue:topBarTextFontSizeInput];
	self.options.topBar.largeTitle.fontFamily = [[Text alloc] initWithValue:inputFont];
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont fontWithName:inputFont size:15];
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.largeTitleTextAttributes[@"NSFont"] isEqual:expectedFont]);
}


-(void)testTopBarTextFontSize_withoutTextFontFamily_withoutTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	self.options.topBar.title.fontSize = [[Number alloc] initWithValue:topBarTextFontSizeInput];
	__unused RNNStackController* nav = [self createNavigationController];
	UIFont* initialFont = self.uut.navigationController.navigationBar.standardAppearance.titleTextAttributes[@"NSFont"];
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont fontWithDescriptor:initialFont.fontDescriptor size:topBarTextFontSizeInput.floatValue];
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
}

-(void)testTopBarTextFontSize_withoutTextFontFamily_withTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	UIColor* inputColor = [RCTConvert UIColor:@(0xFFFF0000)];
	self.options.topBar.title.fontSize = [[Number alloc] initWithValue:topBarTextFontSizeInput];
	self.options.topBar.title.color = [[Color alloc] initWithValue:inputColor];
	__unused RNNStackController* nav = [self createNavigationController];
	UIFont* initialFont = self.uut.navigationController.navigationBar.standardAppearance.titleTextAttributes[@"NSFont"];
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont fontWithDescriptor:initialFont.fontDescriptor size:topBarTextFontSizeInput.floatValue];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.titleTextAttributes[@"NSColor"] isEqual:expectedColor]);
}

-(void)testTopBarTextFontSize_withTextFontFamily_withTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	UIColor* inputColor = [RCTConvert UIColor:@(0xFFFF0000)];
	NSString* inputFont = @"HelveticaNeue";
	self.options.topBar.title.fontSize = [[Number alloc] initWithValue:topBarTextFontSizeInput];
	self.options.topBar.title.color = [[Color alloc] initWithValue:inputColor];
	self.options.topBar.title.fontFamily = [[Text alloc] initWithValue:inputFont];
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIColor* expectedColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
	UIFont* expectedFont = [UIFont fontWithName:inputFont size:15];
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.titleTextAttributes[@"NSColor"] isEqual:expectedColor]);
}

-(void)testTopBarTextFontSize_withTextFontFamily_withoutTextColor {
	NSNumber* topBarTextFontSizeInput = @(15);
	NSString* inputFont = @"HelveticaNeue";
	self.options.topBar.title.fontSize = [[Number alloc] initWithValue:topBarTextFontSizeInput];
	self.options.topBar.title.fontFamily = [[Text alloc] initWithValue:inputFont];
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIFont* expectedFont = [UIFont fontWithName:inputFont size:15];
	XCTAssertTrue([self.uut.navigationController.navigationBar.standardAppearance.titleTextAttributes[@"NSFont"] isEqual:expectedFont]);
}

// TODO: Currently not passing
-(void)testTopBarTextFontFamily_invalidFont{
	NSString* inputFont = @"HelveticaNeueeeee";
	__unused RNNStackController* nav = [self createNavigationController];
	self.options.topBar.title.fontFamily = [[Text alloc] initWithValue:inputFont];
	//	XCTAssertThrows([self.uut viewWillAppear:false]);
}

-(void)testOrientation_portrait {
	NSArray* supportedOrientations = @[@"portrait"];
	self.options.layout.orientation = supportedOrientations;
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIInterfaceOrientationMask expectedOrientation = UIInterfaceOrientationMaskPortrait;
	XCTAssertTrue(self.uut.navigationController.supportedInterfaceOrientations == expectedOrientation);
}

-(void)testOrientation_portraitString {
	NSString* supportedOrientation = @"portrait";
	self.options.layout.orientation = supportedOrientation;
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIInterfaceOrientationMask expectedOrientation = (UIInterfaceOrientationMaskPortrait);
	XCTAssertTrue(self.uut.navigationController.supportedInterfaceOrientations == expectedOrientation);
}

-(void)testOrientation_portraitAndLandscape {
	NSArray* supportedOrientations = @[@"portrait", @"landscape"];
	self.options.layout.orientation = supportedOrientations;
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIInterfaceOrientationMask expectedOrientation = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape);
	XCTAssertTrue(self.uut.navigationController.supportedInterfaceOrientations == expectedOrientation);
}

-(void)testOrientation_all {
	NSArray* supportedOrientations = @[@"all"];
	self.options.layout.orientation = supportedOrientations;
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIInterfaceOrientationMask expectedOrientation = UIInterfaceOrientationMaskAll;
	XCTAssertTrue(self.uut.navigationController.supportedInterfaceOrientations == expectedOrientation);
}

-(void)testOrientation_default {
	NSString* supportedOrientations = @"default";
	self.options.layout.orientation = supportedOrientations;
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	UIInterfaceOrientationMask expectedOrientation = [[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:[[UIApplication sharedApplication] keyWindow]];
	XCTAssertTrue(self.uut.navigationController.supportedInterfaceOrientations == expectedOrientation);
}


-(void)testOrientationTabsController_portrait {
	NSArray* supportedOrientations = @[@"portrait"];
	self.options.layout.orientation = supportedOrientations;
	NSMutableArray* controllers = [[NSMutableArray alloc] initWithArray:@[self.uut]];
    __unused RNNBottomTabsController* vc = [[RNNBottomTabsController alloc] initWithLayoutInfo:nil creator:nil options:[[RNNNavigationOptions alloc] initEmptyOptions] defaultOptions:nil presenter:[RNNComponentPresenter new] eventEmitter:nil childViewControllers:controllers];

	[self.uut viewWillAppear:false];

	UIInterfaceOrientationMask expectedOrientation = UIInterfaceOrientationMaskPortrait;
	XCTAssertTrue(self.uut.tabBarController.supportedInterfaceOrientations == expectedOrientation);
}

-(void)testOrientationTabsController_portraitAndLandscape {
	NSArray* supportedOrientations = @[@"portrait", @"landscape"];
	self.options.layout.orientation = supportedOrientations;
    NSMutableArray* controllers = [[NSMutableArray alloc] initWithArray:@[self.uut]];
    __unused RNNBottomTabsController* vc = [[RNNBottomTabsController alloc] initWithLayoutInfo:nil creator:nil options:[[RNNNavigationOptions alloc] initEmptyOptions] defaultOptions:nil presenter:[RNNComponentPresenter new] eventEmitter:nil childViewControllers:controllers];

	[self.uut viewWillAppear:false];

	UIInterfaceOrientationMask expectedOrientation = (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape);
	XCTAssertTrue(self.uut.tabBarController.supportedInterfaceOrientations == expectedOrientation);
}

-(void)testOrientationTabsController_all {
	NSArray* supportedOrientations = @[@"all"];
	self.options.layout.orientation = supportedOrientations;
	NSMutableArray* controllers = [[NSMutableArray alloc] initWithArray:@[self.uut]];
	__unused RNNBottomTabsController* vc = [[RNNBottomTabsController alloc] initWithLayoutInfo:nil creator:nil options:[[RNNNavigationOptions alloc] initEmptyOptions] defaultOptions:nil presenter:[RNNComponentPresenter new] eventEmitter:nil childViewControllers:controllers];

	[self.uut viewWillAppear:false];

	UIInterfaceOrientationMask expectedOrientation = UIInterfaceOrientationMaskAll;
	XCTAssertTrue(self.uut.tabBarController.supportedInterfaceOrientations == expectedOrientation);
}

-(void)testRightButtonsWithTitle_withoutStyle {
	self.options.topBar.rightButtons = @[@{@"id": @"testId", @"text": @"test"}];
	self.uut = [[RNNComponentViewController alloc] initWithLayoutInfo:nil rootViewCreator:nil eventEmitter:nil presenter:[RNNComponentPresenter new] options:self.options defaultOptions:nil];
	RNNStackController* nav = [[RNNStackController alloc] initWithLayoutInfo:nil creator:_creator options:nil defaultOptions:nil presenter:nil eventEmitter:nil childViewControllers:@[self.uut]];

	RNNUIBarButtonItem* button = (RNNUIBarButtonItem*) nav.topViewController.navigationItem.rightBarButtonItems[0];
	NSString* expectedButtonId = @"testId";
	NSString* expectedTitle = @"test";
	XCTAssertTrue([button.buttonId isEqualToString:expectedButtonId]);
	XCTAssertTrue([button.title isEqualToString:expectedTitle]);
	XCTAssertTrue(button.enabled);
}

-(void)testRightButtonsWithTitle_withStyle {
	NSNumber* inputColor = @(0xFFFF0000);

	self.options.topBar.rightButtons = @[@{@"id": @"testId", @"text": @"test", @"enabled": @false, @"buttonColor": inputColor, @"buttonFontSize": @22, @"buttonFontWeight": @"800"}];
	self.uut = [[RNNComponentViewController alloc] initWithLayoutInfo:nil rootViewCreator:nil eventEmitter:nil presenter:[RNNComponentPresenter new] options:self.options defaultOptions:nil];
	RNNStackController* nav = [[RNNStackController alloc] initWithLayoutInfo:nil creator:_creator options:nil defaultOptions:nil presenter:nil eventEmitter:nil childViewControllers:@[self.uut]];

	RNNUIBarButtonItem* button = (RNNUIBarButtonItem*)[nav.topViewController.navigationItem.rightBarButtonItems objectAtIndex:0];
	NSString* expectedButtonId = @"testId";
	NSString* expectedTitle = @"test";
	XCTAssertTrue([button.buttonId isEqualToString:expectedButtonId]);
	XCTAssertTrue([button.title isEqualToString:expectedTitle]);
	XCTAssertFalse(button.enabled);

	//TODO: Determine how to tests buttonColor,buttonFontSize and buttonFontWeight?
}

-(void)testLeftButtonsWithTitle_withoutStyle {
	self.options.topBar.leftButtons = @[@{@"id": @"testId", @"text": @"test"}];
	self.uut = [[RNNComponentViewController alloc] initWithLayoutInfo:nil rootViewCreator:nil eventEmitter:nil presenter:[RNNComponentPresenter new] options:self.options defaultOptions:nil];
	RNNStackController* nav = [[RNNStackController alloc] initWithLayoutInfo:nil creator:_creator options:nil defaultOptions:nil presenter:nil eventEmitter:nil childViewControllers:@[self.uut]];
	
	RNNUIBarButtonItem* button = (RNNUIBarButtonItem*)[nav.topViewController.navigationItem.leftBarButtonItems objectAtIndex:0];
	NSString* expectedButtonId = @"testId";
	NSString* expectedTitle = @"test";
	XCTAssertTrue([button.buttonId isEqualToString:expectedButtonId]);
	XCTAssertTrue([button.title isEqualToString:expectedTitle]);
	XCTAssertTrue(button.enabled);
}

-(void)testLeftButtonsWithTitle_withStyle {
	NSNumber* inputColor = @(0xFFFF0000);

	self.options.topBar.leftButtons = @[@{@"id": @"testId", @"text": @"test", @"enabled": @false, @"buttonColor": inputColor, @"buttonFontSize": @22, @"buttonFontWeight": @"800"}];
	self.uut = [[RNNComponentViewController alloc] initWithLayoutInfo:nil rootViewCreator:nil eventEmitter:nil presenter:[RNNComponentPresenter new] options:self.options defaultOptions:nil];
	RNNStackController* nav = [[RNNStackController alloc] initWithLayoutInfo:nil creator:_creator options:nil defaultOptions:nil presenter:nil eventEmitter:nil childViewControllers:@[self.uut]];

	RNNUIBarButtonItem* button = (RNNUIBarButtonItem*)[nav.topViewController.navigationItem.leftBarButtonItems objectAtIndex:0];
	NSString* expectedButtonId = @"testId";
	NSString* expectedTitle = @"test";
	XCTAssertTrue([button.buttonId isEqualToString:expectedButtonId]);
	XCTAssertTrue([button.title isEqualToString:expectedTitle]);
	XCTAssertFalse(button.enabled);

	//TODO: Determine how to tests buttonColor,buttonFontSize and buttonFontWeight?
}

-(void)testTopBarNoBorderOn {
	NSNumber* topBarNoBorderInput = @(1);
	self.options.topBar.noBorder = [[Bool alloc] initWithValue:topBarNoBorderInput];
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	XCTAssertNil(self.uut.navigationController.navigationBar.standardAppearance.shadowColor);
}

-(void)testTopBarNoBorderOff {
	NSNumber* topBarNoBorderInput = @(0);
	self.options.topBar.noBorder = [[Bool alloc] initWithValue:topBarNoBorderInput];
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	XCTAssertEqual(self.uut.navigationController.navigationBar.standardAppearance.shadowColor, [UINavigationBarAppearance new].shadowColor);
}

-(void)testStatusBarBlurOn {
	NSNumber* statusBarBlurInput = @(1);
	self.options.statusBar.blur = [[Bool alloc] initWithValue:statusBarBlurInput];
	[self.uut viewWillAppear:false];
	XCTAssertNotNil([self.uut.view viewWithTag:BLUR_STATUS_TAG]);
}

-(void)testStatusBarBlurOff {
	NSNumber* statusBarBlurInput = @(0);
	self.options.statusBar.blur = [[Bool alloc] initWithValue:statusBarBlurInput];
	[self.uut viewWillAppear:false];
	XCTAssertNil([self.uut.view viewWithTag:BLUR_STATUS_TAG]);
}

- (void)testTabBarHidden_default {
	[self.uut viewWillAppear:false];

	XCTAssertFalse([self.uut hidesBottomBarWhenPushed]);
}

- (void)testTabBarHidden_false {
	self.options.bottomTabs.visible = [[Bool alloc] initWithValue:@(1)];
	[self.uut viewWillAppear:false];

	XCTAssertFalse([self.uut hidesBottomBarWhenPushed]);
}

-(void)testTopBarBlur_default {
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	XCTAssertNil([self.uut.navigationController.navigationBar viewWithTag:BLUR_TOPBAR_TAG]);
}

-(void)testTopBarBlur_false {
	NSNumber* topBarBlurInput = @(0);
	self.options.topBar.background.blur = [[Bool alloc] initWithValue:topBarBlurInput];
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	XCTAssertNil([self.uut.navigationController.navigationBar viewWithTag:BLUR_TOPBAR_TAG]);
}

-(void)testTopBarBlur_true {
	NSNumber* topBarBlurInput = @(1);
	self.options.topBar.background.blur = [[Bool alloc] initWithValue:topBarBlurInput];
	__unused RNNStackController* nav = [self createNavigationController];
	[self.uut viewWillAppear:false];
	XCTAssertNotNil([self.uut.navigationController.navigationBar viewWithTag:BLUR_TOPBAR_TAG]);
}

-(void)testBackgroundImage {
	Image* backgroundImage = [[Image alloc] initWithValue:[[UIImage alloc] init]];
	self.options.backgroundImage = backgroundImage;
	[self.uut viewWillAppear:false];

	XCTAssertTrue([[(UIImageView*)self.uut.view.subviews[0] image] isEqual:backgroundImage.get]);
}

- (void)testMergeOptionsShouldCallPresenterMergeOptions {
	RNNNavigationOptions* newOptions = [[RNNNavigationOptions alloc] initEmptyOptions];
    [[(id) self.uut.presenter expect] mergeOptions:newOptions resolvedOptions:self.uut.options];
	[self.uut mergeOptions:newOptions];
	[(id)self.uut.presenter verify];
}

- (void)testOverrideOptions {
	RNNNavigationOptions* newOptions = [[RNNNavigationOptions alloc] initEmptyOptions];
	newOptions.topBar.background.color = [[Color alloc] initWithValue:[UIColor redColor]];
	
	[self.uut overrideOptions:newOptions];
	XCTAssertEqual([UIColor redColor], self.uut.options.topBar.background.color.get);
}

#pragma mark BottomTabs


- (RNNStackController *)createNavigationController {
	RNNStackController* nav = [[RNNStackController alloc] initWithLayoutInfo:nil creator:nil options:[[RNNNavigationOptions alloc] initEmptyOptions] defaultOptions:nil presenter:[[RNNStackPresenter alloc] init] eventEmitter:nil childViewControllers:@[self.uut]];
	
	return nav;
}

@end
