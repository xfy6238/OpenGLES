//
//  MatrixController.m
//  OpenGLES
//
//  Created by 胥福阳 on 2019/11/21.
//  Copyright © 2019 微光星芒. All rights reserved.
//

/**
    这个类是用来学习正交投影和透视投影
    这里不再使用基类中的着色器
 */

#import "MatrixController.h"


@interface MatrixController ()

@end

@implementation MatrixController


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)update{
    [super update];
    //透视投影
//    [self perspectiveProjection];

    //正交投影
    [self orthographicProjection];
}

//MARK: 透视投影
- (void)perspectiveProjection{
    
    //旋转矩阵
    float varyingFacrot = self.elapsedTime;

    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFacrot, 0, 1, 0);
    float aspect = self.view.frame.size.width/self.view.frame.size.height;
    //透视投影矩阵
    //第一个参数: 视角,视角越大,看到的东西越多  GLKMathDegreesToRadians 将角度转为弧度
    //第二个参数: 设置屏幕宽高比 为了将所有轴的单位统一
    //第三个参数: near 平截头体的近平面  表示可视范围在z轴的起点到原点(0,0,0)的距离
    //第四个参数: far 平截头体的远平面  表示在可视范围在z轴的终点到原点(0,0,0)的距离
    //near 和 far 始终为正
    GLKMatrix4 perspectiveMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90), aspect, 0.1, 100.f);
    
    //一个位于z=0 的点是不能被投影到屏幕上,所以增加了一个平移矩阵
    //如果不设置,将z轴的点移动m. 那图像无法显示;
    GLKMatrix4 translateMatrix = GLKMatrix4MakeTranslation(0, 0, -1.6);

    //先旋转 再平移 最后执行透视   投影必须放在最后
    self.transformMatrix = GLKMatrix4Multiply(translateMatrix, rotateMatrix);
    self.transformMatrix = GLKMatrix4Multiply(perspectiveMatrix, self.transformMatrix);
}

//MARK: 正交投影
- (void)orthographicProjection {
    float varyingFacrot = self.elapsedTime;

    GLKMatrix4 rotateMatrix = GLKMatrix4MakeRotation(varyingFacrot, 0, 1, 0);

    float viewWidth = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height;
    //原先的屏幕的x轴从左到右是-1到1, y轴是从上到下是1到-1;
    //前两个参数 指定了 平截头体的左右坐标
    //三四 参数 指定了平截头体的底部和上部
    //五六 参数 顶一个近平面和远平面的距离
    //这个指定的投影矩阵 将处于x,y,z 范围之间的坐标转换到标准化设备坐标系中
    GLKMatrix4 ortMatrix = GLKMatrix4MakeOrtho(-viewWidth/2.0, viewWidth/2, -viewHeight/2, viewHeight/2, -10, 10);
    GLKMatrix4 scaleMatrix = GLKMatrix4MakeScale(200, 200, 200);
    self.transformMatrix = GLKMatrix4Multiply(scaleMatrix, rotateMatrix);
    self.transformMatrix = GLKMatrix4Multiply(ortMatrix, self.transformMatrix);

}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [super glkView:view drawInRect:rect];
    
    GLuint transformUniformLocation = glGetUniformLocation(self.shaderProgram, "transform");
    glUniformMatrix4fv(transformUniformLocation, 1, 0, self.transformMatrix.m);
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
