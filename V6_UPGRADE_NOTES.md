# V6 Upgrade Notes

本次升级新增 `app_v6.py`，继续保留 V1-V5 历史版本。

V6定位：准生产骨架版。

V6重点不是单纯增加演示页面，而是把系统推进到更接近正式产品的流程架构：客户-项目绑定、AI字段映射、复核转任务、ICF版本链核查、SAE报告链核查、中心文件夹完整性评分和修改密码。

## V6新增能力

### 1. 客户-项目绑定

新增 `project_company_map` 表。

支持将项目绑定到客户/申办方，为后续多租户、客户成功、报价和项目归属打基础。

### 2. AI字段映射入库

新增 `mapped_fields` 表。

V5中AI解析结果只是保存为原始结果；V6可以将AI输出的JSON拆解为结构化字段。

字段包括：

- field_group
- field_name
- field_value
- source_name
- review_status

用途：

- 后续映射到正式报告模板
- 后续进入专家复核
- 后续生成稽查计划/核查问答/质量报告

### 3. 复核转任务

专家复核队列中的“待复核”和“需补充”事项，可以一键生成项目任务。

任务字段：

- task_name
- priority
- owner
- due_date
- status
- source

该功能用于形成质量闭环：

```text
AI识别/高风险问题 → 专家复核 → 生成任务 → 跟踪关闭
```

### 4. ICF版本链自动核查

新增 `icf_checks` 表。

支持上传CSV/XLSX，建议字段：

```text
中心编号
中心名称
ICF版本号
伦理批准日期
启用日期
受试者编号
签署日期
筛选检查日期
```

系统自动识别：

- 知情同意签署晚于筛选检查日期
- ICF启用日期早于伦理批准日期
- 受试者签署日期早于ICF启用日期
- ICF版本号缺失

### 5. SAE报告链自动核查

新增 `sae_checks` 表。

支持上传CSV/XLSX，建议字段：

```text
中心编号
中心名称
受试者编号
SAE事件
研究者获知日期
首次上报日期
随访状态
医学判断
```

系统自动识别：

- SAE首次上报是否超过24小时
- 获知日期或首次上报日期是否缺失
- SAE随访状态是否缺失
- 医学判断是否缺失

### 6. 中心文件夹完整性评分

新增 `center_file_scores` 表。

支持按中心和文件领域录入完整性状态。

内置文件领域：

- 伦理批件
- 方案及修正案
- ICF批准版本
- 研究者CV
- GCP证书
- 授权分工表
- 培训记录
- 实验室正常值
- 安全性文件
- 药品文件

状态与评分：

```text
完整：100
需复核：70
部分缺失：50
缺失：0
```

### 7. 修改密码

新增“修改密码”页面。

当前登录用户可输入原密码并设置新密码。

### 8. 专项核查报告导出

支持导出Word版专项核查报告，包含：

- ICF版本链核查
- SAE报告链核查
- 中心文件夹完整性评分

## 新增示例文件

```text
sample_data/sample_icf_chain.csv
sample_data/sample_sae_chain.csv
```

可用于测试ICF和SAE专项核查模块。

## 运行方式

```bash
pip install -r requirements.txt
streamlit run app_v6.py
```

默认账号：

```text
admin / admin123
qa / qa123
pm / pm123
```

## 推荐演示路径

1. 运行 `streamlit run app_v6.py`
2. 使用 `admin/admin123` 登录
3. 客户中心：新增客户
4. 项目管理：创建项目
5. 客户-项目绑定：绑定客户与项目
6. 文件解析：上传方案文本
7. AI结构化解析：生成AI解析结果
8. AI字段映射：将AI JSON拆解为结构化字段
9. 问题清单：上传 sample_findings.csv
10. 专家复核：高风险问题进入复核队列
11. 复核转任务：将待复核事项生成项目任务
12. ICF版本链核查：上传 sample_icf_chain.csv
13. SAE报告链核查：上传 sample_sae_chain.csv
14. 中心文件评分：录入中心文件夹完整性
15. 专项核查导出：导出Word报告
16. 报告中心：导出项目Word/PPT报告

## 当前版本文件结构

```text
app.py                 稳定MVP演示版
app_v2.py              登录权限+PDF解析+任务清单+问答+日志增强版
app_v3.py              高级页面+管理层驾驶舱+风险热力图+证据矩阵版
app_v4.py              商业化增强版：AI钩子+PPT+数据治理+中心评分+受试者画像
app_v5.py              商业化流程版：客户中心+用户管理+AI入库+专家复核+模板中心
app_v6.py              准生产骨架版：客户绑定+字段映射+ICF/SAE核查+中心文件评分
sample_data/sample_icf_chain.csv
sample_data/sample_sae_chain.csv
```

## V6当前限制

- 仍使用SQLite，适合演示、试点、小规模内部使用。
- 客户-项目绑定通过单独映射表实现，尚未改造projects主表。
- 模板中心仍以元数据为主，尚未实现真实模板文件上传和套版生成。
- ICF和SAE核查依赖结构化CSV/XLSX，尚未从原始PDF/Word自动抽取。
- 中心文件夹完整性为手工录入，尚未批量导入。

## V7建议升级方向

1. PostgreSQL/Supabase正式数据库适配。
2. 模板文件上传与真实套版导出。
3. ICF/SAE从原始文档中自动抽取。
4. 中心文件夹完整性Excel批量导入。
5. 专家复核流增加审批人、截止日期和消息提醒。
6. 任务状态流转和逾期提醒。
7. 客户级数据隔离。
8. 系统初始化脚本和数据库迁移脚本。
9. 自动化测试。
10. Streamlit Cloud入口配置切换为app_v6.py。
