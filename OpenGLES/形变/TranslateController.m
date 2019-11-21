//
//  TranslateController.m
//  OpenGLES
//
//  Created by 胥福阳 on 2019/11/20.
//  Copyright © 2019 微光星芒. All rights reserved.
//

#import "TranslateController.h"

@interface TranslateController()


@end

@implementation TranslateController

- (void)viewDidLoad {
    [super viewDidLoad];
    //一个4x4 的矩阵
    self.transformMatrix = GLKMatrix4Identity;
}

//MARK:update Delegate
- (void)update {
    [super update];
    float varyingFactor = sin(self.elapsedTime);
    
    //定义了一个4x4 矩阵 但只需要3个参数  因为只是对x,y,z 这三个参数进行形变; 第四个是w, 在3D空间中没有意义,所以省略了(猜测);
    //这个矩阵用于缩放
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(varyingFactor, varyingFactor, 1.0);
    //旋转矩阵
    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFactor, 0.0, 0.0, 1.0);
    
    //平移矩阵
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(varyingFactor, 0.0, 0.0);
    
    //因为想要使这个点 先缩放,再旋转,最后平移;
    //而矩阵可以看成一个点会经过怎么样的变换; 由于矩阵的相乘不具备交换性, 所以顺序不能错
    //点经过矩阵的顺序是从右向左,写成下面的形式才是 选scale 再rotate, 最后translate
    self.transformMatrix = GLKMatrix4Multiply(translateMatrix, rotateMatrix);
    self.transformMatrix = GLKMatrix4Multiply(self.transformMatrix, scaleMatrix);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    
    GLuint transformUniformLocation = glGetUniformLocation(self.shaderProgram, "transform");
    glUniformMatrix4fv(transformUniformLocation, 1, 0, self.transformMatrix.m);
    [self drawTriangle];
}

- (void)drawTriangle {
    static float triangleData[36] = {
        0,      0.5f,  0,  1,  0,  0, // x, y, z, r, g, b,每一行存储一个点的信息，位置和颜色
        -0.5f,  0.0f,  0,  0,  1,  0,
        0.5f,   0.0f,  0,  0,  0,  1,
        0,      -0.5f,  0,  1,  0,  0,
        -0.5f,  0.0f,  0,  0,  1,  0,
        0.5f,   0.0f,  0,  0,  0,  1,

    };
    
    [self bindAttribs:triangleData];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}

@end
