from flask import Blueprint, jsonify, send_file, request, Response
import os
import time
import mimetypes
from .config import BASE_DIR

file_routes = Blueprint("file_routes", __name__)

@file_routes.route('/files', methods=['GET'])
def list_files():
    """Lists files and folders, supports browsing subfolders."""
    folder = request.args.get('folder', '')  # Optional folder parameter
    target_dir = os.path.join(BASE_DIR, folder)

    if not os.path.exists(target_dir):
        return jsonify({"error": "Folder not found"}), 404

    try:
        items = []
        for item in os.listdir(target_dir):
            item_path = os.path.join(target_dir, item)
            items.append({
                "name": item,
                "is_folder": os.path.isdir(item_path),
                "size": os.path.getsize(item_path) if os.path.isfile(item_path) else None,
                "last_modified": time.ctime(os.path.getmtime(item_path))
            })
        return jsonify({"items": items, "current_folder": folder})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@file_routes.route('/download/<path:filename>', methods=['GET'])
def download_file(filename):
    """Streams file downloads"""
    file_path = os.path.join(BASE_DIR, filename)

    if not os.path.exists(file_path):
        return jsonify({"error": "File not found"}), 404

    def generate():
        with open(file_path, "rb") as f:
            while chunk := f.read(4096):
                yield chunk

    return Response(generate(), content_type=mimetypes.guess_type(file_path)[0] or "application/octet-stream",
                    headers={"Content-Disposition": f"attachment; filename={filename}"})

@file_routes.route('/upload', methods=['POST'])
def upload_file():
    """Upload a file to the specified folder"""
    folder = request.args.get('folder', '')  # Optional folder path
    target_dir = os.path.join(BASE_DIR, folder)

    if not os.path.exists(target_dir):
        return jsonify({"error": "Target folder does not exist"}), 404

    if 'file' not in request.files:
        return jsonify({"error": "No file part"}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({"error": "No selected file"}), 400

    try:
        file_path = os.path.join(target_dir, file.filename)
        file.save(file_path)
        return jsonify({"message": "File uploaded successfully", "filename": file.filename})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@file_routes.route('/delete/<filename>', methods=['DELETE'])
def delete_file(filename):
    """Deletes a file"""
    file_path = os.path.join(BASE_DIR, filename)

    if not os.path.exists(file_path):
        return jsonify({"error": "File not found"}), 404

    try:
        os.remove(file_path)
        return jsonify({"message": "File deleted successfully", "filename": filename})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@file_routes.route('/move', methods=['POST'])
def move_file():
    """Moves a file from one folder to another"""
    file_name = request.args.get('file')
    target_folder = request.args.get('to')

    if not file_name or not target_folder:
        return jsonify({"error": "Missing file name or target folder"}), 400

    source_path = os.path.join(BASE_DIR, file_name)
    target_path = os.path.join(BASE_DIR, target_folder, file_name)

    if not os.path.exists(source_path):
        return jsonify({"error": "File not found"}), 404

    if not os.path.exists(os.path.join(BASE_DIR, target_folder)):
        return jsonify({"error": "Target folder does not exist"}), 404

    try:
        os.rename(source_path, target_path)
        return jsonify({
            "message": "File moved successfully",
            "file": file_name,
            "from": source_path,
            "to": target_path
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@file_routes.route('/rename', methods=['PUT'])
def rename_file():
    """Renames a file"""
    old_name = request.args.get('old_name')
    new_name = request.args.get('new_name')

    if not old_name or not new_name:
        return jsonify({"error": "Missing old_name or new_name"}), 400

    old_path = os.path.join(BASE_DIR, old_name)
    new_path = os.path.join(BASE_DIR, new_name)

    if not os.path.exists(old_path):
        return jsonify({"error": "File not found"}), 404

    if os.path.exists(new_path):
        return jsonify({"error": "File with new name already exists"}), 400

    try:
        os.rename(old_path, new_path)
        return jsonify({"message": "File renamed successfully", "old_name": old_name, "new_name": new_name})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
