#!/bin/bash
version="v0.1.0"

case "$1" in
    --help)
        echo "Usage: sysopctl <command> [options]"
        echo "Commands:"
        echo "  --help                Show this help message"
        echo "  --version             Show version information"
        echo "  service list          List all running services"
        echo "  service start         <service_name> Start a service"
        echo "  service stop          <service_name> Stop a service"
        echo "  service status        <service_name> Show the status of a service"
        echo "  disk usage            Show disk usage statistics by partition"
        echo "  process monitor       Monitor real-time system processes"
        echo "  logs analyze          Analyze system logs for critical entries"
        echo "  backup                <path> Backup specified files or directories"
        echo ""
        ;;
    --version)
        echo "sysopctl version $version"
        ;;
    service)
        case "$2" in
            list)
                systemctl list-units --type=service
                ;;
            start)
                if [ -n "$3" ]; then
                    sudo systemctl start "$3"
                    echo "Service $3 started."
                else
                    echo "Please specify a service name to start."
                fi
                ;;
            stop)
                if [ -n "$3" ]; then
                    sudo systemctl stop "$3"
                    echo "Service $3 stopped."
                else
                    echo "Please specify a service name to stop."
                fi
                ;;
            status)
                if [ -n "$3" ]; then
                    systemctl status "$3"
                else
                    echo "Please specify a service name to check status."
                fi
                ;;
            *)
                echo "Invalid service command. Use --help for guidance."
                ;;
        esac
        ;;
    disk)
        if [ "$2" == "usage" ]; then
            df -h
        else
            echo "Invalid disk command. Use --help for guidance."
        fi
        ;;
    process)
        if [ "$2" == "monitor" ]; then
            top
        else
            echo "Invalid process command. Use --help for guidance."
        fi
        ;;
    logs)
        if [ "$2" == "analyze" ]; then
            echo "Recent critical log entries:"
            sudo journalctl -p 3 -n 10
        else
            echo "Invalid logs command. Use --help for guidance."
        fi
        ;;
    backup)
    if [ -n "$2" ]; then
        backup_dir="$HOME/backup"
        mkdir -p "$backup_dir"
        if [ $? -ne 0 ]; then
            echo "Failed to create backup directory: $backup_dir"
            exit 1
        fi
        cp -r "$2" "$backup_dir"
        if [ $? -eq 0 ]; then
            echo "Backup of $2 completed in $backup_dir."
        else
            echo "Failed to back up $2."
        fi
    else
        echo "Please specify a path to back up."
    fi
    ;;

esac
