# 学位科研副驾驶 2.2.0

首个 GitHub Marketplace 结构化发行版。

## 重点更新

- `research/project.json` 成为学位、课题类型、阶段、健康、阻塞和下一闸门的唯一项目状态源。
- 新增初始化、跨会话恢复、Profile/Track 迁移、状态页和阶段验证脚本。
- 新增任务书/培养计划、开题、中期、预答辩、外审、提交、答辩与归档里程碑。
- 新增周报、导师会议、决策和 AI 使用记录。
- 本科文献、工程、设计，硕士湿实验和博士计算项目按最小模板集自适应。
- 提供 Codex Marketplace、Codex App 安装提示词、Windows CI、README、指南和质量报告。

## 安装

```powershell
codex plugin marketplace add momo-api/degree-research-copilot --ref v2.2.0
codex plugin add lab-research-kit@degree-research-copilot
```

安装后新建 Codex 任务并调用：

```text
$lab-research-router
```

## 验证

- 源码目录：25/25
- Release ZIP 解压副本：25/25
- PowerShell 脚本语法、Skill validator、Plugin validator：通过

Release ZIP SHA-256：

```text
9C5DF49E9CAD0DEF712AB0425DFC1C7B7A16BF46E5C19EB0CB8330EAF451BEB7
```

这些测试验证软件和工作流合同，不代表科研结论、引用、实验、统计或毕业结果天然正确。
