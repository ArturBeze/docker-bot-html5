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
$screenshotsPath = "C:\Users\r2r\PycharmProjects\promotion\headless-main\screenshots"
$imageName = "my-app"
$logFile = "C:\Users\r2r\PycharmProjects\promotion\headless-main\docker_scheduler.log"

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

# ===== Основная логика =====
$hourMinute = (Get-Date).ToString("HH:mm")
Write-Log "Проверка расписания. Текущее время: $hourMinute"

if ($hourMinute -ge "10:00" -and $hourMinute -lt "10:20") {
    Ensure-GroupState `
        @("my_name1", "my_name2", "my_name3", "my_name4", "my_name5") `
        @("my_name56", "my_name57", "my_name58", "my_name59", "my_name60") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 1"
}
elseif ($hourMinute -ge "10:20" -and $hourMinute -lt "10:40") {
    Ensure-GroupState `
        @("my_name6", "my_name7", "my_name8", "my_name9", "my_name10") `
        @("my_name1", "my_name2", "my_name3", "my_name4", "my_name5") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 2"
}
elseif ($hourMinute -ge "10:40" -and $hourMinute -lt "11:00") {
    Ensure-GroupState `
        @("my_name11", "my_name12", "my_name13", "my_name14", "my_name15") `
        @("my_name6", "my_name7", "my_name8", "my_name9", "my_name10") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 3"
}
elseif ($hourMinute -ge "11:00" -and $hourMinute -lt "11:20") {
    Ensure-GroupState `
        @("my_name16", "my_name17", "my_name18", "my_name19", "my_name20") `
        @("my_name11", "my_name12", "my_name13", "my_name14", "my_name15") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 4"
}
elseif ($hourMinute -ge "11:20" -and $hourMinute -lt "11:40") {
    Ensure-GroupState `
        @("my_name21", "my_name22", "my_name23", "my_name24", "my_name25") `
        @("my_name16", "my_name17", "my_name18", "my_name19", "my_name20") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 5"
}
elseif ($hourMinute -ge "11:40" -and $hourMinute -lt "12:00") {
    Ensure-GroupState `
        @("my_name26", "my_name27", "my_name28", "my_name29", "my_name30") `
        @("my_name21", "my_name22", "my_name23", "my_name24", "my_name25") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 6"
}
elseif ($hourMinute -ge "12:00" -and $hourMinute -lt "12:20") {
    Ensure-GroupState `
        @("my_name31", "my_name32", "my_name33", "my_name34", "my_name35") `
        @("my_name26", "my_name27", "my_name28", "my_name29", "my_name30") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 7"
}
elseif ($hourMinute -ge "12:20" -and $hourMinute -lt "12:40") {
    Ensure-GroupState `
        @("my_name36", "my_name37", "my_name38", "my_name39", "my_name40") `
        @("my_name31", "my_name32", "my_name33", "my_name34", "my_name35") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 8"
}
elseif ($hourMinute -ge "12:40" -and $hourMinute -lt "13:00") {
    Ensure-GroupState `
        @("my_name41", "my_name42", "my_name43", "my_name44", "my_name45") `
        @("my_name36", "my_name37", "my_name38", "my_name39", "my_name40") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 9"
}
elseif ($hourMinute -ge "13:00" -and $hourMinute -lt "13:20") {
    Ensure-GroupState `
        @("my_name46", "my_name47", "my_name48", "my_name49", "my_name50") `
        @("my_name41", "my_name42", "my_name43", "my_name44", "my_name45") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 10"
}
elseif ($hourMinute -ge "13:20" -and $hourMinute -lt "13:40") {
    Ensure-GroupState `
        @("my_name51", "my_name52", "my_name53", "my_name54", "my_name55") `
        @("my_name46", "my_name47", "my_name48", "my_name49", "my_name50") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 11"
}
elseif ($hourMinute -ge "13:40" -and $hourMinute -lt "14:00") {
    Ensure-GroupState `
        @("my_name56", "my_name57", "my_name58", "my_name59", "my_name60") `
        @("my_name51", "my_name52", "my_name53", "my_name54", "my_name55") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 12"
}
elseif ($hourMinute -ge "13:40" -and $hourMinute -lt "14:00") {
    Ensure-GroupState `
        @("my_name61", "my_name62", "my_name63", "my_name64", "my_name65") `
        @("my_name56", "my_name57", "my_name58", "my_name59", "my_name60") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 13"
}
elseif ($hourMinute -ge "14:00" -and $hourMinute -lt "14:20") {
    Ensure-GroupState `
        @("my_name66", "my_name67", "my_name68", "my_name69", "my_name70") `
        @("my_name61", "my_name62", "my_name63", "my_name64", "my_name65") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 14"
}
elseif ($hourMinute -ge "14:20" -and $hourMinute -lt "14:40") {
    Ensure-GroupState `
        @("my_name71", "my_name72", "my_name73", "my_name74", "my_name75") `
        @("my_name66", "my_name67", "my_name68", "my_name69", "my_name70") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 15"
}
elseif ($hourMinute -ge "14:40" -and $hourMinute -lt "15:00") {
    Ensure-GroupState `
        @("my_name76", "my_name77", "my_name78", "my_name79", "my_name80") `
        @("my_name71", "my_name72", "my_name73", "my_name74", "my_name75") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 16"
}
elseif ($hourMinute -ge "15:00" -and $hourMinute -lt "15:20") {
    Ensure-GroupState `
        @("my_name81", "my_name82", "my_name83", "my_name84", "my_name85") `
        @("my_name76", "my_name77", "my_name78", "my_name79", "my_name80") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 17"
}
elseif ($hourMinute -ge "15:20" -and $hourMinute -lt "15:40") {
    Ensure-GroupState `
        @("my_name86", "my_name87", "my_name88", "my_name89", "my_name90") `
        @("my_name81", "my_name82", "my_name83", "my_name84", "my_name85") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 18"
}
elseif ($hourMinute -ge "15:40" -and $hourMinute -lt "16:00") {
    Ensure-GroupState `
        @("my_name91", "my_name92", "my_name93", "my_name94", "my_name95") `
        @("my_name86", "my_name87", "my_name88", "my_name89", "my_name90") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 19"
}
elseif ($hourMinute -ge "16:00" -and $hourMinute -lt "16:20") {
    Ensure-GroupState `
        @("my_name96", "my_name97", "my_name98", "my_name99", "my_name100") `
        @("my_name91", "my_name92", "my_name93", "my_name94", "my_name95") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 20"
}
elseif ($hourMinute -ge "16:20" -and $hourMinute -lt "16:40") {
    Ensure-GroupState `
        @("my_name101", "my_name102", "my_name103", "my_name104", "my_name105") `
        @("my_name96", "my_name97", "my_name98", "my_name99", "my_name100") `
        $imageName `
        $screenshotsPath

    Write-Log "Активна группа 21"
}
else {
    Stop-Container "my_name101"
    Stop-Container "my_name102"
    Stop-Container "my_name103"
    Stop-Container "my_name104"
    Stop-Container "my_name105"

    Write-Log "Вне расписания. Все контейнеры остановлены"
}
