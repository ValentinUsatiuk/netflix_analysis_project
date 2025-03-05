import pandas as pd

# Завантажуємо файл
file_path = "D:/проекти скл/нетфлікс проект/netflix_titles.csv"  # Шлях до файлу
df = pd.read_csv(file_path)

# 🔹 Очищаємо текстові поля
# 1. Видаляємо зайві пробіли, лапки, символи переведення рядків
df = df.applymap(lambda x: str(x).strip().replace('"', '').replace("\n", " ") if pd.notnull(x) else x)

# 2. Обрізаємо довгі значення до адекватних розмірів
column_limits = {
    "show_id": 20,
    "type": 20,
    "title": 255,
    "director": 255,
    "cast": 500,
    "country": 100,
    "date_added": 50,
    "release_year": 10,
    "rating": 20,
    "duration": 50,
    "listed_in": 255,
    "description": 1000
}

for col, limit in column_limits.items():
    if col in df.columns:
        df[col] = df[col].astype(str).str[:limit]  # Обрізаємо текст

# 🔹 Видаляємо можливі дублікатні записи
df.drop_duplicates(inplace=True)

# 🔹 Видаляємо рядки, без назви
df.dropna(subset=["title"], inplace=True)

# 🔹 Переконуємося, що дата у правильному форматі
df["date_added"] = pd.to_datetime(df["date_added"], errors="coerce").dt.strftime("%Y-%m-%d")

# 🔹 Замінюємо NaN на порожні значення
df = df.fillna("")

# 🔹 Зберігаємо очищений файл для імпорту в DBeaver
cleaned_file_path = "D:/проекти скл/нетфлікс проект/cleaned_netflix_titles.csv"
df.to_csv(cleaned_file_path, index=False, quoting=2)  # quoting=2 - лапки тільки для тексту з комами

print(f"Файл збережено: {cleaned_file_path}")
