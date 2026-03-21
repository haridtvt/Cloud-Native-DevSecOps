from flask import Flask, render_template, request, redirect, url_for, session
import pymysql
import os

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'devsecops-very-secret')

# DB enviroment ( set in Docker-compose/K8s)
DB_HOST = os.environ.get('DB_HOST', 'localhost')
DB_USER = os.environ.get('DB_USER', 'root')
DB_PASS = os.environ.get('DB_PASSWORD', 'password')
DB_NAME = os.environ.get('DB_NAME', 'shopdata')

def get_db_connection():
    return pymysql.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASS,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )

PRODUCTS = [
    {"id": 1, "name": "Laptop Dell XPS", "price": 1500, "img": "https://via.placeholder.com/150"},
    {"id": 2, "name": "iPhone 15 Pro", "price": 1200, "img": "https://via.placeholder.com/150"},
    {"id": 3, "name": "Mechanical Keyboard", "price": 100, "img": "https://via.placeholder.com/150"},
    {"id": 4, "name": "Sony WH-1000XM5", "price": 350, "img": "https://via.placeholder.com/150"},
]

@app.route('/')
def index():
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        session['user'] = request.form['username']
        return redirect(url_for('dashboard'))
    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    if 'user' not in session: return redirect(url_for('login'))
    return render_template('dashboard.html', products=PRODUCTS)

@app.route('/checkout', methods=['GET', 'POST'])
def checkout():
    if request.method == 'POST':
        return redirect(url_for('success'))
    return render_template('checkout.html')

@app.route('/success')
def success():
    return render_template('success.html')

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('login'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)