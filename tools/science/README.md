# Science Tools

这个目录包含面向学术工作流的技能与脚本。当前核心能力是 `paper-review-revision`，用于根据审稿意见安全、可控地修改论文全文。

## Paper Review Revision Skill

### 项目目的

在“返修论文”场景下，把审稿意见转化为可执行修改，并输出一份可直接替换原稿的 `clean` 全文版本。

### 核心作用

- 输入支持两种审稿格式：
  - 原始审稿意见（Reviewer 1/2/3 原文）
  - 作者整理后的结构化问题清单
- 先“评估”再“改稿”，不盲从审稿意见（Review Skeptic）
- 默认执行“最小必要改动”，避免无关扩写和结构漂移
- 仅 `accept` 自动执行；`partial-accept/defer/needs-author-confirmation` 必须作者确认
- 当中等改写不足时，先给“激进改写提案”，经作者批准后才执行
- 全文回归检查：术语一致、论证链一致、摘要-正文-结论一致
- 安全约束：禁止虚构数据、实验或引用

### 适用场景

- 期刊返修（major/minor revision）
- 多审稿人意见冲突整合
- 需要快速产出“可替换原稿”的 clean 版本

### 技能文件位置

- `skills/paper-review-revision/SKILL.md`
- `skills/paper-review-revision/references/decision-rules.md`
- `skills/paper-review-revision/references/workflow-checklist.md`

### 快速使用示例

```text
请使用 paper-review-revision skill。

输入：
1) 论文全文
2) 审稿意见（原始评论或结构化问题清单）

要求：
- 默认最小必要改动
- 非 accept 项先给我确认
- 如需激进改写，先输出提案

输出：
- 一份 clean 的全文修订稿
```

## 相关模块（进行中）

`notebooklm-ingest`：用于种子论文参考文献抓取、全文获取和 NotebookLM 上传包构建的实验模块。
