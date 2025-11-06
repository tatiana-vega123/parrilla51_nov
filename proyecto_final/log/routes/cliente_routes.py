from flask import Blueprint, render_template, session, redirect, url_for, request, flash
from __init__ import mysql
import MySQLdb.cursors
from datetime import datetime

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

            cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
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


@cliente_bp.route('/productos')
def cliente_productos():
    if 'rol' not in session or session['rol'] != 'cliente':
        return redirect(url_for('auth.login'))

    try:
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.execute("""
            SELECT 
                p.id_producto,
                p.nombre,
                p.precio,
                p.descripcion,
                p.imagen,
                c.nombre_categoria
            FROM productos p
            LEFT JOIN categorias c ON p.cod_categoria = c.id_categoria
        """)
        productos = cur.fetchall()
        cur.close()

        print("📦 Productos encontrados:", productos)  # 👀 Revisa esto en consola

        return render_template('cliente_productos.html', productos=productos)

    except Exception as e:
        print(f"❌ Error al cargar productos: {e}")
        flash("No se pudieron cargar los productos", "danger")
        return render_template('cliente_productos.html', productos=[])


@cliente_bp.route('/agregar_carrito/<int:id_producto>', methods=['POST', 'GET'])
def agregar_carrito(id_producto):
    try:
        cantidad = int(request.form.get('cantidad', 1))
        acompanamientos_ids = request.form.getlist('acompanamientos')  # 🔹 lista de acompañamientos seleccionados

        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cur.execute("SELECT * FROM productos WHERE id_producto = %s", (id_producto,))
        producto = cur.fetchone()

        if not producto:
            flash("❌ Producto no encontrado.", "warning")
            return redirect(url_for('cliente.cliente_productos'))

        carrito = session.get('carrito', [])

        # 🔸 Agregar el producto principal
        carrito.append({
            'id_producto': producto['id_producto'],
            'nombre': producto['nombre'],
            'precio': producto['precio'],
            'cantidad': cantidad
        })

        # 🔸 Agregar los acompañamientos seleccionados
        for id_acom in acompanamientos_ids:
            cur.execute("SELECT * FROM productos WHERE id_producto = %s", (id_acom,))
            acomp = cur.fetchone()
            if acomp:
                carrito.append({
                    'id_producto': acomp['id_producto'],
                    'nombre': acomp['nombre'],
                    'precio': acomp['precio'],
                    'cantidad': 1  # normalmente 1 acompañamiento por plato
                })

        cur.close()
        session['carrito'] = carrito

        flash(f"🛒 {producto['nombre']} agregado al carrito con sus acompañamientos", "success")
        return redirect(url_for('cliente.cliente_productos'))

    except Exception as e:
        print(f"❌ Error al agregar al carrito: {e}")
        flash("Error al agregar producto al carrito.", "danger")
        return redirect(url_for('cliente.cliente_productos'))



@cliente_bp.route('/cliente/carrito')
def cliente_carrito():
    carrito = session.get('carrito', [])
    total = sum(item['precio'] * item['cantidad'] for item in carrito)

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("""
        SELECT p.* 
        FROM productos p
        LEFT JOIN categorias c ON p.cod_categoria = c.id_categoria
        WHERE c.nombre_categoria = 'acompañamientos'
    """)
    acompanamientos = cur.fetchall()
    cur.close()

    return render_template(
        'cliente_carrito.html',
        carrito=carrito,
        total=total,
        acompanamientos=acompanamientos
    )
    
    # Eliminar producto del carrito
@cliente_bp.route("/carrito/eliminar/<int:id_producto>")
def eliminar_carrito(id_producto):
    carrito = session.get("carrito", [])
    
    # Filtra el producto a eliminar
    nuevo_carrito = [item for item in carrito if item["id_producto"] != id_producto]
    session["carrito"] = nuevo_carrito

    flash("Producto eliminado del carrito", "success")
    return redirect(url_for("cliente.cliente_carrito"))
    
@cliente_bp.route("/pedido/confirmar", methods=["POST"])
def hacer_pedido():
    carrito = session.get("carrito", [])
    if not carrito:
        flash("El carrito está vacío", "warning")
        return redirect(url_for("cliente.cliente_productos"))

    total = sum(item["precio"] * item["cantidad"] for item in carrito)

    tipo_entrega = request.form.get("tipo_entrega", "restaurante")
    metodo_pago = request.form.get("metodo_pago", "efectivo")

    direccion = None
    telefono = None
    if tipo_entrega == "domicilio":
        direccion = request.form.get("direccion")
        telefono = request.form.get("telefono_envio")

    id_usuario = session.get("id_usuario")
    if not id_usuario:
        flash("Debes iniciar sesión para hacer un pedido.", "danger")
        return redirect(url_for("auth.login"))

    acompanamientos_ids = request.form.getlist("acompanamientos")  # vienen como strings

    try:
        cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        # Insertar pedido
        cur.execute("""
            INSERT INTO pedidos (
                cod_usuario, fecha, hora, total, estado,
                tipo_entrega, metodo_pago, direccion, telefono
            ) VALUES (
                %s, CURDATE(), CURTIME(), %s, 'pendiente',
                %s, %s, %s, %s
            )
        """, (id_usuario, total, tipo_entrega, metodo_pago, direccion, telefono))

        # Obtener id_pedido recién insertado
        # cur.lastrowid suele funcionar con MySQLdb
        id_pedido = cur.lastrowid

        if not id_pedido:
            # intento alternativo si por alguna razón lastrowid falla
            cur.execute("SELECT LAST_INSERT_ID() AS id_pedido")
            row = cur.fetchone()
            id_pedido = row["id_pedido"] if row else None

        if not id_pedido:
            raise Exception("No se pudo obtener un ID de pedido válido.")

        # Insertar productos del carrito en detalle_pedido
        for item in carrito:
            cur.execute("""
                INSERT INTO detalle_pedido (
                    cod_pedido, cod_producto, cantidad, precio_unitario
                ) VALUES (%s, %s, %s, %s)
            """, (id_pedido, item["id_producto"], item["cantidad"], item["precio"]))

        # Insertar acompañamientos (cantidad 1, precio 0)
        # Sólo si vienen acompañamientos seleccionados
        if acompanamientos_ids:
            for id_acomp in acompanamientos_ids:
                # Asegurar que sean ints
                try:
                    id_ac = int(id_acomp)
                except:
                    continue
                cur.execute("""
                    INSERT INTO detalle_pedido (
                        cod_pedido, cod_producto, cantidad, precio_unitario
                    ) VALUES (%s, %s, 1, 0)
                """, (id_pedido, id_ac))

        mysql.connection.commit()
        cur.close()

        print(f"✅ Pedido {id_pedido} guardado correctamente en la base de datos para usuario {id_usuario}")

        session.pop("carrito", None)
        flash("✅ Pedido registrado correctamente", "success")
        return redirect(url_for("dashboard.cliente_dashboard"))

    except Exception as e:
        mysql.connection.rollback()
        print(f"❌ Error al guardar el pedido: {e}")
        flash("Error al guardar el pedido.", "danger")
        return redirect(url_for("cliente.cliente_carrito"))




# -------------------- VER RESERVAS --------------------


@cliente_bp.route('/cliente/ver_reservas')
def cliente_ver_reservas():
    if 'rol' not in session or session['rol'] != 'cliente':
        return redirect(url_for('auth.login'))

    id_usuario = session.get('id_usuario')

    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
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
@cliente_bp.route('/mis_pedidos')
def cliente_mis_pedidos():
    if 'rol' not in session or session['rol'] != 'cliente':
        return redirect(url_for('auth.login'))

    id_usuario = session.get('id_usuario')
    cur = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

    # Traer pedidos del usuario
    cur.execute("""
        SELECT 
            pe.id_pedido,
            pe.tipo_entrega,
            pe.fecha,
            pe.hora,
            pe.metodo_pago,
            pe.total,
            pe.estado,
            u.nombre AS nombre_usuario
        FROM pedidos pe
        LEFT JOIN usuarios u ON pe.cod_usuario = u.id_usuario
        WHERE pe.cod_usuario = %s
        ORDER BY pe.id_pedido DESC
    """, (id_usuario,))
    pedidos = cur.fetchall()

    pedidos_final = []
    for pedido in pedidos:
        # Traer productos del pedido
        cur.execute("""
            SELECT 
                dp.cod_producto,
                p.nombre AS nombre_producto,
                dp.cantidad,
                dp.precio_unitario
            FROM detalle_pedido dp
            LEFT JOIN productos p ON dp.cod_producto = p.id_producto
            WHERE dp.cod_pedido = %s
        """, (pedido["id_pedido"],))
        productos = cur.fetchall()

        pedidos_final.append({
            "id_pedido": pedido["id_pedido"],
            "fecha": pedido["fecha"],
            "hora": pedido["hora"],
            "total": pedido["total"],
            "estado": pedido["estado"],
            "tipo_entrega": pedido["tipo_entrega"],
            "metodo_pago": pedido["metodo_pago"],
            "nombre_usuario": pedido.get("nombre_usuario"),
            "productos": productos
        })

    cur.close()
    return render_template('mis_pedidos.html', pedidos=pedidos_final)


def init_app(app):
    app.register_blueprint(cliente_bp)
