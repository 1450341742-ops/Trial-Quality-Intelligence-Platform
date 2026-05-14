# V8 Upgrade Notes

本次升级新增 `app_v8.py` 和 `db_adapter.py`，并将 Docker 默认入口切换为 `app_v8.py`。

V8定位：工程化增强版。

V8的重点是让系统更接近工程化交付：数据库适配层、GitHub Actions自动测试、模板占位符套版、交付包ZIP、提醒配置占位、质量门禁和Docker入口升级。

## V8新增能力

### 1. 数据库适配层 db_adapter.py

新增：

```text
db_adapter.py
```

能力：

- 自动识别 `DATABASE_URL`
- 支持SQLite默认模式
- 预留PostgreSQL连接能力
- 提供 `query_df()` / `execute()` / `healthcheck()`
- 数据库健康检查可在V8驾驶舱中查看

说明：历史版本仍沿用 `app_v4.py` 中的SQLite函数，避免破坏现有功能。后续模块可逐步迁移到 `db_adapter.py`。

### 2. 模板占位符套版

新增“模板占位符套版”页面。

支持对已上传的 `docx` / `pptx` 模板进行基础占位符替换。

当前支持占位符：

```text
{{project_name}}
{{sponsor_name}}
{{protocol_no}}
{{indication}}
{{phase}}
{{readiness_score}}
{{generated_at}}
{{high_risk_count}}
{{open_capa_count}}
```

新增示例说明：

```text
sample_data/template_placeholder_example.md
```

### 3. 交付包ZIP生成

新增“交付包ZIP”页面。

支持将已生成的套版文件打包为ZIP，并生成 `manifest.json`。

用途：

- 客户交付
- 内部归档
- 核查准备材料包
- 项目质量复盘包

### 4. 提醒配置占位

新增“提醒配置”页面。

支持配置：

- DingTalk
- Email
- Webhook
- 企业微信

当前仅保存配置，不实际发送。V9可接入真实钉钉机器人、SMTP或企业微信Webhook。

### 5. 工程化中心

新增“工程化中心”页面。

展示：

- 安装命令
- 测试命令
- Docker启动命令
- 关键环境变量
- 质量门禁检查

### 6. 质量门禁

新增质量门禁检查：

- 数据库连接
- AI Key环境变量
- 模板上传目录
- 输出目录
- 默认账号提醒

### 7. GitHub Actions自动测试

新增：

```text
.github/workflows/tests.yml
```

每次push或pull request到main时自动运行：

```bash
pytest -q
```

### 8. Docker默认入口切换

Dockerfile 默认入口已从：

```text
app_v4.py
```

切换为：

```text
app_v8.py
```

并新增环境变量：

```text
TQIP_DB_PATH=/app/data/trial_quality_v8.db
TQIP_UPLOAD_DIR=/app/uploads
TQIP_TEMPLATE_DIR=/app/template_uploads
TQIP_RENDERED_DIR=/app/rendered_outputs
```

### 9. 新增依赖

新增：

```text
SQLAlchemy
psycopg2-binary
```

用于后续PostgreSQL适配。

## V8运行方式

### 本地运行

```bash
pip install -r requirements.txt
streamlit run app_v8.py
```

### Docker运行

```bash
docker compose up --build
```

访问：

```text
http://localhost:8501
```

### 自动测试

```bash
pytest
```

## V8推荐演示路径

1. 运行 `streamlit run app_v8.py`
2. 使用 `admin/admin123` 登录
3. 进入“V8工程化驾驶舱”，查看DB健康和质量门禁
4. 客户中心：新增客户
5. 项目管理：创建项目
6. 客户-项目绑定：绑定客户与项目
7. 文件解析：上传方案文本
8. 问题清单：上传 `sample_data/sample_findings.csv`
9. 模板中心：新增模板元数据
10. 模板文件上传：上传包含占位符的docx/pptx模板
11. 模板占位符套版：生成套版文件
12. 交付包ZIP：打包套版文件和manifest.json
13. 提醒配置：保存钉钉/邮件/Webhook配置
14. 工程化中心：查看部署命令和质量门禁

## 当前版本文件结构

```text
app.py                 稳定MVP演示版
app_v2.py              登录权限+PDF解析+任务清单+问答+日志增强版
app_v3.py              高级页面+管理层驾驶舱+风险热力图+证据矩阵版
app_v4.py              商业化增强版
app_v5.py              商业化流程版
app_v6.py              准生产骨架版
app_v7.py              试点生产增强版
app_v8.py              工程化增强版
db_adapter.py          数据库适配层
migrations/001_initial_schema.sql
.github/workflows/tests.yml
sample_data/template_placeholder_example.md
```

## V8当前限制

- db_adapter已建立，但历史功能尚未全面迁移到该适配层。
- PostgreSQL连接能力已预留，但生产级数据迁移仍需继续开发。
- 模板套版目前只做基础文本占位符替换，不处理复杂表格循环和图片替换。
- 提醒配置仅保存，不实际发送。
- ZIP交付包只打包已生成套版文件，未自动生成所有报告。

## V9建议升级方向

1. 将核心CRUD逐步迁移到db_adapter.py。
2. 实现真实钉钉/邮件/Webhook提醒发送。
3. 模板套版支持表格循环、图片替换和条件段落。
4. 交付包ZIP自动生成Word/PPT/CSV全套材料。
5. 增加Streamlit Cloud配置文件，默认入口app_v8.py。
6. 增加更完整数据库测试和迁移测试。
7. 增加客户级数据隔离过滤器。
8. 增加一键初始化演示数据。
9. 增加系统管理员安全检查，强制修改默认密码。
10. 增加API服务层，为后续前后端分离做准备。
