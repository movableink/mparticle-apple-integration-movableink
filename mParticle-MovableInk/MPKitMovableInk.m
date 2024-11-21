#import "MPKitMovableInk.h"

static NSString * _Nonnull const miAPIKey = @"miApiKey";
static NSString * _Nonnull const miDomains = @"miDomains";
static NSString * _Nonnull const miClickthrough = @"miClickthrough";

static NSString * _Nonnull const miProductSearched = @"product_searched";
static NSString * _Nonnull const miCategoryViewed = @"category_viewed";

typedef enum {
  MIEventInvalid, MIEventProductSearched, MIEventCategoryViewed
} MIEvent;

@implementation MPKitMovableInk

- (instancetype _Nonnull) init {
  self = [super init];
  self.configuration = @{};
  return self;
}

/*
 mParticle will supply a unique kit code for you. Please contact our team
 */
+ (NSNumber *)kitCode {
  return @179;
}

+ (void)load {
  MPKitRegister *kitRegister = [[MPKitRegister alloc] initWithName:@"MovableInk" className:@"MPKitMovableInk"];
  BOOL success = [MParticle registerExtension:kitRegister];
  
  NSLog(@"REGISTERING KIT - %d", success);
}

- (MPKitExecStatus *)execStatus:(MPKitReturnCode)returnCode {
  return [[MPKitExecStatus alloc] initWithSDKCode:self.class.kitCode returnCode:returnCode];
}

#pragma mark - MPKitInstanceProtocol methods

#pragma mark Kit instance and lifecycle

- (nonnull MPKitExecStatus *)didFinishLaunchingWithConfiguration:(nonnull NSDictionary *)configuration {
  self.configuration = configuration;
  
  NSLog(@"configuration: %@", configuration);
  
  NSString *apiKey = configuration[miAPIKey];
  NSString *domainsString = configuration[miDomains];
  
  if (!apiKey || !domainsString) {
    return [self execStatus:MPKitReturnCodeRequirementsNotMet];
  }
  
  _configuration = configuration;
  
  [self start];
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

- (void)start {
  static dispatch_once_t kitPredicate;
  
  dispatch_once(&kitPredicate, ^{
    NSArray *domains = [self.configuration[miDomains] componentsSeparatedByString:@","];
    
    [MIClient startWithApiKey:self.configuration[miAPIKey]
                       region: BehaviorEventRegionUs
              deeplinkDomains:domains
                launchOptions:nil
                       result:^(NSString * _Nullable clickthrough, NSError * _Nullable error) {
      MPAttributionResult *attributionResult = [[MPAttributionResult alloc] init];
      
      if (error) {
        [self.kitApi onAttributionCompleteWithResult:attributionResult error:error];
        return;
      }
      
      attributionResult.linkInfo = @{miClickthrough: clickthrough};
      [self.kitApi onAttributionCompleteWithResult:attributionResult error:nil];
    }];
    
    self->_started = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
      NSDictionary *userInfo = @{mParticleKitInstanceKey:[[self class] kitCode]};
      
      [[NSNotificationCenter defaultCenter] postNotificationName:mParticleKitDidBecomeActiveNotification
                                                          object:nil
                                                        userInfo:userInfo];
    });
  });
}

- (id const)providerKitInstance {
  return nil;
}

#pragma mark Application
/*
 Implement this method if your SDK handles a user interacting with a remote notification action
 */
- (MPKitExecStatus *)handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK receives and handles remote notifications
 */
- (MPKitExecStatus *)receivedUserNotification:(NSDictionary *)userInfo {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK registers the device token for remote notifications
 */
- (MPKitExecStatus *)setDeviceToken:(NSData *)deviceToken {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK handles continueUserActivity method from the App Delegate
 */
- (nonnull MPKitExecStatus *)continueUserActivity:(nonnull NSUserActivity *)userActivity restorationHandler:(void(^ _Nonnull)(NSArray * _Nullable restorableObjects))restorationHandler {
  [MIClient handleUniversalLinkFrom:userActivity];
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK handles the iOS 9 and above App Delegate method to open URL with options
 */
- (nonnull MPKitExecStatus *)openURL:(nonnull NSURL *)url options:(nullable NSDictionary<NSString *, id> *)options {
  [MIClient handleUniversalLinkWithUrl:url];
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK handles the iOS 8 and below App Delegate method open URL
 */
- (nonnull MPKitExecStatus *)openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nullable id)annotation {
  [MIClient handleUniversalLinkWithUrl:url];
  return [self execStatus:MPKitReturnCodeSuccess];
}

#pragma mark User attributes
/*
 Implement this method if your SDK allows for incrementing numeric user attributes.
 */
- (MPKitExecStatus *)onIncrementUserAttribute:(FilteredMParticleUser *)user {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK resets user attributes.
 */
- (MPKitExecStatus *)onRemoveUserAttribute:(FilteredMParticleUser *)user {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK sets user attributes.
 */
- (MPKitExecStatus *)onSetUserAttribute:(FilteredMParticleUser *)user {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK supports setting value-less attributes
 */
- (MPKitExecStatus *)onSetUserTag:(FilteredMParticleUser *)user {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

#pragma mark Identity
/*
 Implement this method if your SDK should be notified any time the mParticle ID (MPID) changes. This will occur on initial install of the app, and potentially after a login or logout.
 */
- (MPKitExecStatus *)onIdentifyComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
  return [self execStatus:MPKitReturnCodeSuccess];
}

- (MPKitExecStatus *)setUserIdentity:(NSString *)identityString identityType:(MPUserIdentity)identityType {
  NSLog(@"setUserIdentity: %@, %ld", identityString, (long)identityType);
  
  if (identityString == nil) {
    return [self execStatus:MPKitReturnCodeSuccess];
  }
  
  switch (identityType) {
    case MPIdentityCustomerId:
      [MIClient setMIU:identityString];
      break;
      
    default:
      break;
  }
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK should be notified when the user logs in
 */
- (MPKitExecStatus *)onLoginComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK should be notified when the user logs out
 */
- (MPKitExecStatus *)onLogoutComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

/*
 Implement this method if your SDK should be notified when user identities change
 */
- (MPKitExecStatus *)onModifyComplete:(FilteredMParticleUser *)user request:(FilteredMPIdentityApiRequest *)request {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

#pragma mark Events
/*
 Implement this method if your SDK wants to log any kind of events.
 Please see MPBaseEvent.h
 */
- (nonnull MPKitExecStatus *)logBaseEvent:(nonnull MPBaseEvent *)event {
  if ([event isKindOfClass:[MPEvent class]]) {
    return [self routeEvent:(MPEvent *)event];
  } else if ([event isKindOfClass:[MPCommerceEvent class]]) {
    return [self routeCommerceEvent:(MPCommerceEvent *)event];
  } else {
    return [self execStatus:MPKitReturnCodeUnavailable];
  }
}
/*
 Implement this method if your SDK logs user events.
 This requires logBaseEvent to be implemented as well.
 Please see MPEvent.h
 */
- (MPKitExecStatus *)routeEvent:(MPEvent *)event {
  switch ([self eventFromString:event.name]) {
    case MIEventProductSearched: {
      ProductSearchedProperties *properties = [[ProductSearchedProperties alloc]
                                               initWithQuery:event.customAttributes[@"query"]
                                               urlString:event.customAttributes[@"url"]
      ];
      [MIClient productSearchedWithProperties:properties];
      
      break;
    }
      
    case MIEventCategoryViewed: {
      ProductCategory *category = [[ProductCategory alloc]
                                   initWithId:event.category
                                   title:event.category
                                   urlString:event.customAttributes[@"url"]
      ];
      
      [MIClient categoryViewedWithCategory:category];
      break;
    }
      
    default:
      return [self execStatus:MPKitReturnCodeCannotExecute];
  }
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

- (MIEvent)eventFromString:(NSString *)event {
  Boolean isProductSearched =
  [event caseInsensitiveCompare:miProductSearched] == NSOrderedSame ||
  [event caseInsensitiveCompare:@"product searched"] == NSOrderedSame;
  
  Boolean isCategoryViewed =
  [event caseInsensitiveCompare:miCategoryViewed] == NSOrderedSame ||
  [event caseInsensitiveCompare:@"category viewed"] == NSOrderedSame;
  
  if (isProductSearched) {
    return MIEventProductSearched;
  }
  else if (isCategoryViewed) {
    return MIEventCategoryViewed;
  }
  else {
    return MIEventInvalid;
  }
}
/*
 Implement this method if your SDK logs screen events
 Please see MPEvent.h
 */
- (MPKitExecStatus *)logScreen:(MPEvent *)event {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

#pragma mark e-Commerce
/*
 Implement this method if your SDK supports commerce events.
 This requires logBaseEvent to be implemented as well.
 If your SDK does support commerce event, but does not support all commerce event actions available in the mParticle SDK,
 expand the received commerce event into regular events and log them accordingly (see sample code below)
 Please see MPCommerceEvent.h > MPCommerceEventAction for complete list
 */
- (MPKitExecStatus *)routeCommerceEvent:(MPCommerceEvent *)commerceEvent {
  MPKitExecStatus *execStatus = [self execStatus:MPKitReturnCodeSuccess];
  
  switch (commerceEvent.action) {
    case MPCommerceEventActionAddToCart: {
      for (MPProduct *product in commerceEvent.products) {
        ProductCategory *category = [[ProductCategory alloc] initWithId:product.category title:product.category url:nil];
        
        ProductProperties *properties = [[ProductProperties alloc]
                                         initWithId:product.sku
                                         title: product.name
                                         price:product.price
                                         url:nil
                                         categories:@[category]
                                         meta:@{ @"currency": commerceEvent.currency }
        ];
        
        [MIClient productAddedWithProperties:properties];
        [execStatus incrementForwardCount];
      }
      
      break;
    }
      
    case MPCommerceEventActionRemoveFromCart: {
      for (MPProduct *product in commerceEvent.products) {
        ProductCategory *category = [[ProductCategory alloc] initWithId:product.category title:product.category url:nil];
        
        ProductProperties *properties = [[ProductProperties alloc]
                                         initWithId:product.sku
                                         title:product.name
                                         price:product.price
                                         url:nil
                                         categories:@[category]
                                         meta:@{ @"currency": commerceEvent.currency }
        ];
        
        [MIClient productRemovedWithProperties:properties];
        [execStatus incrementForwardCount];
      }
      
      break;
    }
      
    case MPCommerceEventActionPurchase: {
      NSMutableArray<OrderCompletedProduct *> *products = [[NSMutableArray alloc] init];
      
      for (MPProduct *product in commerceEvent.products) {
        OrderCompletedProduct *completedProduct = [[OrderCompletedProduct alloc]
                                                   initWithId:product.sku
                                                   title:product.name
                                                   price:product.price
                                                   url:nil
                                                   quantity:product.quantity
        ];
        
        [products addObject:completedProduct];
      }
      
      OrderCompletedProperties *properties = [[OrderCompletedProperties alloc]
                                              initWithId:commerceEvent.transactionAttributes.transactionId
                                              revenue:commerceEvent.transactionAttributes.revenue
                                              products:products
      ];
      
      [MIClient orderCompletedWithProperties:properties];
      [execStatus incrementForwardCount];
      
      break;
    }
      
    case MPCommerceEventActionViewDetail: {
      for (MPProduct *product in commerceEvent.products) {
        ProductCategory *category = [[ProductCategory alloc] initWithId:product.category title:product.category url:nil];
        
        ProductProperties *properties = [[ProductProperties alloc]
                                         initWithId:product.sku
                                         title:product.name
                                         price:product.price
                                         url:nil
                                         categories:@[category]
                                         meta:@{ @"currency": commerceEvent.currency }
        ];
        
        [MIClient productViewedWithProperties:properties];
        [execStatus incrementForwardCount];
      }
      
      break;
    }
      
    case MPCommerceEventActionAddToWishList:
    case MPCommerceEventActionRemoveFromWishlist:
      break;
      
    case MPCommerceEventActionCheckout:
      break;
      
    case MPCommerceEventActionCheckoutOptions:
      break;
      
    case MPCommerceEventActionClick:
      break;
      
    case MPCommerceEventActionRefund:
      break;
  }
  
  return execStatus;
}

#pragma mark Assorted
/*
 Implement this method if your SDK implements an opt out mechanism for users.
 */
- (MPKitExecStatus *)setOptOut:(BOOL)optOut {
  /*  Your code goes here.
   If the execution is not successful, please use a code other than MPKitReturnCodeSuccess for the execution status.
   Please see MPKitExecStatus.h for all exec status codes
   */
  
  return [self execStatus:MPKitReturnCodeSuccess];
}

@end
