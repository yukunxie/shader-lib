//
//  Context.m
//  shaderlib
//
//  Created by 解玉坤 on 11/8/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import "GLContext.h"

@implementation GLContext

-(id)init: (GLKView *) view {
    if (self == [super init]){
        self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:self.context];
        
        if (!self.context) {
            NSLog(@"Failed to create ES context");
        }
        
        view.context = self.context;
        view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    }
    
    return self;
}

-(void)clearScreenWithColor {
    glClearColor(0.0f, 00.f/255.f, 174.f/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

-(void)render : (GLProgram*)program : (GLuint)vertexArray : (GLuint)vertexBuffer{
    //NSLog(@"%d, %d", vertexArray, vertexBuffer);
    //[program linkProgram];
    glBindVertexArrayOES(vertexArray);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glUseProgram([program program]);
    GLushort qIndices[6] = {0, 1, 2,1, 3, 2};
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, qIndices);
    [program unlinkProgram];
}

@end
