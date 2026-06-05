import os
import psycopg2
from flask import Flask, request, jsonify

app = Flask(__name__)
# Railway otomatis kasih variabel DATABASE_URL
DB_URL = os.environ.get("DATABASE_URL")

def get_db():
    return psycopg2.connect(DB_URL)

# Buat table pas pertama kali jalan
def init_db():
    conn = get_db()
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS keys (
            id SERIAL PRIMARY KEY,
            key TEXT UNIQUE,
            used BOOLEAN DEFAULT FALSE,
            hwid TEXT,
            device TEXT
        )
    """)
    conn.commit()
    cur.close()
    conn.close()

init_db()

@app.route('/api/keys', methods=['GET', 'POST', 'DELETE'])
def handle_keys():
    if request.headers.get('x-bot-secret') != 'aurora-secret-2025': return jsonify({'success': False}), 401
    conn = get_db()
    cur = conn.cursor()

    if request.method == 'POST':
        key = request.json['key']
        cur.execute("INSERT INTO keys (key) VALUES (%s)", (key,))
        conn.commit()
        return jsonify({'success': True})

    if request.method == 'DELETE':
        key = request.args.get('key')
        cur.execute("DELETE FROM keys WHERE key = %s", (key,))
        conn.commit()
        return jsonify({'success': True})

    cur.execute("SELECT key, used, hwid, device FROM keys")
    rows = cur.fetchall()
    return jsonify({'success': True, 'data': [{'key': r[0], 'used': r[1], 'hwid': r[2], 'device': r[3]} for r in rows]})

@app.route('/api/redeem', methods=['POST'])
def redeem():
    data = request.json
    conn = get_db()
    cur = conn.cursor()
    cur.execute("SELECT used, hwid FROM keys WHERE key = %s", (data['key'],))
    row = cur.fetchone()
    
    if not row: return jsonify({'success': False, 'message': 'Invalid Key'})
    
    if row[1] is None:
        cur.execute("UPDATE keys SET used=TRUE, hwid=%s, device=%s WHERE key=%s", (data['hwid'], data['device'], data['key']))
        conn.commit()
        return jsonify({'success': True})
    
    return jsonify({'success': True if row[1] == data['hwid'] else False})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=int(os.environ.get("PORT", 8080)))
