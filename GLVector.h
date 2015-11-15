//
//  GLPoint.h
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

@interface GLVec2 : NSObject{
}
@property float x;
@property float y;

-(id)init: (float) x :(float) y;
-(void)normalize;
@end


@interface GLVec3: GLVec2{
}

@property float z;
-(id)init: (float) x :(float) y :(float)z;
-(void)normalize;

@end

@interface GLVec4: GLVec3{
}
@property float w;
-(id)init: (float) x :(float) y :(float)z :(float)w;
-(void)normalize;
@end

@interface GLRect: NSObject

@property float x, y;
@property float width, height;

-(id)init: (float) x :(float) y :(float)w :(float)h;

@end

@interface GLSize: NSObject

@property float width, height;
-(id)init:(float)w :(float)h;

@end

