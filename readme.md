## 会话变量配置 (Session Environment Configuration)

目的：通过存储别名和路径，用于在 CMD 和 PowerShell 中快速设置环境变量（仅限会话）。

Purpose: Use to set session environment quickly in CMD and PowerShell by store alias and path.

主要使用场景是切换一些语言的不同版本，比如 java。因此本项目提取自 [JEnv](https://github.com/FelixSelter/JEnv-for-Windows) 并做了一些修改。

Mainly use to switch different version of some language, like java. This project extracted from  [JEnv](https://github.com/FelixSelter/JEnv-for-Windows) , thanks for  [JEnv](https://github.com/FelixSelter/JEnv-for-Windows) .

## 安装 (Installation)

1. 下载此项目 (Clone this repository)
2. 将此项目目录路径添加至环境变量中 (Add it to the path)

## 使用 (Usage)

1. **添加一个环境变量** (**Add a new environment**)
   
   `senv add <name> <path>` 
   
   例子：`senv add jdk11 D:\Java\jdk-11.0.13\bin`。
   
   （你需要将路径指定到 `bin` 目录下，你可以指定任何具有可执行文件的路径）
   
   (You need to specify the path to the bin, or other which have executable file you want to execute)
2. **查看变量配置列表** (**List all your environments**)
   
   `senv list` 
3. **删除指定名称的变量配置** (**Remove an existing environment from the SEnv list**)
   
   `senv remove <name>` 
4. **指定名称改变当前环境变量** (**Change environment for the current session**)
   
   `senv use <name>` 
   
   例子：`senv use jdk11`，实际上执行 (Actually executed)：
   
   ---CMD：`set path=D:\Java\jdk-11.0.13\bin;%path%` 
   
   ---PowerShell：`$Env:PATH="D:\Java\jdk-11.0.13\bin;$Env:PATH"` 

