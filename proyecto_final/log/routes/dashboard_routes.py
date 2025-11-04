from flask import Blueprint, render_template, session, redirect, url_for, flash

dashboard_bp = Blueprint('dashboard', __name__)

# ================== DASHBOARD CLIENTE ==================
@dashboard_bp.route('/cliente/dashboard')
def cliente_dashboard():
    if 'rol' not in session or session['rol'] != 'cliente':
        flash("No tienes acceso a esta sección", "warning")
        return redirect(url_for('auth.login'))
    return render_template('admin.html', nombre=session.get('nombre'))


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
    return render_template('cliente_reservar.html', nombre=session.get('nombre'))


@dashboard_bp.route('/cliente/productos')
def cliente_productos():
    if 'rol' not in session or session['rol'] != 'cliente':
        flash("No tienes acceso a esta sección", "warning")
        return redirect(url_for('auth.login'))
    return render_template('cliente_productos.html', nombre=session.get('nombre'))


@dashboard_bp.route('/cliente/carrito')
def cliente_carrito():
    if 'rol' not in session or session['rol'] != 'cliente':
        flash("No tienes acceso a esta sección", "warning")
        return redirect(url_for('auth.login'))
    return render_template('cliente_carrito.html', nombre=session.get('nombre'))


@dashboard_bp.route('/cliente/mis_pedidos')
def cliente_mis_pedidos():
    if 'rol' not in session or session['rol'] != 'cliente':
        flash("No tienes acceso a esta sección", "warning")
        return redirect(url_for('auth.login'))
    return render_template('mis_pedidos.html', nombre=session.get('nombre'))


@dashboard_bp.route('/cliente/ver_reservas')
def cliente_ver_reservas():
    if 'rol' not in session or session['rol'] != 'cliente':
        flash("No tienes acceso a esta sección", "warning")
        return redirect(url_for('auth.login'))
    return render_template('cliente_ver_reservas.html', nombre=session.get('nombre'))


# ================== REGISTRAR BLUEPRINT ==================
def init_app(app):
    app.register_blueprint(dashboard_bp)