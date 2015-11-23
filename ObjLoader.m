//
//  PPModel.m
//  ObjLoader
//
//  Created by 解玉坤 on 11/15/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//
#import "ObjLoader.h"
//#import <Foundation/Foundation.h>



@implementation ObjLoader

+(ObjLoader *)sharedInstance
{
    static ObjLoader * sharedSingleton = nil;
    @synchronized([ObjLoader class]) {
        if(sharedSingleton == nil)
        {
            sharedSingleton = [[self alloc] init];
        }
    }
    return sharedSingleton;
}

-(id) init {
    self = [super init];
    _mHandlers = [[NSMutableDictionary alloc] init];
    
    //[self setInvok:self sel:@selector(_hndVector3Type: :) key:@"Ka"];
    
    return self;
}


-(void) parseTrianglesFromListItems: (NSArray*) listItems triangles: (NSMutableArray*) triangles posPoints: (NSArray*) posPoints texPoints: (NSArray*) texPoints nrmPoints: (NSArray* )nrmPoints
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
    
    for (NSArray* tri in tris){
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
                triangle.useUV = NO;
            }
            if (point[2] != [NSNull null]){
                int nrmIdx = [point[2] intValue];
                if (nrmIdx < 0){
                    nrmIdx = [nrmPoints count] + nrmIdx;
                }
                [triangle.nrm data][i] = nrmIdx;
            }else{
                triangle.useNrm = NO;
            }
        }
        [triangles addObject:triangle];
    }
}

-(ModelData*) loadObj: (NSString*)objFilename{
    
    NSString* text = [NSString stringWithContentsOfFile:objFilename encoding:NSUTF8StringEncoding error:nil];
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    NSMutableArray *  posPoints = [[NSMutableArray alloc] init];
    NSMutableArray *  texPoints = [[NSMutableArray alloc] init];
    NSMutableArray *  nrmPoints = [[NSMutableArray alloc] init];
    NSMutableArray *  triangles = [[NSMutableArray alloc] init];
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
            Vec3 * point = [self _hndVector3: listItems];
            [posPoints addObject: point];
            
        }else if([prefix isEqualToString:@"vt"])
        {
            Vec2 * point = [self _hndVector2: listItems];
            [texPoints addObject: point];
            
        }else if([prefix isEqualToString:@"vn"])
        {
            Vec3 * point = [self _hndVector3: listItems];
            [nrmPoints addObject: point];
            
        }else if([prefix isEqualToString:@"f"])
        {
            [listItems removeObjectAtIndex:0];
            [self parseTrianglesFromListItems: listItems triangles: triangles posPoints: posPoints texPoints: texPoints nrmPoints: nrmPoints];
        }
    }
    return [self postProcess:[triangles copy] vertices:[posPoints copy] texUVs:[texPoints copy] Nrms:[nrmPoints copy]];
}

-(Vec3*) _hndVector3: (NSArray *) listItems{
    float x = [listItems[1] floatValue];
    float y = [listItems[2] floatValue];
    float z = [listItems[3] floatValue];
    return [[Vec3 alloc] init: x: y: z];
}

-(Vec2*) _hndVector2: (NSArray *) listItems{
    float x = [listItems[1] floatValue];
    float y = [listItems[2] floatValue];
    return [[Vec2 alloc] init: x: y];
}

-(ModelData*) postProcess: (NSMutableArray*) triangles vertices: (NSMutableArray*) vertices texUVs: (NSMutableArray*) texUVs Nrms: (NSMutableArray*) Nrms
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
                dictionary[keyX] = [self packVerticeData: pos uv:uv nrm:nrm];
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

-(NSVertex *) packVerticeData: (Vec3*) position uv:(Vec2*) uv nrm: (Vec3*) nrm
{
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
