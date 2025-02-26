from flask import Blueprint, jsonify
import psutil
import platform
import os
import uptime

server_routes = Blueprint("server_routes", __name__)

@server_routes.route('/server-stats', methods=['GET'])
def get_server_stats():
    """Returns server resource usage and system info."""
    try:
        # CPU usage
        cpu_usage = psutil.cpu_percent(interval=1)

        # Memory usage
        memory = psutil.virtual_memory()
        ram_used = memory.used / (1024 * 1024)  # MB
        ram_total = memory.total / (1024 * 1024)  # MB
        ram_percent = memory.percent

        # Disk usage
        disk = psutil.disk_usage('/')
        disk_used = disk.used / (1024 * 1024 * 1024)  # GB
        disk_total = disk.total / (1024 * 1024 * 1024)  # GB
        disk_percent = disk.percent

        # Uptime
        system_uptime = uptime.uptime()  # Seconds

        # System info
        system_info = {
            "os": platform.system(),
            "os_version": platform.version(),
            "hostname": platform.node()
        }

        return jsonify({
            "cpu_usage": f"{cpu_usage}%",
            "ram_used": f"{ram_used:.2f} MB / {ram_total:.2f} MB ({ram_percent}%)",
            "disk_used": f"{disk_used:.2f} GB / {disk_total:.2f} GB ({disk_percent}%)",
            "uptime": f"{int(system_uptime // 3600)}h {int((system_uptime % 3600) // 60)}m",
            "system_info": system_info
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
