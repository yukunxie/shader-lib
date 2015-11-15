//
//  PPNode.m
//  shaderlib
//
//  Created by 解玉坤 on 11/9/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import "PPNode.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <GLKit/GLKit.h>

GLfloat data[] = {
    -1.0f, -1.0f, 1.0f, -0.577350, -0.577350, 0.577350, 0.0, 0.0,
    -1.0f, 1.0f, 1.0f, -0.577350, 0.577350, 0.577350,0.0, 1.0,
    1.0f, 1.0f, 1.0f, 0.577350, 0.577350, 0.577350, 1.0, 0.0,
    1.0f, -1.0f, 1.0f, 0.577350, -0.577350, 0.577350, 1.0, 1.0,
    
    1.0f, -1.0f, -1.0f, 0.577350, -0.577350, -0.577350, 0.0, 1.0,
    1.0f, 1.0f, -1.0f, 0.577350, 0.577350, -0.577350, 1.0, 0.0,
    -1.0f, 1.0f, -1.0f, -0.577350, 0.577350, -0.577350, 0.0, 0.0,
    -1.0f, -1.0f, -1.0f, -0.577350, -0.577350, -0.577350, 1.0, 1.0
    
    
};


GLushort indices[]={
    // Front face
    3, 2, 1, 3, 1, 0,
    
    // Back face
    7, 5, 4, 7, 6, 5,
    
    // Left face
    0, 1, 7, 7, 1, 6,
    
    // Right face
    3, 4, 5, 3, 5, 2,
    
    // Up face
    1, 2, 5, 1, 5, 6,
    
    // Down face
    0, 7, 3, 3, 7, 4
};


@implementation PPNode

//

-(id)init: (GLProgram*) program{
    if (self == [super init]){
        glGenVertexArraysOES(1, &_glVerticeArray);
        glBindVertexArrayOES(_glVerticeArray);
        
        glGenBuffers(1, &_glVerticeBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _glVerticeBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(data), data, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
        
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
        
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_TRUE, 32, BUFFER_OFFSET(24));
        
    }
    return self;
}

-(void)bindGPUData{
    glBindVertexArrayOES(_glVerticeArray);
    glBindBuffer(GL_ARRAY_BUFFER, _glVerticeBuffer);
}

-(void)renderNode{
    
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(GLushort), GL_UNSIGNED_SHORT, indices);
    
//    [_glProgram linkProgram];
//    glBindVertexArrayOES(_glVerticeArray);
//    glBindBuffer(GL_ARRAY_BUFFER, _glVerticeBuffer);
//    glUseProgram([_glProgram program]);
//    glDrawElements(GL_TRIANGLES, _triangleLength, _trinalgeVertexType, _triangleIdx);
//    [_glProgram unlinkProgram];
}

@end
