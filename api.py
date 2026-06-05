import json
import os
from flask import Flask, request, jsonify

app = Flask(__name__)

# File untuk menyimpan database key
DB_FILE = 'database.json'
BOT_SECRET = 'aurora-secret-2025'

def load_db():
    if not os.path.exists(DB_FILE):
        return {}
    with open(DB_FILE, 'r') as f:
        try:
            return json.load(f)
        except json.JSONDecodeError:
            return {}

def save_db(data):
    with open(DB_FILE, 'w') as f:
        json.dump(data, f, indent=4)

def check_auth(req):
    return req.headers.get('x-bot-secret') == BOT_SECRET

@app.route('/api/keys', methods=['POST'])
def generate_key():
    if not check_auth(request):
        return jsonify({'success': False, 'message': 'Akses Ditolak'}), 401
    
    data = request.json
    key = data.get('key')
    
    db = load_db()
    db[key] = {'used': False, 'hwid': None} 
    save_db(db)
    
    return jsonify({'success': True})

@app.route('/api/keys/<key>', methods=['DELETE'])
def delete_key(key):
    if not check_auth(request):
        return jsonify({'success': False, 'message': 'Akses Ditolak'}), 401
    
    db = load_db()
    if key in db:
        del db[key]
        save_db(db)
        return jsonify({'success': True})
    
    return jsonify({'success': False, 'message': 'Key tidak ditemukan'}), 404

@app.route('/api/keys', methods=['GET'])
def list_keys():
    if not check_auth(request):
        return jsonify({'success': False, 'message': 'Akses Ditolak'}), 401
    
    db = load_db()
    result = [{'key': k, 'used': v['used'], 'hwid': v['hwid']} for k, v in db.items()]
    return jsonify({'success': True, 'data': result})

@app.route('/api/keys/redeem', methods=['POST'])
# Contoh modifikasi di api.py
def get_keys():
    # ... query SQL kamu harus mengambil device_name ...
    # SELECT key, used, hwid, device_name FROM keys
    return jsonify({
        "success": True,
        "data": [{"key": k[0], "used": k[1], "hwid": k[2], "device": k[3]} for k in keys]
    })

def redeem_key():
    data = request.json
    if not data:
        return jsonify({'success': False, 'message': 'Format data salah.'})
        
    key = data.get('key')
    hwid = data.get('hwid')
    
    if not key or not hwid:
        return jsonify({'success': False, 'message': 'Key atau HWID tidak boleh kosong.'})
        
    db = load_db()
    
    if key not in db:
        return jsonify({'success': False, 'valid': False, 'message': 'Key tidak valid atau salah.'})
        
    key_data = db[key]
    
    if key_data['hwid'] is None:
        key_data['hwid'] = hwid
        key_data['used'] = True
        save_db(db)
        return jsonify({'success': True, 'valid': True, 'message': 'Login berhasil. HWID terkunci!'})
        
    if key_data['hwid'] == hwid:
        return jsonify({'success': True, 'valid': True, 'message': 'Login berhasil.'})
    else:
        return jsonify({
            'success': False, 
            'valid': False, 
            'message': 'HWID Mismatch: Key ini sudah dipakai di perangkat (HP/PC) lain.'
        })

@app.route('/')
def home():
    return "🌐 Aurora API Backend is Online!"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8050)
