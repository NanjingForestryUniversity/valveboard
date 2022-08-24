# 阀板固件

这是阀板上CPLD的固件，严格意义上也属于硬件，因为是描述的硬件结构。这个固件是按照通信协议写的，但比通信协议能适应更广的传输速度，**烟梗分选机上`SCLK`为2MHz，高电平时间为0.2ms**

## 如何烧录

Quartus软件

## 程序说明

看程序注释

## Changelog

**作者是丁坤，2019年9月入学、丁坤QQ1091546069、丁坤电话17761700156**，他是搞嵌入式的，自师兄王聪（2018年9月入学）毕业后硬件领域师门出现空档期，被老倪催的没办法了，就顺手写了这份FPGA代码，作者已经毕业，但很乐意解答关于固件的所有问题

### v1.0

继承自老程序

### v1.1

丁坤重写了

### v1.2

修正了引脚分配

### v1.3

- 添加了高电压抑制，见[issue#4](https://github.com/NanjingForestryUniversity/valveboard/issues/4)
- 修正了高电压时间为0.2ms

### 当前版本

- 暂且添加每路阀独立的开启超时为200ms，见[issue#6](https://github.com/NanjingForestryUniversity/valveboard/issues/6)
- 通讯中断超时从原来的1s修改为200ms
