#import <XCTest/XCTest.h>
#import "MPKitMovableInk.h"

@interface mParticle_MovableInkTests : XCTestCase

@property (nonatomic, strong, nullable) MPKitMovableInk *kit;

@end

@implementation mParticle_MovableInkTests

- (void)setUp {
  _kit = [[MPKitMovableInk alloc] init];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testModuleID {
  XCTAssertEqualObjects([MPKitMovableInk kitCode], @179);
}

- (void)testStarted {
  MPKitExecStatus *execResult = [_kit didFinishLaunchingWithConfiguration:@{
    @"miApiKey": @"12345",
    @"miDomains": @"mi.example.com, mi2.example.com"
  }];
  
  XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
  XCTAssertTrue(_kit.started);
}

- (void)testInvalidConfiguration {
  NSMutableDictionary *config = [[NSMutableDictionary alloc] init];
  
  MPKitExecStatus *execResult = [_kit didFinishLaunchingWithConfiguration:config];
  
  XCTAssertTrue([execResult returnCode] == MPKitReturnCodeRequirementsNotMet);
}

- (void)testLogEventProductViewed {
  MPProduct *product = [[MPProduct alloc] initWithName:@"Test Product" sku:@"12345" quantity:@0 price:@1.00];
  product.category = @"Test Category";
  
  MPCommerceEvent *event = [[MPCommerceEvent alloc] initWithAction:MPCommerceEventActionViewDetail product:product];
  event.currency = @"USD";
  
  MPKitExecStatus *execResult = [_kit logBaseEvent:event];
  
  XCTAssert([execResult forwardCount] > 1);
  XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testLogEventProductAdded {
  MPProduct *product = [[MPProduct alloc] initWithName:@"Test Product" sku:@"12345" quantity:@1 price:@1.00];
  product.category = @"Test Category";
  
  MPCommerceEvent *event = [[MPCommerceEvent alloc] initWithAction:MPCommerceEventActionAddToCart product:product];
  event.currency = @"USD";
  
  MPKitExecStatus *execResult = [_kit logBaseEvent:event];
  
  XCTAssert([execResult forwardCount] > 1);
  XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testLogEventProductRemoved {
  MPProduct *product = [[MPProduct alloc] initWithName:@"Test Product" sku:@"12345" quantity:@1 price:@1.00];
  product.category = @"Test Category";
  
  MPCommerceEvent *event = [[MPCommerceEvent alloc] initWithAction:MPCommerceEventActionRemoveFromCart product:product];
  event.currency = @"USD";
  
  MPKitExecStatus *execResult = [_kit logBaseEvent:event];
  
  XCTAssert([execResult forwardCount] > 1);
  XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testLogEventProductPurchased {
  MPProduct *product = [[MPProduct alloc] initWithName:@"Test Product" sku:@"12345" quantity:@1 price:@1.00];
  
  MPCommerceEvent *event = [[MPCommerceEvent alloc] initWithAction:MPCommerceEventActionPurchase product:product];
  event.currency = @"USD";
  
  MPKitExecStatus *execResult = [_kit logBaseEvent:event];
  XCTAssert([execResult forwardCount] > 1);
  XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testLogEventUnknownCommerce {
  MPProduct *product = [[MPProduct alloc] initWithName:@"Test Product" sku:@"12345" quantity:@1 price:@1.00];
  
  MPCommerceEvent *event = [[MPCommerceEvent alloc] initWithAction:MPCommerceEventActionAddToWishList product:product];
  event.currency = @"USD";
  
  MPKitExecStatus *execResult = [_kit logBaseEvent:event];
  NSLog(@"forwardCount: %ld", [execResult forwardCount]);
  
  XCTAssert([execResult forwardCount] < 2);
  XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testLogEventProductSearched {
  MPEvent *event = [[MPEvent alloc] initWithName:@"product searched" type:MPEventTypeOther];
  event.customAttributes = @{@"query": @"searched for this"};
  
  MPKitExecStatus *execResult = [_kit logBaseEvent:event];
  
  XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testLogEventCategoryViewed {
  MPEvent *event = [[MPEvent alloc] initWithName:@"category viewed" type:MPEventTypeOther];
  event.category = @"books";
  
  MPKitExecStatus *execResult = [_kit logBaseEvent:event];
  
  XCTAssertTrue([execResult returnCode] == MPKitReturnCodeSuccess);
}

- (void)testLogEventUnknown {
  MPEvent *event = [[MPEvent alloc] initWithName:@"unknown" type:MPEventTypeOther];
  event.category = @"books";
  
  MPKitExecStatus *execResult = [_kit logBaseEvent:event];
  
  XCTAssertTrue([execResult returnCode] == MPKitReturnCodeCannotExecute);
}

@end
