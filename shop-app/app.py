from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
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

    if 'user' not in session and request.endpoint not in allowed_routes and request.endpoint is not None:
        return redirect(url_for('login'))


@app.route('/')
def index():
    if 'user' in session:
        return redirect(url_for('dashboard'))
    return redirect(url_for('login'))


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']

        hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')

        try:
            conn = get_db_connection()
            with conn.cursor() as cursor:
                cursor.execute("SELECT * FROM users WHERE username = %s", (username,))
                if cursor.fetchone():
                    flash('Username already exists!', 'danger')
                    return redirect(url_for('register'))

                cursor.execute("INSERT INTO users (username, email, password) VALUES (%s, %s, %s)",
                               (username, email, hashed_password))
                conn.commit()
            conn.close()
            flash('Registration successful! Please login.', 'success')
            return redirect(url_for('login'))
        except Exception as e:
            flash(f'Error: {str(e)}', 'danger')

    return render_template('register.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        try:
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
        except Exception as e:
            flash('Database connection error!', 'danger')

    return render_template('login.html')


@app.route('/dashboard')
def dashboard():
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


@app.route('/success')
def success():
    return render_template('success.html')


@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('login'))


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)