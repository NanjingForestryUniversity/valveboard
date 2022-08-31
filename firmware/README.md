# 阀板固件

这是阀板上CPLD的固件，严格意义上也属于硬件，因为是描述的硬件结构。这个固件是按照通信协议写的，但比通信协议能适应更广的传输速度，**烟梗分选机上`SCLK`为2MHz，高电平时间为0.2ms**

## 如何烧录

Quartus软件

## 程序说明

看程序注释

## Changelog
### v1.0

继承自老程序

### v1.1

丁坤重写了

### v1.2

修正了引脚分配

### v1.3

- 添加了高电压抑制，见[issue#4](https://github.com/NanjingForestryUniversity/valveboard/issues/4)
- 修正了高电压时间为0.2ms

### v1.4

确认了阀不需要长时间开启保护，删除了阀板固件v1.4-beta1([commit 6af8df](https://github.com/NanjingForestryUniversity/valveboard/commit/6af8dfd09c268d677a46063cc9637f573e69919e))中的长时间开启保护，见[issue#6](https://github.com/NanjingForestryUniversity/valveboard/issues/6)


## 作者
[过奕任](https://github.com/3703781)、丁坤

过奕任自师兄王聪（2018年入学）毕业后硬件方面师门出现空档期，被老倪催的没办法了，就学了硬件并顺手写了这份FPGA代码。丁坤是专门搞嵌入式的，但也看过这份代码。欢迎提[issue](https://github.com/NanjingForestryUniversity/valveboard/issues)，bug随缘解决。

过奕任2020年入学，目前正打算找其他人接管这个库，毕业了就不要找他，但永远可以找丁坤。

丁坤2019年入学、丁坤QQ1091546069、丁坤电话17761700156，已经毕业，但很乐意解答所有问题。

