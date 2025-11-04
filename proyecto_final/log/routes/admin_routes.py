from flask import Blueprint, render_template, session, redirect, url_for, request, flash
from __init__ import mysql

admin_bp = Blueprint('admin', __name__)

# ===============================
# VERIFICACIÓN DE ADMINISTRADOR
# ===============================
def verificar_admin():
    """Función helper para verificar si el usuario es administrador"""
    if 'logueado' not in session:
        return False, 'Debes iniciar sesión primero'
    
    if session.get('rol') != 'administrador':
        return False, f'Acceso denegado. Tu rol actual es: {session.get("rol")}'
    
    return True, None

# ===============================
# DASHBOARD
# ===============================
@admin_bp.route('/admin/dashboard')
def admin_dashboard():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    return render_template('admin2.html')

# ===============================
# PRODUCTOS
# ===============================
@admin_bp.route('/admin/productos', methods=['GET', 'POST'])
def admin_productos():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT p.id_producto, p.nombre, p.cantidad, p.descripcion, p.precio, 
               p.imagen, c.nombre_categoria, p.cod_categoria
        FROM productos p
        LEFT JOIN categorias c ON p.cod_categoria = c.id_categoria
    """)
    productos = cur.fetchall()
    cur.close()
    return render_template('admin_productos.html', productos=productos)


@admin_bp.route('/admin/productos/agregar', methods=['GET', 'POST'])
def agregar_producto():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM categorias")
    categorias = cur.fetchall()

    if request.method == 'POST':
        nombre = request.form['nombre']
        cantidad = request.form['cantidad']
        descripcion = request.form['descripcion']
        precio = request.form['precio']
        cod_categoria = request.form['cod_categoria']
        imagen = request.form.get('imagen', '')

        cur.execute("""
            INSERT INTO productos (nombre, cantidad, descripcion, precio, cod_categoria, imagen)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (nombre, cantidad, descripcion, precio, cod_categoria, imagen))
        mysql.connection.commit()
        cur.close()

        flash("Producto agregado correctamente", "success")
        return redirect(url_for('admin.admin_productos'))

    cur.close()
    return render_template('editar_producto.html', producto=None, categorias=categorias)


@admin_bp.route('/admin/productos/editar/<int:id_producto>', methods=['GET', 'POST'])
def editar_producto(id_producto):
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM productos WHERE id_producto = %s", (id_producto,))
    producto = cur.fetchone()

    cur.execute("SELECT * FROM categorias")
    categorias = cur.fetchall()

    if request.method == 'POST':
        nombre = request.form['nombre']
        cantidad = request.form['cantidad']
        descripcion = request.form['descripcion']
        precio = request.form['precio']
        cod_categoria = request.form['cod_categoria']
        imagen = request.form.get('imagen', '')

        cur.execute("""
            UPDATE productos SET nombre=%s, cantidad=%s, descripcion=%s, precio=%s,
                                cod_categoria=%s, imagen=%s
            WHERE id_producto=%s
        """, (nombre, cantidad, descripcion, precio, cod_categoria, imagen, id_producto))
        mysql.connection.commit()
        cur.close()

        flash("Producto actualizado correctamente", "success")
        return redirect(url_for('admin.admin_productos'))

    cur.close()
    return render_template('editar_producto.html', producto=producto, categorias=categorias)


@admin_bp.route('/admin/productos/eliminar/<int:id_producto>', methods=['POST', 'GET'])
def eliminar_producto(id_producto):
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM productos WHERE id_producto = %s", (id_producto,))
    mysql.connection.commit()
    cur.close()

    flash("✅ Producto eliminado correctamente", "success")
    return redirect(url_for('admin.admin_productos'))

# ===============================
# RESERVAS
# ===============================
@admin_bp.route('/admin/reservas')
def admin_reservas():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM reservas ORDER BY fecha DESC")
    reservas = cur.fetchall()
    cur.close()
    return render_template('admin_reservas.html', reservas=reservas)

# ===============================
# PEDIDOS
# ===============================
@admin_bp.route('/admin/pedidos')
def admin_pedidos():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT p.id_pedido, u.nombre, u.apellido, p.fecha, p.hora, 
               p.total, p.estado, p.tipo_entrega
        FROM pedidos p
        LEFT JOIN usuarios u ON p.cod_usuario = u.id_usuario
        ORDER BY p.fecha DESC, p.hora DESC
    """)
    pedidos = cur.fetchall()
    cur.close()

    return render_template('admin_pedidos.html', pedidos=pedidos)


@admin_bp.route('/admin/pedidos/estado/<int:id_pedido>/<string:nuevo_estado>')
def cambiar_estado_pedido(id_pedido, nuevo_estado):
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("UPDATE pedidos SET estado=%s WHERE id_pedido=%s", (nuevo_estado, id_pedido))
    mysql.connection.commit()
    cur.close()

    flash(f"✅ Estado del pedido {id_pedido} cambiado a {nuevo_estado}", "success")
    return redirect(url_for('admin.admin_pedidos'))

# ===============================
# INVENTARIO (PRODUCTOS + INSUMOS + MESAS)
# ===============================
@admin_bp.route('/admin/inventario')
def admin_inventario():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    cur = mysql.connection.cursor()
    
    # Productos con categoría
    cur.execute("""
        SELECT p.id_producto, p.nombre, p.cantidad, p.descripcion, p.precio, 
               p.imagen, c.nombre_categoria, p.cod_categoria
        FROM productos p
        LEFT JOIN categorias c ON p.cod_categoria = c.id_categoria
    """)
    productos = cur.fetchall()

    # Insumos con subcategoría
    cur.execute("""
        SELECT i.id_insumo, i.nombre, i.cantidad, i.precio, i.fecha_vencimiento, i.lote,
               s.nombre_subcategoria, i.subcategoria_id
        FROM insumos i
        LEFT JOIN subcategorias_insumos s ON i.subcategoria_id = s.id_subcategoria
    """)
    insumos = cur.fetchall()

    # Mesas
    cur.execute("SELECT * FROM mesas")
    mesas = cur.fetchall()
    
    cur.close()

    return render_template('inventario.html',
                           productos=productos,
                           insumos=insumos,
                           mesas=mesas)

# ===============================
# INSUMOS
# ===============================
@admin_bp.route('/admin/insumos/agregar', methods=['GET', 'POST'])
def agregar_insumo():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    if request.method == 'POST':
        nombre = request.form['nombre']
        cantidad = request.form['cantidad']
        precio = request.form['precio']
        fecha_vencimiento = request.form.get('fecha_vencimiento') or None
        lote = request.form.get('lote') or None
        subcategoria_id = request.form['subcategoria_id']

        cur = mysql.connection.cursor()
        cur.execute("""
            INSERT INTO insumos (nombre, cantidad, precio, fecha_vencimiento, lote, subcategoria_id)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (nombre, cantidad, precio, fecha_vencimiento, lote, subcategoria_id))
        mysql.connection.commit()
        cur.close()

        flash("Insumo agregado correctamente", "success")
        return redirect(url_for('admin.admin_inventario'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM subcategorias_insumos")
    subcategorias = cur.fetchall()
    cur.close()

    return render_template('editar_insumo.html', insumo=None, subcategorias=subcategorias)


@admin_bp.route('/admin/insumos/editar/<int:id_insumo>', methods=['GET', 'POST'])
def editar_insumo(id_insumo):
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()

    if request.method == 'POST':
        nombre = request.form['nombre']
        cantidad = request.form['cantidad']
        precio = request.form['precio']
        fecha_vencimiento = request.form.get('fecha_vencimiento') or None
        lote = request.form.get('lote') or None
        subcategoria_id = request.form['subcategoria_id']

        cur.execute("""
            UPDATE insumos SET nombre=%s, cantidad=%s, precio=%s, 
                   fecha_vencimiento=%s, lote=%s, subcategoria_id=%s
            WHERE id_insumo=%s
        """, (nombre, cantidad, precio, fecha_vencimiento, lote, subcategoria_id, id_insumo))
        mysql.connection.commit()
        cur.close()

        flash("Insumo actualizado correctamente", "success")
        return redirect(url_for('admin.admin_inventario'))

    cur.execute("SELECT * FROM insumos WHERE id_insumo=%s", (id_insumo,))
    insumo = cur.fetchone()

    # Convertir fechas a string si existen
    if insumo:
        if insumo['fecha_vencimiento']:
            insumo['fecha_vencimiento'] = str(insumo['fecha_vencimiento'])
        if insumo['lote']:
            insumo['lote'] = str(insumo['lote'])

    cur.execute("SELECT * FROM subcategorias_insumos")
    subcategorias = cur.fetchall()
    cur.close()

    return render_template('editar_insumo.html', insumo=insumo, subcategorias=subcategorias)


@admin_bp.route('/admin/insumos/eliminar/<int:id_insumo>', methods=['POST', 'GET'])
def eliminar_insumo(id_insumo):
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM insumos WHERE id_insumo=%s", (id_insumo,))
    mysql.connection.commit()
    cur.close()

    flash("Insumo eliminado correctamente", "success")
    return redirect(url_for('admin.admin_inventario'))

# ===============================
# MESAS
# ===============================
@admin_bp.route('/admin/mesas/agregar', methods=['GET', 'POST'])
def agregar_mesa():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    if request.method == 'POST':
        numero_mesa = request.form['numero_mesa']
        capacidad = request.form['capacidad']

        cur = mysql.connection.cursor()
        cur.execute("""
            INSERT INTO mesas (numero_mesa, capacidad, estado)
            VALUES (%s, %s, 'Disponible')
        """, (numero_mesa, capacidad))
        mysql.connection.commit()
        cur.close()

        flash("Mesa agregada correctamente", "success")
        return redirect(url_for('admin.admin_inventario'))

    return render_template('editar_mesa.html', mesa=None)


@admin_bp.route('/admin/mesas/estado/<int:id_mesa>')
def cambiar_estado_mesa(id_mesa):
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT estado FROM mesas WHERE id_mesa=%s", (id_mesa,))
    mesa = cur.fetchone()

    # Como estamos usando DictCursor, accedemos como diccionario
    nuevo_estado = 'Disponible' if mesa['estado'] == 'Ocupada' else 'Ocupada'
    cur.execute("UPDATE mesas SET estado=%s WHERE id_mesa=%s", (nuevo_estado, id_mesa))
    mysql.connection.commit()
    cur.close()

    flash(f"Estado de la mesa cambiado a: {nuevo_estado}", "success")
    return redirect(url_for('admin.admin_inventario'))


@admin_bp.route('/admin/mesas/eliminar/<int:id_mesa>', methods=['POST', 'GET'])
def eliminar_mesa(id_mesa):
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM mesas WHERE id_mesa=%s", (id_mesa,))
    mysql.connection.commit()
    cur.close()

    flash("Mesa eliminada correctamente", "success")
    return redirect(url_for('admin.admin_inventario'))

# ===============================
# USUARIOS
# ===============================
@admin_bp.route('/admin/usuarios')
def admin_usuarios():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM usuarios")
    usuarios = cur.fetchall()
    cur.close()

    return render_template('asignarol.html', usuarios=usuarios)


@admin_bp.route('/admin/usuarios/estado/<int:id_usuario>/<string:nuevo_estado>')
def admin_cambiar_estado_usuario(id_usuario, nuevo_estado):
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("UPDATE usuarios SET estado = %s WHERE id_usuario = %s", (nuevo_estado, id_usuario))
    mysql.connection.commit()
    cur.close()

    flash(f"Estado del usuario cambiado a: {nuevo_estado}", "success")
    return redirect(url_for('admin.admin_usuarios'))


@admin_bp.route('/admin/usuarios/rol/<int:id_usuario>/<string:nuevo_rol>')
def admin_cambiar_rol_usuario(id_usuario, nuevo_rol):
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    cur.execute("UPDATE usuarios SET rol = %s WHERE id_usuario = %s", (nuevo_rol, id_usuario))
    mysql.connection.commit()
    cur.close()

    flash(f"Rol del usuario cambiado a: {nuevo_rol}", "success")
    return redirect(url_for('admin.admin_usuarios'))

# ===============================
# REGISTRAR BLUEPRINT
# ===============================
def init_app(app):
    app.register_blueprint(admin_bp)