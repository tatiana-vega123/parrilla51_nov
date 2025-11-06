function confirmarReserva(event) {
  event.preventDefault();

  const nombre = document.getElementById('nombre').value;
  const fecha = document.getElementById('fecha').value;
  const hora = document.getElementById('hora').value;
  const personas = document.getElementById('cant_personas').value;

  if (!nombre || !fecha || !hora || !personas) {
    alert("Por favor completa todos los campos.");
    return false;
  }

  document.getElementById("reserva-nombre").innerText = nombre;
  document.getElementById("resumen-personas").innerText = personas;
  document.getElementById("resumen-fecha").innerText = formatearFecha(fecha);
  document.getElementById("resumen-hora").innerText = formatearHora(hora);

  const modal = new bootstrap.Modal(document.getElementById('reservaConfirmada'));
  modal.show();

  return false;
}

function enviarReserva() {
  document.querySelector("form").submit();
}

function formatearFecha(fechaISO) {
  const fecha = new Date(fechaISO);
  const opciones = { day: 'numeric', month: 'long' };
  return fecha.toLocaleDateString('es-ES', opciones);
}

function formatearHora(hora24) {
  let [h, m] = hora24.split(':');
  h = parseInt(h);
  const sufijo = h >= 12 ? 'pm' : 'am';
  h = h % 12 || 12;
  return `${h}:${m} ${sufijo}`;
}

document.addEventListener("DOMContentLoaded", () => {
  const fechaInput = document.getElementById("fecha");
  const hoy = new Date();
  hoy.setDate(hoy.getDate() + 1);
  const manana = hoy.toISOString().split("T")[0];
  fechaInput.setAttribute("min", manana);
});
