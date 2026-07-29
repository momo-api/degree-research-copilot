# 学位科研副驾驶 2.2：质量测试报告

测试日期：2026-07-29  
测试对象：`lab-research-kit` 2.2.0 / `lab-research-router`  
交付包：`degree-research-copilot-2.2.0.zip`

## 结论

源码目录与 ZIP 解压副本均通过全部 25 项确定性测试；Skill 与 Plugin 官方结构验证器均通过。ZIP 顶层为 `lab-research-kit`，并包含 `.codex-plugin/plugin.json`。

| 检查 | 源码目录 | ZIP 解压副本 |
|---|---:|---:|
| 单元/合同测试 | 25/25 | 25/25 |
| PowerShell 脚本语法解析 | 6/6 | 由测试执行与解压烟雾测试覆盖 |
| 全新 Git clone（CRLF checkout） | 不适用 | 25/25 |
| GitHub Actions `windows-latest` | 不适用 | 通过 |
| Skill `quick_validate.py` | 通过 | 通过 |
| Plugin `validate_plugin.py` | 通过 | 通过 |

首次测试为 24/25，发现空的 `research-brief.md` 会因 Degree/Track 等模板元数据被误判为实质内容。已修正 `validate-stage.ps1` 的内容过滤规则；修正后源码包和解压包均为 25/25。没有通过放宽测试来掩盖问题。

## 2.2 新增测试覆盖

### Canonical project state

- 初始化创建 `research/project.json`，包含 schema、插件版本、项目 ID、学位、学校、毕业时间、题目、学科、Track、阶段和工作流状态。
- `research-status.ps1` 从 canonical state 恢复阶段、健康、阻塞和下一闸门，并可重建 `status.md`。
- 使用冲突参数重复初始化会拒绝，并明确要求使用迁移脚本。

### Profile migration and history

- `update-research-project.ps1` 可迁移学位、课题类型、学科与阶段。
- 新 Track/学位需要的模板会补齐。
- 已生成的 Degree/Track/Discipline 头部会同步。
- 变更会追加到 `decision-log.md`。
- 旧 Track 文件保留为历史，不会静默删除。
- 没有实际更新字段的调用会拒绝。

### Stage gates and input safety

- 空 intake 不通过，退出码为 2。
- 有明确问题、约束、交付物和成功标准的 intake 通过。
- 阶段验证检查 Markdown 实质内容或 CSV 数据行，而非只看文件存在。
- 文件系统根目录初始化、多行元数据和非法学位 Profile 会拒绝。
- `-WhatIf` 不写入；重复初始化不覆盖已有文件。

### Adaptive profiles

| Profile | 预期文件数 | 结果 |
|---|---:|---:|
| Bachelor + Literature | 19 | 通过 |
| Bachelor + Engineering | 22 | 通过 |
| Bachelor + Design | 22 | 通过 |
| Master + WetLab | 26 | 通过 |
| Doctoral + Computational | 28 | 通过 |

同时验证 Literature 不创建实验目录，Engineering/Design 不误建湿实验随机化与默认统计计划，Doctoral 创建研究计划和工作包。

## 验证命令

```powershell
& .\lab-research-kit\skills\lab-research-router\scripts\test-quality.ps1

$env:PYTHONUTF8 = '1'
python C:\Users\lumao\.codex\skills\.system\skill-creator\scripts\quick_validate.py `
  .\lab-research-kit\skills\lab-research-router
python C:\Users\lumao\.codex\skills\.system\plugin-creator\scripts\validate_plugin.py `
  .\lab-research-kit
```

Windows 中文环境需设置 `PYTHONUTF8=1`，否则上游 Python 验证器可能使用系统 GBK 解码 UTF-8 的中文 `SKILL.md`。这不是 Skill 内容错误。

## ZIP 完整性

- 文件大小：62,930 bytes
- SHA-256：`07F26410B48659F1903FE4FA596A91221DFED0B1E3F66D43E4CBDB6E4DF4325C`
- 解压烟雾测试目录：`work/package-smoke-2.2-crlf-final`
- ZIP 顶层：`lab-research-kit`

GitHub Actions 首轮还发现 Profile 头部同步测试只兼容 LF 行尾。已将同步逻辑改为保留 Windows CRLF，并使测试显式兼容 LF/CRLF；全新 clone 和 `windows-latest` CI 随后均通过。

## 测试没有证明什么

这些测试验证的是目录、元数据、脚本行为、状态迁移和工作流合同，不是科研效果基准。它们尚未证明：

- 任意模型都能正确完成选题、文献判断、实验设计或统计推断；
- 引用、DOI、数据库记录、样本量、DOE 或统计结果天然真实；
- 真实湿实验、伦理/安全审批、导师决策或毕业要求已经完成；
- 第三方 Skills 已安装、可用、安全或适合当前课题；
- 长期真实 Agent 前向测试在所有 Codex 版本上行为一致。

生产使用仍需按材料做引用核验、数据/代码复现、设计与统计审查，并由学生、导师和相关审批机构承担最终责任。
