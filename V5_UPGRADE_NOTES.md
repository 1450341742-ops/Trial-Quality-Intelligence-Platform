# V5 Upgrade Notes

本次升级新增 `app_v5.py`，继续保留 `app.py`、`app_v2.py`、`app_v3.py`、`app_v4.py`。

V5定位：商业化流程版。

V5不再只是单纯增加页面，而是开始围绕正式产品交付流程建设：客户、项目、AI解析、专家复核、核查专项清单、模板资产、用户权限。

## V5新增能力

### 1. 客户中心

新增客户/申办方档案表 `companies`。

支持维护：

- 客户/申办方名称
- 客户类型
- 联系人
- 联系电话/邮箱
- 状态

该模块为后续多租户、项目归属、报价体系、客户成功管理打基础。

### 2. 用户与权限管理

新增页面化用户管理能力。

支持：

- 新增用户
- 设置角色
- 设置初始密码
- 启用/停用账号

角色包括：

- 系统管理员
- 申办方QA负责人
- 项目经理PM
- 注册负责人
- 只读用户

### 3. AI结构化解析中心

V5新增 `ai_extractions` 表，用于保存AI解析结果。

支持解析类型：

- 方案结构化提取
- ICF版本链提取
- SAE报告链提取
- 中心文件夹缺口提取
- 稽查发现摘要

AI解析结果保存后，会自动进入专家复核队列。

### 4. 专家复核工作台

新增 `review_queue` 表。

支持将以下内容进入专家复核：

- AI解析结果
- 高风险问题
- 极高风险问题
- 关键证据缺口

支持复核状态：

- 待复核
- 已确认
- 需补充
- 已关闭
- 不适用

支持填写复核人和复核意见。

### 5. 核查专项清单

新增三类核查清单：

- CFDI注册核查准备清单
- FDA BIMO核查准备清单
- 中心文件夹完整性清单

支持导出Word。

### 6. 模板中心

新增 `template_center` 表。

内置模板资产：

- 项目质量风险分析报告
- 核查准备评估报告
- 中心风险画像报告
- CAPA审核意见表
- 申办方核查访谈问答

支持页面新增模板。

### 7. V5商业化驾驶舱

新增V5总览页面，展示：

- 客户数
- 项目数
- AI解析结果数量
- 待复核数量
- 模板资产数量
- 组合项目核查准备评分

## V5运行方式

```bash
pip install -r requirements.txt
streamlit run app_v5.py
```

默认账号：

```text
admin / admin123
qa / qa123
pm / pm123
```

## AI接口配置

在系统设置中启用AI接口，并配置环境变量：

```bash
OPENAI_API_KEY=your_key
OPENAI_BASE_URL=https://api.openai.com/v1
```

DeepSeek兼容方式：

```bash
OPENAI_API_KEY=your_deepseek_key
OPENAI_BASE_URL=https://api.deepseek.com
```

模型名称示例：

```text
gpt-4.1-mini
deepseek-chat
```

## V5推荐演示路径

1. 运行 `streamlit run app_v5.py`
2. 使用 `admin/admin123` 登录
3. 进入“客户中心”，新增一个申办方客户
4. 进入“项目管理”，创建项目
5. 进入“文件解析”，上传 `sample_data/sample_protocol.txt`
6. 如已配置AI接口，进入“AI结构化解析”，执行方案结构化提取并保存
7. 进入“问题清单”，上传 `sample_data/sample_findings.csv`
8. 进入“风险分析”，查看中心评分、受试者画像、热力图
9. 进入“专家复核”，将高风险问题加入复核队列并填写意见
10. 进入“核查专项清单”，导出CFDI/FDA清单
11. 进入“模板中心”，查看或新增模板资产
12. 进入“报告中心”，导出Word/PPT

## 当前版本文件结构

```text
app.py                 稳定MVP演示版
app_v2.py              登录权限+PDF解析+任务清单+问答+日志增强版
app_v3.py              高级页面+管理层驾驶舱+风险热力图+证据矩阵版
app_v4.py              商业化增强版：AI钩子+PPT+数据治理+中心评分+受试者画像
app_v5.py              商业化流程版：客户中心+用户管理+AI入库+专家复核+模板中心
requirements.txt       依赖文件
Dockerfile             Docker部署文件，默认仍运行app_v4.py，可按需改为app_v5.py
sample_data/           示例数据
V2_UPGRADE_NOTES.md    V2升级说明
V3_UPGRADE_NOTES.md    V3升级说明
V4_UPGRADE_NOTES.md    V4升级说明
V5_UPGRADE_NOTES.md    V5升级说明
```

## Docker运行V5

当前Dockerfile默认运行 `app_v4.py`。如需运行V5，可将Dockerfile最后一行改为：

```dockerfile
CMD ["streamlit", "run", "app_v5.py", "--server.port=8501", "--server.address=0.0.0.0"]
```

也可直接本地运行：

```bash
streamlit run app_v5.py
```

## V5当前限制

- 仍使用SQLite，适合演示、内部试用、小规模验证。
- 客户中心尚未与项目强绑定，后续需要给projects表增加company_id。
- AI解析结果已入库，但尚未自动映射为正式字段。
- 专家复核流程为基础状态流，尚未增加审批流和通知机制。
- 模板中心目前管理模板元数据，尚未上传真实模板文件。

## V6建议升级方向

1. PostgreSQL/Supabase正式数据库版本。
2. projects表增加company_id，实现客户-项目绑定。
3. 模板中心支持上传Word/PPT模板文件。
4. AI解析JSON字段映射入库。
5. 专家复核后自动生成整改任务。
6. 用户修改密码和权限细粒度配置。
7. ICF版本链自动比对。
8. SAE报告链自动核查。
9. 中心文件夹完整性自动评分。
10. EDC与原始记录一致性核查模块。
