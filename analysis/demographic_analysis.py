import matplotlib.pyplot as plt
import pandas as pd
import datetime

def calculateAverageSessionDuration(df: pd.DataFrame, session_no: str):
    df[f'S{session_no}_Duration'] = df[f'S{session_no}_End'].apply(lambda t: datetime.datetime.combine(datetime.datetime.today(), t)) - df[f'S{session_no}_Start'].apply(lambda t: datetime.datetime.combine(datetime.datetime.today(), t))
    s_average_duration = df[f'S{session_no}_Duration'].sum() / len(df[f'S{session_no}_Duration'])
    return s_average_duration


demographic_data = '/Users/emreoztas/Desktop/DUE/Biometrics and Public Displays/ParticipantsDemographicStats.xlsx'

a = datetime.time(10, 30)

df = pd.read_excel(demographic_data)

s1_average_duration = calculateAverageSessionDuration(df, '1')

s2_average_duration = calculateAverageSessionDuration(df, '2')

s3_average_duration = calculateAverageSessionDuration(df, '3')

print(f"Average S1 Duration: {s1_average_duration}\nAverage S2 Duration: {s2_average_duration}\nAverage S3 Duration: {s3_average_duration}\n")

print(f"Average age is: {df['Age'].sum()/len(df['Age'])}\nMax age: {df['Age'].max()}\nMin age: {df['Age'].min()}\n")

print(f"Number of females: {len(df[(df['Gender'] == 0)])}\nNumber of males: {len(df[(df['Gender'] == 1)])}\n")

print(f"Right handed people: {len(df[(df['Dominant_Hand'] == 1)])}\nLeft handed people: {len(df[(df['Dominant_Hand'] == 0)])}")

