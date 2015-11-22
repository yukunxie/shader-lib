//
//  Material.h
//  ObjLoader
//
//  Created by 解玉坤 on 11/21/15.
//  Copyright © 2015 解玉坤. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SubMaterial : NSObject
-(id) init;

@property GLKVector3 mDiffuseColor;
@property GLKVector3 mAmbientColor;
@property GLKVector3 mSpecularColor;
@property GLfloat    mAlpha;
@property GLfloat    mSpecularIntensity;

@property BOOL       mAmbientOff;
@property BOOL       mAmbientOn;
@property BOOL       mHighlightOn;
@property BOOL       mReflectionRayTraceOn;
@property BOOL       mGlassRayTraceOn;
@property BOOL       mFresnelRayTraceOn;
@property BOOL       mRefractionOnFresnelOffRayTraceOn;
@property BOOL       mRefractionFresnelRayTraceOn;
@property BOOL       mReflectionOnRayTraceOff;
@property BOOL       mGlassOnRayTraceOff;
@property BOOL       mInvisibleSurfaceShadowOn;

@property(strong, nonatomic) NSString* mTexAmbient; //  map_Ka
@property(strong, nonatomic) NSString* mTexDiffuse; //  map_Kd
@property(strong, nonatomic) NSString* mTexSpecularColor;//  map_Ks
@property(strong, nonatomic) NSString* mTexSpecularHighlight;//  map_Ns
@property(strong, nonatomic) NSString* mTexAlpha;   //  map_d
@property(strong, nonatomic) NSString* mTexBump;    //  map_bump bump
@property(strong, nonatomic) NSString* mTexDisplacement;    //  disp
@property(strong, nonatomic) NSString* mTexStencilDecal;    //  decal
@end


@interface Material : NSObject
{
    NSMutableDictionary * _mSubMaterials;
}
@property (strong, nonatomic) NSString * filename;

-(id) init:(NSString*) filename;
-(SubMaterial*) getSubMaterial: (NSString*) matName;
-(void) setSubMaterial:(NSString*) matName :(SubMaterial*) subMaterial;
@end




@interface MaterialLoader : NSObject
{
    NSMutableDictionary * _mHandlers;
}

-(id) init;
+(MaterialLoader*) sharedInstance;

-(Material*) loadMaterial: (NSString*) filename;
-(void)setInvok:(id)target sel:(SEL)sel key:(id)key;
-(NSInvocation*) getInvok: (NSString*) hndName;

-(void) _hndVector3Type: (NSMutableArray*) args :(SubMaterial*) material;
-(void) _hndFloatType: (NSMutableArray*) args :(SubMaterial*) material;
-(void) _hndIllumType: (NSMutableArray*) args :(SubMaterial*) material;

-(void) _hndTexAmbient: (NSMutableArray*) args :(SubMaterial*) material;
-(void) _hndTexDiffuse: (NSMutableArray*) args material: (SubMaterial*) material;
-(void) _hndTexSpecularColor: (NSMutableArray*) args material: (SubMaterial*) material;
-(void) _hndTexSpecularHighlight: (NSMutableArray*) args material: (SubMaterial*) material;
-(void) _hndTexAlpha: (NSMutableArray*) args material: (SubMaterial*) material;
-(void) _hndTexBump: (NSMutableArray*) args material: (SubMaterial*) material;
-(void) _hndTexDisplacement: (NSMutableArray*) args material: (SubMaterial*) material;
-(void) _hndTexStencilDecal: (NSMutableArray*) args material: (SubMaterial*) material;
@end
