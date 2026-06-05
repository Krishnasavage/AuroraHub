import os
import uuid
import io
import asyncio
import aiohttp
import discord
from discord.ext import commands, tasks
from discord import app_commands
from datetime import datetime, timezone

# Import untuk fitur 24/7 (Keep Alive)
from flask import Flask
from threading import Thread

try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass

TOKEN = os.environ.get("DISCORD_BOT_TOKEN", "")
if not TOKEN:
    raise SystemExit("❌ DISCORD_BOT_TOKEN tidak ditemukan. Isi file .env terlebih dahulu.")

# ===========================================================================
# 1. KONFIGURASI ROLE & API
# ===========================================================================

ALLOWED_ROLE_IDS = [1511590117100359841, 1415244691427037225] 

API_BASE = "http://127.0.0.1:5000/api"

BOT_SECRET = "aurora-secret-2025"
API_HEADERS = {"x-bot-secret": BOT_SECRET, "Content-Type": "application/json"}

# ===========================================================================
# 2. SETUP DISCORD BOT
# ===========================================================================

intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix="!", intents=intents)

def has_allowed_role():
    async def predicate(interaction: discord.Interaction) -> bool:
        if not isinstance(interaction.user, discord.Member):
            await interaction.response.send_message("❌ Perintah ini hanya bisa digunakan di dalam server Discord.\n*This command can only be used in a Discord server.*", ephemeral=True)
            return False
            
        safe_allowed_ids = [int(r) for r in ALLOWED_ROLE_IDS]
        if any(role.id in safe_allowed_ids for role in interaction.user.roles):
            return True
        
        role_mentions = ", ".join(f"<@&{r_id}>" for r_id in safe_allowed_ids)
        embed = discord.Embed(
            title="🔒 Akses Terbatas / Access Denied",
            description=f"Maaf {interaction.user.mention}, perintah ini hanya dapat digunakan oleh anggota dengan role:\n*Sorry, this command is restricted to members with the following roles:*\n{role_mentions}",
            color=discord.Color.red()
        )
        embed.set_footer(text="Aurora Hub • Sistem Keamanan / Security System")
        embed.timestamp = datetime.now(timezone.utc)
        
        if interaction.response.is_done():
            await interaction.followup.send(embed=embed, ephemeral=True)
        else:
            await interaction.response.send_message(embed=embed, ephemeral=True)
        return False
    return app_commands.check(predicate)



# ===========================================================================
# 3. FUNGSI API (MEMANGGIL BACKEND)
# ===========================================================================

async def api(method: str, path: str, **kwargs) -> tuple[int, dict | None]:
    url = API_BASE + path
    try:
        async with aiohttp.ClientSession(headers=API_HEADERS) as s:
            async with s.request(method, url, timeout=aiohttp.ClientTimeout(total=15), **kwargs) as r:
                try:
                    return r.status, await r.json(content_type=None)
                except Exception:
                    return r.status, {"success": False, "message": f"Response tidak valid (HTTP {r.status})"}
    except Exception as e:
        return 500, {"success": False, "message": str(e)}

async def generate_key() -> tuple[bool, str]:
    generated_key = "AURORA-" + str(uuid.uuid4()).upper().replace("-", "")[:16]
    status, data = await api("POST", "/keys", json={"key": generated_key})
    
    if data is None:
        return False, f"Gagal terhubung ke API / Failed to connect to API (HTTP {status})."
    if data.get("success"):
        return True, generated_key
    return False, data.get("message", f"HTTP {status}")

async def delete_key(key: str) -> tuple[bool, str]:
    status, data = await api("DELETE", f"/keys/{key}")
    
    if data is None:
        return False, f"Gagal terhubung ke API / Failed to connect to API (HTTP {status})."
    if data.get("success"):
        return True, "Key berhasil dihapus / Key successfully deleted."
    return False, data.get("message", f"HTTP {status}")

async def list_keys() -> tuple[bool, list | str]:
    status, data = await api("GET", "/keys")
    
    if data is None:
        return False, f"Gagal terhubung ke API / Failed to connect to API (HTTP {status})."
    if data.get("success"):
        return True, data.get("data", [])
    return False, data.get("message", f"HTTP {status}")

# ===========================================================================
# 4. UI & EMBED HELPERS
# ===========================================================================

def make_embed(title: str, description: str, color: discord.Color) -> discord.Embed:
    embed = discord.Embed(title=title, description=description, color=color)
    embed.set_footer(text="Aurora Hub • Key System")
    embed.timestamp = datetime.now(timezone.utc)
    return embed

async def safe_defer(interaction: discord.Interaction, ephemeral: bool = False) -> bool:
    try:
        await interaction.response.defer(ephemeral=ephemeral)
        return True
    except (discord.NotFound, discord.HTTPException):
        return False

async def safe_send(interaction: discord.Interaction, embed: discord.Embed, ephemeral: bool = False):
    try:
        if interaction.response.is_done():
            await interaction.followup.send(embed=embed, ephemeral=ephemeral)
        else:
            await interaction.response.send_message(embed=embed, ephemeral=ephemeral)
    except (discord.NotFound, discord.HTTPException):
        pass

# ===========================================================================
# UI VIEW UNTUK DELETE KEY
# ===========================================================================

class DeleteKeyView(discord.ui.View):
    def __init__(self, keys_list):
        super().__init__(timeout=120)
        self.keys_list = keys_list

        options = []
        # Mengambil 25 key pertama untuk menu Dropdown (Batas maksimal Discord UI)
        for entry in keys_list[:25]:
            # Mendukung format dict (dari listkeys) atau string
            k_str = entry.get("key", str(entry)) if isinstance(entry, dict) else str(entry)
            options.append(discord.SelectOption(label=k_str, description="Hapus key ini / Delete this key"))
        
        if options:
            self.select = discord.ui.Select(
                placeholder="Pilih Key yang mau dihapus / Select Key...",
                min_values=1,
                max_values=1,
                options=options
            )
            self.select.callback = self.select_callback
            self.add_item(self.select)

    async def select_callback(self, interaction: discord.Interaction):
        selected_key = self.select.values[0]
        await interaction.response.defer(ephemeral=True)
        
        success, msg = await delete_key(selected_key)
        
        if success:
            text = f"✅ Key **{selected_key}** berhasil dihapus! / *Successfully deleted!*"
        else:
            text = f"❌ Gagal menghapus / *Failed to delete* **{selected_key}**:\n`{msg}`"
            
        for item in self.children:
            item.disabled = True
        await interaction.edit_original_response(content=text, view=self, embed=None)
        self.stop()

    @discord.ui.button(label="Delete All Keys", style=discord.ButtonStyle.danger, emoji="🗑️")
    async def delete_all_button(self, interaction: discord.Interaction, button: discord.ui.Button):
        await interaction.response.defer(ephemeral=True)
        
        deleted_count = 0
        failed_count = 0
        
        # Proses hapus massal
        for entry in self.keys_list:
            k_str = entry.get("key", str(entry)) if isinstance(entry, dict) else str(entry)
            succ, _ = await delete_key(k_str)
            if succ:
                deleted_count += 1
            else:
                failed_count += 1
            await asyncio.sleep(0.1) # Jeda agar tidak limit API
            
        text = f"🚨 **{deleted_count} KEY** berhasil dihapus dari database! / *Successfully deleted from database!*\n"
        if failed_count > 0:
            text += f"⚠️ Gagal menghapus / *Failed to delete*: **{failed_count}** keys."
            
        for item in self.children:
            item.disabled = True
        await interaction.edit_original_response(content=text, view=self, embed=None)
        self.stop()

# ===========================================================================
# 5. PERINTAH SLASH (COMMANDS)
# ===========================================================================

@bot.event
async def on_ready():
    await bot.change_presence(
        status=discord.Status.online,
        activity=discord.Activity(type=discord.ActivityType.listening, name="❄ Aurora Hub ❄")
    )
    print(f"✅ Bot online sebagai {bot.user} (ID: {bot.user.id})")
    print(f"   Server : {len(bot.guilds)}")
    print(f"   API    : {API_BASE}")
    print("   Ctrl+C untuk stop.\n")

    asyncio.create_task(_sync_all())

async def _sync_all():
    try:
        # Melakukan sinkronisasi global (untuk semua server)
        synced = await bot.tree.sync()
        print(f"✅ Global sync berhasil! Terdaftar {len(synced)} command.")
    except Exception as e:
        print(f"⚠️ Gagal global sync: {e}")

@bot.command(name="sync")
@commands.has_permissions(administrator=True)
async def sync_cmd(ctx: commands.Context):
    try:
        synced = await bot.tree.sync()
        await ctx.send(f"✅ Global sync berhasil! {len(synced)} command telah di-update.")
    except Exception as e:
        await ctx.send(f"❌ Gagal sync: {e}")


@bot.tree.command(name="genkey", description="Generate key baru / Generate a new key")
@app_commands.describe(jumlah="Jumlah key / Number of keys (max 10)")
@has_allowed_role()
async def genkey(interaction: discord.Interaction, jumlah: int = 1):
    if jumlah < 1 or jumlah > 10:
        await safe_send(interaction, make_embed("❌ Error", "Jumlah key harus antara 1–10.\n*Amount must be between 1–10.*", discord.Color.red()), ephemeral=True)
        return

    ok = await safe_defer(interaction, ephemeral=True)
    if not ok: return

    results, errors = [], []
    for _ in range(jumlah):
        success, result = await generate_key()
        (results if success else errors).append(result)
        await asyncio.sleep(0.1)

    if results:
        desc = f"✨ **Berhasil membuat {len(results)} Key Baru! / Successfully created {len(results)} New Keys!**\n💾 *Key telah dimasukkan ke dalam file `.txt` di bawah. / Keys are saved in the `.txt` file below.*"
        if errors:
            desc += f"\n\n⚠️ **{len(errors)} Gagal / Failed:** `{errors[0]}`"
            
        embed = make_embed("🔑 Aurora Hub — Key Generated", desc, discord.Color.green())
        embed.add_field(name="👤 Pembuat / Creator", value=interaction.user.mention, inline=True)
        
        key_file_content = "\n".join(results)
        string_io = io.StringIO(key_file_content)
        discord_file = discord.File(fp=string_io, filename="Aurora_Keys.txt")
        
        await interaction.followup.send(embed=embed, file=discord_file, ephemeral=True)
    else:
        embed = make_embed("❌ Gagal Generate Key / Failed to Generate", errors[0] if errors else "Server Error.", discord.Color.red())
        await safe_send(interaction, embed, ephemeral=True)

@bot.tree.command(name="deletekey", description="Buka menu interaktif untuk menghapus key / Open interactive menu to delete keys")
@has_allowed_role()
async def delkey_menu(interaction: discord.Interaction):
    ok = await safe_defer(interaction, ephemeral=True)
    if not ok: return
    
    # Langsung ambil data dari database untuk ditampilkan di menu
    success, result = await list_keys()
    
    if not success:
        await interaction.followup.send(embed=make_embed("❌ Gagal / Failed", f"Error memuat data:\n`{result}`", discord.Color.red()), ephemeral=True)
        return
        
    if not result:
        await interaction.followup.send(embed=make_embed("🗑️ Hapus Key / Delete Key", "✨ Database kosong, tidak ada key yang bisa dihapus.\n*Database is empty, no keys to delete.*", discord.Color.blurple()), ephemeral=True)
        return

    # Panggil tampilan UI Dropdown & Button
    view = DeleteKeyView(result)
    
    desc = (
        "🛠️ **Menu Penghapusan Key / Key Deletion Menu**\n\n"
        "Silakan pilih key yang ingin dihapus dari menu di bawah, atau tekan tombol merah untuk menghapus semua data.\n"
        "*Please select a key to delete from the dropdown below, or press the red button to wipe all keys.*"
    )
    embed = make_embed("🗑️ Aurora Hub — Delete Key", desc, discord.Color.orange())
    
    await interaction.followup.send(embed=embed, view=view, ephemeral=True)

@bot.tree.command(name="listkeys", description="Tampilkan semua key yang aktif / Show all active keys")
@has_allowed_role()
async def listkeys(interaction: discord.Interaction):
    ok = await safe_defer(interaction, ephemeral=True)
    if not ok: return
    
    success, result = await list_keys()
    if not success:
        await safe_send(interaction, make_embed("❌ Gagal / Failed", f"Error: {result}", discord.Color.red()), ephemeral=True)
        return
    if not result:
        await safe_send(interaction, make_embed("📋 Daftar Key / Key List", "✨ Bersih! Belum ada key aktif saat ini.\n*Clean! No active keys at the moment.*", discord.Color.blurple()), ephemeral=True)
        return

    chunks, current = [], ""
    # ... bagian dalam loop perintah listkeys di bot.py ...
    for entry in result:
        k = entry.get("key", "Unknown")
        hwid = entry.get("hwid", "N/A")
        # Mengambil nama perangkat, jika tidak ada tulis "Unknown Device"
        device = entry.get("device", "Unknown Device") 
        
        status_icon = "🟢 Digunakan" if entry.get("used") else "⚪ Belum Digunakan"
        
        # Tampilan baru dengan Nama Perangkat
        line = f"🔑 `{k}`\n└ 📌 {status_icon}\n└ 💻 HWID: `{hwid}`\n└ 📱 Device: **{device}**\n\n"
        
        if len(current) + len(line) > 3500:
            chunks.append(current)
            current = line
        else:
            current += line
# ... sisanya sama ...
    if current:
        chunks.append(current)

    for i, chunk in enumerate(chunks):
        title = f"📋 Aurora Hub — Daftar Key ({len(result)} Total)" if i == 0 else "📋 Daftar Key (Lanjutan / Continued)"
        desc = (
            f"📱 *Tips HP: Ketuk baris key untuk menyalin.* / *Mobile Tip: Tap a key to copy.*\n\n"
            f"{chunk}"
        )
        await interaction.followup.send(embed=make_embed(title, desc, discord.Color.blurple()))

@bot.tree.command(name="leaveall", description="[BAHAYA] Memerintahkan bot keluar dari semua server / Leave all servers")
@has_allowed_role()
async def leaveall_cmd(interaction: discord.Interaction):
    ok = await safe_defer(interaction, ephemeral=True)
    if not ok: return
        
    guilds = bot.guilds
    total_guilds = len(guilds)
    success_count = 0
    failed_count = 0
    
    for guild in guilds:
        try:
            await guild.leave()
            success_count += 1
            await asyncio.sleep(0.5) 
        except Exception:
            failed_count += 1
            
    desc = (
        "Bot telah memproses perintah keluar server / *Bot has processed the leave servers command.*\n\n"
        f"✅ **Berhasil / Success:** `{success_count}` server\n"
        f"❌ **Gagal / Failed:** `{failed_count}` server\n"
        f"📊 **Total awal / Initial total:** `{total_guilds}` server"
    )
    
    embed = make_embed("⚠️ Aurora Hub — Leave All Servers", desc, discord.Color.orange())
    await interaction.followup.send(embed=embed, ephemeral=True)

@bot.tree.command(name="help", description="Tampilkan semua perintah bot / Show all bot commands")
async def help_cmd(interaction: discord.Interaction):
    embed = make_embed("📖 Aurora Hub — Menu Bantuan / Help Menu", "Berikut adalah daftar perintah yang tersedia di sistem key Aurora Hub.\n*Here is the list of available commands in the Aurora Hub key system.*", discord.Color.blurple())
    embed.add_field(name="🔑 `/genkey [jumlah]`", value="Membuat key baru (1–10). / *Generate new keys.*\n*Admin Only.*", inline=False)
    embed.add_field(name="🗑️ `/delkey`", value="Membuka menu interaktif untuk menghapus key. / *Open interactive menu to delete keys.*\n*Admin Only.*", inline=False)
    embed.add_field(name="📋 `/listkeys`", value="Melihat status penggunaan seluruh key. / *View usage status of all keys.*\n*Admin Only.*", inline=False)
    embed.add_field(name="⚠️ `/leaveall`", value="Mengeluarkan bot dari semua server. / *Force bot to leave all servers.*\n*Admin Only.*", inline=False)
    await safe_send(interaction, embed, ephemeral=True)

@bot.tree.error
async def on_app_command_error(interaction: discord.Interaction, error: app_commands.AppCommandError):
    if isinstance(error, app_commands.CheckFailure):
        return
        
    embed = make_embed("❌ Terjadi Kesalahan / An Error Occurred", f"Terjadi error tak terduga / Unexpected error:\n`{str(error)}`", discord.Color.red())
    await safe_send(interaction, embed, ephemeral=True)

@bot.command(name="leaveall")
async def leaveall_prefix(ctx: commands.Context):
    safe_allowed_ids = [int(r) for r in ALLOWED_ROLE_IDS]
    
    if not isinstance(ctx.author, discord.Member):
        await ctx.send("❌ Perintah ini hanya bisa digunakan di dalam server.\n*This command can only be used in a server.*")
        return

    if not any(role.id in safe_allowed_ids for role in ctx.author.roles):
        await ctx.send(f"❌ Maaf {ctx.author.mention}, kamu tidak memiliki akses / *You do not have access.*")
        return

    loading_msg = await ctx.send("⏳ Sedang memproses keluar dari semua server. Mohon tunggu...\n*Processing leaving all servers. Please wait...*")
    
    guilds = bot.guilds
    total_guilds = len(guilds)
    success_count = 0
    failed_count = 0
    
    for guild in guilds:
        try:
            await guild.leave()
            success_count += 1
            await asyncio.sleep(0.5)
        except Exception:
            failed_count += 1
            
    desc = (
        "Bot telah memproses perintah keluar server / *Bot has processed the leave servers command.*\n\n"
        f"✅ **Berhasil / Success:** `{success_count}` server\n"
        f"❌ **Gagal / Failed:** `{failed_count}` server\n"
        f"📊 **Total awal / Initial total:** `{total_guilds}` server"
    )
    
    embed = make_embed("⚠️ Aurora Hub — Leave All Servers", desc, discord.Color.orange())
    await loading_msg.edit(content=None, embed=embed)

# ===========================================================================
# 6. RUNNING BOT
# ===========================================================================

if __name__ == "__main__":
    bot.run(TOKEN)
