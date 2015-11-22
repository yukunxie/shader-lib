//
//  PPModel.m
//  ObjLoader
//
//  Created by 解玉坤 on 11/15/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//
#import "ObjLoader.h"
//#import <Foundation/Foundation.h>

@implementation NSVertex
-(id) init{
    self = [super init];
    return self;
}
@end

@implementation Vec2
-(id) init: (float)x: (float)y{
    if (self = [super init]){
        self.x = x;
        self.y = y;
    }
    return self;
}
@end

@implementation Vec3
-(id) init: (float)x: (float)y: (float) z{
    if (self = [super init: x: y]){
        self.z = z;
    }
    return self;
}
@end

@implementation NSVector3Idx

-(id) init:(int) x: (int)y: (int)z
{
    if (self = [super init])
    {
        _data[0] = x;
        _data[1] = y;
        _data[2] = z;
    }
    return self;
}

-(int *) data{
    return _data;
}

@end

@implementation NSTriangleIdx

-(id) init:(NSVector3Idx* ) pos: (NSVector3Idx* ) tuv: (NSVector3Idx* ) nrm{
    if (self = [super init]){
        self.pos = pos;
        self.tuv = tuv;
        self.nrm = nrm;
        self.useNrm = YES;
        self.useUV = YES;
    }
    return self;
}
@end

@implementation ObjLoader

+(NSArray*) parseFaces: (NSArray*) listItems
{
    NSMutableArray* tris = [[NSMutableArray alloc] init];
    for (int i = 2; i < [listItems count]; ++i){
        NSMutableArray* strItems = [[NSMutableArray alloc] init];
        int posIndex[3];
        if (i == 2){
            posIndex[0] = 0;posIndex[1] = 1; posIndex[2] = 2;
        }
        else{
            posIndex[0] = 3;posIndex[1] = 0; posIndex[2] = 2;
        }
        for (int k = 0; k <3 ; ++k){
            int j = posIndex[k];
            NSArray* pvs = [listItems[j] componentsSeparatedByString:@"/"];
            NSMutableArray* values = [[NSMutableArray alloc] initWithObjects: [NSNull null], [NSNull null], [NSNull null], nil];
            for (int i = 0; i < MIN(3, [pvs count]); ++i){
                values[i] = [NSNumber numberWithInteger:[pvs[i] intValue]];
            }
            [strItems addObject:values];
        }
        [tris addObject:strItems];
    }
    return [tris copy];
}

+(ModelData*) loadObj: (NSString*)objFilename{
    
    NSString* text = [NSString stringWithContentsOfFile:objFilename encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    NSMutableArray *  posPoints = [[NSMutableArray alloc] init];
    NSMutableArray *  texPoints = [[NSMutableArray alloc] init];
    NSMutableArray *  nrmPoints = [[NSMutableArray alloc] init];
    NSMutableArray *  triangles = [[NSMutableArray alloc] init];
    BOOL useUV = YES;
    BOOL useNrm= YES;
    for (NSString* str in lines){
        NSString * _str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        NSArray* _tmpItems = [_str componentsSeparatedByString:@" "];
        NSMutableArray* listItems = [[NSMutableArray alloc] init];
        for (NSString* item in _tmpItems){
            if (![item isEqualToString: @""]){
                [listItems addObject:item];
            }
        }
        if ([listItems count] <= 1) continue;
        NSString* prefix = listItems[0];
        if ([prefix isEqualToString:@"v"])
        {
            assert([listItems count] == 4);
            float x = [listItems[1] floatValue];
            float y = [listItems[2] floatValue];
            float z = [listItems[3] floatValue];
            [posPoints addObject: [[Vec3 alloc] init: x: y: z]];
            
        }else if([prefix isEqualToString:@"vt"])
        {
            assert([listItems count] >= 3);
            float x = [listItems[1] floatValue];
            float y = [listItems[2] floatValue];
            [texPoints addObject: [[Vec2 alloc] init: x: y]];
            
        }else if([prefix isEqualToString:@"vn"])
        {
            assert([listItems count] == 4);
            float x = [listItems[1] floatValue];
            float y = [listItems[2] floatValue];
            float z = [listItems[3] floatValue];
            [nrmPoints addObject: [[Vec3 alloc] init: x: y: z]];
            
        }else if([prefix isEqualToString:@"f"])
        {
            [listItems removeObjectAtIndex:0];
            NSArray * faces = [ObjLoader parseFaces: listItems];
            for (NSArray* tri in faces){
                NSTriangleIdx * triangle = [[NSTriangleIdx alloc] init: [NSVector3Idx alloc]: [NSVector3Idx alloc]: [NSVector3Idx alloc]];
                
                for (int i = 0; i < 3; ++i){
                    NSArray * point = tri[i];
                    int vIdx = [point[0] intValue];
                    if (vIdx < 0){
                        vIdx = [posPoints count] + vIdx;
                    }
                    [triangle.pos data][i] = vIdx;
                    if (point[1] != [NSNull null]){
                        int uvIdx = [point[1] intValue];
                        if (uvIdx < 0){
                            uvIdx = [texPoints count] + uvIdx;
                        }
                        [triangle.tuv data][i] = uvIdx;
                    }
                    else {
                        useUV = NO;
                        triangle.useUV = NO;
                    }
                    if (point[2] != [NSNull null]){
                        int nrmIdx = [point[2] intValue];
                        if (nrmIdx < 0){
                            nrmIdx = [nrmPoints count] + nrmIdx;
                        }
                        [triangle.nrm data][i] = nrmIdx;
                    }else{
                        useNrm = NO;
                        triangle.useNrm = NO;
                    }
                }
                [triangles addObject:triangle];
            }
        }
    }
    return [ObjLoader postProcess:[triangles copy] :[posPoints copy ]:[texPoints copy] :[nrmPoints copy]];
}

+(ModelData *) postProcess: (NSMutableArray*) triangles: (NSMutableArray*) vertices: (NSMutableArray*) texUVs: (NSMutableArray*) Nrms
{
    
    NSMutableDictionary * dictIndex = [[NSMutableDictionary alloc] init];
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    
    for(NSTriangleIdx * tri in triangles){
        for (int i = 0; i < 3; ++i){
            int vIdx = tri.pos.data[i];
            int uIdx = tri.tuv.data[i];
            int nIdx = tri.nrm.data[i];
            NSString * keyX = [NSString stringWithFormat:@"%d-%d-%d", vIdx, uIdx, nIdx];
            if (nil == [dictionary objectForKey: keyX]){
                Vec3* pos= vertices[vIdx-1];
                Vec2* uv = texUVs[uIdx-1];
                Vec3* nrm= Nrms[nIdx-1];
                dictionary[keyX] = [ObjLoader packVerticeData: pos: uv: nrm];
            }
        }
    }
    
    Vertex * vertexData = (Vertex*) malloc(sizeof(Vertex) * [dictionary count]);
    memset(vertexData, 0, sizeof(Vertex) * [dictionary count]);
    
    int count = 0;
    for(id key in dictionary){
        NSVertex* value = [dictionary objectForKey:key];
        dictIndex[key] = [NSNumber numberWithInt:count];
        
        Vertex* target = vertexData + count++;
        
        for (int i = 0; i < 3; ++i)target->position[i] = value.vertex.position[i];
        for (int i = 0; i < 3; ++i)target->normal[i] = value.vertex.normal[i];
        for (int i = 0; i < 2; ++i)target->uv[i] = value.vertex.uv[i];
        
        NSLog(@"### %f, %f", value.vertex.uv[0], value.vertex.uv[1]);
    }
    
    GLushort *indices = (GLushort*) malloc(sizeof(short) * 3 * [triangles count]);
    
    count = 0;
    for(NSTriangleIdx * tri in triangles){
        NSMutableString * text = [[NSMutableString alloc] init];
        for (int i = 0; i < 3; ++i){
            int vIdx = tri.pos.data[i];
            int uIdx = tri.tuv.data[i];
            int nIdx = tri.nrm.data[i];
            NSString * keyX = [NSString stringWithFormat:@"%d-%d-%d", vIdx, uIdx, nIdx];
            [text appendString: keyX];
            [text appendString: [NSString stringWithFormat: @"[%d];\t", [[dictIndex objectForKey: keyX] shortValue]]];
            indices[count++] = [[dictIndex objectForKey: keyX] shortValue];
        }
    }
    
    ModelData * model = (ModelData*) malloc(sizeof(ModelData));
    model->vertices = vertexData;
    model->vertexNum= [dictIndex count];
    model->idxNum = 3 * [triangles count];
    model->triIndices = indices;
    
    return model;
}

+(NSVertex *) packVerticeData: (Vec3*) position: (Vec2*) uv: (Vec3*) nrm{
    Vertex vertex;
    
    vertex.position[0] = position.x;
    vertex.position[1] = position.y;
    vertex.position[2] = position.z;
    
    vertex.normal[0] = nrm.x;
    vertex.normal[1] = nrm.y;
    vertex.normal[2] = nrm.z;
    
    vertex.uv[0] = uv.x;
    vertex.uv[1] = uv.y;
    
    NSVertex* retValue = [NSVertex alloc];
    retValue.vertex = vertex;
    return retValue;
}

@end
