# 给 Codex App Agent 的安装提示词

把下面整段复制到一个新的 Codex App 任务中。Agent 可以完成 Marketplace 注册、Plugin 安装和验证；不要把 GitHub Token、密码或一次性验证码写进提示词。

```text
请为当前用户安装“学位科研副驾驶”Codex Plugin。

来源：momo-api/degree-research-copilot
稳定版本：v2.2.0
Marketplace 名称：degree-research-copilot
Plugin 名称：lab-research-kit
Skill 入口：$lab-research-router

请严格执行以下流程：

1. 先做只读检查：
   - 确认 codex CLI 可用；
   - 运行 `codex plugin marketplace list`；
   - 运行 `codex plugin list --available --json`；
   - 不要显示、读取或请求我的 GitHub Token、密码或验证码。

2. 如果 degree-research-copilot Marketplace 尚未配置，运行：
   `codex plugin marketplace add momo-api/degree-research-copilot --ref v2.2.0`

3. 如果同名 Marketplace 已存在：
   - 不要重复添加；
   - 先报告它的来源和当前 ref；
   - 来源正确时运行 `codex plugin marketplace upgrade degree-research-copilot`；
   - 来源冲突时停止，不要删除或替换，等我确认。

4. 确认 Marketplace 中的 lab-research-kit 版本为 2.2.0，且来源路径为：
   `./plugins/lab-research-kit`

5. 如果 Plugin 尚未安装，运行：
   `codex plugin add lab-research-kit@degree-research-copilot --json`

6. 如果已经安装：
   - 不要重复安装；
   - 核对安装版本；
   - 版本不一致时先说明差异，再执行官方支持的升级/重新安装流程；
   - 不要手工修改 Codex 缓存或 marketplace 配置文件。

7. 安装后验证：
   - `codex plugin list --json`
   - 确认 lab-research-kit 已安装并启用；
   - 确认插件清单含 `$lab-research-router`；
   - 不安装任何第三方科研 Skills；
   - 不初始化任何真实课题目录。

8. 最后告诉我：
   - Marketplace 和 Plugin 的实际状态；
   - 执行过的命令及结果摘要；
   - 是否需要新建 Codex 任务；
   - 给出一条只读测试提示词。

只读测试提示词应为：
`$lab-research-router 我是硕士生。请只说明首次建档需要哪些信息，不创建文件、不安装其他技能。`

任何来源冲突、权限错误、版本不一致或需要删除现有配置的情况都必须停止并向我报告，不能自行覆盖。
```

安装完成后新建 Codex 任务。Plugin bundled skills 通常只会在新的任务/CLI session 中加载。
