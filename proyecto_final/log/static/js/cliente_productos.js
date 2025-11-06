function filtrar(categoria) {
    localStorage.setItem("filtroSeleccionado", categoria);
    document.querySelectorAll(".producto-card").forEach(el => {
        if (categoria === "plato del dia") {
            mostrarPlatoDelDia(el);
        } else {
            el.style.display = (el.dataset.categoria === categoria) ? "flex" : "none";
        }
    });
    document.getElementById("imagen-fondo").classList.add("oculto");
}

function mostrarPlatoDelDia(el) {
    const hoy = new Date().getDay();
    const nombre = el.querySelector("h3").innerText.toLowerCase();
    const dias = { 1: "lunes", 2: "martes", 3: "miércoles", 4: "jueves", 5: "viernes" };
    el.style.display = (dias[hoy] && nombre.includes(dias[hoy])) ? "flex" : "none";
}

window.onload = function() {
    localStorage.removeItem("filtroSeleccionado");
    document.querySelectorAll(".producto-card").forEach(el => el.style.display = "none");
    document.getElementById("imagen-fondo").classList.remove("oculto");
};

function mostrarMensaje(e) {
    e.preventDefault();
    const mensaje = document.getElementById("mensaje-agregado");
    mensaje.style.display = "block";
    setTimeout(() => mensaje.style.display = "none", 2000);
    e.target.submit();
}
