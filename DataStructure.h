//
//  DataStructure.h
//  shaderlib
//
//  Created by 解玉坤 on 11/19/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#ifndef DataStructure_h
#define DataStructure_h

#import <GLKit/GLKit.h>

typedef struct {
    GLfloat position[3];
    GLfloat normal[3];
    GLfloat uv[2];
} Vertex;

typedef struct{
    Vertex* vertices;
    int vertexNum;
    GLushort * triIndices;
    int idxNum;
}ModelData;


#endif /* DataStructure_h */
