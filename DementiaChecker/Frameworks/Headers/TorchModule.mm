//
//  TorchModule.mm
//  DementiaChecker
//
//  Created by 하창진 on 2/12/24.
//

#import "TorchModule.h"
#import <Libtorch-Lite.h>

@implementation TorchModule {
@protected
    torch::jit::mobile::Module _impl;
}

- (nullable instancetype)initWithFileAtPath:(NSString*)filePath {
  self = [super init];
  if (self) {
    try {
      _impl = torch::jit::_load_for_mobile(filePath.UTF8String);
    } catch (const std::exception& exception) {
      NSLog(@"%s", exception.what());
      return nil;
    }
  }
  return self;
}

-(NSArray<NSNumber*>*)predict_MMSE:(void*)data : (int)outputSize {
    try{
        at::Tensor tensor = torch::from_blob(data, {1, 1, 3, 32}, at::kFloat);
        c10::InferenceMode mode;

        auto outputTensor = _impl.forward({tensor}).toTensor();
        float* floatBuffer = outputTensor.data_ptr<float>();
        
        if(!floatBuffer){
            return nil;
        }
        
        NSMutableArray* results = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < outputSize; i++){
            float score = floatBuffer[i] * 100;
            
            [results addObject:@((int)(score * 1000.0) / 1000.0)];
        }
        
        return [results copy];
        
    } catch(const std::exception& exception){
        NSLog(@"%s", exception.what());
    }
    
    return nil;
}

-(NSArray<NSNumber*>*)predict_Others:(void*)data : (int)outputSize{
    try{
        at::Tensor tensor = torch::from_blob(data, {1, 3, 1}, at::kFloat);
        c10::InferenceMode mode;

        auto outputTensor = _impl.forward({tensor}).toTensor();
        float* floatBuffer = outputTensor.data_ptr<float>();
        
        if(!floatBuffer){
            return nil;
        }
        
        NSMutableArray* results = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < outputSize; i++){
            float score = floatBuffer[i] * 100;
            
            [results addObject:@((int)(score * 1000.0) / 1000.0)];
        }
        
        return [results copy];
        
    } catch(const std::exception& exception){
        NSLog(@"%s", exception.what());
    }
    
    return nil;
}

@end
