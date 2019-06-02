# AI算法工程师手册



## 数学基础

### 1.线性代数基础

#### 基本知识

1.本书中所有的向量都是列向量的形式：
$$
\vec\chi = (x_1,x_2,\dots,x_n)^T = 
\left[
\begin{matrix}
x_1 \\
x_2 \\
\vdots \\
x_n
\end{matrix}
\right] \tag{1a}
$$
本书中所有的矩阵$X \in R^{m \times n}$都表示为：
$$
X = 
\left[
\begin{matrix}
x_{1,1} & x_{1,2} & \cdots & x_{1,n} \\
x_{2,1} & x_{2,2} & \cdots & x_{2,n} \\
\vdots & \vdots & \ddots & \vdots \\
x_{m,1} & x_{m,2} & \cdots & x_{m,n}
\end{matrix}
\right] \tag{1b}
$$
简写为：$(x_{i,j})_{m \times n}$或者$[x_{i,j}]_{m,n}$

2.矩阵的`F`范数：设矩阵$A=(a_{i,j})_{m,n}$，则其`F`范数为：$\prod A \prod=\sqrt{\sum_{i,j}{a_{i,j}^2}}$.它是向量的$L_2$范数的推广

3.矩阵的迹：设矩阵$A=(a_{i,j})_{m \times n}$，则$A$的的迹为：$tr(A)=\sum_i{a_{i,i}}$

迹的性质有：

* $A$的`F`范数等于$AA^T$的迹的平方根：$\prod A \prod_F=\sqrt{tr(AA^T)}$
* $A$的迹等于$A^T$的迹：$tr(A)=tr(A^T)$
* 交换律：假设$A \in R^{m \times n},B \in R^{n \times m}$，则有：$tr(AB)=tr(BA)$
* 结合律：$tr(ABC)=tr(CAB)=tr(BCA)$

#### 向量操作

1.一组向量$\vec v_1, \vec v_2, \dots, \vec v_n$是线性相关的：指存在一组不全为零的实数$a_1, a_2, \dots, a_n$，使得：$\sum_{i=1}^n{a_i \vec v_i} = \vec 0$

一组向量$\vec v_1, \vec v_2, \dots, \vec v_n$是线性无关的，当且仅当$a_i=0, i=1,2,\dots,n$时，才有：$\sum_{i=1}^n{a_i \vec v_i}=\vec 0$

2.一个向量空间包含的最大线性无关向量的数目，称作该向量空间的维数

3.三维向量的点积：$\vec u \times \vec v = u_xv_x + u_yv_y + u_zv_z = |\vec u||\vec v|\cos{(\vec u, \vec v)}$

4.三维向量的叉积：
$$
\vec w = \vec u \times \vec v = 
\left[
\begin{matrix}
\vec i & \vec j & \vec k \\
u_x & u_y & u_z \\
v_x & v_y & v_z
\end{matrix}
\right] \tag{1c}
$$
其中$\vec i, \vec j, \vec k$分别为$x, y, z$轴的单位向量.
$$
\vec u = u_x \vec i + u_y \vec j + u_z \vec k, \\
\vec v = v_x \vec i + v_y \vec j + v_z \vec k
\tag{1d}
$$

- $\vec u$和$\vec v$的叉积垂直于 $\vec u, \vec v$构成的平面，其方向符合右手规则
- 叉积的模等于$\vec u, \vec v$构成的平行四边形的面积
- $\vec u \times \vec v = -\vec v \times \vec u$
- $\vec u \times (\vec v \times \vec w) = (\vec u \cdot \vec w)\vec v - (\vec u \cdot \vec v)\vec w$

![cross](http://www.huaxiaozhuan.com/%E6%95%B0%E5%AD%A6%E5%9F%BA%E7%A1%80/imgs/algebra/cross.png)

5.三维向量的混合积：
$$
\left[
\begin{matrix}
\vec u & \vec v & \vec w
\end{matrix}
\right]
=
(\vec u \times \vec v) \cdot \vec w
=
\vec u \cdot (\vec v \times \vec w)
= \left|
\begin{matrix}
u_x & u_y & u_z \\
v_x & v_y & v_z \\
w_x & w_y & w_z
\end{matrix}
\right|
= \left|
\begin{matrix}
u_x & v_x & w_x \\
u_y & v_y & w_y \\
u_z & v_z & w_z
\end{matrix}
\right| \tag{1e}
$$
其物理意义为：以$\vec u, \vec v, \vec w$为三个棱边所围成的平行六面体的面积。当$\vec u, \vec v, \vec w$构成右手系时，该平行六面体的体积为正号

6.两个向量的并失：给定两个向量$\vec x=(x_1, x_2, \cdots, x_n)^T, \vec y = (y_1, y_2, \cdots, y_m)^T$，则向量的并失记作：
$$
\vec x \vec y = 
\left[
\begin{matrix}
x_1y_1 & x_1y_2 & \cdots & x_1y_m \\
x_2y_1 & x_2y_2 & \cdots & x_2y_m \\
\vdots & \vdots & \ddots & \vdots \\
x_ny_1 & x_ny_2 & \cdots & x_ny_m
\end{matrix}
\right] \tag{1f}
$$
也记作$\vec x \otimes \vec y$或者$\vec x \vec y^T$

#### 矩阵运算

1.给定两个矩阵$A=(a_{i,j}) \in R^{m \times n}, B=(b_{i,j} \in R^{m \times n})$，定义：

- 阿达马积`Hadamard product`（又称作逐元素积）：

$$
A \circ B 
= 
\left[
\begin{matrix}
a_{1,1}b_{1,1} & a_{1,2}b_{1,2} & \cdots & a_{1,n}b_{1,n} \\
a_{2,1}b_{2,1} & a_{2,2}b_{2,2} & \cdots & a_{2,n}b_{2,n} \\
\vdots & \vdots & \ddots & \vdots \\
a_{m,1}b_{m,1} & a_{m,2}b_{m,2} & \cdots & a_{m,n}b_{m,n}
\end{matrix}
\right] \tag{1g}
$$



- 克罗内积`Kronnecker product`：

$$
A \otimes B 
= 
\left[
\begin{matrix}
a_{1,1}B & a_{1,2}B & \cdots & a_{1,n}B \\
a_{2,1}B & a_{2,2}B & \cdots & a_{2,n}B \\
\vdots & \vdots & \ddots & \vdots \\
a_{m,1}B & a_{m,2}B & \cdots & a_{m,n}B
\end{matrix}
\right] \tag{1h}
$$



2.设$\vec x, \vec a, \vec b, \vec c$为n阶向量，$A, B, C, C$为n阶方阵， 则有：
$$
\frac{\delta(\vec a^T \vec x)}{\delta \vec x}
=
\frac{\delta(\vec x^T \vec a)}{\delta \vec x}
=
\vec a
\\

\frac{\delta \vec a^TX \vec b}{\delta X}
=
\vec a \vec b^T 
=
\vec a \otimes \vec b \in R^{n \times n}
\\

\frac{\delta(\vec a^TX^T \vec b)}{\delta X}
=
\vec b \vec a^T
=
\vec b \otimes \vec a \in R^{n \times n}
\\

\frac{\delta(\vec a^T X \vec a)}{\delta X}
=
\frac{\delta(\vec a^T X^T \vec a)}{\delta X}
=
\vec a \otimes \vec a
\\

\frac{\delta(\vec a^T X^T X \vec b)}{\delta X}
=
X(\vec a \otimes \vec b + \vec b \otimes \vec a)
\\

\frac{\delta[(A \vec x + \vec a)^T C (B \vec x + \vec b)]}{\delta \vec x}
=
A^T C (B \vec x + \vec b) + B^T C (A \vec x + \vec a)
\\

\frac{\delta (\vec x^T A \vec x)}{\delta \vec x}
=
(A + A^T) \vec x
\\

\frac{\delta[(X \vec b + \vec c)^T A(X \vec b + \vec c)]}{\delta X}
=
(A + A^T)(X \vec b + \vec c)\vec b^T
\\

\frac{\delta (\vec b^T X^T A X \vec c)}{\delta X}
=
A^T X \vec b \vec c^T + A X \vec c \vec b^T
$$
3.如果$f$是一元函数，则：

- 其逐元向量函数为：$f(\vec x) = (f(x_1), f(x_2), \cdots, f(x_n))T$
- 其逐矩阵函数为：

$$
f(X) = 
\left[
\begin{matrix}
f(x_{1,1}) & f(x_{1,2}) & \cdots & f(x_{1, n}) \\
f(x_{2,1}) & f(x_{2,2}) & \cdots & f(x_{2, n}) \\
\vdots & \vdots & \ddots & \vdots \\
f(x_{m,1}) & f(x_{m,2}) & \cdots & f(x_{m, n})
\end{matrix}
\right]
$$



- 其逐元导数分别为：

$$
f^\prime = (f^\prime(x_1), f^\prime(x_2), \cdots, f^\prime(x_n))^T \\

f^\prime =
\left[
\begin{matrix}
f^\prime(x_{1,1}) & f^\prime(x_{1,2}) & \cdots & f^\prime(x_{1,n}) \\
f^\prime(x_{2,1}) & f^\prime(x_{2,2}) & \cdots & f^\prime(x_{2,n}) \\
\vdots & vcdots & \ddots & \vdots \\
f^\prime(x_{m,1}) & f^\prime(x_{m,2}) & \cdots & f^\prime(x_{m,n})
\end{matrix}
\right]
$$

4.各种类型的偏导数：

- 标量对标量的偏导数：$\frac{\delta u}{\delta v}$
- 标量对向量(n维向量)的偏导数：$\frac{\delta u}{\delta \vec v}=(\frac{\delta u}{\delta v_1}, \frac{\delta u}{\delta v_2}, \cdots, \frac{\delta u}{\delta v_n})^T$
- 标量对矩阵(m x n阶矩阵)的偏导数：

$$
\frac{\delta u}{\delta V} =
\left[
\begin{matrix}
\frac{\delta u}{\delta V_{1,1}} & \frac{\delta u}{\delta V_{1,2}} & \cdots & \frac{\delta u}{\delta V_{1,n}} \\
\frac{\delta u}{\delta V_{2,1}} & \frac{\delta u}{\delta V_{2,2}} & \cdots & \frac{\delta u}{\delta V_{2,n}} \\
\vdots & \vdots & \ddots & \vdots \\
\frac{\delta u}{\delta V_{m,1}} & \frac{\delta u}{\delta V_{m,2}} & \cdots & \frac{\delta u}{\delta V_{m,n}}
\end{matrix}
\right]
$$

- 向量(m维向量)对标量的偏导数：$\frac{\delta \vec u}{\delta v} = (\frac{\delta u_1}{\delta v}, \frac{\delta u_2}{\delta v}, \cdots, \frac{\delta u_m}{\delta v})^T$
- 向量(m维向量)对向量(n维向量)的偏导数(雅可比矩阵，行优先)：

$$
\frac{\delta \vec u}{\delta \vec v} =
\left[
\begin{matrix}
\frac{\delta u_1}{\delta v_1} & \frac{\delta u_1}{\delta v_2} & \cdots & \frac{\delta u_1}{\delta v_n} \\
\frac{\delta u_2}{\delta v_1} & \frac{\delta u_2}{\delta v_2} & \cdots &
\frac{\delta u_2}{\delta v_n} \\
\vdots & \vdots & \ddots & \vdots \\
\frac{\delta u_m}{\delta v_1} & \frac{\delta u_m}{\delta v_2} & \cdots & \frac{\delta u_m}{\delta v_n}
\end{matrix}
\right]
$$

如果为列优先，则为上面矩阵的转置

- 矩阵(m x n阶矩阵)对标量的偏导数：

$$
\frac{\delta U}{\delta v} =
\left[
\begin{matrix}
\frac{\delta U_{1,1}}{\delta v} & \frac{\delta U_{1,2}}{\delta v} & \cdots & \frac{\delta U_{1,n}}{\delta v} \\
\frac{\delta U_{2,1}}{\delta v} & \frac{\delta U_{2,2}}{\delta v} & \cdots & \frac{\delta U_{2,n}}{\delta v} \\
\vdots & \vdots & \ddots & \cdots \\
\frac{\delta U_{m,1}}{\delta v} & \frac{\delta U_{m,2}}{\delta v} & \cdots & \frac{\delta U_{m,n}}{\delta v}
\end{matrix}
\right]
$$



5.对于矩阵的迹，有下列偏导数成立：
$$
\frac{\delta [tr(f(X))]}{\delta X} = (f^\prime(X))^T \\
\frac{\delta[tr(AXB)]}{\delta X} = A^TB^T \\
\frac{\delta[tr(AX^TB)]}{\delta X} = BA \\
\frac{\delta[tr(A \otimes X)]}{\delta X} = tr(A)I \\
\frac{\delta[tr(AXBX)]}{\delta X} = A^TX^TB^T + B^TXA^T \\
\frac{\delta[tr(X^TBXC)]}{\delta X} = BXC + B^TXC^T \\
\frac{\delta[tr(C^TX^TBXC)]}{\delta X} = (B^T + B)XCC^T \\
\frac{\delta[tr(AXBX^TC)]}{\delta X} = A^TC^TXB^T + CAXB \\
\frac{\delta[tr((AXB+C)(AXB+C))]}{\delta X} = 2A^T(AXB+C)B^T
$$

6.假设$U=f(X)$是关于$X$的据真值函数($f:R^{m \times n} \to R^{m \times n}$)，且$g(U)$是关于$U$的实值函数($g: R^{m \times n} \to R$)，则下面链式法则成立：
$$
\frac{\delta g(U)}{\delta X}
=
(\frac{\delta g(U)}{\delta x_{i,j}})_{m \times n}
=
\left[
\begin{matrix}
\frac{\delta g(U)}{\delta x_{1,1}} & \frac{\delta g(U)}{\delta x_{1,2}} & \cdots & \frac{\delta g(U)}{\delta x_{1,n}} \\
\frac{\delta g(U)}{\delta x_{2,1}} & \frac{\delta g(U)}{\delta x_{2,2}} & \cdots & \frac{\delta g(U)}{\delta x_{2,n}} \\
\vdots & \vdots & \ddots & \cdots \\
\frac{\delta g(U)}{\delta x_{m,1}} & \frac{\delta g(U)}{\delta x_{m,2}} & \cdots & \frac{\delta g(U)}{\delta x_{m,n}}
\end{matrix}
\right] \\
=
(\sum_k \sum_l \frac{\delta g(U)}{\delta u_{k,l}}\frac{\delta u_{k,l}}{\delta x_{i,j}})
=
(tr[(\frac{\delta g(U)}{\delta U})^T \frac{\delta U}{\delta x_{i,j}}])
$$


#### 特殊函数

> 这里给出机器学习中用到的一些特殊函数

##### 4.1 sigmoid函数

1.`sigmoid`函数
$$
\delta(x) = \frac{1}{a+exp(-x)}
$$


### 2.概率论基础

#### 概率与分布

#### 期望和方差

#### 大数定律及中心极限定理

#### 常见概率分布

#### 先验分布和后验分布

#### 信息论

#### 其它

### 3.数值计算基础

#### 数值稳定性

#### 梯度下降法

#### 二阶导数和海森矩阵

#### 牛顿法

#### 逆牛顿法

#### 约束优化

### 4.蒙特卡洛方法与MCMC采样

#### 蒙特卡洛方法

#### 马尔可夫链

#### MCMC采样

## 统计学习

### 0.机器学习简介

#### 基本概念

#### 监督学习

#### 机器学习三要素

### 1.线性代数基础

#### 线性回归

#### 广义线性模型

#### 对数几率回归

#### 线性判断分析

#### 感知机

### 2.支持向量机

#### 线性可分支持向量机

#### 线性支持向量机

#### 非线性支持向量机

#### 支持向量回归

#### SVDD

#### 序列最小最优化方法

#### 其它讨论

### 3.朴素贝叶斯

#### 贝叶斯定理

#### 朴素贝叶斯法

#### 半朴素贝叶斯分类器

#### 其它讨论

### 4.决策树

#### 原理

#### 特征选择

#### 生成算法

#### 剪枝算法

#### CART树

#### 连续值、缺失值处理

#### 多变量决策树

### 5.knn

#### k近邻算法

#### kd树

### 6.集成学习

#### 集成学习误差

#### Boosting

#### Bagging

#### 集成策略

#### 多样性分析

### 7.梯度提升树

#### 提升树

#### xgboost

#### LightGBM

### 8.特征工程

#### 缺失值处理

#### 特征编码

#### 数据标准化、正则化

#### 特征选择

#### 稀疏表述和字典学习

#### 多类分类问题

#### 类别不平衡问题

### 9.模型评估

#### 泛化能力

#### 过拟合、欠拟合

#### 偏差方差分解

#### 参数估计准则

#### 泛化能力评估

#### 训练集、验证集、测试集

#### 性能度量

#### 超参数调节

#### 传统机器学习的挑战

### 10.降维

#### 维度灾难

#### 主成分分析 PCA

#### 核化线性降维 KPCA

#### 流形学习

#### 度量学习

#### 概率PCA

#### 独立成分分析

#### t-SNE

#### LargeVis

### 11.聚类

#### 性能度量

#### 原型聚类

#### 密度聚类

#### 层次聚类

#### 谱聚类

### 12.半监督学习

#### 半监督学习

#### 生成式半监督学习方法

#### 半监督SVM

#### 图半监督学习

#### 基于分歧的方法

#### 半监督聚类

#### 总结

### 13.EM算法

#### 示例

#### EM算法原理

#### EM算法与高斯混合模型

#### EM算法与kmeans模型

#### EM算法的推广

### 14.最大熵算法

#### 最大熵模型MEM

#### 分类任务最大熵模型

#### 最大熵的学习

### 15.隐马尔可夫模型

#### 隐马尔科夫模型HMM

#### HMM基本问题

#### 最大熵马尔可夫模型MEMM

### 16.概率图与条件随机场

#### 概率图模型

#### 贝叶斯网络

#### 马尔可夫随机场

#### 条件随机场 CRF

### 17.边际概率推断

#### 精确推断

#### 近似推断

## 深度学习

### 0.深度学习简介

#### 介绍

#### 历史

### 1.深度前馈神经网络

#### 基础

#### 损失函数

#### 输出单元

#### 隐单元

#### 结构设计

#### 历史小计

### 2.反向传播算法

#### 链式法则

#### 反向传播

#### 算法实现

#### 自动微分

### 3.正则化

#### 参数范数正则化

#### 显式约束正则化

#### 数据集增强

#### 噪声鲁棒性

#### 早停

#### 参数相对约束

#### dropout

#### 对抗训练

#### 正切传播算法

#### 其它相关

### 4.最优化基础

#### 代价函数

#### 神经网络最优化挑战

#### mini-batch

#### 基本优化算法

#### 自适应学习率算法

#### 二阶近似方法

#### 共轭梯度法

#### 优化策略和元算法

#### 参数初始化策略

#### Normalization

### 5.卷积神经网络

#### 卷积运算

#### 卷积层、池化层

#### 基本卷积变体

#### 应用

#### 历史和现状

### 5.1.CNN之图片分类

#### LeNet

#### AlexNet

#### VGG-Net

#### Inception

#### ResNet

#### ResNet变种

#### SENet

#### DenseNet

#### 小型网络

### 6.循环神经网络

#### RNN计算图

#### 循环神经网络

#### 长期依赖

#### 序列到序列架构

#### 递归神经网路

#### 回声状态网路

#### LSTM和其它门控RNN

#### 外显记忆

### 7.工程实践指导原则

#### 性能度量

#### 默认的基准模型

#### 决定是否收集更多数据

#### 选择超参数

#### 调试策略

#### 示例：数字识别系统

#### 数据预处理

#### 变量初始化

#### 结构设计

## 自然语言处理

### 主题模型

#### Unigram Model

#### pLSA Model

#### LDA Model

#### 模型讨论

### 2.词向量

#### 向量空间模型VSM

#### LSA

#### Word2Vec

#### GloVe

## 工具

### CRF

#### 安装

#### 使用

#### 常见错误

### lightgbm

#### 安装

#### 调参

#### 进阶

#### API

#### Docker

### numpy
### pandas
### sklearn
#### 预处理
##### 特征处理
##### 特征选择
##### 字典学习
##### Pipeline
#### 降维
##### PCA
##### MDS
##### lsomap
##### LocallyLinearEmbedding
##### FA
##### FastICA
##### t-SNE
#### 监督学习模型
##### 线性模型
##### 支持向量机
##### 贝叶斯模型
##### 决策树
##### KNN
##### AdaBoost
##### 梯度提升树
##### Random Forest
#### 模型评估
##### 数据集切分
##### 性能度量
##### 验证曲线 && 学习曲线
##### 超参数优化
#### 聚类模型
##### KMeans
##### DBSCAN
##### MeanShift
##### AgglomerativeClustering
##### BIRCH
##### GaussianMixture
##### SpectralClustering
#### 半监督学习模型
##### 标签传播算法
#### 隐马尔可夫模型
##### Hmmlearn
##### seqlearn
### scipy
### xgboost
### matplotlib
### seaborn
### spark
