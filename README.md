# Sphynx File Server

Sphynx is an attempt at a **cross-platform mobile and desktop Flutter-based application** for managing personal file storage through a custom backend. It works like a private Google Drive, connecting to your Ubuntu server using a **RESTful API** (Flask).

## **🚀 Features**
- 📂 **File Management**: Upload, download, rename, delete, move files  
- 📁 **Folder Management**: Create and delete folders  
- 🔎 **Search & Sorting**: Find files and sort by name, size, or date  
- 🖼 **Preview Support**: View images and text files without downloading  
- 🎥 **Streaming**: Large file downloads work efficiently  
- 📦 **ZIP Compression**: Download folders as ZIP  
- 📊 **Usage & Server Statistics**: Get total files, total storage, recent uploads  
- ⚡ **Systemd Integration**: Auto-starts as a service  

## **You will need:**
- an Ubuntu Server 
- a Windows Client
- or/and an Android Client
- The service **isn't accessible on its own** if you're not inside your home network. You can work around this, [using a vpn](https://www.youtube.com/watch?v=9wG6qDFcaJc&t=263s).

For back-end installation,source code and testing, look in **/back-end**.

For front-end source code, look in **/front-end**
