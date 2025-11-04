from flask import Blueprint, render_template, send_file, request, session, redirect, url_for, flash
import pandas as pd
from fpdf import FPDF
from io import BytesIO
import mysql.connector
from datetime import datetime

# =====================
# CONEXIÓN DIRECTA
# =====================
def obtener_conexion():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="parrilla51"
    )

# =====================
# VERIFICACIÓN DE ADMINISTRADOR
# =====================
def verificar_admin():
    """Función helper para verificar si el usuario es administrador"""
    if 'logueado' not in session:
        return False, 'Debes iniciar sesión primero'
    
    if session.get('rol') != 'administrador':
        return False, f'Acceso denegado. Solo administradores pueden acceder.'
    
    return True, None

# =====================
# BLUEPRINT
# =====================
reportes_bp = Blueprint("reportes", __name__)

# =====================
# REPORTES DE VENTAS
# =====================
@reportes_bp.route("/ventas", methods=["GET", "POST"])
def reportes_ventas():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    # Valores por defecto
    busqueda = ""
    filtro_mes = ""
    filtro_estado = ""

    # Si vienen datos por POST
    if request.method == "POST":
        busqueda = request.form.get("busqueda", "").strip()
        filtro_mes = request.form.get("mes", "")
        filtro_estado = request.form.get("estado", "")

    # Construir la consulta base
    query = """
        SELECT p.id_pedido, u.nombre, u.apellido, p.fecha, p.hora, p.total, 
               p.estado, p.metodo_pago, p.tipo_entrega
        FROM pedidos p
        INNER JOIN usuarios u ON p.cod_usuario = u.id_usuario
        WHERE 1=1
    """
    params = []

    # Aplicar filtros
    if busqueda:
        query += " AND (u.nombre LIKE %s OR u.apellido LIKE %s OR CAST(p.id_pedido AS CHAR) LIKE %s)"
        busqueda_param = f"%{busqueda}%"
        params.extend([busqueda_param, busqueda_param, busqueda_param])

    if filtro_mes:
        query += " AND DATE_FORMAT(p.fecha, '%%Y-%%m') = %s"
        params.append(filtro_mes)

    if filtro_estado:
        query += " AND p.estado = %s"
        params.append(filtro_estado)

    query += " ORDER BY p.fecha DESC, p.hora DESC"

    cursor.execute(query, params)
    pedidos = cursor.fetchall()
    
    # Calcular estadísticas
    total_ventas = sum(p['total'] for p in pedidos if p['total'])
    total_pedidos = len(pedidos)
    
    cursor.close()
    conexion.close()

    return render_template(
        "reportes_ventas.html",
        pedidos=pedidos,
        busqueda=busqueda,
        filtro_mes=filtro_mes,
        filtro_estado=filtro_estado,
        total_ventas=total_ventas,
        total_pedidos=total_pedidos
    )

# =====================
# REPORTES DE INVENTARIO
# =====================
@reportes_bp.route("/inventario", methods=["GET", "POST"])
def reportes_inventario():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)

    # Valores por defecto
    busqueda = ""
    filtro_categoria = ""
    filtro_stock = ""

    # Si vienen datos por POST
    if request.method == "POST":
        busqueda = request.form.get("busqueda", "").strip()
        filtro_categoria = request.form.get("categoria", "")
        filtro_stock = request.form.get("stock", "")

    # Construir la consulta base
    query = """
        SELECT p.id_producto, p.nombre, p.cantidad, p.precio, p.descripcion,
               c.nombre_categoria, p.fecha_vencimiento, p.fecha_lote
        FROM productos p
        LEFT JOIN categorias c ON p.cod_categoria = c.id_categoria
        WHERE 1=1
    """
    params = []

    # Aplicar filtros
    if busqueda:
        query += " AND (p.nombre LIKE %s OR p.descripcion LIKE %s)"
        busqueda_param = f"%{busqueda}%"
        params.extend([busqueda_param, busqueda_param])

    if filtro_categoria:
        query += " AND c.id_categoria = %s"
        params.append(filtro_categoria)

    if filtro_stock == "bajo":
        query += " AND p.cantidad < 5"
    elif filtro_stock == "sin_stock":
        query += " AND p.cantidad = 0"
    elif filtro_stock == "disponible":
        query += " AND p.cantidad >= 5"

    query += " ORDER BY p.cantidad ASC"

    cursor.execute(query, params)
    productos = cursor.fetchall()
    
    # Obtener categorías para el filtro
    cursor.execute("SELECT id_categoria, nombre_categoria FROM categorias ORDER BY nombre_categoria")
    categorias = cursor.fetchall()
    
    # Calcular estadísticas
    total_productos = len(productos)
    productos_bajo_stock = sum(1 for p in productos if p['cantidad'] and p['cantidad'] < 5)
    productos_sin_stock = sum(1 for p in productos if p['cantidad'] == 0)
    valor_inventario = sum(p['cantidad'] * p['precio'] for p in productos if p['cantidad'] and p['precio'])
    
    cursor.close()
    conexion.close()

    return render_template(
        "reportes_inventario.html",
        productos=productos,
        categorias=categorias,
        busqueda=busqueda,
        filtro_categoria=filtro_categoria,
        filtro_stock=filtro_stock,
        total_productos=total_productos,
        productos_bajo_stock=productos_bajo_stock,
        productos_sin_stock=productos_sin_stock,
        valor_inventario=valor_inventario
    )

# =====================
# EXPORTAR VENTAS A EXCEL
# =====================
@reportes_bp.route("/ventas/exportar_excel")
def exportar_ventas_excel():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    conexion = obtener_conexion()
    query = """
        SELECT p.id_pedido AS 'ID Pedido', 
               CONCAT(u.nombre, ' ', u.apellido) AS 'Cliente',
               p.fecha AS 'Fecha', 
               p.hora AS 'Hora',
               p.total AS 'Total', 
               p.estado AS 'Estado',
               p.metodo_pago AS 'Método de Pago',
               p.tipo_entrega AS 'Tipo de Entrega'
        FROM pedidos p
        INNER JOIN usuarios u ON p.cod_usuario = u.id_usuario
        ORDER BY p.fecha DESC
    """
    df = pd.read_sql(query, conexion)
    conexion.close()

    output = BytesIO()
    with pd.ExcelWriter(output, engine="openpyxl") as writer:
        df.to_excel(writer, index=False, sheet_name="Ventas")
    output.seek(0)

    return send_file(
        output,
        as_attachment=True,
        download_name=f"reporte_ventas_{datetime.now().strftime('%Y%m%d')}.xlsx",
        mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

# =====================
# EXPORTAR INVENTARIO A EXCEL
# =====================
@reportes_bp.route("/inventario/exportar_excel")
def exportar_inventario_excel():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    conexion = obtener_conexion()
    query = """
        SELECT p.id_producto AS 'ID',
               p.nombre AS 'Producto',
               p.cantidad AS 'Cantidad',
               p.precio AS 'Precio',
               c.nombre_categoria AS 'Categoría',
               p.descripcion AS 'Descripción',
               p.fecha_vencimiento AS 'Fecha Vencimiento',
               p.fecha_lote AS 'Fecha Lote'
        FROM productos p
        LEFT JOIN categorias c ON p.cod_categoria = c.id_categoria
        ORDER BY p.cantidad ASC
    """
    df = pd.read_sql(query, conexion)
    conexion.close()

    output = BytesIO()
    with pd.ExcelWriter(output, engine="openpyxl") as writer:
        df.to_excel(writer, index=False, sheet_name="Inventario")
    output.seek(0)

    return send_file(
        output,
        as_attachment=True,
        download_name=f"reporte_inventario_{datetime.now().strftime('%Y%m%d')}.xlsx",
        mimetype="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )

# =====================
# EXPORTAR VENTAS A PDF
# =====================
@reportes_bp.route('/ventas/exportar_pdf')
def exportar_ventas_pdf():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)
    cursor.execute("""
        SELECT p.id_pedido, u.nombre, u.apellido, p.fecha, p.hora, p.total, 
               p.estado, p.metodo_pago
        FROM pedidos p
        INNER JOIN usuarios u ON p.cod_usuario = u.id_usuario
        ORDER BY p.fecha DESC
    """)
    pedidos = cursor.fetchall()
    cursor.close()
    conexion.close()

    # Crear PDF
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", 'B', 16)
    pdf.cell(0, 10, "Reporte de Ventas - Parrilla 51", ln=True, align="C")
    pdf.set_font("Arial", size=10)
    pdf.cell(0, 10, f"Generado: {datetime.now().strftime('%d/%m/%Y %H:%M')}", ln=True, align="C")
    pdf.ln(5)

    total_general = 0
    pdf.set_font("Arial", 'B', 10)
    
    for pedido in pedidos:
        texto = (
            f"Pedido #{pedido['id_pedido']} | "
            f"{pedido['nombre']} {pedido['apellido']} | "
            f"Fecha: {pedido['fecha']} {pedido['hora']} | "
            f"Total: ${pedido['total']:,.0f} | "
            f"Estado: {pedido['estado']}"
        )
        pdf.set_font("Arial", size=9)
        pdf.multi_cell(0, 6, texto.encode('latin-1', 'replace').decode('latin-1'))
        pdf.ln(2)
        total_general += pedido['total'] if pedido['total'] else 0

    pdf.ln(5)
    pdf.set_font("Arial", 'B', 12)
    pdf.cell(0, 10, f"Total General: ${total_general:,.0f}", ln=True, align="R")

    # Generar PDF en memoria
    salida = BytesIO()
    pdf_bytes = pdf.output(dest='S').encode('latin1')
    salida.write(pdf_bytes)
    salida.seek(0)

    return send_file(
        salida,
        as_attachment=True,
        download_name=f"reporte_ventas_{datetime.now().strftime('%Y%m%d')}.pdf",
        mimetype="application/pdf"
    )

# =====================
# EXPORTAR INVENTARIO A PDF
# =====================
@reportes_bp.route('/inventario/exportar_pdf')
def exportar_inventario_pdf():
    es_admin, mensaje = verificar_admin()
    if not es_admin:
        flash(mensaje, 'danger')
        return redirect(url_for('auth.login'))
    
    conexion = obtener_conexion()
    cursor = conexion.cursor(dictionary=True)
    cursor.execute("""
        SELECT p.id_producto, p.nombre, p.cantidad, p.precio, c.nombre_categoria
        FROM productos p
        LEFT JOIN categorias c ON p.cod_categoria = c.id_categoria
        ORDER BY p.cantidad ASC
    """)
    productos = cursor.fetchall()
    cursor.close()
    conexion.close()

    # Crear PDF
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", 'B', 16)
    pdf.cell(0, 10, "Reporte de Inventario - Parrilla 51", ln=True, align="C")
    pdf.set_font("Arial", size=10)
    pdf.cell(0, 10, f"Generado: {datetime.now().strftime('%d/%m/%Y %H:%M')}", ln=True, align="C")
    pdf.ln(5)

    valor_total = 0
    
    for producto in productos:
        stock_status = ""
        if producto['cantidad'] == 0:
            stock_status = "[SIN STOCK]"
        elif producto['cantidad'] < 5:
            stock_status = "[STOCK BAJO]"
        
        texto = (
            f"{stock_status} ID: {producto['id_producto']} | "
            f"{producto['nombre']} | "
            f"Stock: {producto['cantidad']} | "
            f"Precio: ${producto['precio']:,.0f} | "
            f"Categoria: {producto['nombre_categoria'] or 'N/A'}"
        )
        pdf.set_font("Arial", size=9)
        pdf.multi_cell(0, 6, texto.encode('latin-1', 'replace').decode('latin-1'))
        pdf.ln(2)
        valor_total += (producto['cantidad'] * producto['precio']) if producto['cantidad'] and producto['precio'] else 0

    pdf.ln(5)
    pdf.set_font("Arial", 'B', 12)
    pdf.cell(0, 10, f"Valor Total del Inventario: ${valor_total:,.0f}", ln=True, align="R")

    # Generar PDF en memoria
    salida = BytesIO()
    pdf_bytes = pdf.output(dest='S').encode('latin1')
    salida.write(pdf_bytes)
    salida.seek(0)

    return send_file(
        salida,
        as_attachment=True,
        download_name=f"reporte_inventario_{datetime.now().strftime('%Y%m%d')}.pdf",
        mimetype="application/pdf"
    )