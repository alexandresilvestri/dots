#!/usr/bin/env bash
command -v powershell.exe >/dev/null || exit 0
input=$(cat)
cwd=$(jq -r '.cwd' <<<"$input")
CN_TITLE="Claude Code — ${cwd##*/}"
CN_BODY=$(jq -r '.message // "Task finished"' <<<"$input")
export CN_TITLE CN_BODY WSLENV=CN_TITLE:CN_BODY

ps='
$m = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
$t = $m::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
$n = $t.GetElementsByTagName("text")
[void]$n.Item(0).AppendChild($t.CreateTextNode($env:CN_TITLE))
[void]$n.Item(1).AppendChild($t.CreateTextNode($env:CN_BODY))
$m::CreateToastNotifier("{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe").Show([Windows.UI.Notifications.ToastNotification]::new($t))
'
setsid -f powershell.exe -NoProfile -NonInteractive -Command "$ps" >/dev/null 2>&1
