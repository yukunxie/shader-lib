//
//  PPNode.h
//  shaderlib
//
//  Created by 解玉坤 on 11/9/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import "GLProgram.h"
#import "DataStructure.h"
#import "ObjLoader.h"

#define BUFFER_OFFSET(i) ((GLchar *)NULL + (i))

@interface PPNode : NSObject{
//    GLfloat *_verticeData;
//    GLuint   _verticeNum;
//    GLushort  *_triangleIdx;
//    GLuint   _triangleNum;
//    GLuint   _triangleLength;
//    GLenum   _trinalgeVertexType;
    GLuint  _glVerticeArray;
    GLuint  _glVerticeBuffer;
    GLProgram* _glProgram;
    ModelData* _data;
}

-(id)init : (GLProgram*) program;

-(void)bindGPUData;
-(void)renderNode;

@end
