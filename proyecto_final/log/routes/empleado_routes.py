from flask import ( Flask, Blueprint, render_template, request, redirect, url_for, flash, session, jsonify )
from flask_mysqldb import MySQL, MySQLdb
from MySQLdb import IntegrityError
import MySQLdb.cursors  

from datetime import date, datetime
import json

from __init__ import mysql
empleado_bp = Blueprint('empleado', __name__)
# ===============================
# VERIFICACIÓN DE EMPLEADO
# ===============================
def verificar_empleado():
    """Función helper para verificar si el usuario es empleado"""
    if 'logueado' not in session:
        return False, 'Debes iniciar sesión primero'
    
    if session.get('rol') not in ['empleado', 'administrador']:
        return False, f'Acceso denegado. Tu rol actual es: {session.get("rol")}'
    
    return True, None

# ===============================
# DASHBOARD EMPLEADO
# ===============================
@empleado_bp.route('/empleado/dashboard')
def empleado_dashboard():
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    return render_template('empleado.html')

# ===============================
# MESAS
# ===============================
# ==================== MESAS (EMPLEADO) ====================
@empleado_bp.route('/empleado/mesas')
def mesas_empleado():
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM mesas ORDER BY numero_mesa ASC")
    mesas = cur.fetchall()
    cur.close()
    
    return render_template('mesas_empleado.html', mesas=mesas)

# ==================== ORDEN DE MESA ====================
@empleado_bp.route('/empleado/orden/<int:mesa_id>', methods=['GET', 'POST'])
def orden_mesa(mesa_id):
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()

    if request.method == 'POST':
        productos_json = request.form.get('productos', '[]')
        total = float(request.form.get('total', 0))
        dinero_cliente = float(request.form.get('dinero_cliente', 0))

        try:
            productos = json.loads(productos_json)
        except json.JSONDecodeError:
            productos = []

        if len(productos) == 0 or total <= 0:
            flash("⚠️ No se seleccionaron productos válidos o el total es 0.", "error")
            return redirect(url_for('empleado.orden_mesa', mesa_id=mesa_id))

        fecha = datetime.now().date()
        hora = datetime.now().strftime("%H:%M:%S")

        # Insertar el pago principal
        cur.execute("""
            INSERT INTO pagos_restaurante (id_mesa, fecha, hora, total)
            VALUES (%s, %s, %s, %s)
        """, (mesa_id, fecha, hora, total))
        id_pago_restaurante = cur.lastrowid

        # Insertar los detalles del pedido
        for p in productos:
            cur.execute("""
                INSERT INTO detalle_pedido_restaurante 
                (id_pago_restaurante, id_producto, cantidad, precio_unitario)
                VALUES (%s, %s, %s, %s)
            """, (
                id_pago_restaurante,
                p['id_producto'],
                p['cantidad'],
                p['precio']
            ))

        mysql.connection.commit()
        cur.close()

        flash("✅ Pago registrado correctamente y guardado en historial.", "success")
        return redirect(url_for('empleado.mesas_empleado'))

    # Si es GET, mostrar productos y categorías
    cur.execute("SELECT * FROM categorias WHERE id_categoria != 6")
    categorias = cur.fetchall()
    cur.execute("SELECT * FROM productos WHERE cod_categoria != 6")
    productos = cur.fetchall()
    cur.close()
    return render_template('calculadora.html', mesa=mesa_id, categorias=categorias, productos=productos)

# ==================== HISTORIAL DE PAGOS ====================
@empleado_bp.route('/empleado/historial_pagos', methods=['GET'])
def historial_pagos_restaurante():
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor()
    query = request.args.get("query", "").strip()

    if query:
        cur.execute("""
            SELECT * FROM pagos_restaurante
            WHERE CAST(id_pago_restaurante AS CHAR) LIKE %s
               OR DATE_FORMAT(fecha, '%%Y-%%m-%%d') LIKE %s
               OR hora LIKE %s
            ORDER BY fecha DESC, hora DESC
        """, (f"%{query}%", f"%{query}%", f"%{query}%"))
    else:
        cur.execute("SELECT * FROM pagos_restaurante ORDER BY fecha DESC, hora DESC")

    pagos = cur.fetchall()
    historial = []

    for pago in pagos:
        cur.execute("""
            SELECT d.*, p.nombre
            FROM detalle_pedido_restaurante d
            JOIN productos p ON d.id_producto = p.id_producto
            WHERE d.id_pago_restaurante = %s
        """, (pago["id_pago_restaurante"],))
        detalles = cur.fetchall()

        pago["detalles"] = detalles
        historial.append(pago)

    cur.close()
    return render_template('historial_pagos_restaurante.html', historial=historial)

# ===============================
# REGISTRAR - CATEGORÍAS Y PRODUCTOS
# ===============================
@empleado_bp.route('/empleado/registrar', methods=['GET', 'POST'])
def registrar_pedido():
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    if request.method == 'POST':
        flash("Pedido registrado correctamente", "success")
        return redirect(url_for('empleado.ordenes_empleado'))
    
    cur = mysql.connection.cursor()

    # 🔹 Obtener categorías (normalizado)
    cur.execute("SELECT id_categoria, nombre_categoria FROM categorias ORDER BY nombre_categoria")
    categorias_raw = cur.fetchall()

    categorias = []
    for c in categorias_raw:
        if isinstance(c, dict):
            categorias.append({
                'id_categoria': c.get('id_categoria'),
                'nombre_categoria': c.get('nombre_categoria')
            })
        else:
            categorias.append({
                'id_categoria': c[0],
                'nombre_categoria': c[1]
            })

    # 🔹 Obtener productos (ahora incluye el campo estado)
    cur.execute("""
        SELECT 
            p.id_producto, 
            p.nombre, 
            p.precio, 
            p.cod_categoria AS id_categoria, 
            p.estado,  -- 👈 se agregó
            c.nombre_categoria
        FROM productos p
        LEFT JOIN categorias c ON p.cod_categoria = c.id_categoria
        ORDER BY c.nombre_categoria, p.nombre
    """)
    productos_raw = cur.fetchall()

    productos = []
    for p in productos_raw:
        if isinstance(p, dict):
            productos.append({
                'id_producto': p.get('id_producto'),
                'nombre': p.get('nombre'),
                'precio': p.get('precio'),
                'id_categoria': p.get('id_categoria'),
                'nombre_categoria': p.get('nombre_categoria'),
                'estado': p.get('estado', 'Disponible')  # 👈 por si viene NULL
            })
        else:
            productos.append({
                'id_producto': p[0],
                'nombre': p[1],
                'precio': p[2],
                'id_categoria': p[3],
                'estado': p[4] if len(p) > 4 else 'Disponible',
                'nombre_categoria': p[5] if len(p) > 5 else ''
            })

    cur.close()

    # 🚀 Debug opcional
    print("=== PRODUCTOS NORMALIZADOS ===")
    for p in productos:
        print(p)

    return render_template("registrar_empleado.html", productos=productos, categorias=categorias)

# 🔹 Actualizar estado del producto
@empleado_bp.route("/empleado/actualizar_estado_producto", methods=["POST"])
def actualizar_estado_producto():
    data = request.get_json()
    id_producto = data.get("id_producto")
    nuevo_estado = data.get("estado")

    if not id_producto or not nuevo_estado:
        return jsonify({"success": False, "msg": "Datos incompletos"}), 400

    try:
        cur = mysql.connection.cursor()
        cur.execute("""
            UPDATE productos
            SET estado = %s
            WHERE id_producto = %s
        """, (nuevo_estado, id_producto))
        mysql.connection.commit()
        return jsonify({"success": True, "nuevo_estado": nuevo_estado})
    except Exception as e:
        mysql.connection.rollback()
        return jsonify({"success": False, "msg": str(e)}), 500
    finally:
        cur.close()
# ===============================
# ÓRDENES
# ===============================
@empleado_bp.route('/empleado/ordenes')
def ordenes_empleado():
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    search_query = request.args.get('search_query', '').strip()

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    
    # Si hay búsqueda, filtramos por cliente, teléfono o estado
    if search_query:
        cur.execute("""
            SELECT * FROM pedidos
            WHERE (cod_usuario LIKE %s OR telefono LIKE %s OR estado LIKE %s)
            AND estado IN ('pendiente', 'entregado')
            ORDER BY fecha DESC, hora DESC
        """, (f"%{search_query}%", f"%{search_query}%", f"%{search_query}%"))
    else:
        cur.execute("""
            SELECT * FROM pedidos
            WHERE estado IN ('pendiente', 'entregado')
            ORDER BY fecha DESC, hora DESC
        """)
    
    pedidos = cur.fetchall()
    
    ordenes = []

    for pedido in pedidos:
        cur.execute("""
            SELECT dp.cod_producto, dp.cantidad, dp.precio_unitario, p.nombre
            FROM detalle_pedido dp
            JOIN productos p ON dp.cod_producto = p.id_producto
            WHERE dp.cod_pedido = %s
        """, (pedido['id_pedido'],))
        detalles = cur.fetchall()

        productos = []
        for d in detalles:
            subtotal = float(d['cantidad']) * float(d['precio_unitario'])
            productos.append({
                'nombre': d['nombre'],
                'cantidad': d['cantidad'],
                'precio_unitario': float(d['precio_unitario']),
                'subtotal': subtotal
            })

        pedido['productos'] = productos
        ordenes.append(pedido)

    cur.close()
    
    return render_template('ordenes_empleado.html', ordenes=ordenes, search_query=search_query)


# ===============================
# CAMBIAR ESTADO (AJAX)
# ===============================
@empleado_bp.route('/actualizar_estado/<int:id_pedido>', methods=['POST'])
def actualizar_estado(id_pedido):
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        return jsonify({'error': mensaje}), 403

    data = request.get_json()
    nuevo_estado = data.get('estado')

    cur = mysql.connection.cursor()
    cur.execute("UPDATE pedidos SET estado=%s WHERE id_pedido=%s", (nuevo_estado, id_pedido))
    mysql.connection.commit()
    cur.close()

    return jsonify({'success': True, 'estado': nuevo_estado})

@empleado_bp.route('/empleado/historial_ordenes')
def historial_ordenes_empleado():
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # Leer parámetro de búsqueda (si existe)
    search_query = request.args.get('search_query', '').strip()

    if search_query:
        # Filtrar por nombre, teléfono, dirección o estado
        cur.execute("""
            SELECT * FROM pedidos
            WHERE estado IN ('entregado', 'cancelado')
              AND (cod_usuario LIKE %s OR telefono LIKE %s OR estado LIKE %s)
            ORDER BY fecha DESC, hora DESC
        """, (
            f"%{search_query}%",
            f"%{search_query}%",
            f"%{search_query}%"
        ))
    else:
        # Mostrar todos los pedidos finalizados o cancelados
        cur.execute("""
            SELECT * FROM pedidos
            WHERE estado IN ('entregado', 'cancelado')
            ORDER BY fecha DESC, hora DESC
        """)

    pedidos = cur.fetchall()
    ordenes = []

    # Obtener detalles de cada pedido
    for pedido in pedidos:
        cur.execute("""
            SELECT dp.cod_producto, dp.cantidad, dp.precio_unitario, p.nombre
            FROM detalle_pedido dp
            JOIN productos p ON dp.cod_producto = p.id_producto
            WHERE dp.cod_pedido = %s
        """, (pedido['id_pedido'],))

        detalles = cur.fetchall()

        productos = []
        for d in detalles:
            subtotal = float(d['cantidad']) * float(d['precio_unitario'])
            productos.append({
                'nombre': d['nombre'],
                'cantidad': d['cantidad'],
                'precio_unitario': float(d['precio_unitario']),
                'subtotal': subtotal
            })

        pedido['productos'] = productos
        ordenes.append(pedido)

    cur.close()

    return render_template('historial_ordenes_em.html', ordenes=ordenes, search_query=search_query)

# ===============================
# RESERVAS
# ===============================
@empleado_bp.route('/empleado/reservas')
def reservas_empleado():
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT * FROM reservas
        WHERE estado IN ('Pendiente', 'Confirmada')
        ORDER BY id_reserva DESC
    """)
    reservas = cur.fetchall()
    cur.close()
    
    today = str(date.today())
    print (reservas)
    return render_template('reservas_empleado.html', reservas=reservas, today=today)

# ===============================
# BUSCAR RESERVAS
# ===============================
@empleado_bp.route('/empleado/buscar_reservas')
def buscar_reservas():
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    search_query = request.args.get('search_query', '')
    
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT * FROM reservas
        WHERE (nombre LIKE %s OR documento LIKE %s OR telefono LIKE %s)
        AND estado IN ('Pendiente', 'Confirmada')
        ORDER BY fecha DESC
    """, (f'%{search_query}%', f'%{search_query}%', f'%{search_query}%'))
    reservas = cur.fetchall()
    cur.close()
    
    today = str(date.today())
    return render_template('reservas_empleado.html', reservas=reservas, today=today)

# ===============================
# AGREGAR RESERVA 
# ===============================
@empleado_bp.route('/empleado/agregar_reserva', methods=['POST'])
def agregar_reserva():
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))

    # 🔹 Obtenemos el ID del usuario desde la sesión
    id_usuario = session.get('id_usuario')

    if not id_usuario:
        flash("⚠️ No se encontró un usuario en sesión. Por favor inicia sesión nuevamente.", "error")
        return redirect(url_for('auth.login'))

    fecha = request.form["fecha"]
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # Validar reserva por fecha
    cur.execute("SELECT COUNT(*) AS total FROM reservas WHERE fecha = %s", (fecha,))
    result = cur.fetchone()
    count = result["total"] if result else 0

    if count > 0:
        flash("Ya existe una reserva para esta fecha. Solo se permite una por día.", "error")
        cur.close()
        return redirect(url_for("empleado.reservas_empleado"))

    # Obtener datos del formulario
    nombre = request.form["nombre"]
    documento = request.form["documento"]
    telefono = request.form["telefono"]
    hora = request.form["hora"]
    cant_personas = request.form["cant_personas"]
    tipo_evento = request.form["tipo_evento"]
    comentarios = request.form.get("comentarios", "")
    estado = request.form.get("estado", "Pendiente")

    try:
        cur.execute("""
            INSERT INTO reservas (
                nombre, documento, telefono, fecha, hora,
                cant_personas, tipo_evento, comentarios, id_usuario, estado
            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """, (
            nombre, documento, telefono, fecha, hora,
            cant_personas, tipo_evento, comentarios, id_usuario, estado
        ))
        mysql.connection.commit()
        flash("✅ Reserva agregada exitosamente.", "success")

    except IntegrityError as e:
        mysql.connection.rollback()
        flash(f"⚠️ Error de clave foránea: {str(e)}", "error")

    except Exception as e:
        mysql.connection.rollback()
        flash(f"⚠️ Ocurrió un error inesperado: {str(e)}", "error")

    finally:
        cur.close()

    return redirect(url_for('empleado.reservas_empleado'))

# ===============================
# EDITAR RESERVA (Versión corregida)
# ===============================
@empleado_bp.route('/empleado/editar_reserva/<int:id_reserva>', methods=['POST'])
def editar_reserva(id_reserva):
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    nueva_fecha = request.form["fecha"]

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT COUNT(*) AS total FROM reservas
        WHERE fecha = %s AND id_reserva != %s
    """, (nueva_fecha, id_reserva))
    count = cur.fetchone()
    count = count["total"] if count else 0

    if count > 0:
        flash("Ya existe una reserva para esta fecha. Solo se permite una por día.", "error")
        cur.close()
        # ❌ Se corrige el redirect (antes estaba con ruta incorrecta)
        return redirect(url_for('empleado.reservas_empleado'))

    # Obtener datos del formulario
    nombre = request.form["nombre"]
    documento = request.form["documento"]
    telefono = request.form["telefono"]
    hora = request.form["hora"]
    cant_personas = request.form["cant_personas"]
    tipo_evento = request.form["tipo_evento"]
    comentarios = request.form["comentarios"]
    id_usuario = request.form["id_usuario"]

    # ✅ Mantener el estado actual si no se envía desde el formulario
    estado_form = request.form.get("estado")
    if not estado_form:
        cur.execute("SELECT estado FROM reservas WHERE id_reserva = %s", (id_reserva,))
        estado = cur.fetchone()["estado"]
    else:
        estado = estado_form

    # Actualizar datos de la reserva
    cur.execute("""
        UPDATE reservas SET
            nombre=%s,
            documento=%s,
            telefono=%s,
            fecha=%s,
            hora=%s,
            cant_personas=%s,
            tipo_evento=%s,
            comentarios=%s,
            id_usuario=%s,
            estado=%s
        WHERE id_reserva=%s
    """, (nombre, documento, telefono, nueva_fecha, hora,
          cant_personas, tipo_evento, comentarios, id_usuario, estado, id_reserva))
    
    mysql.connection.commit()
    cur.close()

    flash("✅ Reserva actualizada exitosamente", "success")
    return redirect(url_for('empleado.reservas_empleado'))

# ===============================
# ELIMINAR RESERVA
# ===============================
@empleado_bp.route('/empleado/eliminar_reserva/<int:id_reserva>', methods=['POST'])
def eliminar_reserva(id_reserva):
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    cur = mysql.connection.cursor()
    cur.execute("DELETE FROM reservas WHERE id_reserva=%s", (id_reserva,))
    mysql.connection.commit()
    cur.close()
    
    flash("Reserva eliminada exitosamente", "success")
    return redirect(url_for('empleado.reservas_empleado'))

# ===============================
# CAMBIAR ESTADO RESERVA
# ===============================
@empleado_bp.route('/empleado/cambiar_estado_reserva/<int:id_reserva>', methods=['POST'])
def cambiar_estado_reserva(id_reserva):
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        return jsonify({"error": mensaje}), 403

    data = request.get_json()
    nuevo_estado = data.get("nuevo_estado")

    if nuevo_estado not in ["Confirmada", "Completada"]:
        return jsonify({"error": "Estado no válido"}), 400

    try:
        cur = mysql.connection.cursor()
        cur.execute("UPDATE reservas SET estado = %s WHERE id_reserva = %s", (nuevo_estado, id_reserva))
        mysql.connection.commit()
        cur.close()
        return jsonify({"success": True, "message": f"Estado actualizado a {nuevo_estado}."}), 200
    except Exception as e:
        print(f"Error al actualizar estado: {e}")
        return jsonify({"success": False, "error": "Error interno del servidor"}), 500


# ===============================
# HISTORIAL RESERVAS
# ===============================
@empleado_bp.route('/empleado/historial_reservas')
def historial_reservas_em():
    es_empleado, mensaje = verificar_empleado()
    if not es_empleado:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT * FROM reservas
        WHERE estado = 'Completada'
        ORDER BY fecha DESC
        LIMIT 100
    """)
    historial = cur.fetchall()
    cur.close()
    
    return render_template('historial_reservas_em.html', historial=historial)

from flask import Blueprint, request, jsonify, current_app, session
from werkzeug.security import check_password_hash, generate_password_hash


# ===============================
# PERFIL DE EMPLEADO (HTML)
# ===============================
@empleado_bp.route("/empleado/perfil")
def perfil_empleado():
    """Muestra la página HTML del perfil del empleado"""
    if "id_usuario" not in session:
        flash("Debes iniciar sesión primero", "danger")
        return redirect(url_for("auth.login"))

    return render_template("perfil_empleado.html")  # 👈 tu HTML


# ===============================
# API: OBTENER DATOS DEL PERFIL (JSON)
# ===============================
@empleado_bp.route("/empleado/api/perfil", methods=["GET"])
def api_perfil_empleado():
    """Devuelve los datos del perfil del empleado en formato JSON"""
    if "id_usuario" not in session:
        return jsonify({"error": True, "mensaje": "No logueado"}), 401

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT id_usuario, nombre, apellido, telefono, direccion, correo
        FROM usuarios WHERE id_usuario = %s
    """, (session["id_usuario"],))
    empleado = cur.fetchone()
    cur.close()

    return jsonify(empleado)


# ===============================
# API: ACTUALIZAR PERFIL
# ===============================
@empleado_bp.route("/empleado/api/perfil", methods=["POST"])
def api_actualizar_perfil_empleado():
    """Actualiza los datos del perfil del empleado"""
    if "id_usuario" not in session:
        return jsonify({"error": True, "mensaje": "No logueado"}), 401

    data = request.get_json()
    cur = mysql.connection.cursor()
    cur.execute("""
        UPDATE usuarios
        SET nombre=%s, apellido=%s, telefono=%s, direccion=%s, correo=%s
        WHERE id_usuario=%s
    """, (
        data["nombre"], data["apellido"], data["telefono"],
        data["direccion"], data["correo"], session["id_usuario"]
    ))
    mysql.connection.commit()
    cur.close()

    return jsonify({"error": False, "mensaje": "Perfil actualizado correctamente"})


# ===============================
# API: CAMBIAR CONTRASEÑA
# ===============================
@empleado_bp.route("/empleado/api/cambiar_contrasena", methods=["POST"])
def api_cambiar_contrasena_empleado():
    """Permite cambiar la contraseña del empleado"""
    if "id_usuario" not in session:
        return jsonify({"error": True, "mensaje": "No logueado"}), 401

    data = request.get_json()
    old_pass = data.get("oldPass")
    new_pass = data.get("newPass")

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT contraseña FROM usuarios WHERE id_usuario = %s", (session["id_usuario"],))
    empleado = cur.fetchone()

    if not empleado:
        cur.close()
        return jsonify({"error": True, "mensaje": "Usuario no encontrado"}), 404

    # Verificar contraseña actual
    if not check_password_hash(empleado["contraseña"], old_pass):
        cur.close()
        return jsonify({"error": True, "mensaje": "La contraseña actual no es correcta"}), 400

    # Guardar nueva contraseña
    new_hashed = generate_password_hash(new_pass)
    cur.execute("UPDATE usuarios SET contraseña = %s WHERE id_usuario = %s", (new_hashed, session["id_usuario"]))
    mysql.connection.commit()
    cur.close()

    return jsonify({"error": False, "mensaje": "Contraseña actualizada con éxito"})


# ===============================
# REGISTRAR BLUEPRINT
# ===============================
def init_app(app):
    app.register_blueprint(empleado_bp)