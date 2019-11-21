//
//  GLKViewController.h
//  OpenGLES
//
//  Created by 胥福阳 on 2019/11/19.
//  Copyright © 2019 微光星芒. All rights reserved.
//

#import <GLKit/GLKit.h>


@interface GLBaseViewController : GLKViewController

@property (assign, nonatomic) GLuint shaderProgram;

//elapsedTime 表示程序运行经过时间的秒数
@property (assign, nonatomic) GLfloat elapsedTime;

@property (assign, nonatomic) GLKMatrix4 transformMatrix;


- (void)update;
- (void)bindAttribs:(GLfloat *)triangleData;
//设置着色器
- (void)setupShaderWithVertexShaderName:(NSString *)vertexShaderName
                     fragmentShaderName:(NSString *)fragmentShaderName;
@end

