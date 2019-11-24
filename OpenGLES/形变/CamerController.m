//
//  CamerController.m
//  OpenGLES
//
//  Created by 胥福阳 on 2019/11/22.
//  Copyright © 2019 微光星芒. All rights reserved.
//

#import "CamerController.h"

@interface CamerController ()

@property (assign, nonatomic) GLKMatrix4 projectionMatrix;
@property (assign, nonatomic) GLKMatrix4 cameraMatrix;
@property (assign, nonatomic) GLKMatrix4 modelMatrix1;
@property (assign, nonatomic) GLKMatrix4 modelMatrix2;


@end

@implementation CamerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpMatrix];
    [self setupShaderWithVertexShaderName:@"camerMatriVertex" fragmentShaderName:@"fragment"];
}

//设置矩阵属性
- (void)setUpMatrix {
    float aspect = self.view.frame.size.width/self.view.frame.size.height;
    //使用投影矩阵
    self.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 100);
    
    //设置摄像机位置 看向0,0,0点. Y轴正向为摄像机顶部指向的方向
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2, 0, 0, 0, 0, 1, 0);
    //将两个模型矩阵 设置为单位矩阵
    self.modelMatrix1 = GLKMatrix4Identity;
    self.modelMatrix2 = GLKMatrix4Identity;

}

//MARK: 代理方法
- (void)update {
    [super update];
    float varyingFactor = (sin(self.elapsedTime) + 1)/2.0; // 0 ~ 1
    self.cameraMatrix = GLKMatrix4MakeLookAt(0, 0, 2 * (varyingFactor + 1), 0, 0, 0, 0, 1, 0);
    
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(-0.7, 0, 0);
    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFactor * M_PI * 2, 0, 1, 0);
    self.modelMatrix1 = GLKMatrix4Multiply(translateMatrix, rotateMatrix);
    
    GLKMatrix4 translateMatrix2 = GLKMatrix4MakeTranslation(0.7, 0, 0);
    GLKMatrix4 rotateMatrix2 = GLKMatrix4MakeRotation(varyingFactor * M_PI * 2, 0, 0, 1);
    self.modelMatrix2 = GLKMatrix4Multiply(translateMatrix2, rotateMatrix2);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    
    GLuint projectionMatrixUniformLocaton = glGetUniformLocation(self.shaderProgram, "projectionMatrix");
    glUniformMatrix4fv(projectionMatrixUniformLocaton, 1, 0, self.projectionMatrix.m);
    
    GLuint cameraMatrixUniformLocaton = glGetUniformLocation(self.shaderProgram, "cameraMatrix");
    glUniformMatrix4fv(cameraMatrixUniformLocaton, 1, 0, self.cameraMatrix.m);

    
      GLuint modelMatrixUniformLocaton = glGetUniformLocation(self.shaderProgram, "modelMatrix");
    //绘制第一个矩形
    glUniformMatrix4fv(modelMatrixUniformLocaton, 1, 0, self.modelMatrix1.m);
    [self drawTriangle];

    
    //绘制第二个图形
    glUniformMatrix4fv(modelMatrixUniformLocaton, 1, 0, self.modelMatrix2.m);
    [self drawTriangle];
    
}

- (void)drawTriangle {
    static float triangleData[36] = {
     
        -0.5,   0.5f,  0,   1,  0,  0, // x, y, z, r, g, b,每一行存储一个点的信息，位置和颜色
        -0.5f,  -0.5f,  0,  0,  1,  0,
        0.5f,   -0.5f,  0,  0,  0,  1,
        0.5,    -0.5f, 0,   0,  0,  1,
        0.5f,  0.5f,  0,    0,  1,  0,
        -0.5f,   0.5f,  0,  1,  0,  0,

    };
    
    [self bindAttribs:triangleData];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end
