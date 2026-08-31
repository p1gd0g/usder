Param (
    [Parameter(Mandatory)]
    [string]$vsn
)

$build_time = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

flutter build web --build-name=$vsn --dart-define=vsn=$vsn --output=public --dart-define=build_time=$build_time
