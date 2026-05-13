# Trial Quality Intelligence Platform

面向临床试验申办方的质量风险与核查准备智能平台 MVP。

本版本定位为可快速演示和客户试用的 Streamlit 原型，聚焦申办方高预算痛点：方案风险解析、稽查问题清单结构化、中心风险评分、CAPA 智能审核、核查准备评分和项目质量报告导出。

## 核心能力

- 项目管理：维护项目、申办方、方案编号、适应症、阶段、中心数量等基础信息。
- 文件上传：支持上传方案、稽查报告、问题清单、CAPA 表等资料。
- 方案风险解析：从方案文本中识别入排、AE/SAE、访视窗口、禁用药、随机化、盲态、终点等风险关键词。
- 问题清单解析：支持 CSV/XLSX 上传，自动识别问题分类、严重程度、中心、CAPA 状态。
- 中心风险评分：按严重问题、主要问题、受试者安全、数据完整性、主要终点、ICF、AE/SAE、CAPA 逾期等维度打分。
- CAPA 审核：识别“加强培训”“加强管理”“已整改”等低质量 CAPA 表述，并给出补充证据建议。
- 核查准备评分：自动生成 Inspection Readiness Score 和核查前补救清单。
- 报告导出：一键导出 Word 版《项目质量风险与核查准备评估报告》。

## 快速运行

```bash
pip install -r requirements.txt
streamlit run app.py
```

首次运行会自动创建本地 SQLite 数据库：`trial_quality.db`。

## 默认账号

当前 MVP 为本地演示版，未启用真实账号密码校验。正式商业版建议升级为：

- 多租户企业隔离
- 用户角色权限
- 操作日志审计
- 文件加密存储
- 私有化部署

## 示例数据

仓库内提供示例文件：

- `sample_data/sample_findings.csv`：中心稽查问题清单示例

可在系统的“问题清单解析”页面上传测试。

## 推荐部署方式

### Streamlit Cloud

1. 将仓库连接到 Streamlit Cloud。
2. 设置入口文件为 `app.py`。
3. Python 版本建议 3.10 或以上。
4. 安装依赖使用 `requirements.txt`。

### 本地部署

```bash
python -m venv .venv
source .venv/bin/activate  # Windows 使用 .venv\Scripts\activate
pip install -r requirements.txt
streamlit run app.py
```

## 后续开发路线

第一阶段：MVP 验证版

- 完成项目、中心、文件、问题、CAPA、评分、报告闭环。
- 支持客户演示和试点。

第二阶段：商业化增强版

- 增加真实登录权限。
- 增加 AI 模型接口。
- 增加 Word/PDF/PPT 深度解析。
- 增加模板化报告生成。
- 增加专家复核工作流。

第三阶段：企业版

- 多租户隔离。
- 审计追踪。
- 私有化部署。
- EDC/CTMS/eTMF 接口。
- FDA/CFDI 核查专项知识库。

## 产品定位

不是普通 AI 文档生成器，而是：

> 面向申办方注册核查和项目质量管理的临床试验质量风险智能平台。

核心价值：

> 让申办方在核查前看见风险，在申报前完成补救。
