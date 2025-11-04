from flask import Blueprint, request, jsonify, current_app, session
from werkzeug.security import check_password_hash, generate_password_hash

usuarios_bp = Blueprint("usuarios", __name__)

# 🔹 Endpoint para obtener datos del perfil
@usuarios_bp.route("/perfil", methods=["GET"])
def obtener_perfil():
    if "id_usuario" not in session:
        return jsonify({"error": True, "mensaje": "No logueado"}), 401

    mysql = current_app.mysql
    cur = mysql.connection.cursor(dictionary=True)
    cur.execute("SELECT id_usuario, nombre, apellido, telefono, direccion, correo FROM usuarios WHERE id_usuario = %s",
                (session["id_usuario"],))
    user = cur.fetchone()
    cur.close()

    return jsonify(user)


# 🔹 Endpoint para actualizar datos del perfil
@usuarios_bp.route("/perfil", methods=["POST"])
def actualizar_perfil():
    if "id_usuario" not in session:
        return jsonify({"error": True, "mensaje": "No logueado"}), 401

    data = request.get_json()
    mysql = current_app.mysql
    cur = mysql.connection.cursor()
    cur.execute("""
        UPDATE usuarios
        SET nombre=%s, apellido=%s, telefono=%s, direccion=%s, correo=%s
        WHERE id_usuario=%s
    """, (data["nombre"], data["apellido"], data["telefono"], data["direccion"], data["correo"], session["id_usuario"]))
    mysql.connection.commit()
    cur.close()

    return jsonify({"error": False, "mensaje": "Perfil actualizado correctamente"})


# 🔹 Endpoint para cambiar contraseña
@usuarios_bp.route("/cambiar_contrasena", methods=["POST"])
def cambiar_contrasena():
    if "id_usuario" not in session:
        return jsonify({"error": True, "mensaje": "No logueado"}), 401

    data = request.get_json()
    old_pass = data.get("oldPass")
    new_pass = data.get("newPass")

    mysql = current_app.mysql
    cur = mysql.connection.cursor(dictionary=True)
    cur.execute("SELECT contraseña FROM usuarios WHERE id_usuario = %s", (session["id_usuario"],))
    user = cur.fetchone()

    if not user:
        return jsonify({"error": True, "mensaje": "Usuario no encontrado"}), 404

    # Verificar contraseña actual
    if not check_password_hash(user["contraseña"], old_pass):
        return jsonify({"error": True, "mensaje": "La contraseña actual no es correcta"}), 400

    # Guardar nueva contraseña
    new_hashed = generate_password_hash(new_pass)
    cur.execute("UPDATE usuarios SET contraseña = %s WHERE id_usuario = %s", (new_hashed, session["id_usuario"]))
    mysql.connection.commit()
    cur.close()

    return jsonify({"error": False, "mensaje": "Contraseña actualizada con éxito"})
