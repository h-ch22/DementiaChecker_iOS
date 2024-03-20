//
//  TorchModule.h
//  DementiaChecker
//
//  Created by Changjin Ha on 2/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TorchModule : NSObject

- (nullable instancetype) initWithFileAtPath : (NSString*)filePath
NS_SWIFT_NAME(init(fileAtPath:)) NS_DESIGNATED_INITIALIZER;
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;
- (nullable NSArray<NSNumber*>*)predict:(void*)data :(int)outputSize NS_SWIFT_NAME(predict(data:outputSize:));
- (nullable NSArray<NSNumber*>*)predictLifeLog:(void*)data : (void*)dates : (int) period : (int)outputSize NS_SWIFT_NAME(predictLifeLog(data:dates:period:outputSize:));

@end /* TorchModule_h */

NS_ASSUME_NONNULL_END
