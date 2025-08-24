import telebot
import json
import os
from telebot.types import ReplyKeyboardMarkup, KeyboardButton, WebAppInfo

# ⚠️ ВСТАВЬ сюда свой токен от BotFather
TOKEN = "YOUR_TELEGRAM_BOT_TOKEN"

# ⚠️ ВСТАВЬ сюда ссылку на твою игру (GitHub Pages)
WEBAPP_URL = "https://YOUR-NAME.github.io/telegram-roguelike/"

bot = telebot.TeleBot(TOKEN)

DATA_FILE = "players.json"

# Загружаем сохранения игроков
if os.path.exists(DATA_FILE):
    with open(DATA_FILE, "r") as f:
        players = json.load(f)
else:
    players = {}

def save_data():
    """Сохраняем прогресс в файл"""
    with open(DATA_FILE, "w") as f:
        json.dump(players, f)

@bot.message_handler(commands=["start"])
def start(message):
    user_id = str(message.from_user.id)

    if user_id not in players:
        players[user_id] = {"hp": 100, "gold": 0, "level": 1}
        save_data()

    player = players[user_id]

    kb = ReplyKeyboardMarkup(resize_keyboard=True)
    btn = KeyboardButton("🎮 Играть", web_app=WebAppInfo(url=WEBAPP_URL))
    kb.add(btn)

    bot.send_message(
        message.chat.id,
        f"Привет, {message.from_user.first_name}!\n"
        f"⚔️ Твой прогресс:\n"
        f"❤️ HP: {player['hp']}\n"
        f"💰 Золото: {player['gold']}\n"
        f"⭐ Уровень: {player['level']}",
        reply_markup=kb
    )

@bot.message_handler(commands=["addgold"])
def add_gold(message):
    user_id = str(message.from_user.id)
    if user_id in players:
        players[user_id]["gold"] += 10
        save_data()
        bot.reply_to(message, f"Теперь у тебя {players[user_id]['gold']} золота! 💰")

print("✅ Бот запущен...")
bot.polling()
