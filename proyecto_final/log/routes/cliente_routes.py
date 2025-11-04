from flask import Blueprint, render_template, session, redirect, url_for, request, flash
from __init__ import mysql

cliente_bp = Blueprint('cliente', __name__)

@cliente_bp.route('/cliente/reservar', methods=['GET', 'POST'])
def cliente_reservar():
    if 'rol' not in session or session['rol'] != 'cliente':
        return redirect(url_for('auth.login'))

    if request.method == 'POST':
        try:
            nombre = request.form['nombre']
            documento = request.form['documento']
            fecha = request.form['fecha']
            hora = request.form['hora']
            cant_personas = request.form['cant_personas']
            tipo_evento = request.form['tipo_evento']
            comentarios = request.form['comentarios']
            telefono = request.form['telefono']
            id_usuario = session.get('id_usuario')

            cur = mysql.connection.cursor()
            cur.execute("""
                INSERT INTO reservas (nombre, documento, fecha, hora, cant_personas, tipo_evento, comentarios, telefono, id_usuario, estado)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, 'Pendiente')
            """, (nombre, documento, fecha, hora, cant_personas, tipo_evento, comentarios, telefono, id_usuario))
            mysql.connection.commit()
            cur.close()

            flash("✅ Reserva registrada correctamente.", "success")
            return redirect(url_for('dashboard.cliente_dashboard'))

        except Exception as e:
            mysql.connection.rollback()
            flash(f"❌ Error al guardar la reserva: {e}", "danger")
            print(f"❌ Error al guardar la reserva: {e}")

    return render_template('cliente_reservar.html')


@cliente_bp.route('/cliente/productos')
def cliente_productos():
    if 'rol' not in session or session['rol'] != 'cliente':
        return redirect(url_for('auth.login'))
    return render_template('cliente_productos.html')


@cliente_bp.route('/cliente/carrito')
def cliente_carrito():
    carrito = session.get('carrito', [])
    total = sum(item['precio'] * item['cantidad'] for item in carrito)
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM productos WHERE categoria = 'acompañamientos'")
    acompanamientos = cur.fetchall()
    
    return render_template(
        'cliente_carrito.html',
        carrito=carrito,
        total=total,
        acompanamientos=acompanamientos
    )

# -------------------- VER RESERVAS --------------------
@cliente_bp.route('/cliente/ver_reservas')
def cliente_ver_reservas():
    if 'rol' not in session or session['rol'] != 'cliente':
        return redirect(url_for('auth.login'))

    id_usuario = session.get('id_usuario')
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT id_reserva, nombre, fecha, hora, cant_personas, tipo_evento, estado, comentarios
        FROM reservas
        WHERE id_usuario = %s
        ORDER BY fecha DESC
    """, (id_usuario,))
    reservas = cur.fetchall()
    cur.close()

    return render_template('cliente_ver_reservas.html', reservas=reservas)



# -------------------- MIS PEDIDOS --------------------
@cliente_bp.route('/cliente/mis_pedidos')
def cliente_mis_pedidos():
    if 'rol' not in session or session['rol'] != 'cliente':
        return redirect(url_for('auth.login'))

    id_usuario = session.get('id_usuario')
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT p.nombre AS producto, dp.cantidad, dp.precio_unitario,
               (dp.cantidad * dp.precio_unitario) AS subtotal,
               pe.fecha_pedido, pe.estado
        FROM pedidos pe
        JOIN detalle_pedido dp ON pe.id_pedido = dp.id_pedido
        JOIN productos p ON dp.id_producto = p.id_producto
        WHERE pe.id_usuario = %s
        ORDER BY pe.fecha_pedido DESC
    """, (id_usuario,))
    pedidos = cur.fetchall()
    cur.close()

    return render_template('cliente_mis_pedidos.html', pedidos=pedidos)


def init_app(app):
    app.register_blueprint(cliente_bp)
