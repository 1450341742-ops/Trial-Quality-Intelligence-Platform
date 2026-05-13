# V4 Upgrade Notes

本次升级新增 `app_v4.py`，继续保留 `app.py`、`app_v2.py`、`app_v3.py`，不破坏历史版本。

V4定位：商业化增强版。

## V4新增能力

### 1. AI接口真实调用钩子

V4新增 `call_ai()` 方法，支持通过 OpenAI SDK 调用兼容接口。

可支持：

- OpenAI
- Azure OpenAI兼容配置
- DeepSeek兼容OpenAI接口
- 其他OpenAI-compatible模型服务

环境变量：

```bash
OPENAI_API_KEY=your_key
OPENAI_BASE_URL=https://api.openai.com/v1
```

DeepSeek等兼容接口可设置：

```bash
OPENAI_API_KEY=your_deepseek_key
OPENAI_BASE_URL=https://api.deepseek.com
```

系统设置页面中需要启用AI接口，并填写模型名称，例如：

```text
gpt-4.1-mini
deepseek-chat
qwen-plus
```

当前AI主要用于“方案深度结构化解析”入口。

### 2. 重复导入保护

问题清单导入时，会根据以下字段生成 fingerprint：

- 项目ID
- 中心编号
- 受试者编号
- 问题分类
- 问题描述前120字

重复导入时自动跳过，避免同一问题反复入库导致评分失真。

### 3. 中心级核查准备评分

新增 `site_readiness()`，可以按中心计算 Inspection Readiness Score。

输出字段：

- 中心编号
- 中心名称
- 中心核查准备评分
- 问题数量
- 高风险问题
- 未关闭CAPA
- 主要缺口

### 4. 受试者风险画像

新增 `subject_profile()`，按受试者聚合问题。

输出字段：

- 受试者编号
- 涉及中心
- 问题数量
- 风险分
- 高风险问题
- 涉及领域

适合识别：

- 主要终点受试者
- SAE相关受试者
- 多问题受试者
- 数据不可溯源风险受试者

### 5. PPT管理层汇报导出

新增 `python-pptx` 依赖。

报告中心支持导出：

- Word综合报告
- PPT管理层汇报

PPT包括：

- 封面
- 管理层结论
- 中心核查准备评分
- 高风险问题摘要

### 6. 数据治理页面

新增“数据治理”模块，支持：

- 查看当前项目问题数据
- 删除指定问题
- 清空当前项目任务
- 支持演示数据维护

### 7. 项目状态维护

项目管理页面增加项目状态更新。

支持状态：

- 进行中
- 核查准备中
- 已完成
- 暂停
- 归档

### 8. Docker部署

新增：

- Dockerfile
- docker-compose.yml
- .dockerignore

## V4运行方式

### 本地运行

```bash
pip install -r requirements.txt
streamlit run app_v4.py
```

### Docker运行

```bash
docker compose up --build
```

访问：

```text
http://localhost:8501
```

默认账号：

```text
admin / admin123
qa / qa123
pm / pm123
```

## V4推荐演示路径

1. 运行 `streamlit run app_v4.py`
2. 使用 `admin/admin123` 登录
3. 进入“项目管理”创建项目
4. 进入“文件解析”上传 `sample_data/sample_protocol.txt`
5. 可在系统设置启用AI接口后，点击“尝试AI深度结构化解析”
6. 进入“问题清单”上传 `sample_data/sample_findings.csv`
7. 重复上传一次，验证重复导入保护
8. 进入“风险分析”查看中心级核查准备评分
9. 查看受试者画像
10. 查看风险热力图
11. 进入“CAPA中心”审核CAPA质量
12. 进入“任务中心”生成核查前任务
13. 进入“报告中心”导出Word和PPT
14. 进入“数据治理”删除演示问题或清空任务

## 当前版本文件结构

```text
app.py                 稳定MVP演示版
app_v2.py              登录权限+PDF解析+任务清单+问答+日志增强版
app_v3.py              高级页面+管理层驾驶舱+风险热力图+证据矩阵版
app_v4.py              商业化增强版：AI钩子+PPT+数据治理+中心评分+受试者画像
requirements.txt       依赖文件
Dockerfile             Docker部署文件
docker-compose.yml     Docker Compose部署文件
sample_data/           示例数据
V2_UPGRADE_NOTES.md    V2升级说明
V3_UPGRADE_NOTES.md    V3升级说明
V4_UPGRADE_NOTES.md    V4升级说明
```

## V4当前限制

- SQLite仍适合演示和小规模试用，不建议直接作为多客户生产数据库。
- AI接口仅在方案解析入口做初步调用，尚未全面融入所有模块。
- PPT为通用汇报模板，尚未做公司品牌模板锁定。
- 扫描PDF仍未接OCR。
- 用户管理暂不支持页面新增用户和修改密码。

## V5建议升级方向

1. Supabase/PostgreSQL正式数据库版本。
2. 多租户客户隔离。
3. 页面新增用户、修改密码、权限配置。
4. AI结构化结果入库。
5. Word/PPT模板锁定导出。
6. 扫描PDF OCR。
7. 中心文件夹完整性核查。
8. ICF版本链自动比对。
9. SAE报告链自动核查。
10. EDC/原始记录一致性核查。
