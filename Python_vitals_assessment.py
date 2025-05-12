import pandas as pd
import numpy as np
import os

base_path = r"path"
input_path = os.path.join(base_path, "Challenge2.csv")
output_path = os.path.join(base_path, "Challenge2_with_vitals.csv")

df = pd.read_csv(input_path, sep=';')
df["post_admission_hours"] = df["post_admission_hours"].astype(int)

vital_params = [
    "heart_rate",
    "respiratory_rate",
    "temperature",
    "systolic_BP",
    "diastolic_BP",
    "mean_AP",
    "SpO2"
]

for param in vital_params:
    print(f"Обработка параметра: {param}")

    temp_df = df[["new_hosp_id", "post_admission_hours", param]].copy()
    temp_df = temp_df.dropna(subset=[param])

    hours_df = temp_df.copy()
    hours_df['hour_shift'] = 0

    prev_hour = temp_df.copy()
    prev_hour['post_admission_hours'] += 1
    prev_hour['hour_shift'] = -1

    prev_prev_hour = temp_df.copy()
    prev_prev_hour['post_admission_hours'] += 2
    prev_prev_hour['hour_shift'] = -2

    expanded_df = pd.concat([hours_df, prev_hour, prev_prev_hour])

    valid_hours = temp_df[['new_hosp_id', 'post_admission_hours']].drop_duplicates()
    expanded_df = pd.merge(
        expanded_df,
        valid_hours,
        on=['new_hosp_id', 'post_admission_hours'],
        how='right'
    )

    stats_df = expanded_df.groupby(['new_hosp_id', 'post_admission_hours']).agg(
        **{
            f'avg_3h_{param}': (param, 'mean'),
            f'min_3h_{param}': (param, 'min'),
            f'max_3h_{param}': (param, 'max'),
            f'sd_3h_{param}': (param, 'std')
        }
    ).reset_index()

    current_avg = temp_df.groupby(['new_hosp_id', 'post_admission_hours']).agg(
        **{f'current_avg_{param}': (param, 'mean')}
    ).reset_index()

    two_hours_ago = temp_df.copy()
    two_hours_ago['post_admission_hours'] += 2
    two_hours_ago_avg = two_hours_ago.groupby(['new_hosp_id', 'post_admission_hours']).agg(
        **{f'two_hours_ago_avg_{param}': (param, 'mean')}
    ).reset_index()

    delta_df = pd.merge(
        current_avg,
        two_hours_ago_avg,
        on=['new_hosp_id', 'post_admission_hours'],
        how='left'
    )
    delta_df[f'delta_3h_{param}'] = delta_df[f'current_avg_{param}'] - delta_df[f'two_hours_ago_avg_{param}']
    delta_df = delta_df[['new_hosp_id', 'post_admission_hours', f'delta_3h_{param}']]

    features_df = pd.merge(stats_df, delta_df, on=['new_hosp_id', 'post_admission_hours'], how='left')

    df = pd.merge(df, features_df, on=['new_hosp_id', 'post_admission_hours'], how='left')

df.to_csv(output_path, sep=';', index=False)
print("Обработка завершена. Результат сохранен в:", output_path)
