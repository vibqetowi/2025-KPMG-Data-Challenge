from sklearn.ensemble import IsolationForest
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

csv_path = r"C:\Users\carte\OneDrive\Documents\Coding Projects\2025-KPMG-Data-Challenge\csv-dump\KPMG Case Data_TIME.csv"
df_time = pd.read_csv(csv_path, encoding="latin-1")

# Select relevant columns for anomaly detection
df_anomaly = df_time[['Hours', 'Charge-Out Rate', 'Std. Price']].dropna()

# Fit Isolation Forest model
iso_forest = IsolationForest(contamination=0.05, random_state=42)  # 5% anomalies
df_anomaly['Anomaly'] = iso_forest.fit_predict(df_anomaly)

# Plot results
plt.figure(figsize=(10, 6))
sns.scatterplot(data=df_anomaly, x='Hours', y='Charge-Out Rate', hue='Anomaly', palette={1: "blue", -1: "red"})
plt.title("Anomaly Detection in Work Hours vs. Charge-Out Rate")
plt.xlabel("Hours Logged")
plt.ylabel("Charge-Out Rate")
plt.legend(title="Anomaly", labels=["Normal", "Anomalous"])
plt.show()

# Count anomalies
df_anomaly['Anomaly'].value_counts()