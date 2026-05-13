import pandas as pd

import app_v4 as core


def test_inspection_score_empty():
    score, gaps = core.inspection_score(pd.DataFrame())
    assert score == 70
    assert gaps


def test_site_readiness_basic():
    df = pd.DataFrame([
        {"site_no": "001", "site_name": "A", "severity": "严重问题", "risk_level": "高风险", "capa_status": "未关闭", "category": "知情同意", "evidence_gap": "需准备", "risk_score": 20},
        {"site_no": "002", "site_name": "B", "severity": "一般问题", "risk_level": "低风险", "capa_status": "已关闭", "category": "研究者文件夹", "evidence_gap": "完整", "risk_score": 2},
    ])
    result = core.site_readiness(df)
    assert not result.empty
    assert "中心核查准备评分" in result.columns
    assert result.iloc[0]["中心核查准备评分"] <= 100


def test_subject_profile_basic():
    df = pd.DataFrame([
        {"subject_no": "S001", "site_name": "A", "risk_score": 15, "risk_level": "高风险", "category": "AE/SAE"},
        {"subject_no": "S001", "site_name": "A", "risk_score": 10, "risk_level": "中风险", "category": "数据完整性"},
    ])
    result = core.subject_profile(df)
    assert not result.empty
    assert result.iloc[0]["风险分"] == 25
