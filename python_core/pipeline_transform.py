import pandas as pd
import numpy as np

# 1. Ingesting clean SQL output view dataset
sql_df = pd.read_csv("sql_patient_output_dataset.csv")
sql_df.columns = sql_df.columns.str.strip().str.lower()

# 2. Ingesting raw data file to fetch authentic geographic and visit parameters
raw_df = pd.read_csv("patient_churn_dataset.csv")
raw_df.columns = raw_df.columns.str.strip().str.lower()

# Isolation of columns required for quadrant feature integration
raw_metrics = raw_df[['patientid', 'distance_to_facility_miles', 'missed_appointments']]

# 3. Executing data enrichment by using relational primary key join operations
enriched_df = pd.merge(sql_df, raw_metrics, on='patientid', how='left')

# 4. Transforming continuous spatial distances into structured access tiers
distance_conditions = [
    (enriched_df['distance_to_facility_miles'] <= 10),
    (enriched_df['distance_to_facility_miles'] > 10) & (enriched_df['distance_to_facility_miles'] <= 30),
    (enriched_df['distance_to_facility_miles'] > 30)
]
distance_labels = ['Local Radius (0-10 mi)', 'Regional Commuter (10-30 mi)', 'Remote High-Risk (30+ mi)']
enriched_df['geographic_access_tier'] = np.select(distance_conditions, distance_labels, default='Unknown Access')

# 5. Quantifying financial capacity losses based on raw appointment attendance patterns
enriched_df['wasted_slot_cost_inr'] = enriched_df['missed_appointments'] * 2500.00

# 6. Dropping raw numeric indices to keep the final reporting schema clean
final_reporting_df = enriched_df.drop(columns=['distance_to_facility_miles', 'missed_appointments'])

# 7. Exporting unified 7-column data file 
final_reporting_df.to_csv("final_attrition_reporting_data.csv", index=False)
print("SUCCESS: 'final_attrition_reporting_data.csv' has been generated successfully!")
