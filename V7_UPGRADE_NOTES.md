# V7 Upgrade Notes

本次升级新增 `app_v7.py`，继续保留 V1-V6 历史版本。

V7定位：试点生产增强版。

V7的目标是让系统更接近客户试点和内部上线前状态，重点补齐数据库迁移准备、客户级项目视图、模板文件上传、中心文件批量导入、任务逾期提醒、复核SLA、交付包管理、上线检查清单和基础自动化测试。

## V7新增能力

### 1. 数据库迁移中心

新增“数据库迁移中心”页面。

用于展示：

- 当前数据库模式
- DATABASE_URL是否配置
- TQIP_DB_PATH路径
- SQLite/ PostgreSQL迁移建议

V7已新增 PostgreSQL 初始建表草案：

```text
migrations/001_initial_schema.sql
```

说明：当前应用主连接仍沿用SQLite，以保证历史版本稳定。下一步可重构 `db_adapter.py`，用SQLAlchemy统一适配SQLite/PostgreSQL。

### 2. 客户级项目视图

新增“客户级项目视图”。

基于客户-项目绑定关系，按客户展示：

- 已绑定项目
- 项目阶段
- 项目状态
- 预计核查日期
- 客户整体核查准备评分
- 客户级问题总数
- 客户级高风险问题

该页面面向客户成功、销售续费、项目组合交付管理。

### 3. 模板文件上传

新增真实模板文件上传入口。

支持上传：

- docx
- pptx
- xlsx
- md
- txt

新增目录：

```text
template_uploads/
```

新增表：

```text
template_files
template_upload_audit
```

用途：为后续Word/PPT模板锁定、套版导出、版本管理打基础。

### 4. 中心文件夹批量导入

新增“中心文件批量导入”页面。

支持CSV/XLSX字段：

```text
中心编号
中心名称
文件领域
状态
备注
```

状态评分规则：

```text
完整：100
需复核：70
部分缺失：50
缺失：0
```

新增示例文件：

```text
sample_data/sample_center_file_scores.csv
```

### 5. 任务逾期与状态中心

新增“任务逾期中心”。

支持：

- 查看任务总数
- 查看逾期任务
- 查看已完成任务数
- 更新任务状态

任务状态包括：

```text
未开始
进行中
需协助
已完成
暂缓
取消
```

### 6. 复核SLA中心

新增“复核SLA中心”。

用于查看专家复核积压，包括：

- 复核总数
- 待处理数量
- 等待天数
- 超过3天未处理事项

### 7. 交付包生成

新增“交付包生成”页面。

支持登记交付包元数据：

- 交付包名称
- 交付包类型
- 包含文件/材料清单
- 创建人
- 创建时间

新增表：

```text
export_packs
```

### 8. 上线检查清单

新增“上线检查清单”页面。

内置上线前验收项：

- 账号权限
- 数据库
- 文件存储
- AI配置
- 样例数据隔离
- 报告导出
- 任务闭环
- 日志审计
- 备份
- 隐私

支持导出Word。

### 9. 基础自动化测试

新增：

```text
tests/test_scoring.py
```

新增pytest依赖。

测试内容：

- 空数据核查准备评分
- 中心核查准备评分
- 受试者风险画像

运行测试：

```bash
pytest
```

## V7运行方式

```bash
pip install -r requirements.txt
streamlit run app_v7.py
```

默认账号：

```text
admin / admin123
qa / qa123
pm / pm123
```

## V7推荐演示路径

1. 运行 `streamlit run app_v7.py`
2. 使用 `admin/admin123` 登录
3. 客户中心：新增客户
4. 项目管理：创建项目
5. 客户-项目绑定：绑定客户与项目
6. 客户级项目视图：查看客户项目组合
7. 文件解析：上传方案文本
8. 问题清单：上传 `sample_data/sample_findings.csv`
9. 风险分析：查看中心评分、受试者画像和热力图
10. 中心文件批量导入：上传 `sample_data/sample_center_file_scores.csv`
11. 专家复核：高风险问题进入复核队列
12. 复核SLA中心：查看复核积压
13. 复核转任务：生成任务
14. 任务逾期中心：更新任务状态
15. 模板中心：新增模板元数据
16. 模板文件上传：上传Word/PPT模板文件
17. 交付包生成：登记客户交付包
18. 上线检查清单：导出Word检查清单

## 当前版本文件结构

```text
app.py                 稳定MVP演示版
app_v2.py              登录权限+PDF解析+任务清单+问答+日志增强版
app_v3.py              高级页面+管理层驾驶舱+风险热力图+证据矩阵版
app_v4.py              商业化增强版：AI钩子+PPT+数据治理+中心评分+受试者画像
app_v5.py              商业化流程版：客户中心+用户管理+AI入库+专家复核+模板中心
app_v6.py              准生产骨架版：客户绑定+字段映射+ICF/SAE核查+中心文件评分
app_v7.py              试点生产增强版：DB迁移+客户视图+模板上传+逾期提醒+测试
migrations/001_initial_schema.sql
sample_data/sample_center_file_scores.csv
tests/test_scoring.py
```

## V7当前限制

- PostgreSQL迁移SQL已提供，但主程序仍默认SQLite。
- 模板文件已能上传登记，但尚未实现真实套版替换。
- 交付包为元数据登记，尚未自动打包ZIP。
- 任务逾期提醒为页面展示，尚未接邮件/钉钉通知。
- 自动化测试仅覆盖核心评分函数，尚未覆盖UI和数据库写入。

## V8建议升级方向

1. 增加db_adapter.py，真正支持SQLite/PostgreSQL切换。
2. 交付包自动生成ZIP。
3. 模板套版导出，根据上传模板替换占位符。
4. 钉钉/邮件任务逾期提醒。
5. 中心文件夹完整性批量导入去重。
6. 项目、客户、任务、复核队列的编辑/删除权限控制。
7. 更完整的pytest数据库测试。
8. GitHub Actions自动测试。
9. Streamlit Cloud入口切换配置。
10. Docker默认入口切换为app_v7.py。
