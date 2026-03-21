from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_bcrypt import Bcrypt
import pymysql
import os

app = Flask(__name__)
app.secret_key = os.environ.get('SECRET_KEY', 'devsecops-very-secret')
bcrypt = Bcrypt(app)

DB_CONFIG = {
    'host': os.environ.get('DB_HOST', 'localhost'),
    'user': os.environ.get('DB_USER', 'root'),
    'password': os.environ.get('DB_PASSWORD', 'password'),
    'database': os.environ.get('DB_NAME', 'shop_db'),
    'cursorclass': pymysql.cursors.DictCursor
}


def get_db_connection():
    return pymysql.connect(**DB_CONFIG)

@app.before_request
def require_login():
    allowed_routes = ['login', 'register', 'static']

    if 'user' not in session and request.endpoint not in allowed_routes:
        return redirect(url_for('login'))


@app.route('/')
def index():
    if 'user' in session:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        conn = get_db_connection()
        with conn.cursor() as cursor:
            cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
            user = cursor.fetchone()
        conn.close()

        if user and bcrypt.check_password_hash(user['password'], password):
            session['user'] = user['username']
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid password or username!', 'danger')

    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    if 'user' not in session: return redirect(url_for('login'))

    conn = get_db_connection()
    with conn.cursor() as cursor:
        cursor.execute("SELECT * FROM products")
        db_products = cursor.fetchall()
    conn.close()

    return render_template('dashboard.html', products=db_products)


@app.route('/api/buy/<int:product_id>', methods=['POST'])
def buy_product(product_id):
    if 'user' not in session: return jsonify({"error": "Unauthorized"}), 401

    conn = get_db_connection()
    with conn.cursor() as cursor:
        cursor.execute("UPDATE products SET stock = stock - 1 WHERE id = %s AND stock > 0", (product_id,))
        conn.commit()
    conn.close()
    return redirect(url_for('success'))
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)