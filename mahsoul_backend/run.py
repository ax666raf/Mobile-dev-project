from app import create_app
from config import Config

app = create_app(Config)

if __name__ == '__main__':
    print("🚀 Starting Mahsoul Backend Server...")
    print("📍 Server running at http://localhost:5000")
    print("📍 Accessible from Android emulator at http://10.0.2.2:5000")
    print("📍 Accessible from network at http://0.0.0.0:5000")
    print("=" * 50)
    app.run(debug=True, host='0.0.0.0', port=5000, threaded=True)

