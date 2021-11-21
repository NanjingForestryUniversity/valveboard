# 阀板

阀板接收上位机给的数据，按其要求控制高速喷阀的开启和关闭，用在棉花、烟叶、茶叶等分选机上，喷阀多用来吹走其中的杂质。因此阀板是分选步骤上控制最终执行机构的驱动板，要求高速、稳定

## 目录结构

- 硬件上阀板就是控制喷阀的板子，相关原理图、PCB、BOM、硬件说明等在`hardware`目录里

- 阀板仅驱动喷阀，具体哪个开启哪个关闭要遵循上级的指令，指令传输过程须符合通信协议，通信协议在`protocol`目录里

- 阀板读取通信数据、发出控制信号的操作由阀板上的CPLD进行，其固件和说明见`firmware`目录
- 另外提供了若干输出符合阀板通信协议的信号的例子，在`examples`目录里，严格上这不属于阀板工程

## 版本

由于阀板经常有不同类型的新要求出现，比如24路阀板、32路阀板、控制不同参数的新阀，因此不同的阀板型号（注意不是更新，比如阀板上添加级联接口属于更新）应建立不同的分支，**主分支无实际意义**

分支命名规则（不使用中文）

```shell
b分支编号-c路数-p生产环境项目名-v喷阀信息-[-其他特点1[-其他特点2...]]
```

中括号在这里表示可省略的项，中括号本身不应出现在实际命名中，其他特点应字母打头，可有多个，"-"相连

使用Git的tag功能定义版本，Github仓库的release功能同步发布最新版本的PCB生产文件、PCB制造视图、BOM表、板载固件、通信协议手册

版本号遵循定义如下（不使用中文）

```shell
b分支编号-h硬件版本-p协议版本-f固件版本
```

分支编号和分支命名中编号一致

