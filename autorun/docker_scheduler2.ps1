# docker_scheduler.ps1
# Логика:
# - с 12:00 до 12:29 должны работать my_name1 и my_name2
# - с 12:30 до 12:59 должны работать my_name3 и my_name4
# - в остальное время все 4 контейнера должны быть остановлены
#
# Если контейнера нет -> create + start
# Если контейнер есть, но не запущен -> start
# Ненужные контейнеры -> stop

$ErrorActionPreference = "SilentlyContinue"

# ===== Настройки =====
$screenshotsPath = "C:\Users\r2r\PycharmProjects\docker-bot-html5\screenshots"
$imageName = "my-app"
$logFile = "C:\Users\r2r\PycharmProjects\docker-bot-html5\docker_scheduler.log"

# ===== Функции =====
function Write-Log($message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logFile -Value "[$timestamp] $message"
}

function Container-Exists($name) {
    $result = docker ps -a --filter "name=^${name}$" --format "{{.Names}}"
    return $result -eq $name
}

function Container-Running($name) {
    $result = docker ps --filter "name=^${name}$" --format "{{.Names}}"
    return $result -eq $name
}

function Ensure-Container($name, $image, $volumePath) {
    if (Container-Running $name) {
        Write-Log "Контейнер уже работает: $name"
        return
    }

    if (Container-Exists $name) {
        docker start $name | Out-Null
        Write-Log "Контейнер запущен: $name"
    }
    else {
        docker create --name $name -v "${volumePath}:/app/screenshots" $image | Out-Null
        Write-Log "Контейнер создан: $name"

        docker start $name | Out-Null
        Write-Log "Контейнер создан и запущен: $name"
    }
}

function Stop-Container($name) {
    if (Container-Running $name) {
        docker stop $name | Out-Null
        Write-Log "Контейнер остановлен: $name"
    }
    else {
        Write-Log "Контейнер уже остановлен или не существует: $name"
    }
}

function Ensure-GroupState($containersToRun, $containersToStop, $image, $volumePath) {
    foreach ($name in $containersToStop) {
        Stop-Container $name
    }

    foreach ($name in $containersToRun) {
        Ensure-Container $name $image $volumePath
    }
}

# Общее количество групп
$totalGroups = 144

# Получаем текущее время в минутах от начала суток
$now = Get-Date
$totalMinutes = $now.Hour * 60 + $now.Minute

# Сдвиг относительно 10:00
$startOffset = 10 * 60
$diff = ($totalMinutes - $startOffset + 1440) % 1440

# Определяем текущую группу (по 20 минут)
$currentGroup = [math]::Floor($diff / 20) + 1

# Вычисляем предыдущую группу
$prevGroup = if ($currentGroup -eq 1) { $totalGroups } else { $currentGroup - 1 }

# Генерация имён
function Get-Names($group) {
    $start = ($group - 1) * 5 + 1
    return 0..4 | ForEach-Object { "my_name$($start + $_)" }
}

$currentNames = Get-Names $currentGroup
$prevNames = Get-Names $prevGroup

Ensure-GroupState `
    $currentNames `
    $prevNames `
    $imageName `
    $screenshotsPath

Write-Log "Активна группа $currentGroup"