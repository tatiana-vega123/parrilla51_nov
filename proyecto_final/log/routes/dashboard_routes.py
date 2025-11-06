from flask import Blueprint, render_template, session, redirect, url_for, flash

dashboard_bp = Blueprint('dashboard', __name__)

# ================== DASHBOARD CLIENTE ==================
@dashboard_bp.route('/cliente/dashboard')
def cliente_dashboard():
    if 'rol' not in session or session['rol'] != 'cliente':
        flash("No tienes acceso a esta sección", "warning")
        return redirect(url_for('auth.login'))
    return render_template('cliente_dashboard.html',
                           nombre=session.get('nombre'))


# ================== DASHBOARD ADMINISTRADOR ==================
@dashboard_bp.route('/admin/dashboard')
def admin_dashboard():
    if 'rol' not in session or session['rol'] not in ['admin', 'administrador']:
        flash("No tienes acceso a esta sección", "warning")
        return redirect(url_for('auth.login'))
    return render_template('admin2.html', nombre=session.get('nombre'))


# ================== CLIENTE: Rutas adicionales ==================
@dashboard_bp.route('/cliente/reservar')
def cliente_reservar():
    if 'rol' not in session or session['rol'] != 'cliente':
        flash("No tienes acceso a esta sección", "warning")
        return redirect(url_for('auth.login'))
    return render_template('cliente_reservar.html',
                           nombre=session.get('nombre'))


# ================== REGISTRAR BLUEPRINT ==================
def init_app(app):
    app.register_blueprint(dashboard_bp)