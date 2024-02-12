//
//  TorchModule.h
//  DementiaChecker
//
//  Created by 하창진 on 2/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TorchModule : NSObject

- (nullable instancetype) initWithFileAtPath : (NSString*)filePath
NS_SWIFT_NAME(init(fileAtPath:)) NS_DESIGNATED_INITIALIZER;
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;
- (nullable NSArray<NSNumber*>*)predict_MMSE:(void*)data :(int)outputSize NS_SWIFT_NAME(predict_MMSE(data:outputSize:));
- (nullable NSArray<NSNumber*>*)predict_Others:(void*)data :(int)outputSize NS_SWIFT_NAME(predict_Others(data:outputSize:));

@end /* TorchModule_h */

NS_ASSUME_NONNULL_END
