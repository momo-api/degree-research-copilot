# Graduate research copilot prompt examples

Use these as task cards. Replace bracketed fields and real file paths. Never claim a skill is installed until it appears in the active skill list.

## Contents

1. Graduate Research Copilot
2. ARS-Codex
3. Scientific Agent Skills
4. ARIS
5. Orchestra AI Research Skills
6. zLanqing academic skills
7. PaperSpine
8. Nature Skills
9. paper-craft-skills
10. Research-Paper-Writing-Skills
11. PaperJury Codex

## 1. Graduate Research Copilot

### Initialize the canonical project state

```powershell
.\scripts\init-research-project.ps1 -Path C:\research\my-thesis `
  -Title "我的论文题目" -Degree Master -Track WetLab -Discipline "生物化学" `
  -CurrentStage intake -Institution "示例大学" -ExpectedGraduation "2027-06"
```

### Resume a later session

```powershell
.\scripts\research-status.ps1 -Path C:\research\my-thesis
```

Read `research/project.json` as canonical state, then open the current artifact, blocker, next gate, milestones, and latest decision/weekly logs. Do not reconstruct the profile from chat memory.

### Change profile or track safely

```powershell
.\scripts\update-research-project.ps1 -Path C:\research\my-thesis `
  -Track Computational -CurrentStage proposal -Health at-risk `
  -CurrentBlocker "尚未获得数据集" -NextGate "确认数据许可和基线"
```

This adds newly required templates, synchronizes generated headers, writes status/decision records, and retains older track files as history.

### Validate a stage before advancing

```powershell
.\scripts\validate-stage.ps1 -Path C:\research\my-thesis -Stage proposal
if ($LASTEXITCODE -ne 0) { throw "Proposal gate has not passed." }
```

The validator checks material content/data rows. Passing it is a structural gate, not proof of scientific correctness or supervisor approval.

### Start a persistent master's/doctoral project

```text
$lab-research-router
我是[专业]的[硕士/博士][年级]，方向是[方向]。
学校要求在[日期]前完成[开题/中期/论文/答辩]。
现有材料位于：[真实路径]。
可用资源：[样本、设备、预算、算力、时间、技能]。

请先检查材料并判断当前阶段，不要直接写成品：
1. 建立或恢复 research/ 项目档案；
2. 列出已知事实、用户提供信息、推断、方案和待核实项；
3. 只处理当前最关键的一个决策；
4. 生成或更新对应项目文件；
5. 告诉我过关条件和下一次需要导师确认的事项。
不要编造文献、数据、实验、审批或结果。
```

### Start a lightweight bachelor's thesis

```text
$lab-research-router
我是[专业]本科四年级，毕业论文/设计类型是[文献/实证/湿实验/计算/工程/设计]。
学校任务书或模板在[路径]，答辩日期是[日期]，可用资源是[资源]。

请使用 Bachelor 模式：
1. 先读取学校要求，把它作为验收标准；
2. 把题目收敛为一个学期可完成的问题或作品；
3. 不要求虚假的重大创新，允许规范的应用、比较、复现、实现、综合或设计贡献；
4. 选择最简单但有效的方法，给出失败后的保底路线；
5. 仅创建当前课题类型需要的项目文件，不要默认生成博士级档案；
6. 每一步都让我能够解释自己做了什么、证据在哪里、局限是什么。
```

### Start an engineering capstone

```text
$lab-research-router
我是计算机本科生，毕业设计是“校园实验室预约系统”。
请使用 Bachelor + Engineering：从真实需求和验收指标开始，
建立需求—测试矩阵、架构、实现里程碑、版本记录、性能/安全/可靠性测试和论文证据映射。
不要把“系统能运行”直接写成研究创新；不要创建湿实验随机化或统计分析文件。
```

### Start a design capstone

```text
$lab-research-router
我是工业设计本科生，毕设是面向老年人的药盒交互设计。
请使用 Bachelor + Design：整理用户与情境证据、设计简报、评价标准、方案迭代、
选择理由、可用性/无障碍/伦理评价、最终作品说明和答辩证据。
不要为了显得科学而强行套假设检验。
```

### Select a feasible thesis topic

```text
$lab-research-router
我是生物化学硕士一年级，兴趣是酶工程与低温催化。
限制：两年、预算 6 万元、可用常规蛋白表达纯化设备，没有冷冻电镜；
每周最多处理 40 个样本，尚无预实验数据。

请进入选题阶段：
1. 把方向收敛为 3–5 个可证伪的候选研究问题；
2. 为每个候选建立检索与新颖性核查计划；
3. 评估重要性、新颖性、可行性、可识别性、风险和论文价值；
4. 设计两周内可完成的最小验证；
5. 推荐一个主选题和一个备选题，并说明否决条件；
6. 更新 research-brief、topic-candidates、novelty-audit 和 decision-log。
真实检索前不要列出貌似真实的论文。
```

### Build a proposal from an institution template

```text
$lab-research-router
学校开题模板在 ./templates/开题报告.docx，已有材料在 ./literature/ 和 ./pilot/。
请先读取模板和材料，再完成开题工作流：
1. 建立“研究问题 → 目标 → 方法 → 终点 → 分析 → 判据”映射；
2. 审核国内外现状、研究空白和创新点的证据状态；
3. 生成技术路线、可行性、风险登记表、备选方案和里程碑；
4. 标出伦理、生物安全、样本、设备和统计方面的待确认项；
5. 先输出 proposal-outline 与 technical-route，等待我和导师确认后再写正式报告；
6. 最后生成 12 分钟开题答辩提纲和高频问题卡。
不要改变学校模板，不要把计划写成已完成结果。
```

### Design a biochemical multifactor experiment

```text
$lab-research-router
研究目标：优化某重组酶的表达与活性。
候选因素：温度 16/25/37℃，诱导剂 0.1/0.5/1.0 mM，
诱导时间 4/8/16 h，培养基 LB/TB。
主要终点：可溶性产量和比活性；限制是每周 30 个样本、预算 5000 元。

请进入 experiment-design / plan 模式：
1. 明确实验单位、观察单位、因素、范围、对照、批次和混杂因素；
2. 比较完整析因、筛选设计、正交试验和响应面法；
3. 给出运行数、可估计效应、混杂/别名、不能回答的问题和选择理由；
4. 区分生物学重复、技术重复和子样本；
5. 设计预实验、正式实验、确认实验和停止/转向判据；
6. 给出样本量所需假设和敏感性分析，不凭“三次重复”拍脑袋；
7. 制定随机化、区组、盲法、QC、异常/缺失、统计分析和版本记录方案；
8. 更新 design-brief、factors-and-controls 和 statistical-analysis-plan。
仅做研究设计；操作参数必须以实验室已批准 SOP 为准。
```

### Write a thesis or paper from evidence

```text
$lab-research-router
文献在 ./literature/，原始数据在 ./data/raw/，分析代码在 ./analysis/，
结果在 ./results/，当前草稿在 ./paper/。
目标：[学位论文/期刊/会议及格式]。

请先做写作前审计：
1. 建立 claim-evidence-map；
2. 区分真实结果、统计估计、解释、机制推断和建议；
3. 找出缺失实验、引用冲突、过强结论和不可复现步骤；
4. 设计论文主线和章节契约；
5. 等我确认后逐章写作，保留引用键，不新增未核实引用；
6. 完成后执行方法/统计、引用、图表和限制四轮审计；
7. 生成模拟审稿矩阵和修改清单。
```

### Prepare for proposal or thesis defense

```text
$lab-research-router
开题/学位论文和已有 PPT 位于 ./defense/，答辩限时 15 分钟。
请生成结论式答辩结构、逐页时间预算和证据边界检查；
从创新性、方法、对照、样本量、统计、负结果、伦理安全、局限和替代解释
九个方向生成问题卡。答案使用“立场 → 证据 → 边界 → 下一步”，
未知内容明确说未知，不编造补充实验。
```

### Choose a minimal stack

```text
$lab-research-router
【身份】计算机硕士一年级
【课题】多模态模型的医学影像报告生成
【现状】只有方向，没有文献库和实验代码
【目标】两周内完成可给导师讨论的选题备忘录
请先判断任务模式，给出“1 个主技能 + 最多 1 个专业技能”的选择。
列出证据缺口、安装前需要检查的许可证与依赖；不要安装任何东西。
```

### Audit a draft without inventing sources

```text
$lab-research-router
审查 ./paper/intro.md。
输出：主张清单、现有证据、缺失证据、逻辑跳跃、可执行修改。
引用只分为“已核实元数据并核实主张”“仅核实元数据”“待核实”。
不要补写任何真实文献条目，除非你实际检索并核验。
```

## 2. ARS-Codex: `academic-research-suite`

### Scope a topic and design the search

```text
$academic-research-suite
【任务】把“生成式 AI 用于程序修复”收紧成硕士可完成的研究问题
【限制】单卡 24 GB GPU，六个月，目标会议短文
【输出】候选问题对比、最终 PICOC/SPIDER 风格问题、数据库与检索式、纳排标准、文献矩阵表头
当前没有真实检索结果，只输出计划，不编造论文。
在进入检索前设置一个人工确认点。
```

### Build a verified related-work matrix

```text
$academic-research-suite
材料位于 ./literature/，其中包含 RIS、BibTeX 和 PDF。
为 related work 建立矩阵：研究问题、数据集、方法、基线、指标、主要发现、限制、可复现资源、证据定位。
仅把实际读取到的论文写入矩阵；缺 PDF 的条目标记“仅元数据”。
最后按“方法谱系”提出章节结构，不直接写正文。
```

### Revise an introduction

```text
$academic-research-suite
按 academic paper 流程修改 ./drafts/introduction.md。
目标：问题重要性 → 现有路线 → 精确缺口 → 我们的方法 → 可核验贡献。
保留原引用键，不新增未核实引用。
先给 gap/contribution 诊断和修改计划，确认后再写修订稿与 diff 摘要。
```

### Simulate peer review

```text
$academic-research-suite
以严格但建设性的领域审稿人审阅 ./paper/main.tex。
输出 Summary / Strengths / Major Weaknesses / Minor Weaknesses / Questions / Reproducibility。
每条意见必须给出文件、章节或行号定位，并区分“阻断接收”“需要澄清”“可选改进”。
不要推断不存在的实验。
```

### Draft a rebuttal plan

```text
$academic-research-suite
审稿意见在 ./reviews/，论文和实验结果在 ./paper/ 与 ./results/。
先生成 reviewer-comment → issue → evidence → planned action → owner → status 矩阵。
只对现有结果使用过去时；未运行的实验写成 proposal。
确认矩阵后再逐点起草回复。
```

## 3. Scientific Agent Skills

### `database-lookup`: gene-disease evidence

```text
使用 database-lookup。
查询基因 [GENE] 与疾病 [DISEASE] 的证据，优先 ClinVar、NCBI Gene、UniProt、Open Targets、ClinicalTrials.gov。
记录每个数据库的查询、过滤条件、稳定标识符、检索时间和原始链接。
按“遗传证据 / 功能证据 / 临床证据 / 冲突”汇总；不要给患者诊疗建议，不编造 PMID。
```

### `paper-lookup`: bounded biomedical search

```text
使用 paper-lookup。
问题：[INTERVENTION] 对 [CONDITION] 的机制证据是什么？
数据库：PubMed、Crossref、OpenAlex；日期范围 2020-01-01 至今；仅英文原始研究和系统综述。
先返回可复现检索式与去重规则，再执行检索。
每条记录必须有 PMID/DOI/稳定 URL；全文未读时标记“仅题录/摘要”。
```

### `scanpy`: single-cell analysis plan

```text
使用 scanpy 处理 ./data/sample.h5ad。
先只读检查 AnnData 结构、批次字段、细胞/基因数量和稀疏矩阵类型。
提出 QC 阈值与理由，等待确认后再过滤。
固定随机种子，保存每个阶段的新文件，不覆盖原始数据；输出 notebook、QC 图、参数表和 session information。
```

### `rdkit`: reproducible compound filtering

```text
使用 rdkit 审查 ./data/compounds.sdf。
任务：标准化结构、去盐、标记无效分子，计算 MW/logP/TPSA/HBD/HBA，并按我确认的阈值过滤。
保留原始 ID，输出 rejected.csv 与明确拒绝原因；不要把计算性质描述成实验测量。
```

## 4. ARIS

Use one ARIS route, not the entire pipeline by default.

### Literature-only route

```text
/research-lit "parameter-efficient fine-tuning under domain shift"
— sources: arxiv, web
— date: 2022-01-01..today
— output: search log, deduplicated evidence matrix, unresolved full-text list
Do not create entries for papers that were not actually retrieved.
```

### Idea discovery

```text
/idea-discovery "calibration drift in retrieval-augmented generation"
Constraints: one 24 GB GPU, public datasets, 8-week pilot.
Require: baseline map, falsifiable hypotheses, cheapest discriminating experiment, stop criteria, and novelty-check plan.
Pause before implementation.
```

### Experiment bridge

```text
/experiment-bridge
Plan: ./plans/pilot.md
Repository: ./src
Before running: capture git revision, environment, dataset version, seed, baseline command, metric code, and output directory.
Run the smallest smoke test first; do not launch a long job until it passes.
```

### Single review loop

```text
/research-review "./paper/main.tex"
Audit contribution-evidence alignment, baseline fairness, leakage, statistical reporting, reproducibility, and citation support.
Every blocking finding needs a concrete locator and a test or edit that would resolve it.
```

## 5. Orchestra AI Research Skills

### `autoresearch`: bounded pilot

```text
Use autoresearch for a bounded pilot, not an open-ended autonomous run.
Question: Does [METHOD] improve [METRIC] over [BASELINE] on [DATASET] under [BUDGET]?
Set an inner-loop budget of 3 variants and an outer-loop gate after the first reproducible baseline.
Write every run to ./runs/<timestamp>/ with config, logs, metrics, and failure notes.
```

### Framework-specific fine-tuning

```text
Use the PEFT skill.
Design a QLoRA baseline for [MODEL] on [DATASET] with a 24 GB GPU.
Return a version-pinned environment, memory estimate, data schema checks, training config, evaluation plan, and OOM fallback ladder.
Do not start training until the configuration review passes.
```

### Evaluation

```text
Use the lm-eval-harness skill.
Add a reproducible evaluation for [MODEL CHECKPOINT] on [TASKS].
Pin harness and model revisions, record few-shot settings and chat template, save raw samples, and produce a manifest that distinguishes comparable from non-comparable runs.
```

### Inference engineering

```text
Use the vLLM skill.
Benchmark [MODEL] on [GPU] for latency, throughput, memory, and error rate at concurrency 1/8/32.
Define warm-up, prompt/output length distribution, quantization state, and exact server flags.
Save raw benchmark JSON and do not compare runs with different generation settings.
```

## 6. zLanqing academic skills

### `research-writing-skill`

```text
使用 research-writing-skill 修改 ./thesis/chapter3.md。
默认中文，保留公式、变量、方法名与引用键。
目标：每段一个论点，明确方法假设、实验条件与限制。
不得新增数据或 DOI；不确定内容标记“待核实”。输出修订稿和逐项修改说明。
```

### `office-academic-skill`

```text
使用 office-academic-skill，根据 ./notes/week12.md 和 ./figures/ 生成 10 页中文组会 PPTX。
结构：问题 → 本周假设 → 方法 → 关键结果 → 失败与原因 → 下周最小实验。
每页使用结论式标题；图表保留坐标、单位、图例和来源。
生成后导出逐页预览并检查文字溢出、遮挡与缺图。
```

### `scientific-toolkit-skill`

```text
使用 scientific-toolkit-skill 分析 ./data/sensor.csv。
先检查采样率、缺失、异常值、单位和时间戳；再提出滤波与频谱分析方案。
确认后生成可重复运行的 Python 脚本、参数表、CSV 结果和 300 dpi 图。
不要覆盖原始文件；在图注中区分测量值与处理后结果。
```

## 7. PaperSpine: `paper-spine`

### Confirm contribution before writing

```text
$paper-spine
目标：会议论文；草稿在 ./paper/，结果在 ./results/。
先做 intake，和我确认一个主贡献、最多两个次贡献，以及每个贡献的直接证据。
未确认前不要写全文。确认后生成 motivation chain、claim-evidence map 和章节单元大纲。
```

### Diagnose a weak narrative

```text
$paper-spine
审计 ./paper/main.tex 的“问题 → 缺口 → 方法 → 证据 → 影响”主线。
输出：断裂点、重复主张、无证据主张、放错章节的内容，以及 writing_rationale_matrix。
保留引用键，不补造文献。
```

### Prepare a revision matrix

```text
$paper-spine
材料：./paper/main.tex、./reviews/reviewer2.md、./results/。
建立审稿意见到 motivation、claim、evidence、section unit 的映射。
将动作分为 edit / analysis / experiment / cannot-address，并说明接受标准。
```

## 8. Nature Skills

Use the current upstream maturity label as a caution signal. Beta or Draft does not mean unusable; it means review the workflow and output more closely.

### `nature-figure`

```text
使用 nature-figure 将 ./results/metrics.csv 生成双栏投稿图。
要求：色盲友好、打印可辨、误差定义明确、单位完整、导出 SVG/PDF/PNG 和绘图脚本。
先给图形选择理由；不得用生成图代替真实数据图。
```

### `nature-polishing`

```text
使用 nature-polishing 润色 ./paper/abstract.md。
保持科学含义、数字、限制和引用键不变；输出 polished version、关键改动和可能改变含义的句子清单。
不要把相关性改写成因果。
```

### `nature-writing`

```text
使用 nature-writing 起草 Introduction。
输入只来自 ./evidence/matrix.csv 与 ./notes/contribution.md。
先给论证骨架；所有缺证据句子使用 [EVIDENCE NEEDED]，不得自动生成引用。
```

### `nature-reviewer`

```text
使用 nature-reviewer 预审 ./paper/main.pdf。
分别模拟方法、领域和统计三个审稿视角，再给编辑综合意见。
每条 major concern 必须有页码/图表定位和可验证的解决路径。
```

### `nature-citation`

```text
使用 nature-citation 为 ./paper/discussion.md 的已标记主张检索 Nature/CNS 系列支撑文献。
返回检索式、候选、排除原因和导出的 RIS；全文未核实时不要写“支持该主张”。
```

### `nature-data`

```text
使用 nature-data 为项目起草 Data Availability statement。
输入：数据类型、敏感性、许可证、仓储、访问流程、代码仓库。
同时给 FAIR 缺口清单；未知 accession 使用占位符，不得编造。
```

### `nature-statistics`

```text
使用 nature-statistics 审查 ./paper/statistics.md 与 ./results/analysis.R。
检查实验单位、重复、样本量、缺失、多重比较、效应量、置信区间和图注。
不要仅凭 p<0.05 判定研究结论成立。
```

### `nature-reader`

```text
使用 nature-reader 处理 ./papers/target.pdf。
生成中英对照 Markdown，保持章节、图表和来源锚点；无法解析的公式或图注标记为 unresolved，不猜测。
```

### `nature-paper-card`

```text
使用 nature-paper-card 精读 ./papers/target.pdf。
重点输出研究问题、方法逻辑、实验-结论证据链、结论边界、失败模式和可检验新想法。
每个判断附页码或图表定位。
```

### `nature-response`

```text
使用 nature-response 处理 ./revision/decision-letter.pdf 与 ./reviews/。
先生成逐点问题矩阵；只有实际完成的修改或实验才使用完成时态。
输出 response letter、cover letter 和稿件改动定位。
```

### `nature-paper2ppt`

```text
使用 nature-paper2ppt 将 ./papers/target.pdf 制作成 12 页中文 journal club PPTX。
每页一个结论，优先复用并标注原论文图；另加一页证据边界和一页批判性问题。
```

### `nature-paper-to-patent`

```text
使用 nature-paper-to-patent 从 ./disclosure/ 提炼中国发明专利技术交底书草稿。
先区分已公开、已有实验、建议实施例和待补数据；权利要求不得超出材料支持范围。
```

### `nature-ref-verifier`

```text
使用 nature-ref-verifier 校验 ./paper/references.bib。
逐字段核对作者、标题、年份、期刊、卷期、页码和 DOI；输出 verified / conflict / unresolved 与证据源。
不要自动修复冲突条目，先给差异表。
```

### `nature-academic-search`

```text
使用 nature-academic-search 检索 [TOPIC]。
要求多源去重、引用指标检索时间、严格区分自引与他引，并为每个保留条目提供稳定标识符。
搜索结果页只用于发现，最终元数据需二次核验。
```

### `nature-downloader`

```text
使用 nature-downloader 合法获取 ./lists/missing-doi.txt 中的全文。
优先开放获取与学校图书馆授权路径；遇到登录、权限、验证码或付费墙时停止并让我接管。
记录成功来源与失败原因。
```

### `nature-literature-pipeline`

```text
使用 nature-literature-pipeline 为 [TOPIC] 设计每周文献管线。
先 dry run：列出数据源、检索式、六维评分、去重、精读阈值、归档路径与通知内容。
未经确认不要创建定时任务或发送消息。
```

### `nature-experiment-log`

```text
使用 nature-experiment-log 将 ./inbox/ 的图片、语音转写和文字整理为 Obsidian 实验日志。
保留原文件，记录时间、样品、设备、参数、观察、偏差、文件哈希和待办；推断与原始观察分开。
```

### `nature-proposal-writer`

```text
使用 nature-proposal-writer 为“[TOPIC]”建立开题报告。
先完成 evidence ledger、论证图、章节契约、风险和验收标准；证据不足时停在 proposal 状态，不直接扩写正文。
```

## 9. paper-craft-skills

### `paper-comic`

```text
使用 paper-comic 为 ./papers/target.pdf 提出 3 个方法图方案。
先给信息结构、来源元素和生成元素清单，确认后再生成。
风格 paper-figure，英文；图中所有数字必须来自论文并给出页码/表格定位。
```

### `paper-deck`

```text
使用 paper-deck 将 ./papers/target.pdf 制作 12 页 16:9 学术汇报。
风格 journal-minimal；优先复用真实图表并标来源。
输出 PPTX、PDF、逐页提示词和一份“生成视觉/原始视觉”清单。
```

### `paper-analyzer`

```text
使用 paper-analyzer 分析 ./papers/target.pdf，风格 academic。
只有在核实为作者官方或明确关联的实现时才对照 GitHub 代码。
输出 HTML、公式解释、架构图、代码-论文映射、限制和未解决问题；不把博客解释当作论文结论。
```

## 10. Research-Paper-Writing-Skills

```text
Use $research-paper-writing to audit ./paper/introduction.md.
先列出本节功能、核心 claim、已有证据和缺口，再给最小重写；不要新增未核实文献或实验结果。
输出修改说明、claim-evidence 风险和仍需作者决定的事项。
```

适合 Abstract、Introduction、Method、Experiments、Conclusion 的段落逻辑和投稿前自查；不承担选题、检索或实验执行。

## 11. PaperJury Codex

```text
Use $paperjury to review ./paper/main.tex before submission.
重点检查 claim 是否过强、实验是否支撑、交叉引用和格式风险。
先产出带定位与证据的 issue ledger；安全文本修改只给最小补丁，缺实验或私有判断的项目交回作者。
未经我确认不要应用实质修改，也不要开启 auto 模式。
```

适合已有真实草稿后的预审闭环；不能替代同行评审，也不能补造实验或证据。
