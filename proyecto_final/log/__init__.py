from flask import Flask
from flask_mysqldb import MySQL
from flask_mail import Mail
from itsdangerous import URLSafeTimedSerializer

mysql = MySQL()
mail = Mail()
serializer = URLSafeTimedSerializer("pinchellave")


def create_app():
    app = Flask(__name__, template_folder="template")
    app.secret_key = "pinchellave"

    # ------------------ Configuración Base de Datos ------------------
    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'root'
    app.config['MYSQL_PASSWORD'] = ''
    app.config['MYSQL_DB'] = 'parrilla51'
    app.config['MYSQL_CURSORCLASS'] = 'DictCursor'

    mysql.init_app(app)

    # ------------------ Configuración Correo ------------------
    app.config['MAIL_SERVER'] = 'smtp.gmail.com'
    app.config['MAIL_PORT'] = 587
    app.config['MAIL_USE_TLS'] = True
    app.config['MAIL_USERNAME'] = 'andresfariasa@juandelcorral.edu.co'
    app.config['MAIL_PASSWORD'] = 'ekyxnfjsubefudgm'
    mail.init_app(app)
    
    # ------------------ Registrar Blueprints ------------------
    from routes import auth_routes, dashboard_routes, cliente_routes, admin_routes, empleado_routes
    from routes.reportes import reportes_bp  # ✅ Importar correctamente desde routes.reportes
    
    auth_routes.init_app(app)
    dashboard_routes.init_app(app)
    cliente_routes.init_app(app)
    admin_routes.init_app(app)
    empleado_routes.init_app(app)
    app.register_blueprint(reportes_bp, url_prefix='/reportes')  # ✅ Registrar el blueprint
    
    return app