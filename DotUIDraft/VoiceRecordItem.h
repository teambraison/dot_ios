//
//  VoiceRecordItem.h
//  DotUIDraft
//
//  Created by Titus Cheng on 3/25/15.
//  Copyright (c) 2015 Braison. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceRecordItem : NSObject

@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, strong) NSString *fileName;

@property (nonatomic, strong) NSString *date;

@property (nonatomic, strong) NSString *summary;

@property (nonatomic, strong) NSString *duration;


@end
