# Contributing

感谢改进学位科研副驾驶。请优先提交可复现的问题、最小修改和确定性测试。

## 开发流程

1. 从 `main` 创建短分支。
2. 修改 `plugins/lab-research-kit/` 下的 Plugin/Skill。
3. 新脚本必须有对应的确定性测试，并在 Windows PowerShell 7 上真实运行。
4. 更新用户可见行为时同步修改 README、指南和 CHANGELOG。
5. 运行：

```powershell
& .\scripts\test-repository.ps1
```

6. 提交 PR，并说明行为变化、风险、测试结果和人工验证范围。

## 设计原则

- `SKILL.md` 是轻量路由器，复杂方法放 references，可重复逻辑放 scripts。
- `research/project.json` 是项目 Profile/工作流状态唯一源。
- 不把计划写成执行结果，不把空模板写成阶段完成。
- 不静默删除用户研究材料或历史 Track 文件。
- 学位和 Track 自适应，不向本科/文献/工程/设计项目强加无关复杂度。
- 不复制第三方 Skills；保留链接、许可证和清晰边界。

## 不应提交

- 真实学生身份、学校账号、患者信息或敏感数据。
- 未发表论文、原始实验数据、真实 `research/project.json`。
- API Key、GitHub Token、Cookie、凭据和本地绝对路径。
- 无法核实的引用、实验结果或宣传性能力声明。
