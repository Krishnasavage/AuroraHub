import os, json
from flask import Flask, request, jsonify

app = Flask(__name__)
DB_FILE = 'database.json'
BOT_SECRET = 'aurora-secret-2025'

def load_db():
    if not os.path.exists(DB_FILE): return {}
    with open(DB_FILE, 'r') as f:
        try: return json.load(f)
        except: return {}

def save_db(data):
    with open(DB_FILE, 'w') as f: json.dump(data, f, indent=4)

@app.route('/api/keys', methods=['GET', 'POST', 'DELETE'])
def handle_keys():
    if request.headers.get('x-bot-secret') != BOT_SECRET: return jsonify({'success': False}), 401
    db = load_db()
    
    if request.method == 'POST':
        db[request.json['key']] = {'used': False, 'hwid': None, 'device': 'Unknown'}
        save_db(db)
        return jsonify({'success': True})
    
    if request.method == 'DELETE':
        key = request.args.get('key')
        if key in db: del db[key]; save_db(db); return jsonify({'success': True})
        return jsonify({'success': False}), 404
        
    return jsonify({'success': True, 'data': [{'key': k, **v} for k, v in db.items()]})

@app.route('/api/redeem', methods=['POST'])
def redeem():
    data = request.json
    db = load_db()
    key = data.get('key')
    if key not in db: return jsonify({'success': False, 'message': 'Invalid Key'})
    if db[key]['hwid'] is None:
        db[key].update({'hwid': data.get('hwid'), 'used': True, 'device': data.get('device', 'Unknown')})
        save_db(db)
        return jsonify({'success': True, 'message': 'Success'})
    return jsonify({'success': False, 'message': 'HWID Mismatch'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
