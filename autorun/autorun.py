import time
import subprocess

# Путь к .bat файлу
bat_file = r"run_scheduler_manual.bat"

# Интервал в секундах (например, 300 = 5 минут)
interval = 150

while True:
    try:
        print("Запуск .bat файла...")
        subprocess.run(bat_file, shell=True, encoding="cp1251")
        print(f"Ожидание {interval} секунд...\n")
        time.sleep(interval)
    except Exception as e:
        print(f"Ошибка: {e}")
        time.sleep(interval)