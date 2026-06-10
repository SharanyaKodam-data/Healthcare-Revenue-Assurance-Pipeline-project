# Enterprise Healthcare Revenue Assurance & Patient Attrition Framework

##  WHAT: Business Problem & Value Realization
This framework targets a critical operational bottleneck in healthcare provider networks: Patient Attrition and Clinical Capacity Waste. When chronic disease patients disrupt their care timelines, it causes unpredictable revenue drops and operational waste. This framework quantifies the damage by converting clinical anomalies into actionable financial metrics: Annualized Revenue Leakage and Resource Opportunity Cost.

##  HOW: Headless Technical Architecture
Built entirely as a headless data pipeline using core engineering tools to eliminate front-end software dependencies and ensure complete auditability:
- **SQL Layer (Data Engineering):** Relational schema architecture utilizing multi-layered Common Table Expressions (CTEs) and Window Functions (`AVG`/`MAX` over partitions) to audit historical transaction timelines.
- **Python Layer (Data Infrastructure):** Vectorized pipeline logic using `pd.merge` and `np.select` to execute a memory-efficient primary key left-join, handle text anomalies, and build rule-based cohort groups from real-world metrics.

## WHERE: Geographic & Spatial Intelligence
Locates the hyper-local operational clusters of attrition to guide physical business expansion:
- **Territorial Loss Auditing:** Pulls real-world regional indices to isolate exactly which states are experiencing the highest financial exposure.
- **Access Radius Auditing:** Maps continuous travel parameters into discrete distance tiers (`Local`, `Commuter`, `Remote`) to analyze how geographic barriers limit patient touchpoints.

##  WHY: Root-Cause Diagnostics & Insights
Rather than relying on manual visual tools like tableau,we built the analytical framework that programmatically isolates the exact friction points driving drop-outs directly into system reporting logs:
1. **Financial Friction:** Quantifies the correlation between out-of-pocket costs and active attrition rates.
2. **Operational Friction:** Maps physical distance barriers against missed appointments to pinpoint the exact operational adjustments required to stabilize patient accounts.

---

###  Repository File Mapping
```text
├── sql_warehouse/
│   └── cohort_extraction.sql     <-- PostgreSQL analytical window query
├── python_core/
│   └── pipeline_transform.py     <-- Pandas & NumPy relational merge script
└── README.md                     <-- Master framework documentation
```

> **Security & Compliance Note:** In accordance with standard healthcare data privacy protocols, raw source tables and generated CSV data outputs are excluded from this public repository.
