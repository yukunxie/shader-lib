//
//  ObjLoaderAssist.h
//  shaderlib
//
//  Created by 解玉坤 on 11/22/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataStructure.h"

@interface NSVertex : NSObject
-(id) init;
@property Vertex vertex;
@end

@interface Vec2 : NSObject
@property float x, y;
-(id) init: (float)x: (float)y;
@end

@interface Vec3 : Vec2
@property float z;
-(id) init: (float)x: (float)y: (float)z;
@end

@interface NSVector3Idx : NSObject
{
    int _data[3];
}
-(int *) data;
-(id) init:(int) x: (int)y: (int)z;
@end

@interface NSTriangleIdx : NSObject
@property (strong, nonatomic) NSVector3Idx* pos;
@property (strong, nonatomic) NSVector3Idx* tuv;
@property (strong, nonatomic) NSVector3Idx* nrm;

@property BOOL useUV;
@property BOOL useNrm;

-(id) init:(NSVector3Idx* ) pos: (NSVector3Idx* ) tuv: (NSVector3Idx* ) nrm;
@end

typedef struct{
    unsigned int vertices[3];
}Face;
