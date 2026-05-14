# 模板占位符示例

在Word或PPT模板中可以放入以下占位符，V8会进行基础替换：

- {{project_name}}：项目名称
- {{sponsor_name}}：申办方名称
- {{protocol_no}}：方案编号
- {{indication}}：适应症
- {{phase}}：研究阶段
- {{readiness_score}}：核查准备评分
- {{generated_at}}：生成时间
- {{high_risk_count}}：高风险问题数量
- {{open_capa_count}}：未关闭CAPA数量

示例标题：

{{project_name}} 质量风险与核查准备评估报告

示例正文：

本报告适用于 {{sponsor_name}} 的 {{project_name}} 项目，方案编号为 {{protocol_no}}，当前核查准备评分为 {{readiness_score}} 分。

生成时间：{{generated_at}}
