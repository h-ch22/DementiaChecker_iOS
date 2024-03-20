//
//  TorchModule.mm
//  DementiaChecker
//
//  Created by Changjin Ha on 2/12/24.
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

-(NSArray<NSNumber*>*)predict:(void*)data : (int)outputSize {
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

-(NSArray<NSNumber*>*)predictLifeLog:(void*)data : (void*)dates : (int)period : (int)outputSize {
    try{
        at::TensorOptions options = at::TensorOptions().dtype(at::kFloat);
        at::Tensor tensor = torch::from_blob(data, {period, 1, 4, 1}, options);
        at::Tensor dateTensor = torch::from_blob(dates, {period}, options);
        
        c10::InferenceMode mode;

        auto outputTensor = _impl.forward({tensor, dateTensor}).toTensor();
        float* floatBuffer = outputTensor.data_ptr<float>();
                
        if(!floatBuffer){
            NSLog(@"Cannot get float buffer");
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

-(NSArray<NSNumber*>*)predictUniversal:(void*)MMSEData : (void*)LifeLogData : (void*)LifeLogDates : (void*)SleepData : (void*)SleepDates : (int)period : (int)outputSize {
    try{
        at::TensorOptions options = at::TensorOptions().dtype(at::kFloat);
        at::Tensor MMSETensor = torch::from_blob(MMSEData, {1, 1, 3, 32}, at::kFloat);
        at::Tensor lifeLogTensor = torch::from_blob(LifeLogData, {period, 1, 4, 1}, options);
        at::Tensor sleepTensor = torch::from_blob(SleepData, {period, 1, 4, 1}, options);
        
        at::Tensor lifeLogDateTensor = torch::from_blob(LifeLogDates, {period}, options);
        at::Tensor sleepDateTensor = torch::from_blob(SleepDates, {period}, options);
        
        c10::InferenceMode mode;

        auto outputTensor = _impl.forward({MMSETensor, lifeLogTensor, lifeLogDateTensor, sleepTensor, sleepDateTensor}).toTensor();
        float* floatBuffer = outputTensor.data_ptr<float>();
                
        if(!floatBuffer){
            NSLog(@"Cannot get float buffer");
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
