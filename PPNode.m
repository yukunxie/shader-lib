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


@implementation PPNode

//

-(id)init: (GLProgram*) program{
    if (self == [super init]){
        NSString* objFilename = [[NSBundle mainBundle] pathForResource:@"pyramid" ofType:@"obj"];
        _data = [ObjLoader loadObj:objFilename];
        
        glGenVertexArraysOES(1, &_glVerticeArray);
        glBindVertexArrayOES(_glVerticeArray);
        
        glGenBuffers(1, &_glVerticeBuffer);
        glBindBuffer(GL_ARRAY_BUFFER, _glVerticeBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex) * _data->vertexNum, _data->vertices, GL_STATIC_DRAW);
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*)offsetof(Vertex, position));
        
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribColor, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (GLvoid*)offsetof(Vertex, normal));
        
        glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
        glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_TRUE, sizeof(Vertex), (GLvoid*)offsetof(Vertex, uv));
        
    }
    return self;
}

-(void)bindGPUData{
    glBindVertexArrayOES(_glVerticeArray);
    glBindBuffer(GL_ARRAY_BUFFER, _glVerticeBuffer);
}

-(void)renderNode{
    
    glDrawElements(GL_TRIANGLES, _data->idxNum, GL_UNSIGNED_SHORT, _data->triIndices);
    
//    [_glProgram linkProgram];
//    glBindVertexArrayOES(_glVerticeArray);
//    glBindBuffer(GL_ARRAY_BUFFER, _glVerticeBuffer);
//    glUseProgram([_glProgram program]);
//    glDrawElements(GL_TRIANGLES, _triangleLength, _trinalgeVertexType, _triangleIdx);
//    [_glProgram unlinkProgram];
}

@end
