function mostrarCampos() {
  const tipo = document.querySelector('input[name="tipo_entrega"]:checked').value;
  const datosDomicilio = document.getElementById("datos-domicilio");

  if (tipo === "domicilio") {
    datosDomicilio.style.display = "block";
    document.getElementById("direccion").setAttribute("required", true);
    document.getElementById("telefono_envio").setAttribute("required", true);
  } else {
    datosDomicilio.style.display = "none";
    document.getElementById("direccion").value = "";
    document.getElementById("telefono_envio").value = "";
    document.getElementById("direccion").removeAttribute("required");
    document.getElementById("telefono_envio").removeAttribute("required");
  }
}


function normalizar(str) {
  return String(str || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/\s+/g, " ")
    .replace(/[()]/g, "")
    .toLowerCase()
    .trim();
}
function escapeRegex(s){ return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'); }

const checkboxes = document.querySelectorAll('input[name="acompanamientos"]');
const totalEl = document.getElementById("total");
const acompDiv = document.getElementById("acompaniamientos");
const tituloAcomp = document.getElementById("titulo-acomp");
const form = document.querySelector("form");


const canonMap = {
  "papa salada": "papa",
  "papa": "papa",
  "aguacate": "aguacate",
  "aguacate macerado con sal": "aguacate",
  "sopa": "sopa",
  "yuca al vapor": "yuca",
  "yuca cocida": "yuca",
  "arroz blanco": "arroz",
  "ensalada (porcion)": "ensalada",
  "ensalada porcion": "ensalada",
  "ensalada de la casa": "ensalada",
  "arepa de maiz y queso": "arepa"
};
const canonNorm = {};
Object.keys(canonMap).forEach(k => canonNorm[normalizar(k)] = normalizar(canonMap[k]));


const carritoTDs = document.querySelectorAll("tbody tr td:first-child");
const nombresEnCarrito = Array.from(carritoTDs)
  .map(td => normalizar(td.textContent))
  .filter(Boolean);

const canonEnCarrito = new Set();
for (const prod of nombresEnCarrito) {
  if (canonNorm[prod]) {
    canonEnCarrito.add(canonNorm[prod]);
    continue;
  }
  for (const key of Object.keys(canonNorm)) {
    const re = new RegExp("\\b" + escapeRegex(key) + "\\b", "i");
    if (re.test(prod)) {
      canonEnCarrito.add(canonNorm[key]);
      break;
    }
  }
}

const hayAdicional = canonEnCarrito.size > 0;
let hayPlato = false;
if (!hayAdicional) hayPlato = nombresEnCarrito.length > 0;
const requiereAcomp = hayPlato && !hayAdicional;


if (!hayPlato && !hayAdicional) {
  acompDiv.style.display = "none";
} else {
  acompDiv.style.display = "block";
  tituloAcomp.textContent = requiereAcomp
    ? "🍽️ Escoge 2 acompañamientos (obligatorio)"
    : "🍽️ Acompañamientos (opcionales)";
}


function actualizarAcompanamientos() {
  console.log("Carrito normalizado:", nombresEnCarrito);
  console.log("Canon detectados:", Array.from(canonEnCarrito));
  const tachados = [];

  checkboxes.forEach(cb => {
    const label = cb.closest("label") || cb.parentElement;
    const textoLabel = label ? label.textContent : "";
    const nombreAcomp = normalizar(cb.dataset.nombre || textoLabel);
    const canonAcomp = canonNorm[nombreAcomp] || null;

    let coincide = false;
    if (canonAcomp && canonEnCarrito.has(canonAcomp)) {
      coincide = true;
    } else {
      for (const prod of nombresEnCarrito) {
        const re = new RegExp("\\b" + escapeRegex(nombreAcomp) + "\\b", "i");
        if (re.test(prod)) {
          coincide = true;
          break;
        }
      }
    }

    if (coincide) {
      tachados.push(nombreAcomp);
      cb.disabled = true;
      cb.checked = false;
      if (label) {
        label.style.textDecoration = "line-through";
        label.style.color = "#888";
        label.style.opacity = "0.6";
      }
    } else {
      cb.disabled = false;
      if (label) {
        label.style.textDecoration = "none";
        label.style.color = "#fff";
        label.style.opacity = "1";
      }
    }
  });

  console.log("Acompañamientos tachados:", tachados);
}
actualizarAcompanamientos();


form.addEventListener("submit", function (e) {
  e.preventDefault();
  const acompChecked = document.querySelectorAll('input[name="acompanamientos"]:checked');
  if (requiereAcomp && acompChecked.length !== 2) {
    Swal.fire('Selecciona 2 acompañamientos', 'Debes elegir exactamente dos acompañamientos para continuar.', 'warning');
    return;
  }
  Swal.fire({
    title: '¿Confirmar pedido?',
    html: `Has seleccionado ${acompChecked.length} acompañamientos.<br>Total actualizado: ${totalEl ? totalEl.innerText : ""}`,
    icon: 'question',
    showCancelButton: true,
    confirmButtonText: '✅ Finalizar',
    cancelButtonText: '❌ Cancelar',
    background: '#2f2f2f',
    color: '#fff',
    confirmButtonColor: '#ffd700',
    cancelButtonColor: '#ff4444'
  }).then(result => {
    if (result.isConfirmed) form.submit();
  });
});
