//
//  PPModel.h
//  ObjLoader
//
//  Created by 解玉坤 on 11/15/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjLoaderAssist.h"


@interface ObjLoader : NSObject
{
    NSMutableDictionary * _mHandlers;
}

-(id) init;
+(ObjLoader*) sharedInstance;

-(ModelData*) loadObj: (NSString*) objFilename;
-(void) parseTrianglesFromListItems: (NSArray*) listItems triangles: (NSMutableArray*) triangles posPoints: (NSArray*) posPoints texPoints: (NSArray*) texPoints nrmPoints: (NSArray* )nrmPoints;
-(ModelData*) postProcess : (ModelData*) modelData shapes: (NSMutableArray*) shapes vertices: (NSMutableArray*) vertices texUVs: (NSMutableArray*) texUVs Nrms: (NSMutableArray*) Nrms;
-(NSVertex *) packVerticeData: (Vec3*) position uv:(Vec2*) uv nrm: (Vec3*) nrm;

-(Vec3*) _hndVector3: (NSArray *) listItems;
-(Vec2*) _hndVector2: (NSArray *) listItems;

@end
