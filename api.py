import os, uuid, json, asyncio, aiohttp, discord, threading
from discord.ext import commands
from discord import app_commands
from datetime import datetime, timezone
from flask import Flask, request, jsonify

# ===========================================================================
# 1. SETUP API FLASK
# ===========================================================================
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
def api_keys():
    if request.headers.get('x-bot-secret') != BOT_SECRET: return jsonify({'success': False}), 401
    db = load_db()
    if request.method == 'POST':
        db[request.json['key']] = {'used': False, 'hwid': None, 'device': 'Unknown'}
        save_db(db)
        return jsonify({'success': True})
    return jsonify({'success': True, 'data': [{'key': k, **v} for k, v in db.items()]})

@app.route('/api/keys/redeem', methods=['POST'])
def redeem_key():
    data = request.json
    db = load_db()
    key = data.get('key')
    if key not in db: return jsonify({'success': False})
    if db[key]['hwid'] is None:
        db[key].update({'hwid': data.get('hwid'), 'used': True, 'device': data.get('device', 'Unknown')})
        save_db(db)
    return jsonify({'success': True, 'valid': True})

def run_flask(): app.run(host='0.0.0.0', port=int(os.environ.get("PORT", 8080)))

# ===========================================================================
# 2. SETUP BOT DISCORD
# ===========================================================================
TOKEN = os.environ.get("DISCORD_BOT_TOKEN")
bot = commands.Bot(command_prefix="!", intents=discord.Intents.all())

async def call_api(method, path, **kwargs):
    async with aiohttp.ClientSession(headers={'x-bot-secret': BOT_SECRET}) as s:
        async with s.request(method, f"http://127.0.0.1:{os.environ.get('PORT', 8080)}"+path, **kwargs) as r:
            return await r.json()

@bot.tree.command(name="genkey", description="Generate key baru")
async def genkey(interaction: discord.Interaction, jumlah: int = 1):
    await interaction.response.defer(ephemeral=True)
    for _ in range(jumlah):
        await call_api("POST", "/api/keys", json={"key": "AURORA-" + uuid.uuid4().hex[:16].upper()})
    await interaction.followup.send(f"✅ Berhasil membuat {jumlah} key.")

@bot.tree.command(name="listkeys", description="Lihat semua key")
async def listkeys(interaction: discord.Interaction):
    await interaction.response.defer(ephemeral=True)
    res = await call_api("GET", "/api/keys")
    text = "\n".join([f"🔑 {k['key']} - {'Used' if k['used'] else 'Unused'}" for k in res['data']])
    await interaction.followup.send(f"📋 **Daftar Key:**\n{text}")

@bot.event
async def on_ready():
    await bot.tree.sync()
    print(f"✅ Bot & API Ready!")

# ===========================================================================
# 3. RUNNING
# ===========================================================================
if __name__ == "__main__":
    threading.Thread(target=run_flask, daemon=True).start()
    bot.run(TOKEN)
