#!/usr/bin/env python3

import subprocess
import sys
import json
import platform
from typing import Dict, Any

def send_notification(title: str, message: str, sound: str = "default") -> None:
    """Send a system notification using platform-appropriate tools"""
    system = platform.system().lower()
    
    try:
        # Escape quotes in the title and message
        escaped_title = title.replace('"', '\\"').replace("'", "\\'")
        escaped_message = message.replace('"', '\\"').replace("'", "\\'")
        
        if system == "linux":
            # Try different Linux notification tools
            notifiers = ["notify-send", "zenity"]
            
            for notifier in notifiers:
                try:
                    if notifier == "notify-send":
                        # notify-send is most common on Linux
                        subprocess.run([
                            "notify-send", 
                            "--app-name=Claude Code",
                            "--icon=dialog-information",
                            escaped_title,
                            escaped_message
                        ], check=True, capture_output=True)
                        return  # Success, exit function
                    elif notifier == "zenity":
                        # zenity as fallback
                        subprocess.run([
                            "zenity", "--info", 
                            f"--title={escaped_title}",
                            f"--text={escaped_message}",
                            "--timeout=5"
                        ], check=True, capture_output=True)
                        return  # Success, exit function
                except (subprocess.CalledProcessError, FileNotFoundError):
                    continue  # Try next notifier
            
            # If no notifiers work, print to stderr
            print(f"No notification system found. Install notify-send or zenity.", file=sys.stderr)
            print(f"Notification: {escaped_title} - {escaped_message}", file=sys.stderr)
            
        elif system == "darwin":
            # macOS - keep original AppleScript
            script = f'''
            tell application "System Events"
                display notification "{escaped_message}" with title "{escaped_title}"
            end tell
            '''
            subprocess.run(['osascript', '-e', script], check=True, capture_output=True, text=True)
            
        elif system == "windows":
            # Windows PowerShell notification
            ps_script = f'''
            [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
            $template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText02)
            $template.SelectSingleNode("//text[@id='1']").InnerText = "{escaped_title}"
            $template.SelectSingleNode("//text[@id='2']").InnerText = "{escaped_message}"
            $toast = [Windows.UI.Notifications.ToastNotification]::new($template)
            [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Claude Code").Show($toast)
            '''
            subprocess.run(["powershell", "-Command", ps_script], check=True, capture_output=True)
            
        else:
            print(f"Unsupported system: {system}", file=sys.stderr)
            print(f"Notification: {escaped_title} - {escaped_message}", file=sys.stderr)
            
    except subprocess.CalledProcessError as e:
        print(f"Failed to send notification: {e}", file=sys.stderr)
        print(f"Notification: {escaped_title} - {escaped_message}", file=sys.stderr)
    except Exception as e:
        print(f"Error sending notification: {e}", file=sys.stderr)
        print(f"Notification: {escaped_title} - {escaped_message}", file=sys.stderr)

def main() -> None:
    input_data: Dict[str, Any] = json.load(sys.stdin)
    tool_name = input_data.get("tool_name")
    
    # Create notification title and message based on tool name
    if tool_name == 'Bash':
        title = "Command Executed"
        message = "Terminal command completed"
    elif tool_name == 'Edit':
        title = "File Modified"
        message = "File has been edited"
    elif tool_name == 'Write':
        title = "File Created"
        message = "New file has been written"
    elif tool_name == 'Read':
        title = "File Accessed"
        message = "File has been read"
    elif tool_name == 'Grep':
        title = "Search Complete"
        message = "Text search finished"
    elif tool_name == 'Glob':
        title = "Pattern Match"
        message = "File pattern search completed"
    elif tool_name == 'WebFetch':
        title = "Web Request"
        message = "Web content fetched"
    elif tool_name == 'Task':
        title = "Task Complete"
        message = "Background task finished"
    else:
        title = "Claude Code Complete"
        message = "operation finished"
    
    send_notification(title, message)

main()
